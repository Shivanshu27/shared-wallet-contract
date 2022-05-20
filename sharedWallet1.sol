//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract sharedWallet {
    

    address public owner;

    constructor (){
        owner= msg.sender;
    }

    function depositmoney() public payable {
          balanceReceived += msg.value;
    }

    function isOwner() public view returns (bool) {
        return owner== msg.sender;
    }

    modifier onlyowner() {
        require (owner== msg.sender, "you are not the owner");
        _;
    }

    

    event allowanceChanged(address indexed _forwho, address indexed _fromwhom, uint _oldAmount, uint _newAmount);
    event moneySent(address indexed _from, uint _amount);

    mapping (address=> uint) allowance;
    uint256 public balanceReceived;

    function addAllowance(address _who, uint _amount) public onlyowner() {
        emit allowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who]= _amount;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit allowanceChanged(_who, msg.sender, allowance[_who], allowance[_who]-_amount);
        allowance[_who]-= _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require (isOwner() || allowance[msg.sender]>= _amount);
        _;
    }

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "not enough funds in smart contract");
        if (!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        balanceReceived -= _amount;
        emit moneySent(_to, _amount);
        _to.transfer(_amount);
    } 


}