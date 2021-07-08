@react.component
let make = () => {
  <section className="my-10">
    <div className="flex flex-col md:flex-row justify-evenly items-center">
      <div className="w-full md:w-1/2 order-2 md:order-1 p-4 md:p-0">
        <h3 className="my-2 text-3xl uppercase font-bold"> {"Governance"->React.string} </h3>
        <p>
          {"The FLT token governs the float capital protocol. The right governance model will direct and shape the protocol through community lead proposals in a decentralised and fair manor. The future of Float Capital will be dictated by its users. FLT holders govern the Float Capital Treasury."->React.string}
        </p>
        <div className="flex flex-row my-4 items-center justify-evenly md:justify-start  ">
          <div className="mr-4"> <Button.Small> {"Read more"} </Button.Small> </div>
          <div> <Button.Small> {"Earn FLT"} </Button.Small> </div>
        </div>
      </div>
      <div className="w-full md:w-1/2 order-1 md:order-2">
        <img src="/img/governance.svg" className="mx-auto w-40" />
      </div>
    </div>
  </section>
}
