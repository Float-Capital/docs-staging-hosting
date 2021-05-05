@react.component
let make = (~txState) => {
  switch txState {
  | ContractActions.Created =>
    <Modal id={1}>
      <div className="text-center m-3">
        <EllipsesLoader /> <h1> {`Confirm the transaction to claim Float`->React.string} </h1>
      </div>
    </Modal>
  | ContractActions.SignedAndSubmitted(txHash) =>
    <Modal id={2}>
      <div className="text-center m-3">
        <div className="m-2"> <MiniLoader /> </div>
        <p> {"Claiming transaction pending... "->React.string} </p>
        <ViewOnBlockExplorer txHash />
      </div>
    </Modal>
  | ContractActions.Complete({transactionHash: _}) =>
    <Modal id={3}>
      <div className="text-center m-3">
        <Tick /> <p> {`Transaction complete 🎉`->React.string} </p>
      </div>
      {if InjectedEthereum.isMetamask() {
        <AddToMetamask
          tokenAddress={Config.config.contracts.floatToken->Ethers.Utils.ethAdrToStr}
          tokenSymbol={"FLOAT"}>
          <button
            className="w-36 h-12 text-sm shadow-md rounded-lg border-2 focus:outline-none border-gray-200 hover:bg-gray-200 flex justify-center items-center mx-auto">
            {"Add FLOAT to"->React.string} <img src="/icons/metamask.svg" className="h-5 ml-1" />
          </button>
        </AddToMetamask>
      } else {
        React.null
      }}
    </Modal>
  | ContractActions.Declined(_message) =>
    <Modal id={4}>
      <div className="text-center m-3">
        <p> {`The transaction was rejected by your wallet`->React.string} </p>
        <MessageUsOnDiscord />
      </div>
    </Modal>
  | ContractActions.Failed(txHash) =>
    <Modal id={5}>
      <div className="text-center m-3">
        <h1> {`The transaction failed.`->React.string} </h1>
        <ViewOnBlockExplorer txHash />
        <MessageUsOnDiscord />
      </div>
    </Modal>
  | _ => React.null
  }
}
