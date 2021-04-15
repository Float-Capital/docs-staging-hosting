---
id: overview
title: Overview
sidebar_label: Overview
slug: /overview
---

<sub><sup> NOTE: These docs are under active development 👷‍♀️👷 </sup></sub>

## Basics of the protocol

In its most basic form, the Float protocol creates a 'peer-to-peer' exposure market where long positions on one synthetic asset, are offset by short positions on that same synthetic asset (synth).

For example, Imagine Alice has $100 000 of short exposure to a synth, while Bob had $100 000 of long exposure to this synth. Given this equilibrium, a 1% decrease in the underlying asset price would mean that Alice now has $101 000 of value while bob has $99 000 of value.

Given the value of long and short sides are no longer equal, there will be floating exposure. In this case, the short side will only have 99 000 / 101 000 = 98% exposure. Strong incentives exist to always keep exposure close to 100% for both sides.

## Incentives

In order to incentivize users to gain exposure to both sides, the long and the short, of the market the float protocol uses two mechanisms; yield enhancement and float token supply rate.

### Yield enhancement

The primary mechanism to incentivize a balancing in the market is through splitting the yield from the underlying collateral to the under-balanced side of the market.

For example, Imagine a market with two participants, Alice with a $100 000 long position and Bob with a $500 000 short position. This means there is a total value of $600 000 in the market. The short side of the market is under-balanced and so earns all of the underlying yield. To further expand on this, let's say the annual yield given by Aave for DAI is 10%, if Alice were to deposit her $100 000 in Aave directly she would earn 10% or a $10 000 yield. Alice being in the under-balanced side of the market now earns interest on the total $600 000 in the market, which is $60 000 or 60% of her $100 000 position. In reality the yield is not fixed to 10% but the variable yield floats between 5% - 15% depending on the demand dictated by the borrowers.

### Float token supply rate

Minting a position and staking your market tokens earns Float tokens ([Read more on float tokens here](/docs/float-token)). The Float token generation supply rate is greater for the under-balanced side of the market. This is a reward mechanism for users adding _good liquidity_ to the system. Further incentivizing users to take part in the under-balanced side of the market.

<!-- ### Imbalance penalty   TODO: based on decision around this fee will reintroduce and finish
Additional adding _bad liquidity_ to the market or entering the market on the over-balanced side is exposed to a balancing fee of 50 basis points which goes to the opposite side of the market. This is -->

Balancing of the market is often dictated by what the actual market is. Some markets by design will naturally have equal amounts of long and short sellers, for example a synthetic asset that follows the cost of gas prices on the ethereum blockchain will tend to fluctuate within a range and therefore it will be more prone to equal amounts of long and short sellers.
