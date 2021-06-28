@ocaml.doc(`Please add additional useful formats:

do MMM ''yy      | 1st Jan '21
ha do MMM ''yy   | 8PM 1st Jan '21
ha               | 8PM
iii              | Tues
iii MMM          | Tues Jan
MMM              | Jan
`)
type dateFormats = [
  | #"do MMM ''yy"
  | #"ha do MMM ''yy"
  | #ha
  | #iii
  | #"iii MMM"
  | #MMM
]

@module("date-fns/format") external format: (Js.Date.t, dateFormats) => string = "default"
@module("date-fns/formatDistanceToNow")
external formatDistanceToNow: Js.Date.t => string = "default"

type durationTimeFormat = {
  years: int,
  months: int,
  weeks: int,
  days: int,
  hours: int,
  minutes: int,
  seconds: int,
}

type durationFormatOutput = {format: array<string>}

@module("date-fns/formatDuration")
external formatDuration: (durationTimeFormat, durationFormatOutput) => string = "default"

type interval = {start: Js_date.t, end: Js_date.t}

@module("date-fns/intervalToDuration")
external intervalToDuration: interval => durationTimeFormat = "default"

@module("date-fns/fromUnixTime") external fromUnixTime: float => Js.Date.t = "default"
