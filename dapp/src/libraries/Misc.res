@ocamldoc("localstorage isn't defined in nodejs for nextjs, thus rather use this optional value")
let optLocalstorage: option<Dom.Storage.t> =
  Js.typeof(Dom.Storage.localStorage) == "undefined" ? None : Some(Dom.Storage.localStorage)
