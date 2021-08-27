type modalInfo = {
  title: string,
  content: React.element,
  showModal: bool,
  hideModalCallback: unit => unit,
}

module ModalContext = {
  type t = {
    showModal: React.element => unit,
    hideModal: unit => unit,
    showModalWithTitle: (React.element, ~title: string) => unit,
    setModalState: (modalInfo => modalInfo) => unit,
  }

  let context = React.createContext({
    showModal: _ => (),
    hideModal: _ => (),
    showModalWithTitle: (_, ~title as _) => (),
    setModalState: _ => (),
  })

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

let defaultModalInfo = {
  title: "",
  content: React.null,
  showModal: false,
  hideModalCallback: _ => (),
}

let useModalDisplay = () => {
  let modalSetters = React.useContext(ModalContext.context)

  React.useEffect0(_ => Some(modalSetters.hideModal))

  modalSetters
}

type modalDisplayChainContext = {
  showNextModalInChain: React.element => unit,
  hideModalChain: unit => unit,
  startModalChain: React.element => unit,
}

type chainData = {
  chainHasBeenInitialized: bool,
  chainHasBeenHidden: bool,
}
let useModalDisplayChain = () => {
  let modalSetters = React.useContext(ModalContext.context)
  let chainHasBeenHidden = React.useRef(false)

  let chainHasBeenInitialized = React.useRef(false)

  let hideModal = _ => {
    chainHasBeenHidden.current = true
    modalSetters.hideModal()
  }

  let startModalChain = content => {
    chainHasBeenHidden.current = false
    chainHasBeenInitialized.current = true

    modalSetters.setModalState(_ => {
      title: "",
      content: content,
      showModal: true,
      hideModalCallback: () => {
        chainHasBeenHidden.current = true
      },
    })
  }

  let showNextModalInChain = content => {
    if !chainHasBeenInitialized.current {
      Js.log("Not showing the modal, please start a chain first")
    } else if !chainHasBeenHidden.current {
      modalSetters.showModal(content)
    }
  }

  React.useEffect0(_ => Some(modalSetters.hideModal))

  {
    startModalChain: startModalChain,
    hideModalChain: hideModal,
    showNextModalInChain: showNextModalInChain,
  }
}

@react.component
let make = (~children) => {
  let ({title, content, showModal, hideModalCallback}, setModalState) = React.useState(_ =>
    defaultModalInfo
  )

  let hideModal = _ => {
    if showModal {
      hideModalCallback()
      setModalState(_ => defaultModalInfo)
    }
  }

  <ModalContext.Provider
    value={(
      {
        showModal: content =>
          setModalState(state => {
            title: "",
            content: content,
            showModal: true,
            hideModalCallback: state.hideModalCallback,
          }),
        showModalWithTitle: (content, ~title) =>
          setModalState(state => {
            title: title,
            content: content,
            showModal: true,
            hideModalCallback: state.hideModalCallback,
          }),
        hideModal: hideModal,
        setModalState: setModalState,
      }: ModalContext.t
    )}>
    {children} {showModal ? <Modal title closeModal={hideModal}> {content} </Modal> : React.null}
  </ModalContext.Provider>
}
