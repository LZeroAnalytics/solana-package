import { exec } from 'child_process';
import { promisify } from 'util';
import { logger } from './logger';

const execAsync = promisify(exec);

export interface CommandResult {
    success: boolean;
    output?: string;
    error?: string;
}

export class SolanaCommands {
    private rpcUrl: string;

    constructor(rpcUrl: string = 'http://localhost:8899') {
        this.rpcUrl = rpcUrl;
    }

    private async executeCommand(command: string): Promise<CommandResult> {
        try {
            logger.info(`Executing command: ${command}`);
            const { stdout, stderr } = await execAsync(command);
            
            if (stderr && !stderr.includes('Warning')) {
                logger.warn(`Command stderr: ${stderr}`);
            }
            
            logger.info(`Command output: ${stdout}`);
            return {
                success: true,
                output: stdout.trim()
            };
        } catch (error: any) {
            logger.error(`Command failed: ${command}`, { error: error.message });
            return {
                success: false,
                error: error.message
            };
        }
    }

    async airdrop(address: string, amount: number): Promise<CommandResult> {
        const command = `solana airdrop ${amount} ${address} --url ${this.rpcUrl}`;
        return this.executeCommand(command);
    }

    async getAccount(address: string): Promise<CommandResult> {
        const command = `solana account ${address} --url ${this.rpcUrl} --output json`;
        return this.executeCommand(command);
    }

    async getBalance(address: string): Promise<CommandResult> {
        const command = `solana balance ${address} --url ${this.rpcUrl}`;
        return this.executeCommand(command);
    }

    async showProgram(programId: string): Promise<CommandResult> {
        const command = `solana program show ${programId} --url ${this.rpcUrl}`;
        return this.executeCommand(command);
    }

    async createTokenAccount(tokenMint: string, owner?: string): Promise<CommandResult> {
        const checkResult = await this.executeCommand('which spl-token');
        if (!checkResult.success) {
            return {
                success: false,
                error: "SPL Token CLI not available in this environment. Please install spl-token-cli using 'cargo install spl-token-cli'",
                output: ""
            };
        }
        
        const ownerFlag = owner ? `--owner ${owner}` : '';
        const command = `spl-token create-account ${tokenMint} ${ownerFlag} --url ${this.rpcUrl}`;
        return this.executeCommand(command);
    }

    async mintTokens(tokenMint: string, amount: number, recipient: string): Promise<CommandResult> {
        const checkResult = await this.executeCommand('which spl-token');
        if (!checkResult.success) {
            return {
                success: false,
                error: "SPL Token CLI not available in this environment. Please install spl-token-cli using 'cargo install spl-token-cli'",
                output: ""
            };
        }
        
        const command = `spl-token mint ${tokenMint} ${amount} ${recipient} --url ${this.rpcUrl}`;
        return this.executeCommand(command);
    }

    async getTokenAccounts(owner: string): Promise<CommandResult> {
        const checkResult = await this.executeCommand('which spl-token');
        if (!checkResult.success) {
            return {
                success: false,
                error: "SPL Token CLI not available in this environment. Please install spl-token-cli using 'cargo install spl-token-cli'",
                output: ""
            };
        }
        
        const command = `spl-token accounts --owner ${owner} --url ${this.rpcUrl}`;
        return this.executeCommand(command);
    }

    async transferTokens(tokenMint: string, amount: number, recipient: string, sender?: string): Promise<CommandResult> {
        const checkResult = await this.executeCommand('which spl-token');
        if (!checkResult.success) {
            return {
                success: false,
                error: "SPL Token CLI not available in this environment. Please install spl-token-cli using 'cargo install spl-token-cli'",
                output: ""
            };
        }
        
        const senderFlag = sender ? `--owner ${sender}` : '';
        const command = `spl-token transfer ${tokenMint} ${amount} ${recipient} ${senderFlag} --url ${this.rpcUrl}`;
        return this.executeCommand(command);
    }

    async resetValidator(): Promise<CommandResult> {
        const command = `pkill -f solana-test-validator && sleep 2 && solana-test-validator --reset --ledger /tmp/solana-ledger --rpc-port 8899 --ws-port 8900 &`;
        return this.executeCommand(command);
    }

    async cloneProgram(programAddress: string, clusterUrl: string = 'https://api.mainnet-beta.solana.com'): Promise<CommandResult> {
        const command = `solana-test-validator --clone ${programAddress} --url ${clusterUrl} --reset --ledger /tmp/solana-ledger --rpc-port 8899 --ws-port 8900 &`;
        return this.executeCommand(command);
    }
}
