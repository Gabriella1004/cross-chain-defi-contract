pragma solidity 0.4.26;
import './components/StandardToken.sol';

interface IMappingToken {
    function transferOwner(address _newOwner) external;
    function name() external view returns (string);
    function symbol() external view returns (string);
    function decimals() external view returns (uint8);
    function mint(address, uint) external;
    function burn(address, uint) external;
    function update(string, string) external;
    function addAdmin(address) external;
    function removeAdmin(address) external;
}