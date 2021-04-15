@react.component
let make = () =>
  <p className="text-xs hover:underline">
    <a target="_" rel="noopenner noreferer" href=Config.discordInviteLink>
      {"Message us on discord for assistance"->React.string}
    </a>
  </p>
