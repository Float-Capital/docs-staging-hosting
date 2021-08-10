@react.component
let make = () => {
  let router = Next.Router.useRouter()

  switch router.route {
  | "/app/mint"
  | "/app/markets" =>
    Config.networkId == CONSTANTS.polygon.chainId
      ? <div className="fixed bottom-3 left-3 flex flex-col items-end invisible md:visible ">
          <a className="block" href=Config.polygonBridgeLink target="_" rel="noopener noreferrer">
            <div
              className="p-2 rounded-lg flex flex-row bg-white bg-opacity-75 hover:bg-opacity-100 custom-cursor shadow-xl hover:shadow-sm">
              <img src={CONSTANTS.daiDisplayToken.iconUrl} className="h-5 pr-1 custom-cursor" />
              <div className="text-sm custom-cursor"> {"Bridge DAI to Polygon"->React.string} </div>
              <img src={CONSTANTS.polygonDisplayToken.iconUrl} className="h-5 pl-1 custom-cursor" />
            </div>
          </a>
        </div>
      : React.null

  | _ => React.null
  }
}
