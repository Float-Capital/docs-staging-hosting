@react.component
let make = () => {
  <section
    className="py-5 my-0 text:2xl md:text-lg flex flex-col md:flex-row items-end md:items-center md:justify-center bg-primary text-white">
    <Next.Link href="/markets">
      <a className="px-3 hover:bg-white hover:text-black"> {"app"->React.string} </a>
    </Next.Link>
    <Next.Link href="/stats">
      <a className="px-3 hover:bg-white hover:text-black"> {"stats"->React.string} </a>
    </Next.Link>
    <a
      href="https://www.cryptovoxels.com/play?coords=N@459W,127S"
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white hover:text-black">
      {"headquarters"->React.string}
    </a>
    <a
      href={Config.discordInviteLink}
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white hover:text-black">
      {"discord"->React.string}
    </a>
    <a
      href="https://twitter.com/float_capital"
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white hover:text-black">
      {"twitter"->React.string}
    </a>
    <a
      href="https://docs.float.capital"
      target="_"
      rel="noopenner noreferer"
      className="px-3 hover:bg-white hover:text-black">
      {"docs"->React.string}
    </a>
  </section>
}
