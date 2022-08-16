// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is VRFConsumerBaseV2, Ownable {
    /**

        VRF coordinator randomness attributes

    */
    VRFCoordinatorV2Interface COORDINATOR;
    LinkTokenInterface LINKTOKEN;

    // Rinkeby coordinator. For other networks,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

    // Rinkeby LINK token contract. For other networks, see
    // https://docs.chain.link/docs/vrf-contracts/#configurations
    address link_token_contract = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

    


    // A reasonable default is 100000, but this value could be different
    // on other networks.
    uint32 callbackGasLimit = 100000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords =  1;


    /**
        
        Lottery attributes

     */
    // Storage parameters
    uint256[] public s_randomWords;
    uint256 public s_requestId;
    uint64 public s_subscriptionId;
    address s_owner;


    address[] public players;
    address payable public recentWinner;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    enum LOTTERY_STATE {
        OPEN, // 0
        CLOSED, // 1
        CALCULATING_WINNER // 2
    }
    LOTTERY_STATE public Lottery_state;
    
    constructor(
        address _priceFeedAddress,
        address _vrfCoordinator,
        address _link_token_contract,
        bytes32 _keyHash
    ) VRFConsumerBaseV2(_vrfCoordinator) {
        vrfCoordinator = _vrfCoordinator;
        link_token_contract = _link_token_contract;
        keyHash = _keyHash;

        COORDINATOR = VRFCoordinatorV2Interface(_vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(_link_token_contract);
        s_owner = msg.sender;
        //Create a new subscription when you deploy the contract.
        s_subscriptionId = COORDINATOR.createSubscription();
        // Add this contract as a consumer of its own subscription.
        COORDINATOR.addConsumer(s_subscriptionId, address(this));
        
        // ...
        usdEntryFee = 50 * 10 ** 18; // 5e+19
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
        Lottery_state = LOTTERY_STATE.CLOSED;
    }

    function enter() public payable {
        require(Lottery_state == LOTTERY_STATE.OPEN);
        require(msg.value > getEntranceFee(), "NOT ENOUGH ETH.");
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns (uint256){
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = ethUsdPriceFeed.latestRoundData();
        uint256 ajustedPrice = uint256(price) * 10**10;  // ajustedPrice e+19
        // 50$, 1600$ / ETH
        // 50/1600
        // 50 * 100000 / 1600
        // Do this conversion in wei 
        uint256 costToEnter = (usdEntryFee * 10**18) / ajustedPrice; // 5e+37 / ajustedPrice e+19 = costToEnter e+19
        return costToEnter; // In wei
    }

    function startLottery() public onlyOwner{
        require(Lottery_state == LOTTERY_STATE.CLOSED, "Can't start a new lottery yet.");
        Lottery_state = LOTTERY_STATE.OPEN;
    }

    function endLottery() public onlyOwner {
        /*
        ---------------------------
        Bad randomness method
        ---------------------------
        uint256 (
            keccak256(
                abi.encodePacked(
                    nonce, // predictable
                    msg.sender, // predictable
                    block.difficulty, // can be modified by miners !
                    block.timestamp // predictable
                )
            )
        );
        Use Chainlink VRF => https://docs.chain.link/docs/chainlink-vrf/
        */
        requestRandomWords();

        require(Lottery_state == LOTTERY_STATE.OPEN, "You aren't there yet.");
        require(s_randomWords.length > 0, "Random not found.");
        
        Lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
        //
        uint256 indexOfThePlayer = players.length % s_randomWords[0];
        recentWinner = payable(players[indexOfThePlayer]);
        recentWinner.transfer(address(this).balance);
        // Reset
        players = new address payable[](0);
        Lottery_state = LOTTERY_STATE.CLOSED;
    }


    /**
    
        VRF Coordinator V2
    
     */
    // Assumes the subscription is funded sufficiently.
    function requestRandomWords() public {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    // Callback from VRF Coordinator
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        s_randomWords = randomWords;
    }
}