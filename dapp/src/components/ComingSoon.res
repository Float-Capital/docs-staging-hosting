@react.component
let make = () => {
  <div className="bg-primary text-center text-sm text-white p-1 mb-2 ">
    {`🏗 The protocol is under active development, join our `->React.string}
    <a
      className="bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold"
      href=Config.discordInviteLink
      target="_blank"
      rel="noopener noreferrer">
      {`discord`->React.string}
    </a>
    {` to get the latest updates  🏗`->React.string}
  </div>
}
