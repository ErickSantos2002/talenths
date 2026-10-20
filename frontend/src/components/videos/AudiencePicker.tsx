import { useMemo, useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { collaborators, departments } from "@/lib/api";
import type { VideoRules } from "@/lib/api";
import { toggleId } from "@/lib/videoFormat";
import { Checkbox } from "@/components/ui/checkbox";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

type Props = { value: VideoRules; onChange: (rules: VideoRules) => void };

export function AudiencePicker({ value, onChange }: Props) {
  const [search, setSearch] = useState("");

  const { data: deptList = [] } = useQuery({
    queryKey: ["departments"],
    queryFn: () => departments.list(),
  });
  const { data: collabList = [] } = useQuery({
    queryKey: ["collaborators"],
    queryFn: () => collaborators.list(),
  });

  const people = useMemo(() => {
    const q = search.trim().toLowerCase();
    return collabList
      .filter((c) => !q || String(c.name ?? "").toLowerCase().includes(q))
      .sort((a, b) => String(a.name ?? "").localeCompare(String(b.name ?? "")));
  }, [collabList, search]);

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2">
        <Checkbox
          id="aud-all"
          checked={value.all}
          onCheckedChange={(c) => onChange({ ...value, all: c === true })}
        />
        <Label htmlFor="aud-all">Todos os colaboradores</Label>
      </div>

      {!value.all && (
        <>
          <div className="space-y-2">
            <Label>Departamentos</Label>
            <div className="max-h-32 overflow-y-auto rounded-md border p-2 space-y-1">
              {deptList.length === 0 && <p className="text-sm text-muted-foreground">Nenhum departamento.</p>}
              {deptList.map((d) => {
                const id = String(d.id);
                return (
                  <div key={id} className="flex items-center gap-2">
                    <Checkbox
                      id={`aud-dept-${id}`}
                      checked={value.department_ids.includes(id)}
                      onCheckedChange={() =>
                        onChange({ ...value, department_ids: toggleId(value.department_ids, id) })
                      }
                    />
                    <Label htmlFor={`aud-dept-${id}`} className="font-normal">{String(d.name)}</Label>
                  </div>
                );
              })}
            </div>
          </div>

          <div className="space-y-2">
            <Label>Pessoas ({value.user_ids.length} selecionadas)</Label>
            <Input
              placeholder="Buscar por nome..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <div className="max-h-40 overflow-y-auto rounded-md border p-2 space-y-1">
              {people.length === 0 && <p className="text-sm text-muted-foreground">Ninguém encontrado.</p>}
              {people.map((c) => {
                const id = String(c.user_id);
                return (
                  <div key={id} className="flex items-center gap-2">
                    <Checkbox
                      id={`aud-user-${id}`}
                      checked={value.user_ids.includes(id)}
                      onCheckedChange={() =>
                        onChange({ ...value, user_ids: toggleId(value.user_ids, id) })
                      }
                    />
                    <Label htmlFor={`aud-user-${id}`} className="font-normal">{String(c.name)}</Label>
                  </div>
                );
              })}
            </div>
          </div>
        </>
      )}
    </div>
  );
}
