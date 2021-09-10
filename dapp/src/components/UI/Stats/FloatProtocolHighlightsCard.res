@react.component
let make = (~liveSince, ~totalUsers, ~txHash, ~numberOfSynths) => {
  let deploymentDateObj = liveSince->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime

  <div className={"bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-2 md:mb-5 p-6"}>
    <h1 className="font-bold text-center text-lg font-alphbeta mb-2">
      {`Float Capital Protocol 🏗️`->React.string}
    </h1>
    <ul>
      <a href={`${Config.blockExplorer}/tx/${txHash}`} className="mt-2">
        <li>
          <span className="text-sm mr-2"> {`🗓️ Live since:`->React.string} </span>
          <span className="text-md">
            {deploymentDateObj->DateFns.format(#"do MMM ''yy")->React.string}
          </span>
        </li>
      </a>
      <li className="mt-2">
        <span className="text-sm mr-2"> {`📅 Days live:`->React.string} </span>
        <span className="text-md">
          {deploymentDateObj->DateFns.formatDistanceToNow->React.string}
        </span>
      </li>
      <li className="mt-2">
        <span className="text-sm mr-2"> {`👯‍♀️ No. users:`->React.string} </span>
        <span className="text-md"> {totalUsers->Ethers.BigNumber.toString->React.string} </span>
      </li>
      <li className="mt-2">
        <span className="text-sm mr-2"> {`👷‍♀️ No. synths:`->React.string} </span>
        <span className="text-md"> {numberOfSynths->React.string} </span>
      </li>
    </ul>
  </div>
}
