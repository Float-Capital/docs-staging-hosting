---
id: overview
title: Overview
sidebar_label: Overview
slug: /overview
---

NOTE: These docs are under active development 👷‍♀️👷

---

## Basics of the protocol

In its most basic form, the Float protocol creates a 'peer-to-peer' exposure market where long positions on one synthetic asset, are offset by short positions on that same synthetic asset.

For example, Imagine Alice has $100 000 of short exposure to a synth, while Bob had $100 000 of long exposure to this synth. Given this equilibrium, a 1% decrease in the underlying asset price would mean that Alice now has $101 000 of value while bob has $99 000 of value.

Given the value of long and short sides are no longer equal, there will be floating exposure. In this case, the short side will only have 99 000 / 101 000 = 98% exposure. Strong incentives exist to always keep exposure close to 100% for both sides.

## Incentives
