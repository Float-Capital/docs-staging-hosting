module ConfirmedTransactionModal = {
  @react.component
  let make = (~marketIndex, ~txStateWithdraw, ~contractExecutionHandlerWithdraw) => {
    let user = RootProvider.useCurrentUserExn()

    let userId = user->Ethers.Utils.ethAdrToLowerStr

    let usersPendingRedeemsQuery = DataHooks.useUsersPendingRedeems(~userId)

    let (refetchAttempt, setRefetchAttempt) = React.useState(_ => 0.)

    let _ = Refetchers.useRefetchPendingRedeems(~userId, ~stateForRefetchExecution=refetchAttempt)
    let _ = Refetchers.useRefetchConfirmedRedeems(~userId, ~stateForRefetchExecution=refetchAttempt)

    <div className="text-center m-3">
      <Tick />
      <p> {`Transaction complete 🎉`->React.string} </p>
      <p className="text-xxs text-gray-700">
        {`You can withdraw your ${Config.paymentTokenName} on the next oracle price update`->React.string}
      </p>
      {switch usersPendingRedeemsQuery {
      | Response(usersPendingRedeems) =>
        usersPendingRedeems->Array.length == 0
          ? <Withdraw
              marketIndex
              txState=txStateWithdraw
              contractExecutionHandler=contractExecutionHandlerWithdraw
            />
          : <PendingBar marketIndex refetchCallback=setRefetchAttempt />
      | GraphError(error) => <p> {error->React.string} </p>
      | Loading => <Loader.Tiny />
      }}
      <ViewProfileButton />
    </div>
  }
}

let useRedeemModal = (
  ~txStateRedeem,
  ~marketIndex,
  ~txStateWithdraw,
  ~contractExecutionHandlerWithdraw,
) => {
  let {showModal, hideModal} = ModalProvider.useModalDisplay()

  React.useEffect1(() => {
    switch txStateRedeem {
    | ContractActions.Created =>
      showModal(
        <div className="text-center m-3">
          <Loader.Ellipses />
          <h1> {`Confirm the transaction to redeem ${Config.paymentTokenName}`->React.string} </h1>
        </div>,
      )
    | ContractActions.SignedAndSubmitted(txHash) =>
      showModal(
        <div className="text-center m-3">
          <div className="m-2"> <Loader.Mini /> </div>
          <p> {"Redeem transaction pending... "->React.string} </p>
          <p className="text-xxs text-yellow-600">
            {`⚡ Redeeming your position requires a second withdraw transaction once the oracle price has updated ⚡`->React.string}
          </p>
          <ViewOnBlockExplorer txHash />
        </div>,
      )
    | ContractActions.Complete(_) =>
      showModal(
        <div>
          <Misc.Time.DelayedDisplay delay=500>
            <ConfirmedTransactionModal
              marketIndex txStateWithdraw contractExecutionHandlerWithdraw
            />
          </Misc.Time.DelayedDisplay>
        </div>,
      )
    | ContractActions.Declined(_message) =>
      showModal(
        <div className="text-center m-3">
          <p> {`The transaction was rejected by your wallet`->React.string} </p>
          <MessageUsOnDiscord />
        </div>,
      )
    | ContractActions.Failed(txHash) =>
      showModal(
        <div className="text-center m-3">
          <h1> {`The transaction failed.`->React.string} </h1>
          <ViewOnBlockExplorer txHash />
          <MessageUsOnDiscord />
        </div>,
      )
    | _ => hideModal()
    }
    None
  }, [txStateRedeem])
}

@react.component
let make = (~txStateRedeem, ~resetFormButton, ~buttonText, ~buttonDisabled) => {
  switch txStateRedeem {
  | ContractActions.Complete(_)
  | ContractActions.Declined(_)
  | ContractActions.Failed(_) =>
    resetFormButton()
  | _ => <Button disabled={buttonDisabled} onClick={_ => ()}> {buttonText} </Button>
  }
}
