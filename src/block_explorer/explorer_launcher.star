shared_utils = import_module("../shared_utils/shared_utils.star")
constants = import_module("../package_io/constants.star")

def launch_explorer(plan, validator_context, explorer_params, persistent, global_node_selectors):
    if not explorer_params["enabled"]:
        return None
        
    plan.print("Launching Solana block explorer")
    
    # Determine RPC URL
    rpc_url = explorer_params["rpc_url"]
    if rpc_url == "":
        rpc_url = validator_context.rpc_url
    
    # Determine WS URL
    ws_url = explorer_params["ws_url"]
    if ws_url == "":
        ws_url = validator_context.ws_url
    
    # Environment variables for the explorer
    env_vars = {
        "NEXT_PUBLIC_MAINNET_RPC_URL": rpc_url,
        "REACT_APP_EXPLORER_TITLE": "Solana Local Explorer",
    }
    
    # Explorer service config
    port_assignments = {
        constants.EXPLORER_PORT_ID: explorer_params["explorer_port"],
    }
    
    config_args = {
        "image": explorer_params["image"],
        "ports": shared_utils.get_port_specs(port_assignments),
        "env_vars": env_vars,
        "node_selectors": global_node_selectors,
    }
    
    explorer_service = plan.add_service("solana-explorer", ServiceConfig(**config_args))
    
    return struct(
        service = explorer_service,
        explorer_url = "http://solana-explorer:{0}".format(explorer_params["explorer_port"]),
    )
