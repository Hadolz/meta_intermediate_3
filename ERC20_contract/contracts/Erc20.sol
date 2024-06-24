// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {    
    function totalSupply() external view returns(uint);
    function balanceOf(address account) external view returns(uint);
    function transfer(address recipient, uint amount) external returns(bool);
   
    event Transfer(address indexed from, address indexed to, uint amount);
}

contract Tokens is IERC20 {
    address public owner;
    uint public override totalSupply;
    mapping(address => uint) public override balanceOf;
    string public name = "Hadol";
    string public symbol = "HD";
    uint8 public decimals = 18;

    // Define custom errors
    error InsufficientBalance(uint required, uint available);
    error NotOwner();

    modifier onlyOwner() {
        if (msg.sender!= owner) revert NotOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function transfer(address recipient, uint amount) external override returns (bool) {
        uint senderBalance = balanceOf[msg.sender];
        if (senderBalance < amount) revert InsufficientBalance(amount, senderBalance);

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external onlyOwner {
        uint newTotalSupply = totalSupply + amount;
        if (newTotalSupply < amount) revert InsufficientBalance(amount, totalSupply);

        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        uint senderBalance = balanceOf[msg.sender];
        if (senderBalance < amount) revert InsufficientBalance(amount, senderBalance);

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
