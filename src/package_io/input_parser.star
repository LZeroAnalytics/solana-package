constants = import_module("./constants.star")

def input_parser(plan, args):
    plan.print("Parsing input parameters")
    
    # Default params if none provided
    if args == None:
        args = {}
        
    # Set up default validator parameters
    validator_params = get_default_validator_params()
    
    # Set up default block explorer parameters
    explorer_params = get_default_explorer_params()
    
    # Set up default network parameters
    network_params = get_default_network_params()

    # Update validator params if provided
    if "validator_params" in args:
        for sub_attr in args["validator_params"]:
            sub_value = args["validator_params"][sub_attr]
            validator_params[sub_attr] = sub_value

    # Update explorer params if provided
    if "explorer_params" in args:
        for sub_attr in args["explorer_params"]:
            sub_value = args["explorer_params"][sub_attr]
            explorer_params[sub_attr] = sub_value
    
    return struct(
        validator_params = validator_params,
        explorer_params = explorer_params,
        network_params = network_params,
        persistent = args.get("persistent", False)
    )

def get_default_validator_params():
    return {
        "image": constants.DEFAULT_VALIDATOR_IMAGE,
        "url": "https://api.mainnet-beta.solana.com",  # Required URL parameter
        "clone_tokens": True,
        "selected_protocols": [],  # Array of protocol names to clone
        "clone_layer_zero": False,  # Disabled by default due to account fetch issues
        "rpc_port": 8899,
        "ws_port": 8900,
        "additional_accounts": [],
        "ledger_compaction_interval": "",
        "log_level": True,  # Boolean flag for --log
        "extra_args": [],
        "prefunded_accounts": {}
    }
    
def get_default_explorer_params():
    return {
        "enabled": True,
        "image": constants.DEFAULT_EXPLORER_IMAGE,
        "rpc_url": "",
        "ws_url": "",
        "explorer_port": 3000
    }
    
def get_default_network_params():
    return {
        "network_name": "solana-local",
        "additional_preloaded_contracts": {}
    }
