shared_utils = import_module("../shared_utils/shared_utils.star")
constants = import_module("../package_io/constants.star")

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
    
    # Add log flag if specified
    if validator_params["log_level"]:
        command.append("--log")
        
    # Clone token program accounts if requested
    if validator_params["clone_tokens"]:
        for token in constants.TOKEN_PROGRAMS:
            command.append("--clone")
            command.append(token)
            
    # Clone DeFi protocol accounts if requested
    if validator_params["clone_defi"]:
        for protocol_name, protocol_address in constants.DEFI_PROTOCOLS.items():
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
    
    return struct(
        service = validator_service,
        rpc_url = "http://solana-validator:{0}".format(validator_params["rpc_port"]),
        ws_url = "ws://solana-validator:{0}".format(validator_params["ws_port"]),
        api_url = "http://solana-validator:3000",  # Add API URL
    )
