pragma solidity ^0.4.0;

contract SimpleToken {
    // For display purposes
    string public name;
    string public symbol;
    
    // The issuer, the entity that can mint and melt tokens.
    address public issuer;
 
    uint8 public decimals = 18;
    uint256 public totalSupply;    
    
    // The balances of each user
    mapping (address => uint256) public balance;

    function SimpleToken(string tokenName, string tokenSymbol) public {
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
        
        // Avoid overflows
        require(totalSupply + _amount > totalSupply);
        
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
    
    // Get the total number of tokens in circulation
    function marketTotal() public view returns (uint256) {
        return totalSupply - balance[issuer];
    }
    
    
    // Get my current balance
    function getBalance() public view returns (uint256) {
        return balance[msg.sender];
    }
    
    
    // Pay an amount
    function pay(uint256 _amount, address _dst) public {
        require (_amount <= balance[msg.sender]);
        
        // Check for overflows
        require (balance[_dst] + _amount > balance[_dst]);
        
        balance[_dst] += _amount;
        balance[msg.sender] -= _amount;
    }   
}
