open Jest
open Expect
open ReactTestingLibrary

describe("example", () => {
  test("Component renders", () =>
    <div style={ReactDOM.Style.make(~color="rebeccapurple", ())}>
      <h1> {React.string("Heading")} </h1>
    </div>
    ->render
    ->container
    ->expect
    ->toMatchSnapshot
  )
})
