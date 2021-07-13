@react.component
let make = () => {
  <section id="security" className="min-h-screen w-screen  fighter-blue">
    <div
      className=" flex flex-col items-center justify-center pb-16 custom-height-for-above-footer">
      <div className="max-w-5xl flex flex-col justify-evenly items-center mx-auto">
        <Heading title="security" suffixEmoji=`🔐` />
        <div className="grid grid-cols-3 gap-10 items-center justify-center">
          <div className="mx-4">
            <a className="custom-cursor" target="_blank" href="#" rel="noopener noreferrer">
              //TODO
              <img src="/icons/coverage.svg" className="h-32 mx-auto  hover:opacity-80" />
              <p className="text-center w-40 mx-auto hover:underline">
                {"Smart contract code coverage"->React.string}
              </p>
            </a>
          </div>
          <div className="mx-4">
            <a className="custom-cursor" target="_blank" href="#" rel="noopener noreferrer">
              //TODO
              <img src="/icons/github-color.svg" className="h-32 mx-auto  hover:opacity-80" />
              <p className="text-center w-40 mx-auto hover:underline">
                {"Github code"->React.string}
              </p>
            </a>
          </div>
          <div className="mx-4">
            <a className="custom-cursor" target="_blank" href="#" rel="noopener noreferrer">
              //TODO
              <img src="/icons/code-arena-sq.png" className="h-32 mx-auto  hover:opacity-80" />
              <p className="text-center  w-40 mx-auto hover:underline">
                {"Audit (Coming soon)"->React.string}
              </p>
            </a>
          </div>
        </div>
      </div>
    </div>
    <Footer />
  </section>
}
