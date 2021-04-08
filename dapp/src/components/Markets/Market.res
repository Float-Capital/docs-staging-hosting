module Tab = {
  @react.component
  @ocaml.doc("
  @param {selected} whether the tab is currently selected
  @param {active} whether the tab is capable of being selected
  ")
  let make = (~selected=false, ~active=true, ~text, ~onClick=_ => ()) => {
    let bg = selected ? "bg-white" : "bg-gray-100"
    let opacity = selected ? "bg-opacity-70" : "opacity-70"
    let margin = !selected ? "mb-0.5" : "pb-1.5"
    let activeStyle = !active ? "cursor-not-allowed" : "cursor-pointer"
    <li className="mr-3 mb-0">
      <div
        className={`${bg}  ${opacity}  ${margin} ${activeStyle} inline-block  rounded-t-lg py-1 px-4`}
        onClick>
        {text->React.string}
      </div>
    </li>
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
      <div className="flex-1  p-1 mb-2 ">
        <ul className="list-reset flex items-end">
          {[
            <Tab text="Mint" selected=true />,
            <Tab text="Redeem" active=false />,
            <Tab text="Stake" active=false />,
            <Tab text="Unstake" active=false />,
          ]->React.array}
        </ul>
        <div className="rounded-b-lg rounded-r-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
          <Mint.Mint />
        </div>
      </div>
      <div
        className="flex-1 w-full min-h-10 p-1 mb-2 ml-8 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        <PriceGraph marketName={marketData.name} />
      </div>
    </div>
    <MarketCard marketData />
  </div>
}
