// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "OpenZeppelin/openzeppelin-contracts@4.7.2/contracts/utils/math/SafeMath.sol";

contract FundMe {
    // to check for uint overflows
    using SafeMath for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    // Especially with ETH
    function fund() public payable {
        // min val 50$
        // GWEI terms so we multiply by ten with 18 decimal;
        uint256 minimumUSDValue = 50 * 10 ** 18;
        require(getConversiontRate(msg.value) >= minimumUSDValue, "NO ENOUGHT ETH !");

        // keywords on every contract transaction
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        // ETH -> USD converstion ? 
    }

    function getEntranceFee() public view returns(uint256) {
        // MINIMUM USD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return ((minimumUSD * precision) / price )+ 1;
    }

    // modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    // MODIFER is used to add custom behavion before or afer code
    modifier onlyOwner {
        // _; if we wand to exec code before
        require(msg.sender == owner, "YOU DON'T HAVE THE OWNER PERMISSIONS.");
        _;
    }

    function withdraw() payable onlyOwner public {
        payable(msg.sender).transfer(address(this).balance);

        for(
            uint256 fundersIndex=0; 
            fundersIndex < funders.length; 
            fundersIndex++
        ){
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
    }

    function getVersion() public view returns(uint256) {
        // Use the contract's address of chainlink for ETH / USD conversion
        return priceFeed.version();
    }

    function getPrice() public view returns(uint256) {
        (
            /*uint80 roundID*/,
            int256 answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000); // to match WEI values
    }

    // 1000000000
    function getConversiontRate(uint256 ethAmout) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        // 1622533090090.000000000000000000
        uint256 ethAmountInUSD = (ethPrice * ethAmout) / 1000000000000000000;
        // 1622533090090 in cents
        return ethAmountInUSD;
    } 
}