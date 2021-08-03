// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "./interfaces/IFloatToken.sol";

/** @title FloatToken
   @notice The Float Token is the governance token for the Float Capital protocol
 */
contract FloatToken is IFloatToken, ERC20PresetMinterPauserUpgradeable {
  /**@notice Initialize the Float Token with relevant roles  
    @param name The name of the Float governance token
   @param symbol The ticker representing the token
   @param stakerAddress The staker contract that controls minting of the token
   */
  function initializeFloatToken(
    string calldata name,
    string calldata symbol,
    address stakerAddress
  ) external initializer {
    initialize(name, symbol);

    _setupRole(DEFAULT_ADMIN_ROLE, stakerAddress);
    _setupRole(MINTER_ROLE, stakerAddress);
    _setupRole(PAUSER_ROLE, stakerAddress);

    renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
    renounceRole(MINTER_ROLE, msg.sender);
    renounceRole(PAUSER_ROLE, msg.sender);
  }

  /*╔═══════════════════════════════════════════════════════════════════╗
    ║    FUNCTIONS INHERITED BY ERC20PresetMinterPauserUpgradeable      ║
    ╚═══════════════════════════════════════════════════════════════════╝*/

  /** 
  @notice Mints an amount of Float tokens for an address.
  @dev Can only be called by addresses with a MINTER_ROLE. 
        This should correspond to the Staker contract.
  @param to The address for which to mint the tokens for.
  @param amount Amount of synthetic tokens to mint in wei.
  */
  function mint(address to, uint256 amount)
    public
    override(IFloatToken, ERC20PresetMinterPauserUpgradeable)
  {
    ERC20PresetMinterPauserUpgradeable.mint(to, amount);
  }
}
