solana_validator = import_module("./solana_validator/solana_validator_launcher.star")
explorer = import_module("./block_explorer/explorer_launcher.star")

def launch_participant_network(plan, args_with_right_defaults, persistent, global_node_selectors):
    plan.print("Launching Solana participant network")
    
    # Launch Solana validator
    validator_context = solana_validator.launch_validator(
        plan,
        args_with_right_defaults.validator_params,
        persistent,
        global_node_selectors
    )
    
    # Launch Block Explorer
    explorer_context = explorer.launch_explorer(
        plan,
        validator_context,
        args_with_right_defaults.explorer_params,
        persistent,
        global_node_selectors
    )
    
    # Return contexts
    return struct(
        validator = validator_context,
        explorer = explorer_context
    )
