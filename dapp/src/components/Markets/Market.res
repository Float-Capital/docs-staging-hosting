@react.component
let make = (~marketData) => {
  <div>
    <MarketCard marketData />
    <LineGraph />
    <Mint.Mint />
    <p> {"stake position form"->React.string} </p>
  </div>
}
