// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./interfaces/ILongShort.sol";
import "./interfaces/ISyntheticToken.sol";
import "./interfaces/IStaker.sol";
import "./StrategyToken.sol";

/** @title ILO Contract */
contract ILO is Initializable, UUPSUpgradeable, AccessControlUpgradeable {
  bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

  address public longShort;
  address public staker;
  StrategyToken public strategyToken;

  /*╔═════════════════════════════╗
    ║       CONTRACT SETUP        ║
    ╚═════════════════════════════╝*/

  function initialize(
    string calldata name,
    string calldata symbol,
    address _longShort,
    address _staker
  ) external initializer {
    __AccessControl_init();
    __UUPSUpgradeable_init();

    longShort = _longShort;
    strategyToken = new StrategyToken(name, symbol);
    staker = _staker;

    _setupRole(UPGRADER_ROLE, msg.sender);
    grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}

  /*╔═════════════════════════════╗
    ║           DEPOSIT           ║
    ╚═════════════════════════════╝*/
  function depositLongAndShortTokens(
    uint32 marketIndex,
    uint256 amountLong,
    uint256 amountShort
  ) public {
    ILongShort _longShort = ILongShort(longShort);
    address longTokenAddress = _longShort.syntheticTokens(marketIndex, true);
    address shortTokenAddress = _longShort.syntheticTokens(marketIndex, false);

    uint256 beforeBalanceOfContract = _getContractStakedBalance(
      marketIndex,
      longTokenAddress,
      shortTokenAddress
    );
    //two transfers - can optimise
    ISyntheticToken(longTokenAddress).transferFrom(msg.sender, address(this), amountLong);
    ISyntheticToken(shortTokenAddress).transferFrom(msg.sender, address(this), amountShort);
    ISyntheticToken(longTokenAddress).stake(amountLong);
    ISyntheticToken(shortTokenAddress).stake(amountShort);

    uint256 totalValueStaked = _getContractStakedBalance(
      marketIndex,
      longTokenAddress,
      shortTokenAddress
    );
    //can maybe add this method to longShort contract?
    (uint256 longTokenPrice, uint256 shortTokenPrice) = _getLongAndShortTokenPrice(marketIndex);

    _performShiftingStrategy(
      marketIndex,
      totalValueStaked,
      longTokenAddress,
      shortTokenAddress,
      longTokenPrice,
      shortTokenPrice
    );
    //can seperate this into it's own method?
    uint256 shares;

    if (strategyToken.totalSupply() == 0) {
      shares = totalValueStaked;
    } else {
      // Users deposited amount * cost per share
      //cost per share =
      shares =
        (((totalValueStaked - beforeBalanceOfContract)) * beforeBalanceOfContract) /
        strategyToken.totalSupply();
    }

    strategyToken.mint(msg.sender, shares);
  }

  /*╔═════════════════════════════╗
    ║       HELPER FUNCTIONS      ║
    ╚═════════════════════════════╝*/

  //Retrieves the number of long and short tokens staked by this contract
  function _getTotalLongAndShortTokensStaked(
    uint32 marketIndex,
    address _longTokenAddress,
    address _shortTokenAddress
  ) internal returns (uint256, uint256) {
    IStaker _staker = IStaker(staker);
    uint256 amountStakedLong = _staker.userAmountStaked(_longTokenAddress, address(this));
    uint256 amountStakedShort = _staker.userAmountStaked(_shortTokenAddress, address(this));

    return (amountStakedLong, amountStakedShort);
  }

  //calculate the shares for the user
  function _calculateUserShares() internal returns (uint256) {
    // add the logic for share distribution here
  }

  //Gets the $ balance of the staked tokens
  function _getContractStakedBalance(
    uint32 marketIndex,
    address _longTokenAddress,
    address _shortTokenAddress
  ) internal returns (uint256) {
    uint256 marketUpdateIndex = ILongShort(longShort).marketUpdateIndex(marketIndex);
    uint256 longTokenPrice = ILongShort(longShort).syntheticToken_priceSnapshot(
      marketIndex,
      true,
      marketUpdateIndex
    );
    uint256 shortTokenPrice = ILongShort(longShort).syntheticToken_priceSnapshot(
      marketIndex,
      false,
      marketUpdateIndex
    );
    (uint256 _amountStakedLong, uint256 _amountStakedShort) = _getTotalLongAndShortTokensStaked(
      marketIndex,
      _longTokenAddress,
      _shortTokenAddress
    );

    return (_amountStakedLong * longTokenPrice + _amountStakedShort * shortTokenPrice) / 1e18;
  }

  function _getLongAndShortTokenPrice(uint32 marketIndex)
    internal
    returns (uint256 longTokenPrice, uint256 shortTokenPrice)
  {
    uint256 marketUpdateIndex = ILongShort(longShort).marketUpdateIndex(marketIndex);
    uint256 longTokenPrice = ILongShort(longShort).syntheticToken_priceSnapshot(
      marketIndex,
      true,
      marketUpdateIndex
    );
    uint256 shortTokenPrice = ILongShort(longShort).syntheticToken_priceSnapshot(
      marketIndex,
      false,
      marketUpdateIndex
    );
  }

  /*╔═════════════════════════════╗
    ║           STRATEGY          ║
    ╚═════════════════════════════╝*/

  //Perform the shifting strategy of this contract to ensure 50/50 balance of long short token values
  function _performShiftingStrategy(
    uint32 marketIndex,
    uint256 totalValueStaked,
    address longTokenAddress,
    address shortTokenAddress,
    uint256 longTokenPrice,
    uint256 shortTokenPrice
  ) internal {
    (uint256 _amountStakedLong, uint256 _amountStakedShort) = _getTotalLongAndShortTokensStaked(
      marketIndex,
      longTokenAddress,
      shortTokenAddress
    );

    //50 - 50 split, can aim to make this resuable
    uint256 desiredAmountOfLongTokens = ((totalValueStaked / 2) * 1e18) / longTokenPrice;
    uint256 desiredAmountOfShortTokens = ((totalValueStaked / 2) * 1e18) / shortTokenPrice;

    //check that no shifting occurs if the distribution of long and short tokens are already correct
    if (_amountStakedLong > desiredAmountOfLongTokens) {
      //Shift to short side
      IStaker(staker).shiftTokens(_amountStakedLong - desiredAmountOfLongTokens, marketIndex, true);
    } else if (_amountStakedShort > desiredAmountOfShortTokens) {
      //shift to long side
      IStaker(staker).shiftTokens(
        _amountStakedShort - desiredAmountOfShortTokens,
        marketIndex,
        false
      );
    }
  }
}
