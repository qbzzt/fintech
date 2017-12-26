pragma solidity ^0.4.0;

contract HelloSolidity {
  // The last user to have used this system.
  address public lastUser;
  
  // The greeting
  string public greeting;
    
  function HelloSolidity(string newGreeting) public {
    greeting = newGreeting;
    lastUser = msg.sender;
  }
  
  
  function hello() public returns (string, address) {
    address prev = lastUser;
    
    lastUser = msg.sender;
    return (greeting, prev);
  }


  function cheapHello() public view returns (string, address) {
    return (greeting, lastUser);
  }
}
