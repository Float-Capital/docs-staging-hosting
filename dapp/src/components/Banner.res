@react.component
let make = () => {
  <div className="absolute bg-primary p-1 mb-2 h-10 flex items-center w-full font-default">
    <div className="text-center text-xxs md:text-sm text-white mx-12 w-full">
      {Config.isPolygon
        ? <>
            {`🍾 Alpha launch is live on Polygon! `->React.string}
            <a
              className="bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold"
              href="https://youtu.be/UFX-mQgV1JU"
              target="_blank"
              rel="noopener noreferrer">
              {`Launch party`->React.string}
            </a>
            {` on Fri 17th Sept, 2pm UTC 🍾`->React.string}
          </>
        : <>
            {`Our Alpha launch is going live on Polygon this Friday 17th Sept (2pm UTC), join the event `->React.string}
            <a
              className="bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold"
              href="https://youtu.be/UFX-mQgV1JU"
              target="_blank"
              rel="noopener noreferrer">
              {`here`->React.string}
            </a>
          </>}
    </div>
  </div>
}
