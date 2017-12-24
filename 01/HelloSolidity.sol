pragma solidity ^0.4.0;

contract HelloSolidity {
  // The last user to have used this system.
  address lastUser;
  
  // The greeting
  string greeting;
    
  function HelloSolidity(string newGreeting) public {
    greeting = newGreeting;
  }
  
  
  function hello() public returns (string, address) {
    address prev = lastUser;
    
    lastUser = msg.sender;
    return (greeting, prev);
  }


  function cheapHello() public constant returns (string, address) {
    return (greeting, lastUser);
  }
}
