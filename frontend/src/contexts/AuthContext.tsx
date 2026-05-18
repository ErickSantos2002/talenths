import { createContext, useContext, useEffect, useState, ReactNode } from "react";
import { auth as authApi, companies as companiesApi, getToken, setToken, clearToken } from "@/lib/api";

type AppRole = "master_admin" | "company_admin" | "leader" | "user";

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
  const [selectedCompanyId, setSelectedCompanyId] = useState<string | null>(() =>
    localStorage.getItem("selectedCompanyId")
  );

  const handleSetSelectedCompanyId = (id: string | null) => {
    setSelectedCompanyId(id);
    if (id === null) localStorage.removeItem("selectedCompanyId");
    else localStorage.setItem("selectedCompanyId", id);
  };

  const loadMe = async () => {
    try {
      const me = await authApi.me();
      setUser({ id: me.id, email: me.email });
      if (me.profile) setProfile(me.profile as unknown as Profile);
      setRoles(me.roles.map((r) => r.role as AppRole));
    } catch {
      clearToken();
      setUser(null);
      setProfile(null);
      setRoles([]);
    }
  };

  useEffect(() => {
    if (getToken()) {
      loadMe().finally(() => setLoading(false));
    } else {
      setLoading(false);
    }
  }, []);

  // Auto-seleciona primeira empresa para master_admin
  useEffect(() => {
    if (selectedCompanyId || !profile || !roles.includes("master_admin")) return;
    companiesApi.list().then((list) => {
      if (list.length > 0) handleSetSelectedCompanyId(list[0].id as string);
    }).catch(() => {});
  }, [profile, roles, selectedCompanyId]);

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
    setUser(null);
    setProfile(null);
    setRoles([]);
    localStorage.removeItem("selectedCompanyId");
  };

  const hasRole = (role: AppRole) => roles.includes(role);

  return (
    <AuthContext.Provider
      value={{ user, profile, roles, loading, selectedCompanyId, setSelectedCompanyId: handleSetSelectedCompanyId, signIn, signUp, signOut, hasRole }}
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
