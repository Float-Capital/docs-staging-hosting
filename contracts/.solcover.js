module.exports = {
  skipFiles: [
    "Migrations.sol",
    "interfaces/IBandOracle.sol",
    "interfaces/IFloatToken.sol",
    "interfaces/ILongShort.sol",
    "interfaces/IOracleManager.sol",
    "interfaces/IStaker.sol",
    "interfaces/ISyntheticToken.sol",
    "interfaces/ITokenFactory.sol",
    "interfaces/IYieldManager.sol",
    "interfaces/aave/DataTypes.sol",
    "interfaces/aave/ILendingPool.sol",
    "interfaces/aave/ILendingPoolAddressesProvider.sol",
    "mocks/BandOracleMock.sol",
    "mocks/Dai.sol",
    "mocks/MockERC20.sol",
    "mocks/OracleManagerMock.sol",
    "mocks/YieldManagerMock.sol"
  ]
};
