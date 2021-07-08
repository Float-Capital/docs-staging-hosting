@react.component
let make = () => {
  <section
    className="py-10 min-h-screen w-screen flex flex-col items-center justify-center bg-pastel-orange">
    <div className="max-w-5xl flex flex-col md:flex-row justify-evenly items-center mx-auto">
      <div className="w-full md:w-1/2 order-2 md:order-1 p-4 md:p-0">
        <h3 className="my-2 text-5xl uppercase font-bold"> {"Governance"->React.string} </h3>
        <p className="text-2xl">
          {"The FLT token governs the float capital protocol. The right governance model will direct and shape the protocol through community lead proposals in a decentralised and fair manor. The future of Float Capital will be dictated by its users."->React.string}
        </p>
        <div className="flex flex-row my-4 items-center justify-evenly md:justify-start  ">
          <div className="mr-4"> <Button.Small> {"Read more"} </Button.Small> </div>
          <div> <Button.Small> {"Earn FLT"} </Button.Small> </div>
        </div>
      </div>
      <div className="w-full md:w-1/2 order-1 md:order-2">
        <img src="/img/governance.svg" className="mx-auto md:ml-auto md:mr-0 w-64" />
      </div>
    </div>
  </section>
}
