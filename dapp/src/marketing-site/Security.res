@react.component
let make = () => {
  <section
    id="security"
    className="py-10 min-h-screen w-screen flex flex-col items-center justify-center fighter-blue">
    <div className="max-w-5xl flex flex-col justify-evenly items-center mx-auto">
      <h3 className="my-2 text-5xl uppercase font-arimo font-extrabold">
        {"Security"->React.string}
      </h3>
      <div className="grid grid-cols-3 items-center justify-center">
        <div className="mx-4">
          <img src="/icons/coverage.svg" className="h-36 mx-auto" />
          <p className="text-center"> {"Smart contract code coverage"->React.string} </p>
        </div>
        <div className="mx-4">
          <img src="/icons/github-color.svg" className="h-36 mx-auto" />
          <p className="text-center"> {"Github code"->React.string} </p>
        </div>
        <div className="mx-4">
          <img src="/icons/code-arena-sq.png" className="h-36 mx-auto" />
          <p className="text-center"> {"Audit: Coming soon"->React.string} </p>
        </div>
      </div>
    </div>
  </section>
}
