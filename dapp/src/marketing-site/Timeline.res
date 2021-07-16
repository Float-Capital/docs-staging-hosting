type milestoneFormat = {
  lineContent: string,
  isBeginning: bool,
}

type quarterContent = {
  title: string,
  milestones: array<milestoneFormat>,
}

@react.component
let make = () => {
  let timeLineContent: array<quarterContent> = [
    {
      title: "Q1 2021",
      milestones: [
        {lineContent: "Mechanism design", isBeginning: true},
        {lineContent: "Mathematical formalization", isBeginning: true},
        {lineContent: "Smart contract", isBeginning: true},
        {lineContent: "implementations", isBeginning: false},
        {lineContent: "UI beta", isBeginning: true},
      ],
    },
    {
      title: "Q2 2021",
      milestones: [
        {lineContent: "Polygon testnet deployment", isBeginning: true},
        {lineContent: "Team expansion", isBeginning: true},
        {lineContent: "$1mil seed funding", isBeginning: true},
        {lineContent: "Chainlink + Polygon + Aave", isBeginning: true},
        {lineContent: "+ POAP partnerships", isBeginning: false},
      ],
    },
    {
      title: "Q3 2021",
      milestones: [
        {lineContent: "Smart contract audit", isBeginning: true},
        {lineContent: "UI/UX improvements", isBeginning: true},
        {lineContent: "PROTOCOL LAUNCH (Polygon)", isBeginning: true},
        {lineContent: "FLT token live", isBeginning: true},
        {lineContent: "Governance live", isBeginning: true},
      ],
    },
    {
      title: "Q4 2021",
      milestones: [
        {lineContent: "New markets", isBeginning: true},
        {lineContent: "(+traditional", isBeginning: false},
        {lineContent: "financial markets)", isBeginning: false},
        {lineContent: "User profiles + Leaderboards", isBeginning: true},
        {lineContent: "Utility NFTs", isBeginning: true},
      ],
    },
    {
      title: "Q1 2022",
      milestones: [
        {lineContent: "New yield protocol", isBeginning: true},
        {lineContent: "integrations", isBeginning: false},
        {lineContent: "Optimism Launch", isBeginning: true},
        {lineContent: "Social trading", isBeginning: true},
        {lineContent: "User deployable markets", isBeginning: true},
      ],
    },
  ]

  let quarterElement = (timeLineContent: quarterContent) => {
    <>
      <h3 className="font-semibold text-lg mb-1"> {timeLineContent.title->React.string} </h3>
      <ul className="text-sm">
        {timeLineContent.milestones
        ->Array.map(milestone =>
          <li>
            <span className="font-vt323 font-bold mr-2">
              {(milestone.isBeginning ? ">" : `\xa0`)->React.string}
            </span>
            {milestone.lineContent->React.string}
          </li>
        )
        ->React.array}
      </ul>
    </>
  }

  <div className="container my-4">
    <div className="flex flex-row flex-wrap border-l md:border-l-0 ml-2 md:m-0">
      <div className="w-full md:w-1/4 md:max-w-1/2 mx-4 md:mx-0 order-1 md:order-1">
        <div
          className="bg-primary md:w-full text-white p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-br-none my-4 shadow-md inline-block w-full md:w-auto relative">
          {quarterElement(timeLineContent->Array.getUnsafe(0))}
          <div
            className="bg-primary h-4 w-4 border rounded-full absolute -left-6 -top-2 md:top-auto md:left-auto md:-right-2 md:-bottom-6 "
          />
        </div>
      </div>
      <div className="w-1/8  order-2 md:order-2" />
      <div className="w-full md:w-1/4 md:max-w-1/2 mx-4 md:mx-0 order-5 md:order-3 ">
        <div
          className="bg-white md:w-full p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-br-none my-4 shadow-md  inline-block w-full md:w-auto relative">
          {quarterElement(timeLineContent->Array.getUnsafe(2))}
          <div
            className="bg-white h-4 w-4 border rounded-full absolute -left-6 -top-2 md:top-auto md:left-auto md:-right-2 md:-bottom-6"
          />
        </div>
      </div>
      <div className="w-1/8  order-3 md:order-3" />
      <div className="w-full md:w-1/4 md:max-w-1/2 mx-4 md:mr-0 md:ml-auto order-10 md:order-4 ">
        <div
          className="bg-white p-4 rounded-md md:w-full rounded-tl-none md:rounded-tl-md md:rounded-br-none my-4 shadow-md  inline-block w-full md:w-auto relative">
          {quarterElement(timeLineContent->Array.getUnsafe(4))}
          <div
            className="bg-white h-4 w-4 border rounded-full absolute -left-6 -top-2 md:top-auto md:left-auto md:-right-2 md:-bottom-6"
          />
        </div>
      </div>
      <div className="md:border-b w-full order-4 md:order-6" />
      <div className="w-1/8  order-5 md:order-7" />
      <div className="w-full md:w-1/4 md:max-w-1/2 mx-4 md:mx-0 order-2 md:order-8">
        <div
          className="bg-primary md:w-full text-white p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-tr-none my-4 shadow-md  inline-block w-full md:w-auto relative">
          {quarterElement(timeLineContent->Array.getUnsafe(1))}
          <div
            className="bg-primary h-4 w-4 border rounded-full absolute  -left-6 -top-2 md:left-auto md:-right-2 md:-top-6"
          />
        </div>
      </div>
      <div className="w-1/8  order-5 md:order-9" />
      <div className="w-full md:w-auto md:max-w-1/2 mx-4 md:ml-0 md:mr-0 order-6 md:order-10">
        <div
          className="bg-white md:w-full p-4 rounded-md rounded-tl-none md:rounded-tl-md md:rounded-tr-none my-4 shadow-md  inline-block  w-full md:w-auto relative">
          {quarterElement(timeLineContent->Array.getUnsafe(3))}
          <div
            className="bg-white h-4 w-4 border rounded-full absolute -left-6 -top-2 md:left-auto md:-right-2 md:-top-6"
          />
        </div>
      </div>
    </div>
  </div>
}
