//SPDX-License-Identifier:MIT
pragma solidity 0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract CrowdFund{

    mapping(address => uint256) private addressToFundsMapping;
    address[] private addresses;

    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    function fund() public payable {
        require(getEtherUsdValue(msg.value) >= 10);
        addressToFundsMapping[msg.sender] = msg.value;
        addresses.push(msg.sender);
    }

    function getEtherUsdValue(uint256 _ethAmount) public view returns (uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        return (uint(price)*_ethAmount)/(10**26);
    }
}
