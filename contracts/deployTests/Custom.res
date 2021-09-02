open ContractHelpers

// This is here because hardhat-deploy needs us to set the gasLimit for this transactions (via the options)
@send
external createNewSyntheticMarketExternalSyntheticTokensWithOptions: (
LongShort.t,~syntheticName: string,~syntheticSymbol: string,~longToken: Ethers.ethAddress,~shortToken: Ethers.ethAddress,~paymentToken: Ethers.ethAddress,~oracleManager: Ethers.ethAddress,~yieldManager: Ethers.ethAddress, ~options: 'a
) => JsPromise.t<transaction> = "createNewSyntheticMarketExternalSyntheticTokens"
