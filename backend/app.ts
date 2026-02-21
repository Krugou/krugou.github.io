import express from 'express';
import eventsRouter from './routes/events.js';
import userRouter from './routes/user.js';
import configRouter from './routes/config.js';

const createApp = () => {
  const app = express();
  app.use(express.json());

  app.get('/health', (_req, res) => res.json({ ok: true, service: 'admin-api' }));

  // mount routes
  app.use('/api/admin/events', eventsRouter);
  app.use('/api/user', userRouter);
  app.use('/api/admin/config', configRouter);

  return app;
};

export default createApp;
