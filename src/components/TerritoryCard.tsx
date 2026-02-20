import React from "react";
import { Territory, TerritoryType } from "../models/types";
import { Building2, Home, Trees, Waves, Mountain, Sun, Snowflake, Moon, Space, Rocket, AlertCircle, Tent } from "lucide-react";

interface Props {
  territory: Territory;
}

const getIconForType = (type: TerritoryType) => {
  switch (type) {
    case TerritoryType.rural: return <Trees size={20} className="text-success" />;
    case TerritoryType.suburbs: return <Home size={20} className="text-primary" />;
    case TerritoryType.urban: return <Building2 size={20} className="text-primary" />;
    case TerritoryType.metropolis: return <Building2 size={20} className="text-warning" />;
    case TerritoryType.border: return <AlertCircle size={20} className="text-danger" />;
    case TerritoryType.coastal: return <Waves size={20} className="text-primary" />;
    case TerritoryType.caves: return <Tent size={20} className="text-secondary" />;
    case TerritoryType.underground: return <Tent size={20} className="text-warning" />;
    case TerritoryType.mountains: return <Mountain size={20} className="text-secondary" />;
    case TerritoryType.desert: return <Sun size={20} className="text-warning" />;
    case TerritoryType.arctic: return <Snowflake size={20} className="text-primary" />;
    case TerritoryType.moon: return <Moon size={20} className="text-secondary" />;
    case TerritoryType.orbital: return <Rocket size={20} className="text-primary" />;
    case TerritoryType.spaceStation: return <Rocket size={20} className="text-success" />;
    case TerritoryType.interstellar: return <Rocket size={20} className="text-warning" />;
    default: return <Home size={20} />;
  }
};

export default function TerritoryCard({ territory }: Props) {
  const percentage = Math.min(100, (territory.population / territory.capacity) * 100);
  const isDanger = percentage >= 90;

  return (
    <div className="card" style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
      <div className="flex justify-between items-center">
        <div className="flex items-center gap-2">
          {getIconForType(territory.type)}
          <h3 style={{ margin: 0 }}>{territory.name}</h3>
        </div>
      </div>
      <p className="text-xs" style={{ margin: 0, minHeight: "40px" }}>
        {territory.description || "A growing settlement."}
      </p>

      <div style={{ marginTop: "auto" }}>
        <div className="flex justify-between items-center text-sm" style={{ marginBottom: "0.25rem" }}>
          <span>Population</span>
          <span style={{ fontWeight: 600 }}>{Math.floor(territory.population).toLocaleString()} / {territory.capacity.toLocaleString()}</span>
        </div>
        <div style={{ width: "100%", height: "8px", backgroundColor: "var(--bg-secondary)", borderRadius: "var(--radius-full)", overflow: "hidden" }}>
          <div
            style={{
              height: "100%",
              width: `${percentage}%`,
              backgroundColor: isDanger ? "var(--danger-color)" : "var(--accent-primary)",
              transition: "width 0.5s cubic-bezier(0.4, 0, 0.2, 1)"
            }}
          />
        </div>
      </div>
    </div>
  );
}
