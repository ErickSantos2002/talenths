// The tour crosses screens and each page mounts its own AdminLayout, so the
// engine and `navigate` live here, above the routes, in a component that does
// not unmount. Port of DocsHS's ProvedorDoTour.

import { useQuery, useQueryClient } from "@tanstack/react-query";
import {
  createContext, useCallback, useContext, useEffect, useMemo, useRef, useState,
  type MutableRefObject, type ReactNode,
} from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { toast } from "sonner";

import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription,
  AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { buttonVariants } from "@/components/ui/button";
import { useAuth } from "@/contexts/AuthContext";
import { tour as tourApi, type TourProgress } from "@/lib/api";
import { createProgressQueue } from "./progressQueue";
import { matchScreen, screenName } from "./screens";
import { prepareSafely, restoreSidebar, type LayoutHooks } from "./sidebarTarget";
import { TourEngine, onlyPresent } from "./tourEngine";
import { asTour, audienceOf, resumeStep } from "./tourRules";
import { WELCOME_TOURS } from "./tours/welcome";
import type { ScreenTour, Tour } from "./tours/types";

export type { LayoutHooks } from "./sidebarTarget";

export const TOUR_QUERY_KEY = "tour-progress";

const COMPLETE_FAILED_TOAST = "tour-complete-failed";

interface TourContextValue {
  welcome: Tour | null;
  progress: TourProgress | null;
  loaded: boolean;
  active: boolean;
  // The mandatory welcome modal was already answered in this visit; it comes
  // back on the next login or page load until the tour is finished.
  prompted: boolean;
  // Every tour progress row, for the "what changed" lookups.
  progressAll: TourProgress[];
  startWelcome(): void;
  beginWelcome(): void;
  showScreenTour(s: ScreenTour): void;
  // Runs the cut of steps added since the person's last completed version.
  viewWhatsNew(cut: Tour): void;
  // Marks the current version as seen without running the cut.
  dismissWhatsNew(cut: Tour): void;
  registerLayout(hooks: LayoutHooks | null): void;
}

// Only for TourLayoutBridge. The "expanded by the tour" flag outlives each
// AdminLayout: the tour may expand the sidebar on one page and end on another.
interface TourLayoutContextValue {
  registerLayout(hooks: LayoutHooks): void;
  unregisterLayout(hooks: LayoutHooks): void;
  expandedByTour: MutableRefObject<boolean>;
}

const TourContext = createContext<TourContextValue | null>(null);
const TourLayoutContext = createContext<TourLayoutContextValue | null>(null);

