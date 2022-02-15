// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Timer.sol";

/// This contract represents most simple crowdfunding campaign.
/// This contract does not protects investors from not receiving goods
/// they were promised from crowdfunding owner. This kind of contract
/// might be suitable for campaigns that does not promise anything to the
/// investors except that they will start working on some project.
/// (e.g. almost all blockchain spinoffs.)
contract Crowdfunding {

    address private owner;

    Timer private timer;

    uint256 public goal;

    uint256 public endTimestamp;

    mapping (address => uint256) public investments;

    constructor(
        address _owner,
        Timer _timer,
        uint256 _goal,
        uint256 _endTimestamp
    ) {
        owner = (_owner == address(0) ? msg.sender : _owner);
        timer = _timer; // Not checking if this is correctly injected.
        goal = _goal;
        endTimestamp = _endTimestamp;
    }

    function invest() public payable {
        require(IsBeforeDeadline(), "Invest failed, can't invest after deadline.");
        investments[msg.sender] += msg.value;
    }

    function claimFunds() public {
        require(IsAfterDeadline(), "Claim failed, can't claim funds before deadline.");
        require(GoalReached(), "Claim failed, can't claim funds before goal is reached.");
        require(IsOwnerLegit(), "Claim failed, can't claim funds if you are not owner.");

        uint256 all = CurrentBalance();
        payable(msg.sender).transfer(all);
    }

    function refund() public {
        require(IsAfterDeadline(), "Refund failed, can't get refund before deadline.");
        require(GoalNotReached(), "Refund failed, can't get refund after goal is reached.");

        uint256 part = investments[msg.sender];
        payable(msg.sender).transfer(part);
        investments[msg.sender] = 0;
    }

    function IsBeforeDeadline() private view returns (bool){
        if(timer.getTime() < endTimestamp) return true;
        return false;
    }
    function IsAfterDeadline() private view returns (bool){
        if(timer.getTime() >= endTimestamp) return true;
        return false;
    }
    function IsOwnerLegit() private view returns (bool){
        if(msg.sender == owner) return true;
        return false;
    }
    function GoalReached() private view returns (bool){
        if(CurrentBalance() >= goal) return true;
        return false;
    }
    function GoalNotReached() private view returns (bool){
        if(CurrentBalance() < goal) return true;
        return false;
    }
    function CurrentBalance() private view returns (uint256){
        //return 3;
        return address(this).balance;
    }
}