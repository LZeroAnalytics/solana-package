import { Request, Response, NextFunction } from 'express';

export function validateSolanaAddress(address: string): boolean {
    if (!address || typeof address !== 'string') {
        return false;
    }
    
    const base58Regex = /^[1-9A-HJ-NP-Za-km-z]{32,44}$/;
    return base58Regex.test(address);
}

export function validateFundRequest(req: Request, res: Response, next: NextFunction) {
    const { address, amount } = req.body;

    if (!address || !amount) {
        return res.status(400).json({ error: 'Address and amount are required.' });
    }

    if (!validateSolanaAddress(address)) {
        return res.status(400).json({ error: 'Invalid Solana address.' });
    }

    const parsedAmount = Number(amount);
    if (Number.isNaN(parsedAmount) || parsedAmount <= 0) {
        return res.status(400).json({ error: 'Amount must be > 0.' });
    }

    next();
}

export function validateAddressRequest(req: Request, res: Response, next: NextFunction) {
    const { address } = req.params;

    if (!address) {
        return res.status(400).json({ error: 'Address is required.' });
    }

    if (!validateSolanaAddress(address)) {
        return res.status(400).json({ error: 'Invalid Solana address.' });
    }

    next();
}

export function validateProgramRequest(req: Request, res: Response, next: NextFunction) {
    const { programId } = req.params;

    if (!programId) {
        return res.status(400).json({ error: 'Program ID is required.' });
    }

    if (!validateSolanaAddress(programId)) {
        return res.status(400).json({ error: 'Invalid Solana program ID.' });
    }

    next();
}

export function validateCloneProgramRequest(req: Request, res: Response, next: NextFunction) {
    const { programAddress, clusterUrl } = req.body;

    if (!programAddress) {
        return res.status(400).json({ error: 'Program address is required.' });
    }

    if (!validateSolanaAddress(programAddress)) {
        return res.status(400).json({ error: 'Invalid Solana program address.' });
    }

    if (clusterUrl && typeof clusterUrl !== 'string') {
        return res.status(400).json({ error: 'Cluster URL must be a string.' });
    }

    next();
}