export function TourProvider({ children }: { children: ReactNode }) {
  const { user, roles } = useAuth();
  const navigate = useNavigate();
  const { pathname } = useLocation();
  const queryClient = useQueryClient();
  const [active, setActive] = useState(false);
  const [resume, setResume] = useState<{ tour: Tour; step: number } | null>(null);
  const [prompted, setPrompted] = useState(false);

  const query = useQuery({
    queryKey: [TOUR_QUERY_KEY, user?.id],
    queryFn: tourApi.list,
    enabled: !!user,
  });
  const welcome = user ? WELCOME_TOURS[audienceOf(roles)] : null;
  const progress = query.data?.find((p) => p.tour === welcome?.id) ?? null;

  // The engine is created once; its callbacks read the current values here.
  const navigateRef = useRef(navigate);
  navigateRef.current = navigate;
  const ownerRef = useRef(user?.id);
  ownerRef.current = user?.id;
  const pathnameRef = useRef(pathname);
  pathnameRef.current = pathname;
  const runningRef = useRef<Tour | null>(null);
  // Pattern of the screen a per-screen tour started on; null for the welcome
  // tour, which navigates by itself.
  const screenPathRef = useRef<string | null>(null);
  const layoutRef = useRef<LayoutHooks | null>(null);
  const expandedByTour = useRef(false);
  const queue = useMemo(() => createProgressQueue(() => ownerRef.current), []);

  const reload = useCallback(
    () => queryClient.invalidateQueries({ queryKey: [TOUR_QUERY_KEY] }),
    [queryClient],
  );

  // Completion is the adoption data: failing silently would leave the person
  // thinking they finished while the server says "in progress".
  const complete = useCallback(
    async (t: Tour) => {
      toast.dismiss(COMPLETE_FAILED_TOAST);
      const owner = ownerRef.current;
      await queue.drain();
      for (let attempt = 1; attempt <= 3; attempt++) {
        // Logged out (or someone else logged in) between attempts: the
        // completion must not go out with the next person's token.
        if (ownerRef.current !== owner) return;
        try {
          await tourApi.complete(t.id, t.version);
          void reload();
          return;
        } catch {
          await new Promise((r) => setTimeout(r, 800 * attempt));
        }
      }
      if (ownerRef.current !== owner) return;
      toast.error("Não foi possível registrar o tour.", {
        id: COMPLETE_FAILED_TOAST,
        description: "Verifique sua conexão.",
        duration: Infinity,
        action: { label: "Tentar de novo", onClick: () => void complete(t) },
      });
    },
    [queue, reload],
  );

  const engine = useMemo(
    () =>
      new TourEngine({
        navigate: (route) => navigateRef.current(route),
        screenName,
        onShow: (step) => {
          const t = runningRef.current;
          if (!t) return;
          queue.push(ownerRef.current, () => tourApi.advance(t.id, t.version, step));
        },
        onComplete: () => {
          const t = runningRef.current;
          runningRef.current = null;
          screenPathRef.current = null;
          setActive(false);
          if (t) void complete(t);
        },
        onClose: () => {
          runningRef.current = null;
          screenPathRef.current = null;
          setActive(false);
          void queue.drain().then(reload);
        },
        prepare: (element) => prepareSafely(layoutRef.current, element),
      }),
    [queue, complete, reload],
  );

  // Tour over (finished, closed, or logged out): the sidebar goes back to how
  // the person left it, through whichever layout is mounted now.
  useEffect(() => {
    if (!active) restoreSidebar(layoutRef.current, expandedByTour);
  }, [active]);

  const start = useCallback(
    (t: Tour, from: number, screenPath: string | null = null) => {
      if (!t.steps.length) return;
      setResume(null);
      runningRef.current = t;
      screenPathRef.current = screenPath;
      setActive(true);
      engine.start(t, from);
    },
    [engine],
  );

  // Logged out with the tour open: close it without saving. The failed
  // completion warning and the resume choice belonged to who left.
  useEffect(() => setPrompted(false), [user?.id]);
  useEffect(() => {
    if (user) return;
    toast.dismiss(COMPLETE_FAILED_TOAST);
    setResume(null);
    if (engine.active || runningRef.current) {
      runningRef.current = null;
      engine.stop();
      setActive(false);
    }
  }, [user, engine]);
  useEffect(() => () => engine.stop(), [engine]);

  const startWelcome = useCallback(() => {
    if (!welcome) return;
    const step = resumeStep(progress, welcome);
    if (step !== null) setResume({ tour: welcome, step });
    else start(welcome, 0);
  }, [welcome, progress, start]);

  // From the mandatory modal: resume straight from where the person stopped,
  // without the "continue or restart" question.
  const beginWelcome = useCallback(() => {
    if (!welcome) return;
    setPrompted(true);
    start(welcome, resumeStep(progress, welcome) ?? 0);
  }, [welcome, progress, start]);

  // A per-screen tour points at elements of one page: leaving it ends the tour
  // (the progress already sent stays).
  useEffect(() => {
    const started = screenPathRef.current;
    if (started === null || !runningRef.current) return;
    if (matchScreen(pathname)?.path === started) return;
    runningRef.current = null;
    screenPathRef.current = null;
    engine.stop();
    setActive(false);
    void queue.drain().then(reload);
  }, [pathname, engine, queue, reload]);

  const startPresent = useCallback(
    (t: Tour) => {
      const present = onlyPresent(t);
      if (!present.steps.length) return false;
      start(present, 0, matchScreen(pathnameRef.current)?.path ?? null);
      return true;
    },
    [start],
  );

  const showScreenTour = useCallback(
    (s: ScreenTour) => {
      if (!startPresent(asTour(s))) toast("Nada para mostrar nesta tela agora.");
    },
    [startPresent],
  );

  // A cut without any route belongs to one screen (same rule as DocsHS).
  const viewWhatsNew = useCallback(
    (cut: Tour) => {
      if (cut.steps.some((s) => s.route)) start(cut, 0);
      else if (!startPresent(cut)) void complete(cut);
    },
    [start, startPresent, complete],
  );

  const dismissWhatsNew = useCallback((cut: Tour) => void complete(cut), [complete]);

  const registerLayout = useCallback((hooks: LayoutHooks | null) => {
    layoutRef.current = hooks;
  }, []);
  const unregisterLayout = useCallback((hooks: LayoutHooks) => {
    if (layoutRef.current === hooks) layoutRef.current = null;
  }, []);

  const value = useMemo<TourContextValue>(
    () => ({
      welcome, progress, loaded: query.isSuccess, active, prompted,
      progressAll: query.data ?? [],
      startWelcome, beginWelcome, showScreenTour, viewWhatsNew, dismissWhatsNew, registerLayout,
    }),
    [
      welcome, progress, query.isSuccess, query.data, active, prompted,
      startWelcome, beginWelcome, showScreenTour, viewWhatsNew, dismissWhatsNew, registerLayout,
    ],
  );
  const layoutValue = useMemo<TourLayoutContextValue>(
    () => ({ registerLayout, unregisterLayout, expandedByTour }),
    [registerLayout, unregisterLayout],
  );

  return (
    <TourContext.Provider value={value}>
      <TourLayoutContext.Provider value={layoutValue}>
        {children}
        <AlertDialog open={resume !== null} onOpenChange={(open) => !open && setResume(null)}>
          {resume && (
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>Continuar de onde parou?</AlertDialogTitle>
                <AlertDialogDescription>
                  Você parou no passo {resume.step + 1} de {resume.tour.steps.length} do tour.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>Cancelar</AlertDialogCancel>
                <AlertDialogAction
                  className={buttonVariants({ variant: "outline" })}
                  onClick={() => start(resume.tour, 0)}
                >
                  Recomeçar
                </AlertDialogAction>
                <AlertDialogAction autoFocus onClick={() => start(resume.tour, resume.step)}>
                  Continuar do passo {resume.step + 1}
                </AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          )}
        </AlertDialog>
      </TourLayoutContext.Provider>
    </TourContext.Provider>
  );
}

export function useTour(): TourContextValue {
  const ctx = useContext(TourContext);
  if (!ctx) throw new Error("useTour must be used inside TourProvider");
  return ctx;
}

export function useTourLayout(): TourLayoutContextValue {
  const ctx = useContext(TourLayoutContext);
  if (!ctx) throw new Error("useTourLayout must be used inside TourProvider");
  return ctx;
}
