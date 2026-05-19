interface DonutRingProps {
  value: number | null;
  label: string;
  objective?: "increase" | "decrease";
  size?: number;
}

export function DonutRing({ value, label, objective = "increase", size = 52 }: DonutRingProps) {
  const radius = (size / 2) * 0.7;
  const circumference = 2 * Math.PI * radius;
  const capped = value !== null ? Math.min(Math.max(value, 0), 100) : 0;
  const strokeDash = (capped / 100) * circumference;

  let color = "#9ca3af";
  if (value !== null) {
    if (objective === "increase") {
      color = value >= 100 ? "#10b981" : value >= 80 ? "#f59e0b" : "#ef4444";
    } else {
      color = value <= 100 ? "#10b981" : value <= 120 ? "#f59e0b" : "#ef4444";
    }
  }

  const cx = size / 2;
  const cy = size / 2;

  return (
    <div className="flex flex-col items-center gap-0.5">
      <div className="relative" style={{ width: size, height: size }}>
        <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
          <circle
            cx={cx} cy={cy} r={radius}
            fill="none"
            stroke="currentColor"
            strokeWidth={size * 0.1}
            className="text-muted-foreground/15"
          />
          {value !== null && (
            <circle
              cx={cx} cy={cy} r={radius}
              fill="none"
              stroke={color}
              strokeWidth={size * 0.1}
              strokeDasharray={`${strokeDash} ${circumference}`}
              strokeLinecap="round"
              transform={`rotate(-90 ${cx} ${cy})`}
            />
          )}
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="font-bold leading-none" style={{ fontSize: size * 0.19, color }}>
            {value !== null ? `${Math.round(value)}%` : "--"}
          </span>
        </div>
      </div>
      <span className="text-[10px] text-muted-foreground leading-none">{label}</span>
    </div>
  );
}
