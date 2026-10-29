import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from "@/components/ui/dialog";
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from "@/components/ui/select";
import { TERMINATION_REASONS, type TerminationReason } from "@/lib/termination";

export interface DeactivateInput {
  termination_date: string;
  reason: TerminationReason;
  note?: string;
}

interface Props {
  name: string | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onConfirm: (input: DeactivateInput) => Promise<void>;
}

function todayISO(): string {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
}

export function DeactivateCollaboratorDialog({ name, open, onOpenChange, onConfirm }: Props) {
  const [date, setDate] = useState(todayISO());
  const [reason, setReason] = useState<TerminationReason | "">("");
  const [note, setNote] = useState("");
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (open) {
      setDate(todayISO());
      setReason("");
      setNote("");
    }
  }, [open]);

  const today = todayISO();
  const noteRequired = reason === "other";
  const valid = !!date && date <= today && !!reason && (!noteRequired || note.trim().length > 0);

  const handleConfirm = async () => {
    if (!valid || !reason) return;
    setSaving(true);
    try {
      await onConfirm({ termination_date: date, reason, note: note.trim() || undefined });
    } finally {
      setSaving(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Desligar colaborador</DialogTitle>
          <DialogDescription>
            <strong>{name}</strong> perde o acesso na hora e sai das listas e contagens. O histórico fica
            guardado e você pode reativar depois.
          </DialogDescription>
        </DialogHeader>
        <div className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="termination-date">Data do desligamento</Label>
            <Input
              id="termination-date"
              type="date"
              value={date}
              max={today}
              onChange={(e) => setDate(e.target.value)}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="termination-reason">Motivo</Label>
            <Select value={reason} onValueChange={(v) => setReason(v as TerminationReason)}>
              <SelectTrigger id="termination-reason">
                <SelectValue placeholder="Selecione o motivo" />
              </SelectTrigger>
              <SelectContent>
                {TERMINATION_REASONS.map((r) => (
                  <SelectItem key={r.value} value={r.value}>{r.label}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <Label htmlFor="termination-note">
              Observação{noteRequired ? "" : " (opcional)"}
            </Label>
            <Textarea
              id="termination-note"
              value={note}
              maxLength={1000}
              onChange={(e) => setNote(e.target.value)}
              placeholder={noteRequired ? "Descreva o motivo" : ""}
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)} disabled={saving}>Cancelar</Button>
          <Button variant="destructive" onClick={handleConfirm} disabled={!valid || saving}>
            {saving ? "Desligando..." : "Desligar colaborador"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
