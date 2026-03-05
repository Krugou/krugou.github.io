# Copilot Onboarding Instructions

Use this file as the primary operating guide for coding-agent changes in this repository.

## Repository Summary

- Monorepo for "The Immigrants" game.
- Root uses npm workspaces: `frontend` (Next.js app) and `backend` (Express API).
- Frontend: Next.js 16 App Router, React 19, TypeScript, i18next, Vitest, Playwright.
- Backend: Express 5 + TypeScript, Firebase Admin integration, Vitest.
- CI/CD targets GitHub Pages and Firebase Hosting.

## Toolchain And Runtime

- CI uses Node.js `22` (from `.github/workflows/deploy.yml` and `release.yml`).
- Local validation here was run with Node.js `v25.6.1` and npm `11.9.0`.
- Always prefer Node 22 locally to match CI behavior.

## Fast Start (Always Use This Order)

Run from repository root unless explicitly noted.

1. Install dependencies first.
2. Run unit tests.
3. Run build.
4. Run lint (expect existing failures; do not assume your changes caused all lint errors).
5. Run targeted tests for touched area.
6. Run i18n sync check when touching UI text.

Recommended command sequence:

```bash
npm install
npm run test:unit
npm run build
npm run lint:quiet
npm run check:i18n
npm --workspace=backend run test
npm --workspace=backend run lint
```

Local run commands:

```bash
npm run dev:web
npm run server
```

## Validated Command Outcomes

Commands below were executed during onboarding.

- `npm install` (root): works. Observed duration about 59s. Warned about cleanup EPERM on Tailwind native binary, but install completed.
- `npm ci` (root): failed on Windows with `EPERM` unlink error on `node_modules/@tailwindcss/.../tailwindcss-oxide.win32-x64-msvc.node`.
  - Mitigation: run `npm install` and continue.
- `npm run test:unit` (root -> frontend Vitest): passes (13 files, 52 tests). Duration about 2.2s.
- `npm run build` (root -> frontend Next build): passes. Compiles and prerenders routes (`/`, `/admin`, `/profile`, `/tech`).
- `npm run lint:quiet` (root -> frontend): currently fails with pre-existing ESLint errors in admin/context/lib files.
- `npm --workspace=backend run test`: passes (1 file, 2 tests).
- `npm --workspace=backend run lint`: currently fails (`TypeError: Plugin "" not found`) due backend ESLint config/tooling mismatch.
- `npm run check:i18n`: passes and reports all keys synchronized.
- `npm run test:e2e`: failed after about 13.2 minutes. 25 failed, 10 passed, 5 skipped.
  - Common failure: `page.waitForSelector('text=appTitle')` timeout in accessibility/functional suites across browser projects.
- `npm run dev:web`: command starts correctly, but current environment hit `EADDRINUSE` on port `3100`.
  - Mitigation: stop existing dev process using port `3100`, or override port before starting.
- `npm run server`: starts backend watcher successfully; observed local URL `http://localhost:3001` with health endpoint `/health`.

## Known Windows Shell Gotcha

- Terminal CWD may already be `frontend/`. In that case, `cd frontend` produces `frontend/frontend` path errors.
- Prefer root-anchored commands or `Push-Location ..` when needed.

## Project Layout And Where To Edit

Top-level important paths:

- `package.json`: workspace orchestration scripts.
- `README.md`: root overview and developer flow.
- `eslint.config.js`: root lint delegates to frontend config.
- `firebase.json`: hosting source is `frontend`.
- `.github/workflows/deploy.yml`: quality/build/deploy pipeline.
- `.github/workflows/release.yml`: semantic release + `npm audit --audit-level=high --production`.
- `.github/workflows/fetch-game-data.yml`: scheduled Firebase data sync.

Frontend structure (`frontend/src`):

- `app/`: Next.js routes (`page.tsx`, `admin/`, `profile/`, `tech/`).
- `components/`: UI and admin components.
- `context/`: game/auth state management.
- `services/`: core domain logic (population, modifiers, tech).
- `locales/`: i18n JSON files (`en`, `fi`).
- `i18n.ts`: i18next initialization.

Backend structure (`backend/`):

- `server.ts`: starts HTTP/HTTPS server.
- `app.ts`: Express app composition.
- `routes/`: `events.ts`, `user.ts`, `config.ts`.
- `firebase.ts`: Firebase wiring.
- `tests/app.test.ts`: backend API smoke tests.

## Validation Expectations Before PR

Always run, at minimum, for most code changes:

1. `npm run test:unit`
2. `npm run build`
3. `npm run check:i18n` when touching translated UI text
4. Targeted package tests (`frontend` and/or `backend`)

Additional notes:

- CI quality job currently runs `npm run lint:quiet` and `npm run test:unit` before build/deploy.
- Because lint has existing repository issues, minimize unrelated lint churn and keep changes scoped.
- If e2e is required, expect long runtime and current baseline failures unless test stability is improved.

## i18n Rules

- Use `frontend/scripts/check-translations.ts` via `npm run check:i18n`.
- Script verifies key synchronization across code and locale files.
- Review `frontend/src/locales/*/translation.json` whenever adding new `t('...')` keys.

## Non-Obvious Dependencies

- Firebase credentials are needed for backend/admin paths (`.env`, service account env vars).
- Playwright tests rely on the app serving at `http://localhost:3000` via `frontend/playwright.config.ts` webServer.
- Frontend rewrite config points `/api/admin/*` to `http://localhost:3001/api/admin/*` during dev (`frontend/next.config.mjs`).
- Frontend dev mode uses `PORT=3100` (`frontend/package.json`), so port availability is a hard precondition.

## Root Directory Snapshot

Key root entries:

- `.agent/`, `.github/`, `.husky/`, `.vscode/`
- `backend/`, `frontend/`, `certificates/`, `scripts/`
- `README.md`, `CHANGELOG.md`, `firebase.json`, `eslint.config.js`, `package.json`

## Agent Operating Rule

Trust this file first. Only perform extra repository-wide search when these instructions are incomplete, outdated, or contradicted by current command output.

When project structure, build scripts, lint/test flow, or CI validation changes, update this file and the relevant README sections in the same PR so future agents stay aligned with the current repository reality.
