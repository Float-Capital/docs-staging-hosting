module Access = {
  @react.component
  let make = (~child) => {
    let optSigner = ContractActions.useSigner()

    switch optSigner {
    | None => React.null
    | Some(signer) => child(~signer)
    }
  }
}
let default = () =>
  <Access
    child={(~signer) => <>
      <h1> {"Dapp"->React.string} </h1>
      <ApproveDai signer />
      <hr />
      <MintLong signer />
      <hr />
      <RedeemLong signer />
      <hr />
      <MintShort signer />
      <hr />
      <RedeemShort signer />
      <hr />
      <UpdateSystemState signer />
    </>}
  />
