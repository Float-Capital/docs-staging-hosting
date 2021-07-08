@react.component
let make = () => {
  <section
    className="py-10 bg-white min-h-screen w-screen flex flex-col items-center justify-center bg-pastel-yellow">
    <h3 className="m-2 text-5xl text-center uppercase font-bold">
      {"Ecosystem partners"->React.string}
    </h3>
    <div className="w-full mx-auto max-w-6xl flex flex-col md:flex-row items-center justify-evenly">
      <img src="/img/partners/aave.png" className="w-64" />
      <img src="/img/partners/polygon.png" className="w-64" />
      <img src="/img/partners/chainlink.png" className="w-64" />
      <img src="/img/partners/thegraph.png" className="w-64" />
    </div>
  </section>
}
