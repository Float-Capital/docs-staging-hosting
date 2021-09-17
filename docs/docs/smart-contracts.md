---
id: smart-contracts
title: Contracts
sidebar_label: Smart Contracts
slug: /smart-contracts
---

<sub><sup> NOTE: These docs are under active development 👷‍♀️👷 </sup></sub>

---

```javascript
pragma solidity 0.8.3;

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

View the currently deployed contracts on etherscan at the contract [addresses](/docs/addresses).

Check out our video walkthroughs which deep dives into our smart contracts that were prepared for our [Code 432n4 audit](/docs/security#code-432n4-Audit-✊):

<iframe width="560" height="315" src="https://www.youtube.com/embed/videoseries?list=PL7RT-0ybd7joiqKeGklvFxcc8dNWpPBCk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

---

**Join our [discord](https://discord.gg/qesr2KZAhn) for more details of the current stage of development.**📈
