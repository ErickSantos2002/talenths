import { createContext, useContext, useEffect, useState, ReactNode } from "react";
import { auth as authApi, getToken, setToken, clearToken } from "@/lib/api";

const USER_KEY = "talenths_user";
function getCachedUser() {
  try { return JSON.parse(localStorage.getItem(USER_KEY) ?? "null"); } catch { return null; }
}
function setCachedUser(me: unknown) {
  try { localStorage.setItem(USER_KEY, JSON.stringify(me)); } catch {}
}
function clearCachedUser() {
  localStorage.removeItem(USER_KEY);
}

type AppRole = "master_admin" | "manager" | "user";

interface User {
  id: string;
  email: string;
  name?: string;
}

interface Profile {
  id: string;
  user_id: string;
  email: string;
  name: string;
  cpf: string | null;
  phone: string | null;
  company_id: string | null;
  department_id: string | null;
}

interface AuthContextType {
  user: User | null;
  profile: Profile | null;
  roles: AppRole[];
  loading: boolean;
  selectedCompanyId: string | null;
  setSelectedCompanyId: (id: string | null) => void;
  signIn: (email: string, password: string) => Promise<{ error: Error | null }>;
  signUp: (email: string, password: string, name: string) => Promise<{ error: Error | null }>;
  signOut: () => Promise<void>;
  hasRole: (role: AppRole) => boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<Profile | null>(null);
  const [roles, setRoles] = useState<AppRole[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedCompanyId, setSelectedCompanyId] = useState<string | null>(null);

  const applyMe = (me: any) => {
    setCachedUser(me);
    setUser({ id: me.id, email: me.email });
    if (me.profile) {
      const p = me.profile as unknown as Profile;
      setProfile(p);
      if (p.company_id) setSelectedCompanyId(p.company_id);
    }
    setRoles((me.roles ?? []).map((r: any) => r.role as AppRole));
  };

  const loadMe = async () => {
    try {
      const me = await authApi.me();
      applyMe(me);
    } catch {
      clearToken();
      clearCachedUser();
      setUser(null);
      setProfile(null);
      setRoles([]);
      setSelectedCompanyId(null);
    }
  };

  useEffect(() => {
    const token = getToken();
    const cached = getCachedUser();
    if (token && cached) {
      applyMe(cached);
      setLoading(false);
      // refresh in background without clearing session on failure
      authApi.me().then(applyMe).catch(() => {});
    } else if (token) {
      loadMe().finally(() => setLoading(false));
    } else {
      setLoading(false);
    }
  }, []);

  const signIn = async (email: string, password: string) => {
    try {
      const res = await authApi.login(email, password);
      setToken(res.access_token);
      setUser(res.user);
      await loadMe();
      return { error: null };
    } catch (e) {
      return { error: e as Error };
    }
  };

  const signUp = async (email: string, password: string, name: string) => {
    try {
      const res = await authApi.register(email, password, name);
      setToken(res.access_token);
      setUser(res.user);
      await loadMe();
      return { error: null };
    } catch (e) {
      return { error: e as Error };
    }
  };

  const signOut = async () => {
    await authApi.logout().catch(() => {});
    clearToken();
    clearCachedUser();
    setUser(null);
    setProfile(null);
    setRoles([]);
    setSelectedCompanyId(null);
  };

  const hasRole = (role: AppRole) => roles.includes(role);

  return (
    <AuthContext.Provider
      value={{ user, profile, roles, loading, selectedCompanyId, setSelectedCompanyId, signIn, signUp, signOut, hasRole }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error("useAuth must be used within AuthProvider");
  return context;
}
