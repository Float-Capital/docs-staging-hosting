@ocamldoc("localstorage isn't defined in nodejs for nextjs, thus rather use this optional value")
let optLocalstorage: option<Dom.Storage.t> =
  Js.typeof(Dom.Storage.localStorage) == "undefined" ? None : Some(Dom.Storage.localStorage)

@ocamldoc("The global window object that exists in browsers") @bs.val
external window: 'a = "window"

@ocamldoc("This is useful for functions that shouldn't be run server side by Next.js for example")
let onlyExecuteClientSide = functionForClientsideExecution =>
  if window->Js.typeof != "undefined" {
    functionForClientsideExecution()
  }
