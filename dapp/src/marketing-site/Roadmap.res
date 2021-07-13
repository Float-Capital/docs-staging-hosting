@react.component
let make = () => {
  <section
    id="roadmap" className="min-h-screen w-screen flex flex-col items-center justify-center road">
    <Heading title="roadmap" suffixEmoji=`🗺️` /> <Timeline />
  </section>
}
