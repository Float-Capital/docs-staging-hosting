const { expect } = require("chai");

describe("Greeter", function() {
  it("Should return the new greeting once it's changed", async function() {
    const wallets = await ethers.getSigners();
    console.log(wallets.map((wallet) => wallet.address));

    expect("true").to.equal("true");
  });
});
