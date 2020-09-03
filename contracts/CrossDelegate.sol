pragma solidity ^0.4.26;

/**
 * Math operations with safety checks
 */

import "./components/Admin.sol";
import "./MappingToken.sol";
import "./IMappingToken.sol";

contract CrossDelegate is Admin {
    using SafeMath for uint;
    /************************************************************
     **
     ** EVENTS
     **
     ************************************************************/

     event AddToken(address indexed tokenAddress, string name, string symbol, uint8 decimals);
     event UpdateToken(address indexed tokenAddress, string name, string symbol);
     event MintToken(address indexed tokenAddress, address indexed to, uint indexed value);
     event BurnToken(address indexed tokenAddress, uint indexed value, bytes destAccount);

    /**
    *
    * MANIPULATIONS
    *
    */

    function mintToken(
        address tokenAddress,
        address to,
        uint    value
    )
        external
        onlyAdmin
    {
        IMappingToken(tokenAddress).mint(to, value);
        emit MintToken(tokenAddress, to, value);
    }

    function burnToken(
        address tokenAddress,
        uint    value,
        bytes   destAccount
    )
        external
    {
        IMappingToken(tokenAddress).burn(msg.sender, value);
        emit BurnToken(tokenAddress, value, destAccount);
    }

    function addToken(
        string name,
        string symbol,
        uint8 decimals
    )
        external
        onlyOwner
    {
        address tokenAddress = new MappingToken(name, symbol, decimals);
        emit AddToken(tokenAddress, name, symbol, decimals);
    }

    function updateToken(address tokenAddress, string name, string symbol)
        external
        onlyOwner
    {
        IMappingToken(tokenAddress).update(name, symbol);
        emit UpdateToken(tokenAddress, name, symbol);
    }

    function changeTokenOwner(address tokenAddress, address _newOwner) external onlyOwner {
        IMappingToken(tokenAddress).transferOwner(_newOwner);
    }

    function addTokenAdmin(address tokenAddress, address admin) external onlyOwner {
        IMappingToken(tokenAddress).addAdmin(admin);
    }

    function removeTokenAdmin(address tokenAddress, address admin) external onlyOwner {
        IMappingToken(tokenAddress).removeAdmin(admin);
    }

}
