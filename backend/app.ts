import express from 'express';
import eventsRouter from './routes/events';
import userRouter from './routes/user';

const createApp = () => {
  const app = express();
  app.use(express.json());

  app.get('/health', (_req, res) => res.json({ ok: true, service: 'admin-api' }));

  // mount routes
  app.use('/api/admin/events', eventsRouter);
  app.use('/api/user', userRouter);

  return app;
};

export default createApp;
