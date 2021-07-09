@react.component
let make = () => {
  <section
    className="min-h-screen w-screen flex flex-col items-center justify-center bg-pastel-pink">
    <h3 className="my-2 text-5xl uppercase  font-arimo font-extrabold ">
      {"ROADMAP"->React.string}
    </h3>
    <Timeline />
  </section>
}
