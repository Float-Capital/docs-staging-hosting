@react.component
let make = () => {
  <section
    id="how-it-works"
    className="py-10 bg-white min-h-screen w-screen flex flex-col items-center justify-center purple-moon">
    <h3 className="m-2 text-5xl text-center uppercase  font-arimo font-extrabold">
      {"How it works"->React.string}
    </h3>
    <div className="flex flex-col md:flex-row items-center">
      <div className="w-full md:w-2/5 mx-2 relative">
        <div className="my-2 text-lg">
          <h2> {"No overcollateralization"->React.string} </h2>
          <h2> {"No liquidiation"->React.string} </h2>
          <h2> {"No centralisation"->React.string} </h2>
        </div>
      </div>
      <div className="w-full md:w-3/5"> <FeaturedMarkets /> </div>
    </div>
  </section>
}
