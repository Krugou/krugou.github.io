import React, { useState } from "react";
import { X, Mail, Lock } from "lucide-react";
import { createUserWithEmailAndPassword, signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../services/firebase";

interface Props {
  onClose: () => void;
}

export default function AuthModal({ onClose }: Props) {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setLoading(true);

    try {
      if (isLogin) {
        await signInWithEmailAndPassword(auth, email, password);
      } else {
        await createUserWithEmailAndPassword(auth, email, password);
      }
      onClose(); // Automatically close on success
    } catch (err: unknown) {
      if (err instanceof Error) {
        setError(err.message || "Failed to authenticate.");
      } else {
        setError("Failed to authenticate.");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="modal-overlay">
      <div className="modal-content relative animate-fade-in">
        <button onClick={onClose} style={{ position: "absolute", top: "1rem", right: "1rem", background: "none", border: "none", color: "var(--text-secondary)", cursor: "pointer" }}>
          <X size={20} />
        </button>

        <h2 style={{ textAlign: "center", marginBottom: "1.5rem" }}>
          {isLogin ? "Welcome Back Commander" : "Register Database ID"}
        </h2>

        <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
          {error && <div style={{ padding: "0.75rem", backgroundColor: "rgba(248, 81, 73, 0.1)", color: "var(--danger-color)", borderRadius: "var(--radius-md)", fontSize: "0.875rem" }}>{error}</div>}

          <div style={{ display: "flex", flexDirection: "column", gap: "0.25rem" }}>
            <label className="text-sm">Transmission Code (Email)</label>
            <div style={{ display: "flex", alignItems: "center", backgroundColor: "var(--bg-secondary)", borderRadius: "var(--radius-md)", padding: "0 0.75rem", border: "1px solid var(--border-color)" }}>
              <Mail size={16} className="text-secondary" />
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                style={{ width: "100%", padding: "0.75rem", background: "none", border: "none", color: "var(--text-primary)", outline: "none" }}
                placeholder="commander@earth.gsa"
              />
            </div>
          </div>

          <div style={{ display: "flex", flexDirection: "column", gap: "0.25rem" }}>
            <label className="text-sm">Access Cipher (Password)</label>
            <div style={{ display: "flex", alignItems: "center", backgroundColor: "var(--bg-secondary)", borderRadius: "var(--radius-md)", padding: "0 0.75rem", border: "1px solid var(--border-color)" }}>
              <Lock size={16} className="text-secondary" />
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                style={{ width: "100%", padding: "0.75rem", background: "none", border: "none", color: "var(--text-primary)", outline: "none" }}
                placeholder="••••••••"
              />
            </div>
          </div>

          <button type="submit" className="btn btn-primary" style={{ width: "100%", marginTop: "0.5rem" }} disabled={loading}>
            {loading ? "Establishing Link..." : isLogin ? "Initialize Link" : "Register Credentials"}
          </button>
        </form>

        <div style={{ marginTop: "1.5rem", textAlign: "center" }}>
          <button
            type="button"
            onClick={() => setIsLogin(!isLogin)}
            style={{ background: "none", border: "none", color: "var(--accent-primary)", fontSize: "0.875rem", cursor: "pointer", textDecoration: "underline" }}
          >
            {isLogin ? "Require new database ID? Register" : "Existing Commander? Initialize Link"}
          </button>
        </div>
      </div>
    </div>
  );
}
