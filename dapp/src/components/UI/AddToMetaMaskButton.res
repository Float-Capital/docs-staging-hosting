@react.component
let make = (~token, ~tokenSymbol) => {
  if InjectedEthereum.isMetamask() {
    <AddToMetamask tokenAddress={token->Ethers.Utils.ethAdrToStr} tokenSymbol>
      <button
        className="w-44 h-12 text-sm shadow-md rounded-lg border-2 focus:outline-none border-gray-200 hover:bg-gray-200 flex justify-center items-center mx-auto">
        <div className="mx-2 flex flex-row">
          <div> {"Add token to"->React.string} </div>
          <img src="/icons/metamask.svg" className="h-5 ml-1" />
        </div>
      </button>
    </AddToMetamask>
  } else {
    React.null
  }
}
