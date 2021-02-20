@module("date-fns/format") external format: (Js.Date.t, string) => string = "default"
@module("date-fns/formatDistanceToNow")
external formatDistanceToNow: Js.Date.t => string = "default"

@module("date-fns/fromUnixTime") external fromUnixTime: float => Js.Date.t = "default"
