@react.component
let make = (~onClick, ~preLabel: string="", ~postLabel: string="") => {
  Js.log(onClick)
  <div className="flex justify-end ">
    <div className="flex items-center my-5">
      <label htmlFor="toogleA" className="flex items-center cursor-pointer">
        {preLabel->Js.String2.length > 0
          ? <div className="mr-3 text-gray-700 font-medium"> {preLabel->React.string} </div>
          : React.null}
        <div className="relative">
          <input id="toogleA" className="hidden" type_="checkbox" />
          <div className="toggle__line w-10 h-4 bg-gray-400 rounded-full shadow-inner" />
          <div
            className="toggle__dot absolute w-6 h-6 bg-white rounded-full shadow inset-b-0 left-0"
          />
        </div>
        {postLabel->Js.String2.length > 0
          ? <div className="ml-3 text-gray-700 font-medium"> {postLabel->React.string} </div>
          : React.null}
      </label>
    </div>
  </div>
}
