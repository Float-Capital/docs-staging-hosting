module Tab = {
  @react.component
  let make = (~selected=false, ~text, ~onClick=_ => ()) => {
    let bg = selected ? "bg-white" : "bg-gray-100"
    let opacity = selected ? "bg-opacity-70" : "opacity-70"
    let margin = !selected ? "mb-0.5" : "pb-1.5"
    <li className="mr-3 mb-0">
      <div
        className={`${bg}  ${opacity}  ${margin} cursor-pointer inline-block rounded-t-lg py-1 px-4`}
        onClick>
        {text->React.string}
      </div>
    </li>
  }
}

module MarketInteractionCard = {
  type tab = Mint | Redeem | Stake | Unstake

  let allTabs = [Mint, Redeem, Stake, Unstake]

  let tabToStr = tab =>
    switch tab {
    | Mint => "Mint"
    | Redeem => "Redeem"
    | Stake => "Stake"
    | Unstake => "Unstake"
    }

  @react.component
  let make = () => {
    let (selected, setSelected) = React.useState(_ => Mint)
    <div className="flex-1 p-1 mb-2 ">
      <ul className="list-reset flex items-end">
        {allTabs
        ->Array.map(tab => {
          <Tab
            text={tab->tabToStr} selected={tab == selected} onClick={_ => setSelected(_ => tab)}
          />
        })
        ->React.array}
      </ul>
      <div className="rounded-b-lg rounded-r-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        {switch selected {
        | Mint => <Mint.Mint />
        | _ => <Mint.Mint />
        }}
      </div>
    </div>
  }
}
@react.component
let make = (~marketData: Queries.MarketDetails.t_syntheticMarkets) => {
  <div>
    <Next.Link href="/markets">
      <div className="uppercase text-sm text-gray-600 hover:text-gray-500 cursor-pointer mt-2">
        {`◀`->React.string} <span className="text-xs"> {" Back to markets"->React.string} </span>
      </div>
    </Next.Link>
    <div className="flex flex-col md:flex-row justify-center items-stretch">
      <MarketInteractionCard />
      <div
        className="flex-1 w-full min-h-10 p-1 mb-2 ml-8 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        <PriceGraph marketName={marketData.name} />
      </div>
    </div>
    <MarketCard marketData />
  </div>
}
