let useStakeTxModal = (~txStateStake, ~tokenToStake) => {
  let stakeTweetMessages = [
    `Hey Siri, play “Celebrate” by Kool and The Gang 🥳, because I just staked my @float_capital synthetic assets to earn FLOAT tokens! 🌊`,
    `Stake that @float_capital! 🌊 I just staked my synthetic assets to earn FLOAT tokens! 🥳`,
    `Make it rain @float_capital! 💸 I just staked my synthetic assets to earn FLOAT tokens! 🥳`,
    `Stake that, all on the floor! Stake that, give me some more! 🎶 I just staked my synthetic assets to earn FLOAT tokens! @float_capital 🌊`,
    `Float like a butterfly, stake like a bee!🐝 I just staked to earn FLOAT tokens @float_capital 🌊`,
  ]

  let {showModal, hideModal} = ModalProvider.useModalDisplay()

  let randomStakeTweetMessage =
    stakeTweetMessages->Array.getUnsafe(Js.Math.random_int(0, stakeTweetMessages->Array.length))

  React.useEffect1(_ => {
    switch txStateStake {
    | ContractActions.Created =>
      showModal(
        <div className="text-center m-3">
          <Loader.Ellipses />
          <h1> {`Confirm the transaction to stake ${tokenToStake}`->React.string} </h1>
        </div>,
      )
    | ContractActions.SignedAndSubmitted(txHash) =>
      showModal(
        <div className="text-center m-3">
          <div className="m-2"> <Loader.Mini /> </div>
          <p> {"Staking transaction pending... "->React.string} </p>
          <ViewOnBlockExplorer txHash />
        </div>,
      )
    | ContractActions.Complete({transactionHash: _}) =>
      showModal(<>
        <div className="text-center m-3">
          <Tick />
          <p> {`Transaction complete 🎉`->React.string} </p>
          <TweetButton message={randomStakeTweetMessage} />
          <ViewProfileButton />
        </div>
      </>)

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
  }, [txStateStake])
}
