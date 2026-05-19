import { useQuery } from "@tanstack/react-query";
import { learning as learningApi } from "@/lib/api";
import { AdminLayout } from "@/components/AdminLayout";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import type { EmployeeCourse } from "@/types/learning";
import { GraduationCap, Clock, CalendarDays, BookOpen } from "lucide-react";
import { cn } from "@/lib/utils";

const AREA_COLORS = [
  "bg-blue-500/10 text-blue-600",
  "bg-emerald-500/10 text-emerald-600",
  "bg-amber-500/10 text-amber-600",
  "bg-purple-500/10 text-purple-600",
  "bg-rose-500/10 text-rose-600",
  "bg-cyan-500/10 text-cyan-600",
];

function areaBreakdown(courses: EmployeeCourse[]) {
  const map: Record<string, number> = {};
  for (const c of courses) {
    map[c.area] = (map[c.area] ?? 0) + c.hours;
  }
  return Object.entries(map).sort((a, b) => b[1] - a[1]);
}

export default function MyLearningPage() {
  const { data: courses = [], isLoading } = useQuery({
    queryKey: ["learning-my"],
    queryFn: learningApi.my,
  });

  const totalHours = courses.reduce((s, c) => s + c.hours, 0);
  const areas = areaBreakdown(courses);
  const maxAreaHours = areas[0]?.[1] ?? 1;

  return (
    <AdminLayout>
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <GraduationCap className="h-6 w-6" /> Minha Universidade
          </h1>
          <p className="text-muted-foreground text-sm mt-1">
            Seu histórico de aprendizado e desenvolvimento
          </p>
        </div>

        {!isLoading && courses.length > 0 && (
          <>
            {/* Summary */}
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
              <Card>
                <CardContent className="pt-6 text-center">
                  <p className="text-3xl font-bold">{courses.length}</p>
                  <p className="text-sm text-muted-foreground mt-1">Cursos concluídos</p>
                </CardContent>
              </Card>
              <Card>
                <CardContent className="pt-6 text-center">
                  <p className="text-3xl font-bold text-primary">{totalHours.toFixed(0)}h</p>
                  <p className="text-sm text-muted-foreground mt-1">Total de horas</p>
                </CardContent>
              </Card>
              <Card>
                <CardContent className="pt-6 text-center">
                  <p className="text-3xl font-bold text-emerald-500">{areas.length}</p>
                  <p className="text-sm text-muted-foreground mt-1">Áreas de conhecimento</p>
                </CardContent>
              </Card>
            </div>

            {/* Areas breakdown */}
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
                  Horas por área
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {areas.map(([area, h], i) => (
                  <div key={area} className="space-y-1">
                    <div className="flex items-center justify-between text-sm">
                      <span className={cn("font-medium", AREA_COLORS[i % AREA_COLORS.length].split(" ")[1])}>
                        {area}
                      </span>
                      <span className="text-muted-foreground">{h.toFixed(0)}h</span>
                    </div>
                    <Progress value={(h / maxAreaHours) * 100} className="h-1.5" />
                  </div>
                ))}
              </CardContent>
            </Card>
          </>
        )}

        {/* Course list */}
        {isLoading ? (
          <p className="text-sm text-muted-foreground">Carregando...</p>
        ) : courses.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <BookOpen className="h-10 w-10 text-muted-foreground mx-auto mb-3" />
              <p className="text-muted-foreground">Nenhum curso registrado ainda.</p>
              <p className="text-sm text-muted-foreground mt-1">
                Seu gestor irá registrar seus cursos concluídos aqui.
              </p>
            </CardContent>
          </Card>
        ) : (
          <div>
            <h2 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-3">
              Histórico de cursos
            </h2>
            <div className="space-y-2">
              {courses.map((c, i) => (
                <div key={c.id} className="flex items-center gap-3 rounded-xl border bg-card px-4 py-3">
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium">{c.course_title}</p>
                    <div className="flex items-center gap-2 mt-1 flex-wrap">
                      <Badge
                        className={cn("text-[10px] h-4 px-1.5 border-0", AREA_COLORS[
                          areas.findIndex(([a]) => a === c.area) % AREA_COLORS.length
                        ])}
                      >
                        {c.area}
                      </Badge>
                      <span className="flex items-center gap-1 text-xs text-muted-foreground">
                        <Clock className="h-3 w-3" />{c.hours}h
                      </span>
                      <span className="flex items-center gap-1 text-xs text-muted-foreground">
                        <CalendarDays className="h-3 w-3" />
                        {new Date(c.completed_at + "T12:00:00").toLocaleDateString("pt-BR")}
                      </span>
                    </div>
                  </div>
                  {c.source === "csv" && (
                    <Badge variant="outline" className="text-[10px] h-4 px-1.5 shrink-0">CSV</Badge>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </AdminLayout>
  );
}
