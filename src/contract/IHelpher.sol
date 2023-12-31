// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IHelper {
    function fund(address _user) external payable;

    function withdrawFunds() external;

    function withdrawable(address _user) external view returns (uint);

    event FundingLive(address recipient, uint amount, uint deadline);
    event Withdrawn(address beneficiary, uint amount);
    event Funded(address funder, uint amount);
}