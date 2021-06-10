@react.component
let make = () => {
  <section className="bg-white">
    <div> <img src="/img/float-token.svg" className="w-10" /> </div>
    <div>
      <h3> {"Governance"->React.string} </h3>
      <p>
        {"The FLT token governs the float capital protocol. The right governance model will direct and shape the protocol through community lead proposals in a decentralised and fair manor. The future of Float Capital is dictated by its users. 100% of the fees and yield from the protocol are distributed fairly with all FLT holders."->React.string}
      </p>
      <div className="flex flex-row">
        <Button.Small> {"Read more"} </Button.Small> <Button.Small> {"Earn FLT"} </Button.Small>
      </div>
    </div>
  </section>
}
