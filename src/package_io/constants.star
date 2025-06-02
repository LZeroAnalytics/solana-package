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
        "programs": [],
        "upgradeable": [
            "LanMV9sAd7wArD4vJFi2qDdfnVhFxYSUg6eADduJ3uj",
            "CPMMoo8L3F4NbTegBCKVNunggL7H1ZpdTHKxQB5qKP1C",
            "675kPX9MHTjS2zt1qfr1NYHuzeLXfQM9H24wFSUt1Mp8",
            "5quBtoiQqxF9Jv6KYKctB59NT3gtJD2Y65kdnB1Uev3h",
            "CAMMCzo5YL8w4VFF8KVHrK22GGUsp5VTaW7grrKgrWqK",
            "LockrWmn6K5twhz3y9w1dQERbmgSaRkfnTeTKbpofwE",
            "routeUGWgWzqBWFcrCfv8tritsqukccJPu3q5GPP3xS",
            "EhhTKczWMGQt46ynNeRX1WfeagwwJd7ufHvCDjRxjo5Q",
            "9KEPoZmtHUrBbhWN1v1KWLMkkvwY6WLtAVUCPRtRjP4z",
            "FarmqiPv5eAj3j1GMdMCMUGXqPUvmquZtMy86QH6rzhG",
            "9HzJyW1qZsEiSfMUf6L2jo3CcTKAyBmSyKdwQeYisHrC"
        ]
    },
    "Orca": {
        "programs": [
            "2LecshUwdy9xi7meFgHtFJQNSKk4KdTrcpvaB56dP2NQ",
            "777H5H3Tp9U11uRVRzFwM8BinfiakbaLT8vQpeuhvEiH",
            "62dSkn5ktwY1PoKPNMArZA4bZsvyemuknWUnnQ2ATTuN",
            "BH9LXGqLhZV3hdvShYZhgQQEjPVKhHPyHwjnsxjETFRr",
            "9zfDkPMnx9ei8mZVfCsLjkBzXob7H3PuAhabmUVAiuJF",
            "GBtp54LJqqDSWonLT878KWerkJAYqYq4jasZ1UYs8wfD",
            "87u3YRwJDNR2wozMTF3umYRgny8UMZ2mHN3UBTSXm8Ho",
            "HT55NVGVTjWmWLjV7BrSMPVZ7ppU8T2xE5nCAZ6YaGad",
            "FapWifnwxWnXQggHBk5XR9bfqAo7H53Gm3ph9Rnb8UTy",
            "BGnhGXT9CCt5WYS23zg9sqsAT2MGXkq7VSwch9pML82W",
            "72NKr3dFXyYWKkgF814hRrdpLjXHJ6F3DwUXxFmAYmp4",
            "zVmMsL5qGh7txhTHFgGZcFQpSsxSx6DBLJ3u113PBer"
        ],
        "upgradeable": [
            "whirLbMiicVdio4qvUfM5KAg6Ct8VwpYzGff3uctyCc"
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
