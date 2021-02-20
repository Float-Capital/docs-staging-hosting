@react.component
let make = (~tokenId) => {
  let router = Next.Router.useRouter()
  let tokenId = router.query->Js.Dict.get("tokenId")->Option.getWithDefault(tokenId)
  let token = Queries.SyntheticToken.use({tokenId: tokenId})

  let signer = ContractActions.useSignerExn()

  let (
    contractActionToCallAfterApproval,
    setContractActionToCallAfterApproval,
  ) = React.useState(((), ()) => ())

  let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(~signer)
  let (
    contractExecutionHandlerApprove,
    txStateApprove,
    setTxStateApprove,
  ) = ContractActions.useContractFunction(~signer)

  let stakerContractAddress = Config.useStakerAddress()

  let amount = 1->Ethers.BigNumber.fromInt

  let approveFunction = () =>
    contractExecutionHandlerApprove(
      ~makeContractInstance=Contracts.Erc20.make(~address=tokenId->Ethers.Utils.getAddressUnsafe),
      ~contractFunction=Contracts.Erc20.approve(
        ~amount=amount->Ethers.BigNumber.mul(Ethers.BigNumber.fromUnsafe("2")),
        ~spender=stakerContractAddress,
      ),
    )
  let stakeAndEarnImmediatlyFunction = () =>
    contractExecutionHandler(
      ~makeContractInstance=Contracts.Staker.make(~address=stakerContractAddress),
      ~contractFunction=Contracts.Staker.stakeAndEarnImmediately(
        ~tokenAddress=tokenId->Ethers.Utils.getAddressUnsafe,
        ~amount=1->Ethers.BigNumber.fromInt,
      ),
    )

  // Execute the call after approval has completed
  React.useEffect1(() => {
    switch txStateApprove {
    | Complete(_) =>
      contractActionToCallAfterApproval()
      setTxStateApprove(_ => ContractActions.UnInitialised)
    | _ => ()
    }
    None
  }, [txStateApprove])

  <>
    {switch token {
    | {loading: true} => <Loader />
    | {error: Some(_error)} => {
        Js.log("Unable to fetch token")
        <> {"Unable to fetch token"->React.string} </>
      }
    | {data: Some({syntheticToken: Some(synthetic)})} =>
      <Form
        className=""
        onSubmit={() => {
          setContractActionToCallAfterApproval(_ => stakeAndEarnImmediatlyFunction)
          approveFunction()
        }}>
        <div className="px-8 pt-2">
          <div className="-mb-px flex justify-between">
            <div
              className="no-underline text-teal-dark border-b-2 border-teal-dark tracking-wide font-bold py-3 mr-8"
              href="#">
              {`Stake ↗️`->React.string}
            </div>
            <div
              className="no-underline text-grey-dark border-b-2 border-transparent tracking-wide font-bold py-3"
              href="#">
              {`Unstake ↗️`->React.string}
            </div>
          </div>
        </div>
        <AmountInput
          disabled={false}
          onBlur={_ => ()}
          onChange={_ => ()}
          onMaxClick={_ => ()}
          placeholder="stake"
          value=""
        />
        <Button onClick={_ => ()} variant="large">
          {`Stake ${synthetic.tokenType->Obj.magic} ${synthetic.syntheticMarket.name}`}
        </Button>
      </Form>
    | {data: None, error: None, loading: false} => {
        Js.log(
          "You might think this is impossible, but depending on the situation it might not be!",
        )
        <> </>
      }
    | {data: Some({syntheticToken: None}), error: None, loading: false} => <>
        {"this is not a valid token to stake"->React.string}
      </>
    }}
  </>
}
