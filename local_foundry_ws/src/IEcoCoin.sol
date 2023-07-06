// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IEcoCoin {
    function balanceOf(address _account) external view returns (uint256);
    function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool);
    function _burn(address account, uint256 amount) external;
    function _mint(address _account, uint256 _amount) external;
}
