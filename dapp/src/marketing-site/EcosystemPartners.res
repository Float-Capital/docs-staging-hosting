@react.component
let make = () => {
  <section>
    <h3> {"Ecosystem partners"->React.string} </h3>
    <div className="grid grid-cols-4 gap-4 items-center">
      <img src="/img/partners/aave.png" />
      <img src="/img/partners/polygon.png" />
      <img src="/img/partners/chainlink.jpg" />
      <img src="/img/partners/thegraph.png" />
    </div>
  </section>
}
