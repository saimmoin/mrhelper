///SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./IHelpher.sol";

error NotOwner();
error fundingExpired(uint deadline);
error WithdrawFailed(uint amount, address _user);
error GoalAlreadyAchieved(uint amount);
error fundExceedingAmount(uint MinRequired, uint provided);

/// @title Helper
/// @author Saim Rayyan
/// @notice launch helping campaigns, accepts, withdraw funding
/// @dev add unExpired functionality.

contract Helper is IHelper {
    address public owner;
    
    struct FundingDetails {
        uint amount; //32bytes                     - slot1
        uint duration; //32bytes                   - slot2
        address recipient; //20bytes               - slot3
        bool isAchieved; //1byte                   - slot3
        bool isWithdrawn; //1byte                  - slot3  //true on full amount withdraw
        bool isExpired; //1byte                    - slot3
        string description; //? (limit to 10 bytes) - slot3
        uint collectedAmount;
        uint withdrawnAmount;
    }


    //user to funding details
    mapping(address => FundingDetails) public fundingDetails;


    constructor(
        uint _amount,
        uint _duration,
        address _recipient,
        string memory _description
    ) {
        fundingDetails[_recipient] = FundingDetails({
            amount: _amount,
            duration: block.timestamp + _duration,
            recipient: _recipient,
            isAchieved: false,
            isWithdrawn: false,
            isExpired: false,
            description: _description,
            collectedAmount: 0,
            withdrawnAmount: 0
        });

        emit FundingLive(
            owner = msg.sender,
            _amount,
            block.timestamp + _duration
        );
    }

    function fund(address _beneficiary, address _funder) external payable override {
        FundingDetails storage funding = fundingDetails[_beneficiary];
        uint _msgValue = msg.value;

        //if funding is active
        if (funding.isAchieved) {
            revert GoalAlreadyAchieved(funding.amount);
        }
        //if funding is expired
        else if (funding.duration < block.timestamp) {
            funding.isExpired = true;
            revert fundingExpired(funding.duration);
        }

        // if provided amount exceeding minimum required amount
        if (funding.collectedAmount + _msgValue > funding.amount) {
            revert fundExceedingAmount(
                funding.amount - funding.collectedAmount,
                _msgValue
            );
        } else if (funding.collectedAmount + _msgValue == funding.amount) {
            funding.isAchieved = true;
        }

        funding.collectedAmount += _msgValue;

        emit Funded(_funder, _msgValue);
    }

    function withdrawFunds() external {
        FundingDetails storage funding = fundingDetails[msg.sender];
        uint withdrawableAmount = funding.collectedAmount -
            funding.withdrawnAmount;

        if (withdrawableAmount == 0) {
            revert WithdrawFailed(withdrawableAmount, msg.sender);
        }

        if (!funding.isWithdrawn) {
            //@TODO: check if there's no extra withdraw
            funding.withdrawnAmount = funding.collectedAmount;
            //if funding goal is achieved and withdrawn
            if (funding.withdrawnAmount == funding.amount) {
                funding.isWithdrawn = true;
            }
        }

        //transfer all outstanding amount
        (bool sent, ) = payable(msg.sender).call{value: withdrawableAmount}("");

        if (!sent) revert WithdrawFailed(withdrawableAmount, msg.sender);
        emit Withdrawn(msg.sender, withdrawableAmount);
    }

    function withdrawable(address _user) external view returns (uint) {
        FundingDetails memory funding = fundingDetails[_user];
        return funding.collectedAmount - funding.withdrawnAmount;
    }

    

}
