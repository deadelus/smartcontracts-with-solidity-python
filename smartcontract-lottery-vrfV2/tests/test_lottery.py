# 2 August 2022 
# The price for 1 ETH is around $1600 
# So for $50 => 0.03125 ETH => 31250000000000000 WEI
# Assertions might be failed

from brownie import Lottery, accounts, config, network
from web3 import Web3

def test_deploy_lottery():
     account = accounts[0]
     lottery = Lottery.deploy(
          config["networks"][network.show_active()]["eth_usd_price_feed"],
          {"from": account}
     )
     assert lottery.getEntranceFee() > Web3.toWei(0.03125, "ether")
     assert lottery.getEntranceFee() < Web3.toWei(0.07000, "ether")
