@react.component
let make = (~txStateStake, ~resetFormButton, ~tokenToStake) => {
  let tweetMessages = [
    `Hey Siri, play “Celebrate” by Kool and The Gang 🥳, because I just staked my @float_capital synthetic assets to earn FLOAT tokens! 🌊`,
    `Stake that @float_capital! 🌊 I just staked my synthetic assets to earn FLOAT tokens! 🥳`,
    `Make it rain @float_capital! 💸 I just staked my synthetic assets to earn FLOAT tokens! 🥳`,
    `Stake that, all on the floor! Stake that, give me some more! 🎶 I just staked my synthetic assets to earn FLOAT tokens! @float_capital 🌊`,
    `Float like a butterfly, stake like a bee!🐝 I just staked to earn FLOAT tokens @float_capital 🌊`,
  ]

  switch txStateStake {
  | ContractActions.Created =>
    <Modal id={"stake-1"}>
      <div className="text-center m-3">
        <Loader.Ellipses />
        <h1> {`Confirm the transaction to stake ${tokenToStake}`->React.string} </h1>
      </div>
    </Modal>
  | ContractActions.SignedAndSubmitted(txHash) =>
    <Modal id={"stake-3"}>
      <div className="text-center m-3">
        <div className="m-2"> <Loader.Mini /> </div>
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
            message={tweetMessages[
              Js.Math.random_int(0, tweetMessages->Array.length)
            ]->Option.getWithDefault(``)}
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
