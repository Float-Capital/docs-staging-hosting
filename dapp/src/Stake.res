module Markets = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let stakeOption = router.query->Js.Dict.get("tokenAddress")
    <>
      {switch stakeOption {
      | Some(tokenAddress) => <StakeForm tokenId=tokenAddress />
      | None => React.null
      }}
      <StakeList />
    </>
  }
}
let default = () => <Markets />
