module Link = Next.Link

@react.component
let make = () =>
  <div>
    <div className="screen-centered-container">
      <div className="start-trading">
        <div className="floating-container">
          <div className="floating">
            <Link href="/dapp">
              <span className="floating-image-wrapper">
                <img src="/img/start-trading.png" className="start-trading" />
              </span>
            </Link>
          </div>
        </div>
      </div>
    </div>
  </div>
