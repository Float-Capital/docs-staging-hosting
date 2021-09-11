type rampInstantSDK = {show: unit => unit}
type rampConfigurationParameters = {
  hostAppName: string,
  hostLogoUrl: string,
  swapAsset: string,
  userAddress: string,
}
@new @module("@ramp-network/ramp-instant-sdk")
external ramp: rampConfigurationParameters => rampInstantSDK = "RampInstantSDK"

let useRamp = () => {
  let emptyRampSDK: rampInstantSDK = {show: _ => ()}
  let (onramp, setOnramp) = React.useState(_ => emptyRampSDK)

  let userAddress = RootProvider.useCurrentUser()
  React.useEffect(_ => {
    Misc.onlyExecuteClientSide(_ =>
      setOnramp(_ =>
        ramp({
          hostAppName: "Float Capital",
          hostLogoUrl: "https://float.capital/img/float-capital-logo-sq.svg",
          swapAsset: "MATIC_DAI",
          userAddress: switch userAddress {
          | Some(usrAddress) => usrAddress->Ethers.Utils.ethAdrToStr
          | None => ""
          },
        })
      )
    )
    None
  })
  onramp
}
