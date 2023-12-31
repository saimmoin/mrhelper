///SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./Helper.sol";
import "./IHelpher.sol";

error FundRequestAlreadyFunded(address user, uint index);
error EthFailed(address user, uint amount);

/**
 * @title HelperFactory
 * @author Saim Rayyan
 * @notice creates a helper contract, each Helper contract serves only one purpose
 */

contract HelperFactory {
    struct FundRequest {
        uint requestedAmount;
        uint fulfilledAmount;
        address helper;
        address beneficiary;
        bool isFunded;
    }

    //user to fund request
    mapping(address => FundRequest[]) private _fundRequest;

    //owner to helper contracts
    mapping(address => address[]) private _helper;
    address[] private _helperAddresses;

    event HelperCreated(address indexed user, address indexed helper);
    event FundRequested(
        address indexed helperContract,
        address indexed funder,
        address indexed beneficiary,
        uint requestedAmount
    );
    event FundFulfilled(
        address indexed helperContract,
        address indexed funder,
        address indexed beneficiary,
        uint fulfilledAmount
    );

    function getHelperAddress(
        address user
    ) external view returns (address[] memory) {
        return _helper[user];
    }

    function createHelper(
        uint _amount,
        uint _duration,
        address _recipient,
        string memory _description
    ) external returns (address helper) {
        helper = address(
            new Helper(_amount, _duration, _recipient, _description)
        );

        address[] storage userHelpers = _helper[msg.sender];
        userHelpers.push(helper);

        _helperAddresses.push(helper);
        emit HelperCreated(msg.sender, helper);
        
    }

    /**
     *
     * @param _index helper contract index
     * @param _amount amount to be requested
     * @param _funder user to request amount
     * @notice anyone can request fund for their campaign from anyone
     */
    function requestFund(uint _index, uint _amount, address _funder) external {
        //get specific helper contract details
        address helperContract = _helper[msg.sender][_index];

        //get funder details for that specific helper contract
        FundRequest[] storage _details = _fundRequest[_funder];

        _details.push(
            FundRequest(_amount, 0, helperContract, msg.sender, false)
        );
        emit FundRequested(helperContract, _funder, msg.sender, _amount);
    }

    function getFundRequests(
        address _user
    ) external view returns (FundRequest[] memory) {
        return _fundRequest[_user];
    }

    function completeFundDetails(uint _index) external payable {
        //get funder details for that specific helper contract
        address _user = msg.sender;
        uint _msgValue = msg.value;
        FundRequest storage _details = _fundRequest[_user][_index];
        if (_details.isFunded) revert FundRequestAlreadyFunded(_user, _index);

        //make sure that the amount sent is not greater than the amount requested, underflow otherwise
        uint extraValue = _details.requestedAmount - _msgValue;
        _details.fulfilledAmount += _msgValue;

        if (_details.requestedAmount == _msgValue) _details.isFunded = true;

        //external call to particular smart contract to initiate fund on funder behalf
        IHelper(_details.helper).fund{value: _msgValue}(
            _details.beneficiary,
            msg.sender
        );

        //transfer any extra value sent
        if (extraValue > 0) {
            (bool sent, ) = payable(_user).call{value: extraValue}("");
            if (!sent) revert EthFailed(_user, extraValue);
        }

        emit FundFulfilled(
            _details.helper,
            _user,
            _details.beneficiary,
            _msgValue
        );
    }
}
