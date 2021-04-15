---
id: smart-contracts
title: Contracts
sidebar_label: Smart Contracts
slug: /smart-contracts
---

<sub><sup> NOTE: These docs are under active development 👷‍♀️👷 </sup></sub>

---

```javascript
pragma solidity 0.7.6;

import "@floatcapital/Legendary.sol";

contract Float is Legendary {
    mapping(address => bool) public smartContractProgrammer;

    function getInvolved() external {
        if (smartContractProgrammer[msg.sender]) {
            // please grab a coffee, sit down, relax and
            // scrutinize our smart contracts
        }
    }
}

```

You'll find our contracts on [Github](https://discord.gg/qesr2KZAhn)
