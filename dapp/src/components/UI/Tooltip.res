@react.component

let make = (~tip) => 
<span className="has-tooltip">
  <span className="text-xs tooltip rounded p-1 bg-gray-100 -mt-8 font-default font-normal">
  {~tip->React.string}
  </span>
  <span className="text-xs cursor-default"> {`ℹ️`->React.string} </span>
</span>