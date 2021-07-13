@react.component
let make = (~title, ~suffixEmoji=``) => {
  <h3 className="my-2 text-5xl uppercase font-arimo font-extrabold flex items-center">
    <span className="text-5xl font-vt323 animate-pulse font-bold mx-2"> {">"->React.string} </span>
    <span className="text-gray-800"> {title->React.string} </span>
    <span className="text-4xl mx-2"> {suffixEmoji->React.string} </span>
  </h3>
}
