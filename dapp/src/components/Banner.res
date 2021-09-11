@react.component
let make = () => {
  <div className="absolute bg-primary p-1 mb-2 h-10 flex items-center w-full font-default">
    <div className="text-center text-xxs md:text-sm text-white mx-12 w-full">
      {`🍾 Alpha launch is live on polygon! 🍾`->React.string}
      // TODO: not the cleanest but keeping for simplicity of commenting out later when banner is changed
      // <a
      //   className="bg-white hover:bg-primary-light text-primary hover:text-white py-1 font-bold"
      //   href=Config.discordInviteLink
      //   target="_blank"
      //   rel="noopener noreferrer">
      //   {`discord`->React.string}
      // </a>
      // {` to get the latest updates  🏗`->React.string}
    </div>
  </div>
}
