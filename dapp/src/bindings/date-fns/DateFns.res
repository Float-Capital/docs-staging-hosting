@bs.module("date-fns/format") external format: (Js.Date.t, string) => string = "default"
@bs.module("date-fns/formatDistanceToNow") external formatDistanceToNow: Js.Date.t => string = "default";

@bs.module("date-fns/fromUnixTime") external fromUnixTime: float => Js.Date.t = "default"
