@react.component
let make = () => {
  <div className="bg-primary text-center text-sm text-white p-1 mb-2 ">
    {`🏗 The protocol is under active development, join our `->React.string}
    <a
      className="hover:bg-white hover:text-primary py-1 "
      href=Config.discordInviteLink
      target="_blank">
      {`discord`->React.string}
    </a>
    {` to get the latest updates  🏗`->React.string}
  </div>
}
