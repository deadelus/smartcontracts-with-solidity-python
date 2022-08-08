from brownie import accounts, config, network, Contract, interface
from brownie import MockV3Aggregator, VRFCoordinatorV2Mock, LinkToken
from web3 import Web3

FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]
DECIMALS = 8
STARTING_PRICE = 200000000000

def get_account(index=None, id=None):
    if (index):
        return accounts[index]
    if (id):
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]
    return accounts.add(config["wallets"]["from_key"])

contract_to_mock = {
    "eth_usd_price_feed": MockV3Aggregator,
    "vrf_coordinator": VRFCoordinatorV2Mock,
    "link_token": LinkToken
}
def get_contract(contract_name): 
    """
        This function will grab the contract addresses from the brownie config if defined,
        otherwise, it will debloy a mock of version of that contract and return that mock contract. 

            Args:
                contract_name (string)

            Returns:
                brownie.network.contract.ProjectContract: The most recently deployed version of this contract
    """
    contract_type = contract_to_mock[contract_name]
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        if len(contract_type) <= 0 :
            deploy_mocks()
        print(contract_type)
        contract = contract_type[-1]
    else:
        contract_address = config["networks"][network.show_active()][contract_name]
        contract = Contract.from_abi(
            contract_type._name,
            contract_address,
            contract_type.abi,
        )
    return contract

DECIMALS=8
INITIAL_VALUE=20000000000
BASE_FEE = 100000000000000000  # The premium
GAS_PRICE_LINK = 1e9  # Some value calculated depending on the Layer 1 cost and Link
def deploy_mocks(decimals=DECIMALS, initial_value=INITIAL_VALUE):
    """
    Use this script if you want to deploy mocks to a testnet
    """
    print(f"The active network is {network.show_active()}")
    print("Deploying Mocks...")
    account = get_account()
    print("Deploying Mock Link Token...")
    link_token = LinkToken.deploy({"from": account})
    print("Deploying Mock Price Feed...")
    mock_price_feed = MockV3Aggregator.deploy(
        decimals, initial_value, {"from": account}
    )
    print(f"Deployed to {mock_price_feed.address}")
    print("Deploying Mock VRFCoordinator...")
    mock_vrf_coordinator = VRFCoordinatorV2Mock.deploy(
        BASE_FEE, GAS_PRICE_LINK, {"from": account}
    )
    print(f"Deployed to {mock_vrf_coordinator.address}")

def fund_with_link(contract_address, account=None, link_token=None, amount=100000000000000000): # 0.1 Link
    account = account if account else get_account()
    link_token = link_token if link_token else get_contract("link_token")
    tx = link_token.transfer(contract_address, amount, {"from": account})
    # The interface way will works as well
    #link_token_contract = interface.LinkTokenInterface(link_token.address)
    #tx = link_token_contract.transfer(contract_address, amount, {"from": account})
    tx.wait(1)
    print("Funded contract !")
    return tx
