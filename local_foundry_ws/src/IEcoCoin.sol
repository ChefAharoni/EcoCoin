// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

interface IEcoCoin {
    function balanceOf(address _account) external view returns (uint256);

    function burn(address account, uint256 amount) external;

    function mint(address _account, uint256 _amount) external;

    // function transfer(address to, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    // function transferTo(address to, uint256 amount) external returns (bool);

    function updateMachineAddressToID(
        address _machineAddr,
        uint64 _machineID
    ) external;
}
