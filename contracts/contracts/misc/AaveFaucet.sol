// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

abstract contract AaveDai {
    function mint(uint256 value) public virtual returns (bool);

    function transfer(address recipient, uint256 amount)
        public
        virtual
        returns (bool);
}

contract AaveFaucet {
    //Aave mumbai dai address : 0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F
    function mintMonies(address aaveDaiContract) public {
        uint256 TEN_TO_THE_18 = 10000**18;
        uint256 monies = 1_000_000 * TEN_TO_THE_18;
        AaveDai aaveDai = AaveDai(aaveDaiContract);
        aaveDai.mint(monies);
        aaveDai.transfer(msg.sender, monies);
    }
}
