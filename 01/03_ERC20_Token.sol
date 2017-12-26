pragma solidity ^0.4.0;

contract ERC20_Token {
    // For display purposes
    string public name;
    string public symbol;
    
    // The issuer, the entity that can mint and melt tokens.
    address public issuer;
 
    uint8 public decimals = 18;
    uint256 public totalSupplyIncludingIssuer;
    
    // The balances of each user
    mapping (address => uint256) public balance;

    function ERC20_Token(string tokenName, string tokenSymbol) public {
        // In the beginning, there is no money
        totalSupplyIncludingIssuer = 0; 
        
        issuer = msg.sender;
        
        // Name and symbol for display purposes
        name = tokenName;   
        symbol = tokenSymbol; 
    }

    function totalSupply() public view returns (uint256) {
        return totalSupplyIncludingIssuer - balance[issuer];
    }
    
    
    function balanceOf(address _owner) public view returns (uint256) {
      return balance[_owner];
    }
    
    
    // The ERC20 standard has two transfer functions. We unify them with the same underlying function
    function transfer(address _to, uint256 _value) public returns (bool success) {
      return moveTokens(msg.sender, _to, _value);
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      return moveTokens(_from, _to, _value);    
    }
    
    
    
    // Move an amount of tokens between accounts. 
    function moveTokens(address _from, address _to, uint256 _amount) internal returns (bool success) {
        require (_amount <= balance[_from]);
        
        // Check for overflows
        // Use >= because it is legitimate to transfer zero tokens
        require (balance[_to] + _amount >= balance[_to]);
        
        // For now, only allow people to move tokens out of their own accounts
        require (_from == msg.sender);
        
        balance[_to] += _amount;
        balance[_from] -= _amount;
        
        // Log the transfer
        Transfer(_from, _to, _amount);
        
        return true;
    }   


    // The ERC20 standard includes allowances - but for the sake of simplicity 
    // we do not implement them yet
    function approve(address _spender, uint256 _value) public returns (bool success) {
        return false;    
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return 0;        
    }

    
    // Events are emitted to the log 
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);    



    
    
    
    // These functions are not part of ERC20, but used for managing the token market

    function mint(uint256 _amount) public {
        // Only the issuer may mint or melt
        require(msg.sender == issuer);
        
        // Avoid overflows
        require(totalSupplyIncludingIssuer + _amount > totalSupplyIncludingIssuer);
        
        balance[issuer] += _amount;
        totalSupplyIncludingIssuer += _amount;
    }
    
    // Melt coins
    function melt(uint256 _amount) public {
        // Only the issuer may mint or destroy
        require(msg.sender == issuer);
        
        // The total supply can't be negative
        require(totalSupplyIncludingIssuer >= _amount);
        
        // The issuer needs to have coins to 
        // destroy them
        require(balance[issuer] >= _amount);
        
        balance[issuer] -= _amount;
        totalSupplyIncludingIssuer -= _amount;
    }    
}
