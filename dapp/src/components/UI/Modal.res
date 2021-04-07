// Styles inspiration:
//     * https://www.creative-tim.com/learning-lab/tailwind-starter-kit/documentation/react/modals/regular
//     * https://tailwindui.com/components/application-ui/overlays/modals

@react.component
let make = (~closeModal=_ => (), ~children) => {
  let (showModal, setShowModal) = React.useState(_ => true)

  let closeButton =
    <button
      className="p-1 ml-auto float-right text-3xl leading-none outline-none focus:outline-none"
      onClick={_ => setShowModal(_ => false)}>
      <span className="opacity-4 block outline-none focus:outline-none">
        {`×`->React.string}
      </span>
    </button>

  showModal
    ? <>
        <div
          onClick=closeModal
          className="justify-center items-center flex overflow-x-hidden overflow-y-auto fixed inset-0 z-50 outline-none focus:outline-none">
          <div className="relative w-auto my-6 mx-auto max-w-3xl">
            <div
              onClick={e => {
                e->ReactEvent.Mouse.preventDefault
                e->ReactEvent.Mouse.stopPropagation
              }}
              className="p-5 border-0 rounded-sm shadow-lg relative flex flex-col w-full bg-white outline-none focus:outline-none">
              {
                // {
                //   // header
                //   switch title {
                //   | Some(title) =>
                //     <div
                //       className="flex items-start justify-between p-5 border-b border-solid border-blueGray-200 rounded-t">
                //       <h3 className="text-3xl"> {title->React.string} </h3>
                //       {closeButton}
                //     </div>
                //   | None => closeButton
                //   }
                // }
                closeButton
              }
              <div className="relative px-6 flex-auto"> {children} </div>
            </div>
          </div>
        </div>
        <div className="opacity-25 fixed inset-0 z-40 bg-black" />
      </>
    : React.null
}
