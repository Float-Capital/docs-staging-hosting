@react.component
let make = () => {
  let onramp: Ramp.rampInstantSDK = Ramp.useRamp()

  <section
    className="max-w-2xl mx-auto p-5  flex-col items-center justify-between bg-white bg-opacity-75 rounded-lg shadow-lg">
    <div className="text-center p-6 pt-0">
      <h1 className="text-lg p-2">
        {"You can use this fiat onramp to buy DAI on Polygon"->React.string}
      </h1>
    </div>
    <div className="mx-auto max-w-sm">
      <Button
        onClick={_ => {
          onramp.show()
        }}>
        "Buy Polygon DAI"
      </Button>
    </div>
  </section>
}
let default = make
