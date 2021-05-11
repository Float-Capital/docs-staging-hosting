@react.component
let make = (~txStateStake, ~resetFormButton, ~tokenToStake) => {
  switch txStateStake {
  | ContractActions.Created =>
    <Modal id={"stake-1"}>
      <div className="text-center m-3">
        <EllipsesLoader />
        <h1> {`Confirm the transaction to stake ${tokenToStake}`->React.string} </h1>
      </div>
    </Modal>
  | ContractActions.SignedAndSubmitted(txHash) =>
    <Modal id={"stake-3"}>
      <div className="text-center m-3">
        <div className="m-2"> <MiniLoader /> </div>
        <p> {"Staking transaction pending... "->React.string} </p>
        <ViewOnBlockExplorer txHash />
      </div>
    </Modal>
  | ContractActions.Complete({transactionHash: _}) => <>
      <Modal id={"stake-4"}>
        <div className="text-center m-3">
          <Tick />
          <p> {`Transaction complete 🎉`->React.string} </p>
          <TweetButton
            message={`Float like a butterfly, stake like a bee!🐝 I just staked to earn Float tokens @float_capital 🌊 `}
          />
          <ViewPositionButton />
        </div>
        {resetFormButton()}
      </Modal>
    </>
  | ContractActions.Declined(_message) =>
    <Modal id={"stake-5"}>
      <div className="text-center m-3">
        <p> {`The transaction was rejected by your wallet`->React.string} </p>
        <MessageUsOnDiscord />
        {resetFormButton()}
      </div>
    </Modal>
  | ContractActions.Failed(txHash) =>
    <Modal id={"stake-6"}>
      <div className="text-center m-3">
        <h1> {`The transaction failed.`->React.string} </h1>
        <ViewOnBlockExplorer txHash />
        <MessageUsOnDiscord />
        {resetFormButton()}
      </div>
    </Modal>
  | _ => React.null
  }
}
