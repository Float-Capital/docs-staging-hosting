---
id: terminology
title: Terminology
sidebar_label: Terminology
slug: /terminology
---

<sub><sup> NOTE: These docs are under active development 👷‍♀️👷 </sup></sub>

---

## Protocol

### EthKillers

The EthKillers is the first synthetic market offered by Float Capital and tracks an equally weighted index comprised of [TRON](https://tron.network/), [XRP](https://ripple.com/xrp/), and [EOS](https://eos.io/) that were nicknamed EthKillers as they were said to be the _killers_ of Ethereum.

### Floating Exposure

Because the value of liquidity locked in the long and short sides respectively may differ, "floating exposure" to the underlying synthetic asset may exist. I.e. If there was $90 in the long side and $100 in the short side, the long side would have 100% exposure and the short side would have ($90/$100), 90% exposure to the underlying synthetic asset. Economic mechanisms exist to incentivize equal liquidity in the long and short sides, hence providing close to 100% market exposure for both sides.

### Governance Token

Token that allows users to govern the direction of the protocol and hence help shape the future of the project. Holders are able to vote on new feature proposals and even change the governance system.

### Float Token

This is the governance token of Float Capital. Float tokens are earned through staking any Float synthetic token in our token contract.

### Synthetic asset token

A token that holds the same market value as an actual asset (e.g Gold). It allows users to get identical exposure to the risk and return benefits of the asset, without having to actually own the underlying asset.

### Going long

Going long refers to buying an asset with the belief the price will go up and you will make returns on the price appreciation.

### Going short

Inversely to [going long](/docs/terminology#going-long), going short is usually a more abstract concept to grasp. This usually entails selling an asset that you do not own with the requirement to buy it back at a later stage. Going short allows investors to make returns on the price depreciation of the underlying asset. To new investors this can seem like quite an odd concept but another, somewhat less accurate way of explaining it is that, imagine an investor, Alice, believed the price of an asset was going to go down while Bob, believed the price on an asset is going to go up. Alice, the short seller, could make an agreement with Bob where if the price of the asset went down $100 Bob would have to pay Alice $100 allowing Alice to make money on the price depreciation of the asset, yet inversely if the price went up $100, Alice would have to pay Bob $100. In summary, if an investor believes the price of an asset will go down then they will enter on the short side of the market.

### Index

A collection of stocks that fit a similar theme. These stocks are bundled together in what’s known as a "basket" to mimic an economy, market, or sector, allowing investors to broadly track different securities. Examples of an index would be the S&P 500, the Dow Jones, and the FTSE 100.

### Minting

Users gain exposure from minting a token in a long or short synthetic asset by depositing DAI as collateral. The user **mints** synthetic tokens.

### Staking

The act of locking tokens to receive rewards, e.g staking EthKillers long tokens to earn Float tokens.


### Over-collateralization

Used to define a situation where more collateral of an asset/assets value is used than what is needed to cover potential loss.

### Oracle

An oracle in the general blockchain sense is a data feed that provides some form of real world data on the blockchain. For Float Capital, oracles provide reliable price data for a market.

### Yield enhanced

A platform feature that rewards users a yield on the underlying collateral ([DAI](/docs/terminology#dai)) when they provide liquidity in the market. Users that provide liquidity on the under balanced side of the market are rewarded a higher yield. This is an incentive mechanism to balance the market. The underlying collateral is deposited in [Aave](https://aave.com/).

### DAI

[DAI](https://makerdao.com/en/) is a stablecoin token pegged to the United States Dollar. Float token uses DAI as the underlying collateral to mint a position.

## Liquidity - Good/Bad

### Liquidity

The availability of liquid assets to a market or company. Liquidity on Float refers to the amount of collateral deposited in the long and short sides of the markets.

### Good & Bad liquidity

Good liquidity refers to liquidity that has been added or removed from the protocol making the balance of long and short positions more balanced, while bad liquidity indicates the opposite.

### Liquidation

Liquidation is simply your assets being converted to cash to cover your position. This is bad for users as it means they lose the funds they have deposited in the system. Your collateral will **never** be liquidated in Float!

## Blockchain

### Smart contracts

An agreement between two parties in the form of code that is run on a blockchain, and stored on a public ledger that cannot be changed. Transactions are processed by the blockchain and can be sent automatically without a third party, like a bank. The Float protocol smart contracts define the set of rules of the system. The system is governed by code, where code is law.

### Blockchain wallet

A digital wallet that allows users to store and manage cryptocurrencies.

Examples of Blockchain wallets we recommend using:

- [**MetaMask**](https://metamask.io/)
- [**Torus**](https://tor.us/)

### Kovan testnet

Kovan is an [EVM](/docs/terminology#evm-ethereum-virtual-machine) compatible blockchain that is used for developing. This allows the team to develop and test the platform in a safe environment. Kovan has a [faucet](https://faucet.kovan.network/) allowing users to experiment with Kovan Ether (KETH) on the Kovan testnet. This is not the ethereum Mainnet and it holds no market value but can be used to make transactions on the Kovan testnet. Follow the guide on the [Kovan testnet](/docs/testnet) to test interacting with the system.

### Polygon (formerly Matic) network

An [EVM](/docs/terminology#evm-ethereum-virtual-machine) compatible blockchain powered by a proof of stake algorithm. [Polygon](https://polygon.technology/) is a growing blockchain with a large ecosystem of projects and is far more affordable on gas/transaction fees.

### EVM (Ethereum Virtual Machine)

**EVM** is a blockchain-based software platform allowing developers to create decentralized applications (Dapps). EVM blockchains are based on the same architecture of the Ethereum blockchain.

### Decentralization

A structure that allows for digital assets like cryptocurrencies to exist outside the control of governments and central authorities. Essentially the opposite of centralization, meaning no central or single party has control over the system.

### DEX (Decentralized Exchange)

A peer-to-peer marketplace connecting cryptocurrency buyers and sellers.

A great example of a **DEX** would be [Quickswap](https://quickswap.exchange). A decentralized finance protocol allowing the exchange of cryptocurrencies.

### CEX (Centralized Exchanges)

A type of cryptocurrency exchange operated by an entity or company on its own infrastructure.

An example of a **CEX** would be [Coinbase](https://www.coinbase.com/).

**Note**: A DEX is usually anonymous, as none of the user’s data is required for trading. Users have full possession of their private keys, and only need a wallet to trade on a decentralized exchange. Whilst a CEX user usually has no control over their private keys.

### Dominance

The measure of a cryptocurrency’s market cap in relation to another cryptocurrency’s market cap (e.g Eth/Btc dominance).
