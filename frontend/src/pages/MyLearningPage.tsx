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
  "bg-blue-500/15 text-blue-400",
  "bg-emerald-500/15 text-emerald-400",
  "bg-amber-500/15 text-amber-400",
  "bg-purple-500/15 text-purple-400",
  "bg-rose-500/15 text-rose-400",
  "bg-cyan-500/15 text-cyan-400",
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
        <div className="flex items-center gap-3">
          <GraduationCap className="h-6 w-6 text-primary" />
          <div>
            <h1 className="text-2xl font-bold">Minha Universidade</h1>
            <p className="text-sm text-muted-foreground">Seu histórico de aprendizado e desenvolvimento</p>
          </div>
        </div>

        {!isLoading && courses.length > 0 && (
          <>
            {/* Summary */}
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
              <Card className="hover:shadow-md hover:border-primary/20 transition-all">
                <CardContent className="p-5">
                  <div className="flex items-center justify-between mb-3">
                    <p className="text-sm text-muted-foreground font-medium">Cursos concluídos</p>
                    <div className="rounded-lg p-2 bg-primary/10">
                      <GraduationCap className="h-4 w-4 text-primary" />
                    </div>
                  </div>
                  <p className="text-3xl font-bold tracking-tight">{courses.length}</p>
                </CardContent>
              </Card>
              <Card className="hover:shadow-md hover:border-blue-500/20 transition-all">
                <CardContent className="p-5">
                  <div className="flex items-center justify-between mb-3">
                    <p className="text-sm text-muted-foreground font-medium">Total de horas</p>
                    <div className="rounded-lg p-2 bg-blue-500/10">
                      <Clock className="h-4 w-4 text-blue-400" />
                    </div>
                  </div>
                  <p className="text-3xl font-bold tracking-tight text-primary">{totalHours.toFixed(0)}h</p>
                </CardContent>
              </Card>
              <Card className="hover:shadow-md hover:border-emerald-500/20 transition-all">
                <CardContent className="p-5">
                  <div className="flex items-center justify-between mb-3">
                    <p className="text-sm text-muted-foreground font-medium">Áreas de conhecimento</p>
                    <div className="rounded-lg p-2 bg-emerald-500/10">
                      <BookOpen className="h-4 w-4 text-emerald-400" />
                    </div>
                  </div>
                  <p className="text-3xl font-bold tracking-tight text-emerald-400">{areas.length}</p>
                </CardContent>
              </Card>
            </div>

            {/* Areas breakdown */}
            <Card>
              <CardHeader className="pb-3">
                <CardTitle className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60">
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
          <div className="rounded-xl border border-dashed p-16 text-center">
            <BookOpen className="mx-auto h-10 w-10 text-muted-foreground/40 mb-3" />
            <p className="text-muted-foreground">Nenhum curso registrado ainda.</p>
            <p className="text-sm text-muted-foreground mt-1">Seu gestor irá registrar seus cursos concluídos aqui.</p>
          </div>
        ) : (
          <div>
            <h2 className="text-xs font-semibold uppercase tracking-widest text-muted-foreground/60 mb-3">
              Histórico de cursos
            </h2>
            <div className="space-y-2">
              {courses.map((c, i) => (
                <div key={c.id} className="flex items-center gap-3 rounded-xl border bg-card px-4 py-3 hover:bg-muted/30 transition-colors">
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
