@val
external describe: (string, unit => unit) => unit = "describe"
@val
external describe_skip: (string, unit => unit) => unit = "describe.skip"

// Synchronous code
@val
external it: (string, unit => unit) => unit = "it"
@val
external it_only: (string, unit => unit) => unit = "it.only"
@val
external it_skip: (string, unit => unit) => unit = "it.skip"
@val
external before_each: (unit => unit) => unit = "beforeEach"
@val
external before: (unit => unit) => unit = "before"

// Asynchronous code
// NOTE - this allows the testing function to return any promise. Even a promise of a promise of a promise. This may not be desirable.
@val
external it': (string, unit => Js.Promise.t<'a>) => unit = "it"
@val
external it_only': (string, unit => Js.Promise.t<'a>) => unit = "it.only"
@val
external it_skip': (string, unit => Js.Promise.t<'a>) => unit = "it.skip"
@val
external before_each': (unit => Js.Promise.t<'a>) => unit = "beforeEach"
@val
external before': (unit => Js.Promise.t<'a>) => unit = "before"
