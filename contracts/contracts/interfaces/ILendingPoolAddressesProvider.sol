//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;

abstract contract ILendingPoolAddressesProvider {
    function getLendingPool() public view virtual returns (address);

    function getLendingPoolCore() public view virtual returns (address);
}

// INSERT LATER INTO NOLOSSDAO
// Therefore, whenever it's required to access the LendingPool contract
// it is recommended to fetch the correct address from the LendingPoolAddressesProvider smart contract.

// Just want to get it to compile. coIo'lll suese this terminal ::DD
// LendingPoolAddressesProvider provider = LendingPoolAddressesProvider(
//     0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
// );
// LendingPool lendingPool = LendingPool(provider.getLendingPool());
