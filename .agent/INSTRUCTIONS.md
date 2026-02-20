# Project Standards & Enhancement Roadmap

This document serves as the "source of truth" for bringing **The Immigrants** to its maximum potential. Every update should align with these cinematic and technical standards.

## 📦 Package Policy

- **Always accept new packages.** If a feature or improvement benefits from a new npm dependency (e.g., `framer-motion`, `react-virtuoso`, `howler`), install it without hesitation. Do not skip improvements because they require a new package.

## 🏛️ Architecture & Clean Code

- **Domain-Driven Contexts**: Move game logic into dedicated service classes (e.g., `PopulationService`, `EraService`) to keep `GameContext` clean.
- **Strict Typing**: No `any` types. Use exhaustive enums for `TerritoryType`, `EraId`, and `EventCategory`.
- **Immutable State**: Use functional updates for state transitions to ensure predictability and easy debugging.
- **Service Worker Persistence**: Implement robust offline support and background syncing for a true PWA experience.

## 🎬 Cinematic UI/UX Standards

- **Motion Orchestration**: Use a library like `framer-motion` for complex transitions between dashboards and era overlays.
- **Glassmorphism & Depth**: Maintain the `cinematic-card` aesthetic with layers of blur, subtle borders, and dynamic shadows.
- **Ambient Feedback**:
  - **Soundscapes**: Integrate the Web Audio API for subtle hover clicks, ambient space-drones, and triumphant era-transition fanfares.
  - **Haptics**: Trigger haptic feedback on mobile for major population milestones.
- **Dynamic HUD**: The header and population counter should feel like a high-tech instrument panel (glitch effects on disasters, glow pulses on growth).

## ⚡ Performance Optimization

- **Memoization Strategy**: Use `useMemo` and `useCallback` aggressively for territory calculations and event generation.
- **Asset Pipelining**: Use WebP/AVIF for images. Implement lazy loading for late-game assets.
- **Virtualized Lists**: If the `EventLog` exceeds 100 entries, use virtualization to maintain 60FPS.

## ♿ Accessibility & Inclusivity

- **WCAG 2.1 AA Compliance**: All text must meet contrast ratios. Use `aria-live` for critical population events.
- **Keyboard Mastery**: The entire game should be playable via keyboard (shortcuts for ` manualImmigration`, etc.).
- **High-Contrast Dark Mode**: Ensure a "High Visibility" variant for the cinematic theme.

## 🚀 The "Max Potential" Roadmap

To consider the game "fully realized," the following must be implemented:

1. [ ] **The Tech Tree**: A branching research system that alters territory multipliers.
2. [ ] **Global Trade & Transit**: Moving population _between_ territories with efficiency penalties.
3. [ ] **Era-Specific Mechanics**: Unique UI components and mini-games that unlock in later phases (e.g., Orbital Radar).
4. [ ] **Prestige System**: "Chronos Reset" – sacrifice population for permanent technical advancements.
5. [ ] **The Living Galaxy**: Dynamic background visuals that evolve as you colonize more of the solar system.

_Every line of code should feel like it belongs in a premium, state-of-the-art space simulator._
