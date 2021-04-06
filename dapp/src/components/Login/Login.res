type connectorObj = {
  name: string,
  connector: Web3Connectors.injectedType,
  img: string,
  connectionPhrase: string,
}

@module("./connectors")
external connectors: array<connectorObj> = "default"

@react.component
let make = () => {
  let (_connectionStatus, activateConnector) = RootProvider.useActivateConnector()

  let router = Next.Router.useRouter()
  let nextPath = router.query->Js.Dict.get("nextPath")
  let optCurrentUser = RootProvider.useCurrentUser()

  React.useEffect2(() => {
    switch (nextPath, optCurrentUser) {
    | (Some(nextPath), Some(_currentUser)) => router->Next.Router.push(nextPath)
    | _ => ()
    }
    None
  }, (nextPath, optCurrentUser))

  <div>
    <p className="mx-2 md:mx-0"> {"Connect with one of the wallets below. "->React.string} </p>
    <div className="grid grid-cols-1 md:grid-cols-3 2xl:grid-cols-6 gap-4 items-center my-5">
      {connectors
      ->Array.mapWithIndex((index, connector) =>
        <div
          key={index->string_of_int}
          onClick={e => {
            ReactEvent.Mouse.stopPropagation(e)
            activateConnector(connector.connector)
          }}
          className="mx-2 md:mx-0 p-5 flex flex-col items-center justify-center bg-white bg-opacity-75 hover:bg-gray-200 active:bg-gray-300 rounded ">
          <div className="w-10 h-10">
            <img src=connector.img alt=connector.name className="w-full h-full" />
          </div>
          <div className="text-xl font-bold my-1"> {connector.name->React.string} </div>
          <div className="text-base my-1 text-gray-400	">
            {connector.connectionPhrase->React.string}
          </div>
        </div>
      )
      ->React.array}
    </div>
  </div>
}

let default = make
