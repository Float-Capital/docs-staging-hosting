@react.component
let make = () => {
  <section
    className="min-h-screen w-screen flex flex-col items-center justify-center bg-pastel-purple">
    <h3 className="my-2 text-3xl uppercase font-bold "> {"ROADMAP"->React.string} </h3> <Timeline />
  </section>
}
