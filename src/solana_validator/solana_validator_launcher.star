shared_utils = import_module("../shared_utils/shared_utils.star")
constants = import_module("../package_io/constants.star")

def process_prefunded_accounts(plan, prefunded_accounts):
    """Process prefunded accounts by calling the faucet API for each account"""
    
    # Wait for API to be ready
    plan.wait(
        service_name="solana-validator",
        recipe=GetHttpRequestRecipe(
            port_id="api",
            endpoint="/ping"
        ),
        field="code",
        assertion="==",
        target_value=200,
        timeout="30s"
    )
    
    # Parse JSON string if it's a string, otherwise use as-is
    accounts_dict = prefunded_accounts
    if type(prefunded_accounts) == "string":
        # For now, we'll need to manually parse the JSON string
        # Since Starlark doesn't have built-in JSON parsing, we'll expect it as a dict
        plan.print("Warning: prefunded_accounts should be passed as a dict, not a JSON string")
        return
    
    # Parse and process each account
    for address, config in accounts_dict.items():
        balance = config.get("balance", "")
        
        if balance.endswith("SOL"):
            # Extract amount in SOL
            amount_str = balance[:-3]  # Remove "SOL" suffix
            amount = float(amount_str)
            
            plan.print("Funding {0} with {1} SOL".format(address, amount))
            
            # Call SOL faucet endpoint
            plan.request(
                service_name="solana-validator",
                recipe=PostHttpRequestRecipe(
                    port_id="api",
                    endpoint="/fund",
                    body='{"address": "' + address + '", "amount": ' + str(amount) + '}',
                    headers={"Content-Type": "application/json"}
                )
            )
            
        elif balance.endswith("USDC"):
            # Extract amount and convert to USDC tokens
            amount_str = balance[:-4]  # Remove "USDC" suffix
            amount = float(amount_str) / 1000000  # Convert to USDC tokens (6 decimals)
            
            plan.print("Funding {0} with {1} USDC".format(address, amount))
            
            # Call USDC faucet endpoint
            plan.request(
                service_name="solana-validator",
                recipe=PostHttpRequestRecipe(
                    port_id="api",
                    endpoint="/fund-usdc",
                    body='{"address": "' + address + '", "amount": ' + str(amount) + '}',
                    headers={"Content-Type": "application/json"}
                )
            )
        else:
            plan.print("Warning: Unknown balance format for address {0}: {1}".format(address, balance))

def launch_validator(plan, validator_params, persistent, global_node_selectors):
    plan.print("Launching Solana test validator")
    
    # Build command arguments based on parameters
    command = ["solana-test-validator"]
    
    # Add required URL parameter (mainnet by default)
    command.append("--url")
    command.append(validator_params.get("url", "https://api.mainnet-beta.solana.com"))
    
    # Add required ledger directory
    command.append("--ledger")
    command.append("/tmp/solana-ledger")
    
    # Add RPC port configuration
    command.append("--rpc-port")
    command.append(str(validator_params["rpc_port"]))

    # Increase faucet amount
    command.append("--faucet-sol")
    command.append(str(2000000000000))
    
    # Add log flag if specified
    if validator_params["log_level"]:
        command.append("--log")
        
    # Clone token program accounts if requested
    if validator_params["clone_tokens"]:
        for token in constants.TOKEN_PROGRAMS:
            command.append("--clone")
            command.append(token)
            
    # Clone selected DeFi protocol accounts
    for protocol_name in validator_params["selected_protocols"]:
        if protocol_name in constants.DEFI_PROTOCOLS:
            for protocol_address in constants.DEFI_PROTOCOLS[protocol_name]:
                command.append("--clone")
                command.append(protocol_address)
            
    # Clone LayerZero contracts if requested
    if validator_params["clone_layer_zero"]:
        command.append("--clone")
        command.append(constants.LAYER_ZERO_ENDPOINT)
        command.append("--clone")
        command.append(constants.LAYER_ZERO_ULN302)
        
    # Add any additional accounts to clone
    for account in validator_params["additional_accounts"]:
        command.append("--clone")
        command.append(account)
        
    # Add ledger compaction interval if specified
    if validator_params["ledger_compaction_interval"]:
        command.append("--ledger-compaction-interval")
        command.append(validator_params["ledger_compaction_interval"])
        
    # Add any extra arguments
    for arg in validator_params["extra_args"]:
        command.append(arg)
    
    # Service config - now includes API port
    port_assignments = {
        constants.RPC_PORT_ID: validator_params["rpc_port"],
        constants.WS_PORT_ID: validator_params["ws_port"],
        "api": 3000,  # API port
    }
    
    config_args = {
        "image": validator_params["image"],
        "ports": shared_utils.get_port_specs(port_assignments),
        "cmd": command,  # Pass the customized validator command
        "node_selectors": global_node_selectors,
    }
    
    validator_service = plan.add_service("solana-validator", ServiceConfig(**config_args))
    
    # Process prefunded accounts if provided
    if validator_params["prefunded_accounts"]:
        plan.print("Processing prefunded accounts...")
        process_prefunded_accounts(plan, validator_params["prefunded_accounts"])
    
    return struct(
        service = validator_service,
        rpc_url = "http://solana-validator:{0}".format(validator_params["rpc_port"]),
        ws_url = "ws://solana-validator:{0}".format(validator_params["ws_port"]),
        api_url = "http://solana-validator:3000",  # Add API URL
    )
