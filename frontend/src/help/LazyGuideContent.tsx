import { Component, lazy, Suspense, type ReactNode } from "react";
import { GuideLoadError } from "./GuideLoadError";
import { Skeleton } from "@/components/ui/skeleton";

const GuideContent = lazy(() => import("./GuideContent").then((m) => ({ default: m.GuideContent })));

class GuideErrorBoundary extends Component<{ children: ReactNode }, { failed: boolean }> {
  state = { failed: false };

  static getDerivedStateFromError() {
    return { failed: true };
  }

  render() {
    if (this.state.failed) return <GuideLoadError what="o guia" />;
    return this.props.children;
  }
}

export function LazyGuideContent({ body }: { body: string }) {
  return (
    <GuideErrorBoundary>
      <Suspense
        fallback={
          <div className="space-y-2" aria-hidden="true">
            <Skeleton className="h-4 w-3/4" />
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-5/6" />
          </div>
        }
      >
        <GuideContent body={body} />
      </Suspense>
    </GuideErrorBoundary>
  );
}
