This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Admin interface and backend

The previous Python Qt-based event management backend has been migrated into the Next.js application itself. A small Express server (started via `server.js`) provides
CRUD endpoints under `/api/admin/events` that interact with Firebase using the
Admin SDK. A user-facing administration page lives at `/admin` and can be
deployed alongside the public game frontend. The old `backend/` directory is
now considered legacy and may eventually be removed.

### Running locally

1. install Node dependencies:
   ```sh
   npm install
   ```
2. set up Firebase credentials for the server; either set
   `FIREBASE_SERVICE_ACCOUNT` to a JSON string containing your service account
   key or point `FIREBASE_CREDENTIALS_PATH` at the downloaded JSON file.
3. start the development server:
   ```sh
   npm run dev
   ```
4. open `http://localhost:3000/admin` to access the admin dashboard.

All API calls will run through the Express server, which uses the same
credentials as the cloud functions or Python backend before.

### Deployment

When building for production the same `server.js` entrypoint is used. The
`build` script still runs `next build`, and `start` invokes `node server.js`.
Ensure the service account information is available in your deployment
environment (e.g. via GitHub Actions secrets or environment variables).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
