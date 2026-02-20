import React from "react";
import { GameEvent, EventType } from "../models/types";
import { TrendingUp, TrendingDown, Star, Activity } from "lucide-react";

interface Props {
  events: GameEvent[];
}

const getEventStyles = (type: EventType) => {
  switch (type) {
    case EventType.opportunity:
    case EventType.immigration:
      return { icon: <TrendingUp size={16} className="text-success" />, color: "var(--success-color)", bg: "rgba(63, 185, 80, 0.1)" };
    case EventType.disaster:
    case EventType.emigration:
      return { icon: <TrendingDown size={16} className="text-danger" />, color: "var(--danger-color)", bg: "rgba(248, 81, 73, 0.1)" };
    case EventType.milestone:
      return { icon: <Star size={16} className="text-warning" />, color: "var(--warning-color)", bg: "rgba(210, 153, 34, 0.1)" };
    default:
      return { icon: <Activity size={16} />, color: "var(--text-secondary)", bg: "var(--bg-secondary)" };
  }
};

export default function EventLog({ events }: Props) {
  if (events.length === 0) {
    return (
      <div className="card" style={{ height: "100%", opacity: 0.7, display: "flex", alignItems: "center", justifyContent: "center" }}>
        <p className="text-sm">No events recorded yet.</p>
      </div>
    );
  }

  return (
    <div className="card" style={{ height: "600px", overflowY: "auto", display: "flex", flexDirection: "column", gap: "0.75rem" }}>
      {events.map((e) => {
        const style = getEventStyles(e.type);
        const timeStr = new Date(e.timestamp).toLocaleTimeString();

        return (
          <div key={e.id} className="animate-fade-in" style={{ padding: "0.75rem", borderRadius: "var(--radius-md)", backgroundColor: style.bg, borderLeft: `3px solid ${style.color}` }}>
            <div className="flex justify-between items-center" style={{ marginBottom: "0.25rem" }}>
              <div className="flex items-center gap-2">
                {style.icon}
                <span className="text-sm" style={{ fontWeight: 600, color: "var(--text-primary)" }}>{e.title}</span>
              </div>
              <span className="text-xs text-secondary">{timeStr}</span>
            </div>

            <p className="text-xs text-secondary" style={{ margin: "0.5rem 0", lineHeight: 1.4 }}>
              {e.description}
            </p>

            {e.populationChange !== 0 && (
              <div className="text-xs" style={{ fontWeight: 600, color: style.color }}>
                {e.populationChange > 0 ? "+" : ""}{Math.floor(e.populationChange)} Population
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
