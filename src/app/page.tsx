"use client";

import React, { useState } from "react";
import { useGame } from "../context/GameContext";
import { useAuth } from "../context/AuthContext";
import { Users, LogOut, Save, Zap } from "lucide-react";
import AuthModal from "../components/AuthModal";
import TerritoryCard from "../components/TerritoryCard";
import EventLog from "../components/EventLog";

export default function Home() {
  const { gameState, manualImmigration } = useGame();
  const { user, signOut, saveGameStateToCloud } = useAuth();
  const [showAuth, setShowAuth] = useState(false);

  const totalPopulation = Math.floor(gameState.territories.reduce((acc, t) => acc + t.population, 0));
  const totalCapacity = gameState.territories.reduce((acc, t) => acc + t.capacity, 0);
  const capacityPercentage = Math.min(100, Math.round((totalPopulation / totalCapacity) * 100)) || 0;

  const handleManualImmigration = () => {
    manualImmigration();
  };

  return (
    <div className="container animate-fade-in">
      {/* Header */}
      <header className="flex justify-between items-center" style={{ marginBottom: "2rem", paddingBottom: "1.5rem", borderBottom: "1px solid var(--border-color)" }}>
        <div>
          <h1 style={{ marginBottom: "0.25rem" }}>The Immigrants</h1>
          <p style={{ margin: 0 }}>From Caves to Space Stations</p>
        </div>

        <div className="flex gap-4 items-center">
          {user ? (
            <div className="flex gap-4 items-center">
              <span className="text-sm text-secondary">Commander {user.displayName || "Unknown"}</span>
              <button className="btn btn-secondary" onClick={() => saveGameStateToCloud(gameState)} title="Save to Cloud">
                <Save size={16} /> Save
              </button>
              <button className="btn btn-secondary" onClick={signOut} title="Sign Out">
                <LogOut size={16} />
              </button>
            </div>
          ) : (
            <button className="btn btn-primary" onClick={() => setShowAuth(true)}>
              Sign In / Sign Up
            </button>
          )}
        </div>
      </header>

      {/* Main Stats Area */}
      <div className="card" style={{ marginBottom: "2rem", display: "flex", justifyContent: "space-between", alignItems: "center", background: "linear-gradient(135deg, rgba(33,38,45,1) 0%, rgba(22,27,34,1) 100%)", borderColor: "rgba(88,166,255,0.3)", boxShadow: "0 0 20px rgba(88, 166, 255, 0.05)" }}>
        <div className="flex items-center gap-8">
          <div>
            <div className="text-sm text-secondary" style={{ display: "flex", alignItems: "center", gap: "0.5rem" }}><Users size={16}/> Total Population</div>
            <div style={{ fontSize: "3rem", fontWeight: 800, color: "var(--accent-primary)", lineHeight: 1 }}>
              {totalPopulation.toLocaleString()}
            </div>
          </div>
          <div style={{ paddingLeft: "2rem", borderLeft: "1px solid var(--border-color)" }}>
            <div className="text-sm text-secondary">Total Immigrants Assisted</div>
            <div style={{ fontSize: "1.5rem", fontWeight: 700 }}>{gameState.totalImmigrants.toLocaleString()}</div>
          </div>
        </div>

        <div className="flex-col items-center" style={{ width: "300px" }}>
          <button
            className="btn btn-primary"
            style={{ width: "100%", padding: "1rem", fontSize: "1.1rem", animation: "pulse 2s infinite" }}
            onClick={handleManualImmigration}
          >
            <Zap size={20} /> Guide Immigrants
          </button>
          <div style={{ marginTop: "1rem", width: "100%" }}>
            <div className="flex justify-between text-xs" style={{ marginBottom: "0.25rem" }}>
              <span>Capacity usage</span>
              <span>{capacityPercentage}%</span>
            </div>
            <div style={{ width: "100%", height: "6px", backgroundColor: "var(--bg-secondary)", borderRadius: "var(--radius-full)", overflow: "hidden" }}>
              <div style={{ height: "100%", width: `${capacityPercentage}%`, backgroundColor: capacityPercentage > 90 ? "var(--danger-color)" : "var(--accent-primary)", transition: "width var(--transition-normal)" }}></div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid lg:grid-cols-4 gap-8">
        {/* Left Column: Territories */}
        <div style={{ gridColumn: "span 3" }}>
          <div className="flex justify-between items-center" style={{ marginBottom: "1rem" }}>
            <h2>Territories ({gameState.territories.length})</h2>
          </div>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
            {gameState.territories.map((territory) => (
              <TerritoryCard key={territory.id} territory={territory} />
            ))}
          </div>
        </div>

        {/* Right Column: Event Log */}
        <div>
          <h2>Event Log</h2>
          <EventLog events={gameState.eventHistory} />
        </div>
      </div>

      {showAuth && <AuthModal onClose={() => setShowAuth(false)} />}
    </div>
  );
}
