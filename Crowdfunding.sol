pragma solidity ^0.8.3;

contract Quest5 {

    enum State {
        IN_PROGRESS,
        ENDED
    }

    address payable public owner;
    State public currentState;
    uint amount;
    string cause;

    constructor (uint _amount, string memory _cause) {
        owner = payable(msg.sender);
        amount = _amount;
        cause = _cause;
    }

    modifier stillInProgress() {
        require(currentState == State.IN_PROGRESS,"donation phase is no longer in progress");
        _;
    }

    function donate() external payable stillInProgress() {
        if(address(this).balance > amount){
            currentState = State.ENDED;
        }
    }

    function checkAmountCollected() public view stillInProgress() returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external {
        require(msg.sender == owner,"only the owner can withdraw");
        owner.transfer(address(this).balance);
        currentState = State.ENDED;
    }    
}