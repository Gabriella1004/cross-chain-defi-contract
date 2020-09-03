pragma solidity ^0.4.26;

/**
 * Math operations with safety checks
 */

import "./components/MultiSigWallet.sol";
import "./components/Halt.sol";
import "./MappingToken.sol";
import "./IMappingToken.sol";

contract TokenManagerDelegate is MultiSigWallet, Halt {
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
    constructor(address[] _owners, uint _required)
        MultiSigWallet(_owners, _required)
        public
    {
        for (uint i = 0; i < _owners.length; i++) {
            require(!isOwner[_owners[i]] && _owners[i] != 0);
            isOwner[_owners[i]] = true;
        }
        owners = _owners;
        required = _required;
    }

    function mintToken(
        address tokenAddress,
        address to,
        uint    value
    )
        external
        notHalted
        onlyWallet
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
        notHalted
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

    function changeTokenOwner(address tokenAddress, address _newOwner) external onlyWallet {
        IMappingToken(tokenAddress).changeOwner(_newOwner);
    }

    function acceptTokenOwnership(address tokenAddress) external {
        IMappingToken(tokenAddress).acceptOwnership();
    }

}
