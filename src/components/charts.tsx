import { ReactNode } from 'react';
import { TrendingUp, TrendingDown, Minus } from 'lucide-react';

/* ──────────────────────────────────────────────────
   STAT CARD (Re-exported here for backwards compat, though main is in ui.tsx)
────────────────────────────────────────────────── */
export function StatCard({
  label, value, icon, trend, trendLabel, color = 'sky',
}: {
  label: string; value: string | number; icon?: ReactNode;
  trend?: 'up' | 'down' | 'neutral'; trendLabel?: string; color?: string;
}) {
  const c: Record<string, string> = {
    sky: 'primary', emerald: 'success', amber: 'warning',
    rose: 'danger', violet: 'primary', slate: 'secondary'
  };
  const iconBg: Record<string, string> = {
    sky: 'bg-gradient-to-br from-blue-500 to-blue-600 text-white shadow-md shadow-blue-500/30',
    emerald: 'bg-gradient-to-br from-emerald-500 to-emerald-600 text-white shadow-md shadow-emerald-500/30',
    amber: 'bg-gradient-to-br from-amber-400 to-amber-600 text-white shadow-md shadow-amber-500/30',
    rose: 'bg-gradient-to-br from-rose-500 to-rose-600 text-white shadow-md shadow-rose-500/30',
    violet: 'bg-gradient-to-br from-violet-500 to-violet-600 text-white shadow-md shadow-violet-500/30',
    slate: 'bg-gradient-to-br from-brand-600 to-brand-800 text-white shadow-md shadow-brand-700/30',
  };
  const TrendIcon = trend === 'up' ? TrendingUp : trend === 'down' ? TrendingDown : Minus;
  const tColor = trend === 'up' ? 'text-success-600 bg-success-50' : trend === 'down' ? 'text-danger-600 bg-danger-50' : 'text-slate-500 bg-slate-50';

  return (
    <div className="card p-5 flex flex-col gap-4 hover-lift">
      <div className="flex items-start justify-between">
        {icon && (
          <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${iconBg[color] || iconBg.sky}`}>
            {icon}
          </div>
        )}
        {trendLabel && (
          <span className={`flex items-center gap-1 text-[11px] font-bold px-2 py-1 rounded-full ${tColor}`}>
            <TrendIcon size={12} /> {trendLabel}
          </span>
        )}
      </div>
      <div>
        <p className="text-2xl font-black text-slate-800 tracking-tight">{value}</p>
        <p className="text-xs font-semibold text-slate-400 uppercase tracking-widest mt-1">{label}</p>
      </div>
    </div>
  );
}

export function ChartCard({ title, children, action }: { title: string; children: ReactNode; action?: ReactNode }) {
  return (
    <div className="card p-5">
      <div className="flex items-center justify-between mb-5">
        <h3 className="text-base font-bold text-slate-800 tracking-tight">{title}</h3>
        {action}
      </div>
      {children}
    </div>
  );
}

export function BarChart({ data, color = '#f59e0b' }: { data: { label: string; value: number }[]; color?: string }) {
  const max = Math.max(...data.map((d) => d.value), 1);
  return (
    <div className="space-y-3.5">
      {data.map((d) => (
        <div key={d.label} className="flex items-center gap-3">
          <div className="w-28 text-xs font-medium text-slate-600 truncate" title={d.label}>{d.label}</div>
          <div className="flex-1 bg-slate-100 rounded-full h-3 overflow-hidden">
            <div
              className="h-full rounded-full transition-all duration-700 ease-out"
              style={{ width: `${(d.value / max) * 100}%`, background: color }}
            />
          </div>
          <div className="w-10 text-right text-xs font-bold text-slate-700">{d.value}</div>
        </div>
      ))}
      {data.length === 0 && <p className="text-sm text-slate-400 text-center py-4 font-medium">No data to display</p>}
    </div>
  );
}

export function LineChart({
  data, color = '#f59e0b', height = 180,
}: {
  data: { label: string; value: number }[]; color?: string; height?: number;
}) {
  const max = Math.max(...data.map((d) => d.value), 1);
  const w = 100;
  const h = 100;
  const step = data.length > 1 ? w / (data.length - 1) : 0;
  const points = data.map((d, i) => `${i * step},${h - (d.value / max) * h}`).join(' ');
  const areaPoints = `${points} ${w},${h} 0,${h}`;

  return (
    <div style={{ height }} className="w-full flex flex-col">
      <div className="flex-1 relative">
        <svg viewBox="0 0 100 100" preserveAspectRatio="none" className="absolute inset-0 w-full h-full overflow-visible">
          <defs>
            <linearGradient id={`grad-${color}`} x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor={color} stopOpacity="0.2" />
              <stop offset="100%" stopColor={color} stopOpacity="0" />
            </linearGradient>
          </defs>
          <polygon points={areaPoints} fill={`url(#grad-${color})`} />
          <polyline
            points={points} fill="none" stroke={color} strokeWidth="2.5"
            strokeLinejoin="round" strokeLinecap="round" vectorEffect="non-scaling-stroke"
          />
          {data.map((d, i) => (
            <circle
              key={i} cx={i * step} cy={h - (d.value / max) * h} r="2"
              fill="white" stroke={color} strokeWidth="1.5" vectorEffect="non-scaling-stroke"
            />
          ))}
        </svg>
      </div>
      <div className="flex justify-between mt-3 px-1 border-t border-slate-100 pt-2">
        {data.map((d, i) => (
          <span key={i} className="text-[10px] font-semibold text-slate-400 uppercase">{d.label}</span>
        ))}
      </div>
    </div>
  );
}

export function ProgressRing({
  value, size = 120, stroke = 12, color = '#f59e0b', label,
}: {
  value: number; size?: number; stroke?: number; color?: string; label?: string;
}) {
  const radius = 50 - stroke / 2;
  const circumference = 2 * Math.PI * radius;
  const clamped = Math.max(0, Math.min(100, value || 0));
  const dash = (clamped / 100) * circumference;
  return (
    <div className="flex flex-col items-center gap-3">
      <div className="relative" style={{ width: size, height: size }}>
        <svg width={size} height={size} viewBox="0 0 100 100" className="-rotate-90">
          <circle cx="50" cy="50" r={radius} fill="none" stroke="#f1f5f9" strokeWidth={stroke} />
          <circle
            cx="50" cy="50" r={radius} fill="none" stroke={color} strokeWidth={stroke}
            strokeDasharray={`${dash} ${circumference - dash}`} strokeLinecap="round"
            className="transition-all duration-700 ease-out"
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-2xl font-black tracking-tight" style={{ color }}>{Math.round(clamped)}%</span>
        </div>
      </div>
      {label && <p className="text-xs font-bold text-slate-500 uppercase tracking-widest text-center">{label}</p>}
    </div>
  );
}

export function DonutChart({
  segments, size = 160,
}: {
  segments: { label: string; value: number; color: string }[]; size?: number;
}) {
  const total = segments.reduce((s, x) => s + x.value, 0) || 1;
  const radius = 40;
  const circumference = 2 * Math.PI * radius;
  let offset = 0;
  return (
    <div className="flex items-center gap-6 justify-center">
      <div className="relative">
        <svg width={size} height={size} viewBox="0 0 100 100" className="-rotate-90">
          <circle cx="50" cy="50" r={radius} fill="none" stroke="#f1f5f9" strokeWidth="16" />
          {segments.map((s, i) => {
            const len = (s.value / total) * circumference;
            const dash = `${len} ${circumference - len}`;
            const el = (
              <circle
                key={i} cx="50" cy="50" r={radius} fill="none"
                stroke={s.color} strokeWidth="16" strokeDasharray={dash} strokeDashoffset={-offset}
                className="transition-all duration-700 ease-out"
              />
            );
            offset += len;
            return el;
          })}
        </svg>
        <div className="absolute inset-0 flex items-center justify-center flex-col">
          <span className="text-2xl font-black text-slate-800 tracking-tight">{total}</span>
          <span className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">Total</span>
        </div>
      </div>
      <div className="space-y-2.5">
        {segments.map((s, i) => (
          <div key={i} className="flex items-center gap-2">
            <span className="w-3 h-3 rounded-full shadow-sm" style={{ backgroundColor: s.color }} />
            <div>
              <p className="text-sm font-bold text-slate-700 leading-none">{s.label}</p>
              <p className="text-xs text-slate-400 mt-0.5">{s.value} ({Math.round((s.value / total) * 100)}%)</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
