%%raw(`
require("chai").use(require('@defi-wonderland/smock').smock.matchers);
`)

type expectation
@module("chai")
external expect: 'a => expectation = "expect"

@send @scope(("to", "have"))
external toHaveCallCount: (expectation, int) => unit = "callCount"
