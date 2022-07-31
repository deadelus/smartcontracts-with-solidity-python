# Setup
```brownie init```

## Secure accounts
``` brownie accounts new my_account ```
Define your account and priv key

## Test
Same as PyTest
``` brownie test ```
``` brownie test -k test_name ```
Test step by step for debug in python shell
``` brownie test --pdb ```
``` brownie test -s ```
### Test workflow
1. Brownie Ganache chain + mocks
2. Testnet for Integration testing
3. Brownie Mainnet fork (optional)
4. Custom Mainnet fork (optional)
5. Self/Local Ganache : Not necessary but good for thinkering


## Network
Show all network available
``` brownie networks list ```
Run on a live Network
``` brownie run <script_name> --network <network_name> ```

## Console
Auto import contract, interract with it contract adhoc
``` brownie console ```

## Add a persistent local network
Because brownie do not have local env saved in his network list
``` brownie networks add Ethereum ganache-local-dev host=http://0.0.0.0:8545 chainid=1337 ```
Run on live local network
``` brownie run deploy --network ganache-local-dev```
WARN : 
As the network is now persisted be sure to delete build/deployments/<chainid> be fore re-run on a newly created network
because it will search for previous address ect.. and will crash.

## Fork Mainnet 
You can fork an Infura but instead we fork with Alchemy in this case

``` brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork='https://mainnet.infura.io/v3/$WEB3_INFURA_PROJECT_ID' accounts=10 mnemonic=brownie port=8545 ```

``` brownie networks add development mainnet-fork-dev cmd=ganache-cli host=http://127.0.0.1 fork='https://eth-mainnet.g.alchemy.com/v2/$WEB3_ALCHEMY_PROJECT_ID' accounts=10 mnemonic=brownie port=8545 ```