@react.component
let make = () => {
  <section
    id="governance"
    className="py-10 min-h-screen w-screen flex flex-col items-center justify-center ballot-box">
    <div className="max-w-5xl flex flex-col md:flex-row justify-evenly items-center mx-auto">
      <div className="w-full md:w-1/2 order-2 md:order-1 p-4 md:p-0">
        <Heading title="governance" suffixEmoji=`👤` />
        <p
          className="text-lg md:text-2xl p-4 md:p-0 bg-white bg-opacity-80 rounded-lg md:bg-transparent">
          {"The FLT token governs the float capital protocol. The right governance model will direct and shape the protocol through community lead proposals in a decentralised and fair manor. The future of Float Capital will be dictated by its users."->React.string}
        </p>
        <div className="flex flex-row my-4 items-center justify-evenly md:justify-start  ">
          <div className="mr-4"> <Button> {"Read more"} </Button> </div>
          <div> <Button> {"Earn FLT"} </Button> </div>
        </div>
      </div>
      <div className="w-full md:w-1/2 order-1 md:order-2" />
    </div>
  </section>
}
