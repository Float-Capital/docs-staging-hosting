@react.component
let make = () => {
  <section className="text-center text-xs my-2">
    <Next.Link href="/markets">
      <a className="px-3 hover:bg-white"> {"app"->React.string} </a>
    </Next.Link>
    <Next.Link href="/stats">
      <a className="px-3 hover:bg-white"> {"stats"->React.string} </a>
    </Next.Link>
    <a
      href="https://www.cryptovoxels.com/play?coords=N@459W,127S"
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white">
      {"headquarters"->React.string}
    </a>
    <a
      href={Config.discordInviteLink}
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white">
      {"discord"->React.string}
    </a>
    <a
      href="https://twitter.com/float_capital"
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white">
      {"twitter"->React.string}
    </a>
    <a
      href="https://docs.float.capital"
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white">
      {"docs"->React.string}
    </a>
  </section>
}
