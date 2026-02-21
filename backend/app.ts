import express from 'express';
import eventsRouter from './routes/events';

const createApp = () => {
  const app = express();
  app.use(express.json());

  app.get('/health', (_req, res) => res.json({ ok: true, service: 'admin-api' }));

  // mount events router at /api/admin/events
  app.use('/api/admin/events', eventsRouter);

  return app;
};

export default createApp;
