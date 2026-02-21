import fs from 'fs';
import path from 'path';
import { Request, Response, NextFunction } from 'express';
import winston from 'winston';

// ensure the logs directory exists
const logDir = path.join(process.cwd(), 'logs');
if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}

// basic log format
const logFormat = winston.format.printf(({ timestamp, level, message, ...meta }) => {
  const metaString = Object.keys(meta).length ? ` ${JSON.stringify(meta)}` : '';
  return `${timestamp} ${level}: ${message}${metaString}`;
});

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(winston.format.timestamp(), logFormat),
  transports: [
    // file transport will write to logs/app.log
    new winston.transports.File({ filename: path.join(logDir, 'app.log') }),
    // always also log to console for development
    new winston.transports.Console({ format: winston.format.simple() }),
  ],
});

// express middleware helper
export function requestLogger(req: Request, _res: Response, next: NextFunction) {
  logger.info(`${req.method} ${req.url}`);
  next();
}

export default logger;
