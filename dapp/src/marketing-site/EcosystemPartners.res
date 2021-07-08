@react.component
let make = () => {
  <section className="my-10">
    <h3 className="m-2 text-3xl text-center uppercase font-bold">
      {"Ecosystem partners"->React.string}
    </h3>
    <div className="w-full mx-auto max-w-5xl flex flex-col md:flex-row items-center justify-evenly">
      <img src="/img/partners/aave.png" className="w-40" />
      <img src="/img/partners/polygon.png" className="w-40" />
      <img src="/img/partners/chainlink.png" className="w-40" />
      <img src="/img/partners/thegraph.png" className="w-40" />
    </div>
  </section>
}
