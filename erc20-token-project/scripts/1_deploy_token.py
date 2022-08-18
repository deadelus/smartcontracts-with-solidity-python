from scripts.helpful_scripts import get_account
from brownie import OurToken
from web3 import Web3

INITIAL_SUPPLY = Web3.toWei(1000, "ether")

def deploy_token():
    account = get_account()
    our_token = OurToken.deploy(INITIAL_SUPPLY, {"from": account})
    print(our_token.name())

def main():
    deploy_token()

