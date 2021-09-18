@react.component
let make = () => {
  <div className="absolute bg-primary p-1 mb-2 h-10 flex items-center w-full font-default">
    <div className="text-center text-xxs md:text-sm text-white mx-12 w-full">
      {Config.isPolygon
        ? <>
            {`🍾 Alpha is live on Polygon! View our `->React.string}
            <a
              className="bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold"
              href="https://youtu.be/UFX-mQgV1JU"
              target="_blank"
              rel="noopener noreferrer">
              {`Launch party recording`->React.string}
            </a>
            {` 🍾 The testnet can be found `->React.string}
            <a
              className="bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold"
              href="https://testnet.float.capital"
              target="_blank"
              rel="noopener noreferrer">
              {`here`->React.string}
            </a>
            {`.`->React.string}
          </>
        : <>
            {`This is the Float testnet, to view the live Alpha go `->React.string}
            <a
              className="bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold"
              href="https://float.capital"
              target="_blank"
              rel="noopener noreferrer">
              {`here`->React.string}
            </a>
            {`.`->React.string}
          </>}
    </div>
  </div>
}
