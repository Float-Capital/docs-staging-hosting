module Link = Next.Link

@react.component
let make = (~clickedTrading) => {
  <div className="floating w-full">
    <div onClick={_ => clickedTrading(_ => true)}>
      <span className="cursor-pointer hover:opacity-70 w-full flex justify-center">
        <img alt="start-trading" src="/img/start-trading.png" className="p-4" />
      </span>
    </div>
  </div>
}
