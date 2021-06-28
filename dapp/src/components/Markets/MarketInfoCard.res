@react.component
let make = (~marketIndex) => {
  let marketInfo: Backend.marketInfo = Backend.getMarketInfoUnsafe(marketIndex)
  <div
    className="flex-1 w-full h-full min-h-10 max-h-60 rounded-lg flex flex-col        overflow-y-scroll bg-white bg-opacity-70 shadow-lg">
    <div className="m-5">
      <h1 className="text-lg mb-1"> {marketInfo.name->React.string} </h1>
      <p className="text-sm text-gray-600"> {marketInfo.description->React.string} </p>
    </div>
  </div>
}
