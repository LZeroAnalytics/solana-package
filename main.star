input_parser = import_module("./src/package_io/input_parser.star")
participant_network = import_module("./src/participant_network.star")

def run(plan, args={}):
    plan.print(args)
    """Launches a Solana test network with validator and explorer
    
    Args:
        args: A YAML or JSON argument to configure the network
    """
    
    # Parse input parameters
    args_with_right_defaults = input_parser.input_parser(plan, args)
    
    persistent = args_with_right_defaults.persistent
    global_node_selectors = {}
    
    # Launch participant network
    network_context = participant_network.launch_participant_network(
        plan,
        args_with_right_defaults,
        persistent,
        global_node_selectors
    )
    
    # Print network information
    plan.print("Solana network launched successfully!")
    plan.print("RPC URL: " + network_context.validator.rpc_url)
    plan.print("WebSocket URL: " + network_context.validator.ws_url)
    
    if network_context.explorer != None:
        plan.print("Explorer URL: " + network_context.explorer.explorer_url)
        
    return struct(
        validator = network_context.validator,
        explorer = network_context.explorer
    )
