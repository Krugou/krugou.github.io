# The Immigrants

An advanced event-driven incremental game about population movement, territory expansion, and space colonization. Build from "Caves to Space Stations" in a cinematic, high-tech environment.

## 🧩 Monorepo Structure

The project is organized as an **npm workspace** with two packages:

- `frontend` – Next.js client application (includes tests, configs, etc.)
- `backend` – Express API server and related tooling

Run all commands from the workspace root; the root `package.json` orchestrates both packages.

## 🚀 Technical Stack

- **Core**: Next.js 16 (App Router), React 19
- **Styling**: Tailwind CSS v4 (Cinematic/Dark Mode)
- **Database/Auth**: Firebase & Firebase Admin SDK
- **Backend**: Express API server in `backend/server.ts` for Admin endpoints
- **Testing**: Playwright (Functional, Responsive, Accessibility)
- **Localization**: i18next (English, Finnish)

## 🏗️ Architecture

The project is a unified Next.js application that includes both the game client and an administrative backend:

- **Frontend**: React-based UI with context-driven state management (`AuthContext`, `GameContext`).
- **Admin API**: An Express server (`backend/server.ts`) providing secure CRUD operations for game events.
- **Service Layer**: Firebase integration for persistent user profiles and cloud saves.

## 🛠️ Development

### Setup

1. **Install Dependencies** (from repo root):

   ```bash
   npm install
   ```

   This will install both frontend and backend packages thanks to npm workspaces. To install only one side:

   ```bash
   npm install --workspace=frontend
   npm install --workspace=backend
   ```

2. **Environment Variables**:
   Provide Firebase credentials via `FIREBASE_SERVICE_ACCOUNT` (JSON string) or `FIREBASE_CREDENTIALS_PATH` in the root `.env`. The backend reads from `../.env` automatically when run from `backend/`.

### Working with individual packages

You can operate on one package directly when needed:

- **Frontend** (runs on port 3001)

  ```bash
  cd frontend
  npm run dev        # start Next.js dev server (http://localhost:3001)
  npm run build
  npm run lint
  npm run test
  ```

- **Backend** (serves API on port 3000 by default)

  ```bash
  cd backend
  npm run dev        # starts Express with hot-reload (http://localhost:3000)
  npm run start      # production mode
  npm run export:events
  ```

Most top-level scripts delegate to the appropriate workspace; running commands from the root is convenient for cross‑package tasks.

### Commands

- `npm run dev`: Starts both servers (frontend on 3001, backend on 3000).
- `npm run dev:admin`: Launches the dev server and opens the admin dashboard.
- `npm run build`: Generates the production build.
- `npm run start`: Starts the production server.
- `npx playwright test`: Runs the full suite of automated tests.
- `npm run lint`: Performs static code analysis.

> **Dev utilities** (only available outside production):
>
> - `/admin` dashboard for live event management.
> - "Simulate 1 Hour" button on the admin page triggers 720 ticks instantly.
> - `/tech` placeholder page for the upcoming tech tree mechanic.

## 📖 Game Systems Spec

### Events

Events are triggered every 5 seconds per territory. They can result in population gains (immigration) or losses (emigration).

**Structure:**

```json
{
  "id": "urban_jobs",
  "title": "Job Opportunities",
  "description": "New businesses open, creating jobs that attract workers.",
  "type": "immigration",
  "populationChange": 5.0,
  "probability": 0.4,
  "category": "opportunity"
}
```

**Examples:**

- **Good Harvest (Rural)**: +2.0 population (Probability: 0.3)
- **Housing Crisis (Urban)**: -2.0 population (Probability: 0.15)
- **Border Crossing (Border)**: +8.0 population (Probability: 0.3)

### Milestones

Milestones are global achievements triggered when the total population reaches specific thresholds.

**Structure:**

```json
{
  "id": "milestone_100",
  "title": "Regional Hub",
  "description": "One hundred people call your settlement home.",
  "type": "milestone",
  "populationChange": 10.0,
  "threshold": 100,
  "category": "milestone"
}
```

**Examples:**

- **Growing Community**: Threshold: 10 people
- **City Status**: Threshold: 500 people
- **Space Pioneer**: Threshold: 0 (Triggered by unlocking Orbital Platform)

## 🧪 Testing & Quality

We maintain high standards through:

- **Functional Tests**: Verifying core gameplay and authentication loops.
- **Accessibility**: WCAG 2.1 AA compliance scans using `@axe-core/playwright`.
- **Responsive Audit**: Ensuring a premium experience across Mobile, Tablet, and Desktop.

## 🛡️ Admin Dashboard

Access the administrative interface at `/admin` (local: `http://localhost:3000/admin`). This allows for managing territory events and milestones via the internal API.

## 🌟 Development Standards

For a comprehensive guide on architecture, UI/UX standards, and the roadmap to maximum potential, see [INSTRUCTIONS.md](file:///c:/Users/moxch/Documents/GitHub/krugou.github.io/.agent/INSTRUCTIONS.md).

## 🧾 Scripts and Tooling

- **Author scripts in TypeScript**: All repository utility scripts (the `scripts/` folder and new tooling) must be written in TypeScript (`.ts`/`.mts`) rather than plain JavaScript. This keeps type-safety and better IDE support.
- To run a TypeScript script locally use `tsx` or `ts-node` in dev. Example:

```bash
npx tsx scripts/my-script.ts
```

If a script still exists as `.mjs`/`.js`, the linter will raise an error with guidance to convert it to TypeScript.

## API: Creating Game Events

You can create game events via the local admin API. Send a POST to `/api/admin/events` with a JSON payload containing an `event` object and a `territoryType`. Example (one-line curl):

curl -X POST <http://localhost:3000/api/admin/events> -H "Content-Type: application/json" -d '{ "event": { "id": "evt_cosmic_tide", "title": "Cosmic Tide", "description": "A solar storm causes temporary migration toward orbital habitats.", "type": "opportunity", "populationChange": 120, "timestamp": 1740000000000 }, "territoryType": "orbital" }'

Adjust `territoryType` and event fields as needed. If your admin API requires authentication, include the appropriate auth headers.
