@react.component
let make = () => {
  <section
    id="roadmap" className="min-h-screen w-screen flex flex-col items-center justify-center bg-car">
    <div className="my-4"> <Heading title="roadmap" suffixEmoji=`🗺️` /> </div> <Timeline />
  </section>
}
