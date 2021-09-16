---
id: faqs
title: FAQs
sidebar_label: FAQs
slug: /faqs
---

<sub><sup> NOTE: These docs are under active development 👷‍♀️👷 </sup></sub>

---

Still have questions? Feel free to reach out to us on [Discord](https://discord.gg/qesr2KZAhn) 🙏

## The basics

<!-- ### What is Float Capital? -->

### What is a synthetic asset?

A synthetic asset simulates the performance of an underlying asset but with some key benefits. Synthetics can offer investors reduced trading costs, tailored cash flow patterns, altered risk profiles, leverage and so on. Float Capital, however, is designed to be simple and safe.

As an example, normally to get exposure to an asset, say Gold, you would need to physically buy Gold, then sell it at a later stage to realise a return. Buying a synthetic asset allows you to get identical exposure to the risk and return benefits of the asset, without having to own the underlying asset.

### What synthetic assets does Float Capital currently support?

Checkout our [alpha launch markets](/docs/alpha#alpha-float-markets) for details on supported synthetic assets in our early release. The alpha Float protocol will launch with an initial synthetic asset tracking the Flipp3ning, a 3x leveraged version of the Flippening, which is based on the market cap of Ethereum vs. the market cap of Bitcoin.

### Testnet synthetic assets

Our testnet deployment currently supports 3 synthetic assets.

One of our test synthetic asset is an 'index' known as the ethereum killers (ETHKillers). This Market is an average of the prices of the tokens of the three protocols seen as alternatives to ethereum, namely TRON, XRP and EOS. The EthKillers market allows users to gain long or short exposure to an equally weighted basket containing TRON, XRP and EOS.

Another synthetic market we have on the testnet is an asset tracking bitcoin vs ethereum dominance.

The third testnet market listed is synthetic Doge coin.

Join our [Discord](https://discord.gg/qesr2KZAhn) and give us your suggestions on which markets to release next.

### What are 'long' and 'short' tokens?

For every synthetic market we offer (eg. The Flipp3ning), users can create long or short tokens for this market.

Holding long tokens allows you to benefit from the price appreciation 📈 of the underlying market. Holding short tokens allows you to benefit from the price depreciation 📉 of the underlying market.

<!-- ### What makes Float Capital different?

Float Capital is designed to be simple and safe: to be easy to use and transparent.

Not over collateralized
...
-->

<!-- ### Long tokens vs Short tokens vs Float tokens.. the differences.

Holders of Long tokens benefit from increases in the price of the underlying market. Holders of Short tokens benefit from decreases in the price of the underlying market. Each market has its own pair of long and short tokens. Holders of Float tokens will benefit from the routine retirement of the Float token done by the LongShort protocol. The Float Token is the governance token and holders will therefore have a say regarding changes to the protocol in the future. -->

---

## Some common protocol questions

### Why call it Float Capital?

Exposure to synthetic assets 'floats' in a band between 0% to 100%. The protocol uses various strong [incentives](/docs/overview) to ensure that synthetic asset exposure is most often near 100%.

### What is _bad liquidity_ and _good liquidity_

The basis of Float Capital is creating a 'peer-to-peer' exposure market where long positions on one synthetic asset, are offset by short positions on that same synthetic asset. _Good liquidity_ refers to liquidity added or removed from the protocol that makes the balance of long and short positions more balanced, while _bad liquidity_ indicates the opposite.

### Are there any trading fees?

Float Capital currently doesn't take any trading fees from traders. All fees levied are accrued either to Float token holders or to users already providing liquidity in that synthetic market. Fees only levied when users [unstake](/docs/stake) their position at a fee of 50 basis points.

### What are the benefits of adding good liquidity?

_Good liquidity_ earns a higher percentage of fees from the protocol. _Good liquidity_ also earns a supercharged yield, through earning yield on all the underlying assets. Finally, staking good liquidity also allows users to earn Float tokens at a higher rate. The whitepaper provides comprehensive details on these incentives.

<!-- Underlying protocol assets generate yield
On the dashboard there will be an indication of the imbalance between the long side liquidity and the short side liquidity. By watching this and taking adding good liquidity, you will be rewarded with the interest on all the liquidity of both sides of the market. The liquidity is deposited in [Aave](https://aave.com) where the token earns interest. -->

<!-- ### Why hold Float governance tokens?

Holders of Float tokens will benefit from the routine retirement of the Float token done by the LongShort protocol using any fees left over after rewarding holders of the Long or Short token that's least in favor. The Float Token is the governance token and therefore holders will also have a say regarding changes to the protocol in the future. -->

<!-- ### Will I really be able to stay completely anonymous?

Yes. KYC (Know Your Customer) is a due diligence process that traditional financial institutions are legally required to perform on you. It's completely normal for a traditional brokerage to know almost everything important about your financial life before they onboard you. -->

<!-- With DAOs (Decentralized Autonomous Organisations) like Float Capital, everything is handled by the blockchain, so no one will ask what your salary is, the source and extent of your liquid net worth, or your level of trading experience. -->

<!-- ### What are the market hours?

Crypto markets are not limited to normal market hours. They are 24-hour and cannot be halted. -->

<!-- ### What is a synthetic asset?

A synthetic asset simulates the performance of an underlying asset but with some key benefits. Synthetics can offer investors reduced trading costs, tailored cash flow patterns, altered risk profiles, leverage and so on. Float Capital however, is designed to be simple and safe. -->

---

## Terminology 📗

### What is an oracle?

Simply put, it's a feed that communicates information from the real world to the blockchain. For the purposes of trading synthetic assets, the oracle would provide the price feed for the underlying asset. Float Capital uses an oracle aggregator so that it is never relying on one single provider, and this increases the durability of the system.

### What is a governance token?

A governance token can be thought of a bit like equity in a company. Governance tokens give holders voting rights over proposed revisions to the protocol, allowing them to have their voices heard on how a protocol operates. Some governance tokens (Float tokens included) give holders added benefits. Similar to stock buybacks, fees earned by the LongShort protocol that aren't paid out to holders in return for helping to balance the liquidity pools, will be used to buy back Float Tokens in the open market, thus decreasing the supply in circulation, and increasing their value.

---

## Other things you may want to know 🤔

### What Blockchain are you on?

We are currently launched on the Mumbai testnet. Float Capital will be launched on the Polygon (formerly Matic) network. Polygon is an EVM (Ethereum Virtual Machine) compatible blockchain.

### Who is the team behind Float?

We are group of passionate mathematicians and computer scientists (turned blockchain engineers) who have been working together for more than 3 years.

Chat to us on [Discord](https://discord.gg/qesr2KZAhn) for a deep dive into the protocol.

<!--
### Have the LongShort Smart Contracts been audited?

Yes, you can find the audit reports [link: here]. -->

Still have questions? Feel free to reach out to us on [Discord](https://discord.gg/qesr2KZAhn) 🙏
