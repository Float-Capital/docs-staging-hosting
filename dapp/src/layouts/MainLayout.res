@react.component
let make = (~children) => {
  let chainId = RootProvider.useChainId()
  <div className="flex lg:justify-center min-h-screen">
    <div className="max-w-5xl w-full text-gray-900 font-base">
      <div className="flex flex-col h-screen">
        <Navigation />
        <div className="m-auto w-full">
          {switch chainId {
          | Some(chainId) if chainId == Config.networkId => children
          | None => children
          | Some(_) => <>
              <h2> {"You are currently connected to the wrong network."->React.string} </h2>
              <h4 className="text-lg">
                {`Please connect to ${Config.networkName}.`->React.string}
              </h4>
            </>
          }}
        </div>
      </div>
    </div>
    <Lost />
  </div>
}
