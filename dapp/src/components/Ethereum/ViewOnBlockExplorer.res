@react.component
let make = (~txHash) => {
  txHash != ""
    ? <a
        className="hover:underline text-gray-600 text-sm"
        target="_"
        rel="noopener noreferrer"
        href={`${Config.blockExplorer}tx/${txHash}`}>
        {`view on ${Config.blockExplorerName}`->React.string}
      </a>
    : React.null
}
