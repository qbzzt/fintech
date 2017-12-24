pragma solidity ^0.4.0;

contract SimpleCoin {
    // For display purposes
    string public name;
    string public symbol;
    
    // The issuer. The address type is used to identify users, contracts, and
    // so on
    address public issuer;
    
    // Solidity uses integers. To allow coins to be divided, act as if 
    // 10^18 is a single coin.
    uint8 public decimals = 18;

    uint256 public totalSupply;
    
    mapping (address => uint256) balance;

    // Contract constructor, called once when a contract is created
    function SimpleCoin(string tokenName, string tokenSymbol) public {
        // In the beginning, there is no money
        totalSupply = 0; 
        issuer = msg.sender;
        
        // Name and symbol for display purposes
        name = tokenName;   
        symbol = tokenSymbol; 
    }
    
    

    function mint(uint256 _amount) public {
        // Only the issuer may mint or melt
        require(msg.sender == issuer);
        
        balance[issuer] += _amount;
        totalSupply += _amount;
    }
    
    // Melt coins
    function melt(uint256 _amount) public {
        // Only the issuer may mint or destroy
        require(msg.sender == issuer);
        
        // The total supply can't be negative
        require(totalSupply >= _amount);
        
        // The issuer needs to have coins to 
        // destroy them
        require(balance[issuer] >= _amount);
        
        balance[issuer] -= _amount;
        totalSupply -= _amount;
    }    
    
    // Get the total number in circulation
    //
    // constant functions do not change the contract state, which means 
    // they are a lot cheaper to run
    function marketTotal() public constant returns (uint256) {
        return totalSupply - balance[issuer];
    }
    
    
    // Get my current balance
    function getBalance() public constant returns (uint256) {
        return balance[msg.sender];
    }
    
    // Pay an amount
    function pay(uint256 _amount, address _destination) public {
        require (_amount <= balance[msg.sender]);
        
        // Check for overflows
        require (balance[_destination] + _amount > balance[_destination]);
        
        balance[_destination] += _amount;
        balance[msg.sender] -= _amount;
    }
    
}
