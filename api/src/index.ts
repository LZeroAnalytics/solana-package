import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import morgan from 'morgan';
import dotenv from 'dotenv';
import rateLimit from 'express-rate-limit';

import { logger } from './logger';
import { 
    validateFundRequest, 
    validateAddressRequest, 
    validateProgramRequest, 
    validateCloneProgramRequest 
} from './validators';
import { SolanaCommands } from './solana-commands';

dotenv.config();

const {
    PORT = '3000',
    RPC_URL = 'http://localhost:8899',
    MAX_REQUESTS = '10',
    USDC_MINT = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v'
} = process.env;

const app = express();
app.use(express.json());
app.set('trust proxy', 1);
app.use(cors());

app.use(morgan('combined', { stream: { write: msg => logger.info(msg.trim()) } }));

const fundLimiter = rateLimit({
    windowMs: 60_000,
    max: Number(MAX_REQUESTS),
    standardHeaders: true,
    legacyHeaders: false,
    message: {
        error: 'Too many requests, please try again later.',
    },
});

const solanaCommands = new SolanaCommands(RPC_URL);

app.get('/ping', (req: Request, res: Response) => {
    res.json({ message: 'pong', timestamp: new Date().toISOString() });
});

app.post('/fund', fundLimiter, validateFundRequest, async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { address, amount } = req.body;

        logger.info(`Processing SOL airdrop to ${address} for ${amount}`);

        const result = await solanaCommands.airdrop(address, amount);

        if (!result.success) {
            return res.status(500).json({
                error: `SOL airdrop failed: ${result.error}`,
            });
        }

        logger.info(`SOL airdrop successful: ${result.output}`);

        res.status(200).json({
            message: 'SOL airdrop successful',
            output: result.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`SOL airdrop failed: ${errorMessage}`);
        
        if (!res.headersSent) {
            res.status(500).json({
                error: `SOL airdrop failed: ${errorMessage}`,
            });
        }
    }
});

app.post('/fund-usdc', fundLimiter, validateFundRequest, async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { address, amount } = req.body;

        logger.info(`Processing USDC funding to ${address} for ${amount}`);

        const tokenAccountResult = await solanaCommands.createTokenAccount(USDC_MINT, address);
        
        if (!tokenAccountResult.success && !tokenAccountResult.error?.includes('already exists')) {
            logger.error(`Token account creation failed: ${tokenAccountResult.error}`);
            return res.status(500).json({
                error: `Failed to create USDC token account: ${tokenAccountResult.error}`,
            });
        }

        
        const mintResult = await solanaCommands.mintTokens(USDC_MINT, amount, address);

        if (!mintResult.success) {
            return res.status(500).json({
                error: `USDC minting failed: ${mintResult.error}`,
            });
        }

        logger.info(`USDC funding successful: ${mintResult.output}`);

        res.status(200).json({
            message: 'USDC funding successful',
            amount: amount,
            recipient: address,
            mint: USDC_MINT,
            output: mintResult.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`USDC funding failed: ${errorMessage}`);
        
        if (!res.headersSent) {
            res.status(500).json({
                error: `USDC funding failed: ${errorMessage}`,
            });
        }
    }
});

app.get('/account/:address', validateAddressRequest, async (req: Request, res: Response) => {
    try {
        const { address } = req.params;

        logger.info(`Getting account info for ${address}`);

        const result = await solanaCommands.getAccount(address);

        if (!result.success) {
            return res.status(500).json({
                error: `Failed to get account info: ${result.error}`,
            });
        }

        res.status(200).json({
            message: 'Account info retrieved successfully',
            data: result.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`Failed to get account info: ${errorMessage}`);
        
        res.status(500).json({
            error: `Failed to get account info: ${errorMessage}`,
        });
    }
});

app.get('/balance/:address', validateAddressRequest, async (req: Request, res: Response) => {
    try {
        const { address } = req.params;

        logger.info(`Getting balance for ${address}`);

        const result = await solanaCommands.getBalance(address);

        if (!result.success) {
            return res.status(500).json({
                error: `Failed to get balance: ${result.error}`,
            });
        }

        res.status(200).json({
            message: 'Balance retrieved successfully',
            balance: result.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`Failed to get balance: ${errorMessage}`);
        
        res.status(500).json({
            error: `Failed to get balance: ${errorMessage}`,
        });
    }
});

app.get('/program/show/:programId', validateProgramRequest, async (req: Request, res: Response) => {
    try {
        const { programId } = req.params;

        logger.info(`Getting program info for ${programId}`);

        const result = await solanaCommands.showProgram(programId);

        if (!result.success) {
            return res.status(500).json({
                error: `Failed to get program info: ${result.error}`,
            });
        }

        res.status(200).json({
            message: 'Program info retrieved successfully',
            data: result.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`Failed to get program info: ${errorMessage}`);
        
        res.status(500).json({
            error: `Failed to get program info: ${errorMessage}`,
        });
    }
});

app.get('/token-accounts/:owner', validateAddressRequest, async (req: Request, res: Response) => {
    try {
        const { owner } = req.params;

        logger.info(`Getting token accounts for ${owner}`);

        const result = await solanaCommands.getTokenAccounts(owner);

        if (!result.success) {
            return res.status(500).json({
                error: `Failed to get token accounts: ${result.error}`,
            });
        }

        res.status(200).json({
            message: 'Token accounts retrieved successfully',
            data: result.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`Failed to get token accounts: ${errorMessage}`);
        
        res.status(500).json({
            error: `Failed to get token accounts: ${errorMessage}`,
        });
    }
});

app.post('/reset', async (req: Request, res: Response) => {
    try {
        logger.info('Resetting Solana test validator');

        const result = await solanaCommands.resetValidator();

        if (!result.success) {
            return res.status(500).json({
                error: `Failed to reset validator: ${result.error}`,
            });
        }

        res.status(200).json({
            message: 'Validator reset successfully',
            output: result.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`Failed to reset validator: ${errorMessage}`);
        
        res.status(500).json({
            error: `Failed to reset validator: ${errorMessage}`,
        });
    }
});

app.post('/clone-program', validateCloneProgramRequest, async (req: Request, res: Response) => {
    try {
        const { programAddress, clusterUrl } = req.body;

        logger.info(`Cloning program ${programAddress} from ${clusterUrl || 'mainnet'}`);

        const result = await solanaCommands.cloneProgram(programAddress, clusterUrl);

        if (!result.success) {
            return res.status(500).json({
                error: `Failed to clone program: ${result.error}`,
            });
        }

        res.status(200).json({
            message: 'Program cloned successfully',
            output: result.output,
        });
    } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        logger.error(`Failed to clone program: ${errorMessage}`);
        
        res.status(500).json({
            error: `Failed to clone program: ${errorMessage}`,
        });
    }
});

app.use((error: any, req: Request, res: Response, _next: NextFunction) => {
    const errorMessage = error?.message || 'Unknown server error';
    const errorStack = error?.stack || '';
    const errorCode = error?.code || '';
    const errorName = error?.name || '';
    
    logger.error('Unhandled error:', { 
        message: errorMessage,
        name: errorName,
        code: errorCode,
        path: req.path,
        method: req.method,
        body: req.body,
        stack: errorStack
    });
    
    if (!res.headersSent) {
        res.status(500).json({
            error: errorMessage,
            code: errorCode || undefined,
            path: req.path
        });
    }
});

app.listen(Number(PORT), () => {
    logger.info(`Solana Faucet API running on port ${PORT}`);
    logger.info(`RPC URL: ${RPC_URL}`);
    logger.info(`USDC Mint: ${USDC_MINT}`);
});
