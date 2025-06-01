# Port IDs
RPC_PORT_ID = "rpc"
WS_PORT_ID = "ws"
EXPLORER_PORT_ID = "explorer"

# Default validator configuration
DEFAULT_VALIDATOR_IMAGE = "tiljordan/solana-test-validator:1.0.2"

# Default explorer configuration
DEFAULT_EXPLORER_IMAGE = "tiljordan/solana-explorer:1.0.6"

# Constants for accounts to clone
TOKEN_PROGRAMS = ["TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA", "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL"]

# LayerZero contracts
LAYER_ZERO_ENDPOINT = "zLGqpAT6dxLJQBwn7PayQUWsDGEMLzKphAJCqUEfULM"
LAYER_ZERO_ULN302 = "uLn3Qpd5ywQQsXH6TLgqEiibPkQU2iiXGETMbtZmxP4"

# Common DeFi protocols with multiple program addresses
DEFI_PROTOCOLS = {
    "Raydium": {
        "programs": [
            "675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8",  # Legacy AMM v4
            "CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C",  # Standard AMM
            "5quBtoiQqxF9Jv6KYKctB59NT3gtJD2Y65kdnB1Uev3h",  # Stable Swap AMM
            "LanMV9sAd7wArD4vJFi2qDfnVhYSUGeeAdtu3uj"       # LaunchLab
        ],
        "upgradeable": [
            "675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8",  # Legacy AMM v4
            "CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C",  # Standard AMM
            "5quBtoiQqxF9Jv6KYKctB59NT3gtJD2Y65kdnB1Uev3h",  # Stable Swap AMM
            "LanMV9sAd7wArD4vJFi2qDfnVhYSUGeeAdtu3uj"       # LaunchLab
        ]
    },
    "Orca": {
        "programs": [
            "whirLbMiicVdio4qvUfM5KAg6Ct8VwpYzGff3uctyCc",  # Whirlpool Program ID
            "2LecshUwdy9xi7meFgHtFJQNSKk4KdTrcpvaB56dP2NQ",  # WhirlpoolConfig Address
            "777H5H3Tp9U11uRVRzFwM8BinfiakbaLT8vQpeuhvEiH"   # WhirlpoolConfigExtension Address
        ],
        "upgradeable": [
            "whirLbMiicVdio4qvUfM5KAg6Ct8VwpYzGff3uctyCc"   # Whirlpool Program ID (upgradeable)
        ]
    },
    "Serum": {
        "programs": ["9xQeWvG816bUx9EPjHmaT23yvVM2ZWbrrpZb9PusVFin"],
        "upgradeable": ["9xQeWvG816bUx9EPjHmaT23yvVM2ZWbrrpZb9PusVFin"]
    },
    "Marinade": {
        "programs": ["MarBmsSgHwmVtVSQxmNgCnFUnQYmH3UEU3yvtP6dkg6"],
        "upgradeable": ["MarBmsSgHwmVtVSQxmNgCnFUnQYmH3UEU3yvtP6dkg6"]
    },
}

# Genesis data mount point
GENESIS_DATA_MOUNTPOINT = "/validator-data"
