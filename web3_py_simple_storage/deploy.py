import json, os
from web3 import Web3
from solcx import compile_standard, install_solc
from dotenv import load_dotenv

load_dotenv()
install_solc("0.7.0")

# I - GET solidity file
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)

# 1.1 - Compile Solidity file to an json file with ABI, EVM, Meta, ect.. (ABI = Application Binary Interface)
compile_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.7.0",
)

# 1.2 - Dump the JSON compiled to a file
with open("compiled_code.json", "w") as file:
    json.dump(compile_sol, file)


# II - FETCHING DATA BEFORE DEPLOY
# We need bytecode and ABI
# 2.1 - get Bytecode
bytecode = compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# 2.2 - get ABI
abi = compile_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# 2.3 - For connecting to ganache
w3 = Web3(Web3.HTTPProvider("https://rinkeby.infura.io/v3/b8964c4daec94db3bc78e3eae92a725d"))
chain_id = 4 # 1337
my_address = os.getenv('ACCOUNT_ADDRESS')
priv_key = os.getenv('PRIVATE_KEY')

# III - DEPLOY CONTRACT
# 3.1 - Create contrat in py
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# 3.2 - Get the latest transaction
nonce = w3.eth.getTransactionCount(my_address)

# 3.3 - Deployment Workfow
# 3.3.1 - Build a transaction
print("DEPLOY CONTRACT...")
transaction = SimpleStorage.constructor().buildTransaction(
    {"gasPrice": w3.eth.gas_price, "chainId": chain_id, "from": my_address, "nonce": nonce}
)
# 3.3.2 - Sign a transaction
signed_transaction = w3.eth.account.sign_transaction(transaction, private_key=priv_key)
# 3.3.3 - Send a transaction
transaction_hash = w3.eth.send_raw_transaction(signed_transaction.rawTransaction)
# 3.3.4 - blockchain validation
transaction_receipt = w3.eth.wait_for_transaction_receipt(transaction_hash)
# print(transaction_receipt)
print("DEPLOYED.")


# IV - Interact with contract
# Working with contract we need address and ABI
simple_storage = w3.eth.contract(address=transaction_receipt.contractAddress, abi=abi)

# Call      -> Simulate making a call and getting a return value, no state change
print(simple_storage.functions.retrieve().call())
# Transac   -> Actually make a state change
print("UPDATE CONTRACT...")
store_txn=simple_storage.functions.store(15).buildTransaction(
    {"gasPrice": w3.eth.gas_price, "chainId": chain_id, "from": my_address, "nonce": nonce + 1} # nonce is unique by transaction
)
signed_store_txn = w3.eth.account.sign_transaction(store_txn, private_key=priv_key)
store_txn_hash = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
store_txn_receipt = w3.eth.wait_for_transaction_receipt(store_txn_hash)
print(simple_storage.functions.retrieve().call())
print("UPDATED")
