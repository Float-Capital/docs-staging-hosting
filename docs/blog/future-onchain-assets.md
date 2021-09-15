---
id: future-onchain-assets
title: "Introducing Float Capital: The Future of On-Chain Assets Powered by Chainlink"
sidebar_label: Introducing Float Capital
slug: /future-onchain-assets
---

First up, some massive news. The Float Capital Alpha goes LIVE on Polygon, this <strong>Friday, September 17, 2021.</strong>

<img src="/blog-assets/float-chainlink.png" alt="float-chainlink" width="100%"/>

Given we are pioneering the future of on-chain assets, our Alpha launch relies on safe and up-to-date access to asset prices. For this reason, we are proud to announce that the launch of the Float Capital protocol is powered by [Chainlink Price Feeds](http://data.chain.link) on the Polygon mainnet to provide access to high-quality financial market data, helping ensure on-chain assets are properly pegged to the assets they represent.

Float allows users to effortlessly turn their crypto dollars into an asset of their choice. Whether it’s crypto assets, commodities, forex, specialized assets (the flippening), and more, we have it covered in an easy, safe, and efficient manner. Under the hood, we have some incredible tech! Pop into our Discord if you’d like to [learn more](https://discord.gg/Kv8Eda6T).

![float-landing-app](/blog-assets/landing-app.png)

<em>The Float UI, live from our test site.</em>

In order for our on-chain assets to accurately track the asset prices they represent, we needed a secure and reliable decentralized oracle solution for our protocol. After building in the blockchain space for more than three years and exploring different solutions, we have chosen to integrate Chainlink as it is the most optimal oracle solution for Float.

Chainlink Price Feeds are powered by a decentralized network of secure oracle nodes that aggregate data from multiple premium data providers. This helps ensure Float has tamper-proof and efficient access to a diverse range of highly accurate financial market data on a range of different crypto assets, indices, and more. Some of the key reasons we choose Chainlink Price Feeds include:

- High-Quality Data — Chainlink Price Feeds source data from numerous premium data aggregators, leading to price data that’s aggregated from hundreds of exchanges, weighted by volume, and cleaned from outliers and suspicious volumes. Chainlink’s data aggregation model helps generate more precise global market prices that are resistant to API downtime, flash crash outliers, and data manipulation attacks like [flash loans](https://blog.chain.link/flash-loans-and-the-importance-of-tamper-proof-oracles/).
- Secure Node Operators — Chainlink Price Feeds are secured by independent, security-reviewed, and Sybil-resistant oracle nodes run by leading blockchain DevOps teams, data providers, and traditional enterprises with a strong track record for reliability, even during high gas prices and extreme network congestion.
- Decentralized Network — Chainlink Price Feeds are decentralized at the data source, oracle node, and oracle network levels, generating strong protections against downtime and tampering by either the data provider or the oracle network.
- Economy of Scale — Chainlink Price Feeds benefit from an economy of scale effect, where increasing adoption allows multiple projects to collectively use and fund shared oracle networks to fetch commonly required datasets (e.g. ETH/USD). This allows DeFi projects to get premium data quality and robust oracle security for a fraction of the total cost.

Made possible through this Chainlink integration, the first market launching in the Float Alpha this Friday (17th of September), is ….

## The Flipp3ning!

The Flippening is a term used to describe the point at which Ether ‘flips’ Bitcoin through a larger market capitalization. The Flipp3ning is a 3x leveraged position tracking the relative market cap of Ether compared against the market cap of Bitcoin. This allows users to take a position for or against the flippening, allowing users to gain financial exposure to this event.

The Chainlink Labs team moves fast, allowing us to build with confidence and scale the protocol and bring you many more markets in Alpha season through the launch of new data feeds. We want to give them a big shout-out for accommodating all our crazy price feed requests with lightning-fast response time and without compromising on security or reliability.

## Did someone say GEMS?

![float-gems](https://float.capital/img/gem.gif)

Users can collect 250 GEMS every day for simply interacting with the Float Capital protocol. We can’t share any more details right now, but it may or may not involve [Chainlink VRF](https://chain.link/solutions/chainlink-vrf) in the future. 👀

## Under the hood

Let’s take a quick technical deep dive.

Although an oversimplification, it may be useful to think of Float as a non-expiry futures contract that settles and rolls over into a new contract at every Chainlink oracle update. Based on demand and supply of liquidity in long and short positions on the on-chain asset, new terms will be algorithmically calculated for a given epoch.

Whenever a new Chainlink oracle update occurs, we have an update system state hook that will automatically fetch the latest price from the reference contract, adjust system liquidity, and perform incentive actions based on the updated price, before finally incrementing the epoch (or what we sometimes call the index).

This helps ensure that the peg of the on-chain assets matches the asset it represents by incentivizing people to enter the less popular position. Securing this process are Chainlink Price Feeds, which update rapidly on the Polygon network to provide access to the freshest financial market data.

“Integrating the industry-standard Chainlink Price Feeds into the Float Capital protocol has provided us easy access to the high-quality financial market data required to mint on-chain assets in a hyper-reliable and secure manner,” stated Jon Jon Clark, Co-Founder of Float Capital. “We look forward to expanding our Chainlink integration to include additional secure oracle services, helping grow and bring advanced utility to our products.”

<img src="/blog-assets/model-diagram.png" alt="float-chainlink-diagram" width="100%"/>

## About Chainlink

Chainlink is the industry standard for building, accessing, and selling oracle services needed to power hybrid smart contracts on any blockchain. Chainlink oracle networks provide smart contracts with a way to reliably connect to any external API and leverage secure off-chain computations for enabling feature-rich applications. Chainlink currently secures tens of billions of dollars across DeFi, insurance, gaming, and other major industries, and offers global enterprises and leading data providers a universal gateway to all blockchains.

Learn more about Chainlink by visiting [chain.link](https://chain.link/) or read the documentation at [docs.chain.link](https://docs.chain.link). To discuss an integration, reach out to an expert.

## About Float Capital

[Float Capital](https://float.capital) builds peer-to-peer, yield enhanced on-chain asset markets that allows users to mint assets in a matter of clicks, without the need for over collateralisation or the risk of liquidation.

You can [test out the protocol](https://float.capital/app/), UI, and our market mechanisms on the Mumbai Testnet. The alpha launch will go live for real capital on Friday, September 17th. If you want to learn more about how the protocol is designed to maximise your exposure, read our documentation. If you want to join the community, meet the team and vote on upcoming markets, join our [Discord](https://discord.gg/yyrHVeDd) or follow us on [Twitter](https://twitter.com/float_capital). The Float Alpha release has various risks such as smart contract, composability, stable coin, network, and financial risk. Please deposit responsibly.
