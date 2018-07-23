import ptvsd
from config import config

def connect_debugger():
    if config.debug:
        address = ("0.0.0.0", config.debug_port)
        ptvsd.enable_attach(config.debug_secret, address)

        print("Waiting for debugger...")
        ptvsd.wait_for_attach()
        print("Debugger attached")
    else:
        print("Not configured for debugging")


print("Starting execution")
connect_debugger()
print("Execution complete")
