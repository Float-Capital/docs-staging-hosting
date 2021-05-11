// Note: hashtags don't work here
@react.component
let make = (~message) => {
  let encodedMessage = message->Js.Global.encodeURI

  <a
    href={`https://twitter.com/intent/tweet?text=${encodedMessage}`}
    target="_blank"
    rel="noopenner noreferrer"
    className="w-44 h-12 text-sm shadow-md rounded-lg border-2 my-2 focus:outline-none border-gray-200 hover:bg-gray-200 flex justify-center items-center mx-auto">
    <div className="mx-2 flex flex-row">
      <div> {"Tweet"->React.string} </div> <img src="/icons/twitter.svg" className="h-5 ml-1" />
    </div>
  </a>
}
