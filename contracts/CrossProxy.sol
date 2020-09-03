pragma solidity 0.4.26;

/**
 * Math operations with safety checks
 */

import "./components/Admin.sol";
import "./components/Proxy.sol";

contract CrossProxy is Admin, Proxy {
    /**
    *
    * MANIPULATIONS
    *
    */

    /// @notice                           function for setting or upgrading TokenManagerDelegate address by owner
    /// @param impl                       TokenManagerDelegate contract address
    function upgradeTo(address impl) public onlyOwner {
        require(impl != address(0), "Cannot upgrade to invalid address");
        require(impl != _implementation, "Cannot upgrade to the same implementation");
        _implementation = impl;
        emit Upgraded(impl);
    }
}