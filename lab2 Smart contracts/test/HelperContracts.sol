// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TestFramework.sol";

//////////////////////////////////////////////
////// TestCrowdfunding helper contracts /////
//////////////////////////////////////////////

contract Investor {

    Crowdfunding private crowdfunding;

    // Allow contract to receive money.
    receive() external payable {}
    
    fallback() external payable {}

    constructor(Crowdfunding _crowdfunding) {
        crowdfunding = _crowdfunding;
    }

    function invest(uint256 amount) public returns (bool) {
        (bool success, ) = address(crowdfunding).call{value : amount, gas : 200000}(abi.encodeWithSignature("invest()"));
        return success;
        
    }

    function refund() public returns (bool) {
        (bool success, ) = address(crowdfunding).call{gas : 200000}(abi.encodeWithSignature("refund()"));
        return success;
    }

    function claimFunds() public returns (bool) {
        (bool success, ) = address(crowdfunding).call{gas : 200000}(abi.encodeWithSignature("claimFunds()"));
        return success;
    }
}

contract FounderCrowdfunding {
    event PrintEvent(string msg);

    Crowdfunding private crowdfunding;

    // Allow contract to receive money.
    receive() external payable {}

    fallback() external payable {}

    function setCrowdfunding(Crowdfunding _crowdfunding) public {
        crowdfunding = _crowdfunding;
    }

    function claimFunds() public returns (bool) {
        (bool success, ) = address(crowdfunding).call{gas:200000}(abi.encodeWithSignature("claimFunds()"));
        return success;
    }
}

//////////////////////////////////////////////
//////// TestAuction helper contracts ////////
//////////////////////////////////////////////

contract SimpleAuction is Auction {

    // constructor
    constructor(
        address _sellerAddress,
        address _judgeAddress,
        Timer _timer
    ) payable Auction(_sellerAddress, _judgeAddress, _timer) {}

    function finish(Auction.Outcome _outcome, address _highestBidder) public {
        // This is for the test purposes and exposes finish auction to outside.
        finishAuction(_outcome, _highestBidder);
    }

    // Allow contract to receive money.
    receive() external payable {}
    
    fallback() external payable {}
}

contract Participant {

    Auction auction;

    constructor() {}

    function setAuction(Auction _auction) public {
        auction = _auction;
    }

    //wrapped call
    function callFinalize() public returns (bool) {
        (bool success, ) = address(auction).call{gas : 200000}(abi.encodeWithSignature("finalize()"));
        return success;
    }

    //wrapped call
    function callRefund() public returns (bool)  {
        (bool success, ) = address(auction).call{gas : 200000}(abi.encodeWithSignature("refund()"));
        return success;
    }

    // Allow contract to receive money.
    receive() external payable {}
    
    fallback() external payable {}
}


//////////////////////////////////////////////
///// TestEnglishAuction helper contract /////
//////////////////////////////////////////////


contract EngAuctionBidder { // lowercase as test naming convention

    EnglishAuction auction;

    constructor(EnglishAuction _auction) {
        auction = _auction;
    }

    //wrapped call
    function bid(uint bidValue) public returns (bool){
        (bool success, ) = address(auction).call{value : bidValue, gas : 200000}(abi.encodeWithSignature("bid()"));
        return success;
    }

    // Allow contract to receive money.
    receive() external payable {}

    fallback() external payable {}
}

//////////////////////////////////////////////
////// TestDutchAuction helper contract //////
//////////////////////////////////////////////

contract DutchAuctionBidder { // lowercase as test naming convention

    DutchAuction auction;

    // Allow contract to receive money.
    receive() external payable {}
    
    fallback() external payable {}

    constructor(DutchAuction _auction) {
        auction = _auction;
    }

    //wrapped call
    function bid(uint bidValue) public returns (bool) {
        (bool success, ) = address(auction).call{value : bidValue,gas : 2000000}(abi.encodeWithSignature("bid()"));
        return success;
    }

}