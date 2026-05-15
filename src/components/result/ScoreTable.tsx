import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { DniaFullAcronym } from "@/components/DniaInfoIcon";
import { discToDisplayKey, dniaDisplayOrder } from "@/data/dniaLabels";

interface ScoreTableProps {
  labels: Record<string, string>;
  naturalData: Record<string, number>;
  adaptedData?: Record<string, number>;
  primaryColor?: string;
  secondaryColor?: string;
  showDniaAcronym?: boolean;
}

export function ScoreTable({ labels, naturalData, adaptedData, primaryColor = "text-primary", secondaryColor = "text-secondary", showDniaAcronym = true }: ScoreTableProps) {
  return (
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead className="w-[100px]">
            <div className="flex items-center gap-2">
              Dimensão
              {showDniaAcronym && <DniaFullAcronym className="gap-1.5" />}
            </div>
          </TableHead>
          <TableHead className="text-center">{adaptedData ? "Natural" : "Valor"}</TableHead>
          {adaptedData && <TableHead className="text-center">Adaptado</TableHead>}
        </TableRow>
      </TableHeader>
      <TableBody>
        {(labels === undefined || Object.keys(labels).some(k => ["D","I","S","C"].includes(k)) ? dniaDisplayOrder : Object.keys(naturalData)).map((key) => {
          const value = naturalData[key];
          if (value === undefined) return null;
          return (
            <TableRow key={key}>
              <TableCell className="font-medium">{discToDisplayKey[key] || key} - {labels[key]}</TableCell>
              <TableCell className={`text-center font-bold ${primaryColor}`}>{value}</TableCell>
              {adaptedData && (
                <TableCell className={`text-center font-bold ${secondaryColor}`}>{adaptedData[key]}</TableCell>
              )}
            </TableRow>
          );
        })}
      </TableBody>
    </Table>
  );
}
