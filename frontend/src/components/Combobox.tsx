import { useState } from "react";
import { Command as CommandPrimitive } from "cmdk";
import { Check, ChevronsUpDown } from "lucide-react";
import { cn } from "@/lib/utils";
import { Command, CommandEmpty, CommandGroup, CommandItem, CommandList } from "@/components/ui/command";

export interface ComboboxOption {
  value: string;
  label: string;
}

interface ComboboxProps {
  options: ComboboxOption[];
  value?: string;
  onChange: (value: string | undefined) => void;
  placeholder?: string;
  searchPlaceholder?: string;
  emptyText?: string;
  className?: string;
  disabled?: boolean;
}

/**
 * Select com busca por texto, editável direto no campo: ao dar TAB (ou clicar) e
 * começar a digitar, a lista abre e filtra — sem precisar do mouse.
 */
export function Combobox({
  options,
  value,
  onChange,
  placeholder = "Selecionar...",
  searchPlaceholder = "Buscar...",
  emptyText = "Nada encontrado.",
  className,
  disabled,
}: ComboboxProps) {
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState("");
  const selected = options.find(o => o.value === value);

  const select = (v: string | undefined) => {
    onChange(v);
    setQuery("");
    setOpen(false);
  };

  return (
    <Command className="relative overflow-visible bg-transparent">
      <div className="relative">
        <CommandPrimitive.Input
          value={open ? query : (selected?.label ?? "")}
          onValueChange={(v) => { setQuery(v); if (!open) setOpen(true); }}
          onFocus={() => { setQuery(""); setOpen(true); }}
          onBlur={() => setOpen(false)}
          onKeyDown={(e) => {
            if (e.key === "Escape" && open) {
              e.preventDefault();
              e.stopPropagation();
              setOpen(false);
              (e.target as HTMLInputElement).blur();
            }
          }}
          disabled={disabled}
          placeholder={open ? searchPlaceholder : placeholder}
          role="combobox"
          aria-expanded={open}
          className={cn(
            "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 pr-8 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
            !selected && !open && "text-muted-foreground",
            className,
          )}
        />
        <ChevronsUpDown className="pointer-events-none absolute right-2 top-1/2 h-4 w-4 -translate-y-1/2 opacity-50" />
      </div>
      {open && (
        <div className="absolute left-0 top-[calc(100%+4px)] z-50 w-full rounded-md border bg-popover text-popover-foreground shadow-md outline-none animate-in fade-in-0 zoom-in-95">
          <CommandList>
            <CommandEmpty>{emptyText}</CommandEmpty>
            <CommandGroup>
              {options.map(o => (
                <CommandItem
                  key={o.value}
                  value={`${o.label} ${o.value}`}
                  onMouseDown={(e) => e.preventDefault()}
                  onSelect={() => select(o.value === value ? undefined : o.value)}
                >
                  <Check className={cn("mr-2 h-4 w-4", value === o.value ? "opacity-100" : "opacity-0")} />
                  <span className="truncate">{o.label}</span>
                </CommandItem>
              ))}
            </CommandGroup>
          </CommandList>
        </div>
      )}
    </Command>
  );
}
