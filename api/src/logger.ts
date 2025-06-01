import { createLogger, format, transports } from 'winston';
import dotenv from 'dotenv';

dotenv.config();

const { LOG_LEVEL = 'info' } = process.env;

export const logger = createLogger({
    level: LOG_LEVEL,
    format: format.combine(
        format.timestamp(),
        format.errors({ stack: true }),
        format.splat(),
        format.json()
    ),
    defaultMeta: { service: 'solana-faucet-api' },
    transports: [
        new transports.Console({
            format: format.combine(format.colorize(), format.simple()),
        }),
    ],
});

export default logger;
