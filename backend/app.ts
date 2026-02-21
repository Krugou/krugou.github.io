import express from 'express';
import eventsRouter from './routes/events';
import userRouter from './routes/user';
import configRouter from './routes/config';
import { requestLogger } from './logger';

const createApp = () => {
  const app = express();
  // log every incoming request
  app.use(requestLogger);
  app.use(express.json());

  app.get('/health', (_req, res) => res.json({ ok: true, service: 'admin-api' }));

  // mount routes
  app.use('/api/admin/events', eventsRouter);
  app.use('/api/user', userRouter);
  app.use('/api/admin/config', configRouter);

  return app;
};

export default createApp;
