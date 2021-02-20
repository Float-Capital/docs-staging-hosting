type bound_mutate<'data> = (option<'data>, option<bool>) => JsPromise.t<option<'data>>

type responseInterface<'data> = {
  data: option<'data>,
  error: exn,
  revalidate: unit => JsPromise.t<bool>,
  mutate: bound_mutate<'data>,
  isValidating: bool,
}

type revalidateOptionInterface = {retryCount: option<int>, dedupe: option<bool>}

type revalidateType = revalidateOptionInterface => JsPromise.t<bool>

@deriving(abstract)
type rec configInterface<'key, 'data> = {
  /* Global options */
  @optional errorRetryInterval: int,
  @optional errorRetryCount: int,
  @optional loadingTimeout: int,
  @optional focusThrottleInterval: int,
  @optional dedupingInterval: int,
  @optional refreshInterval: int,
  @optional refreshWhenHidden: bool,
  @optional refreshWhenOffline: bool,
  @optional revalidateOnFocus: bool,
  @optional revalidateOnMount: bool,
  @optional revalidateOnReconnect: bool,
  @optional shouldRetryOnError: bool,
  @optional suspense: bool,
  @optional initialData: 'data,
  @optional onLoadingSlow: ('key, configInterface<'key, 'data>) => unit,
  @optional onSuccess: ('data, 'key, configInterface<'key, 'data>) => unit,
  @optional onError: (exn, 'key, configInterface<'key, 'data>) => unit,
  @optional
  onErrorRetry: (
    exn,
    'key,
    configInterface<'key, 'data>,
    revalidateType,
    revalidateOptionInterface,
  ) => unit,
  @optional compare: (option<'data>, option<'data>) => bool,
}

@val @module("swr")
external useSwrConditonal1: (
  unit => option<array<'param>>,
  'param => JsPromise.t<'data>,
  ~config: option<configInterface<('a, 'b), 'data>>,
) => responseInterface<'data> = "default"

@val @module("swr")
external useSwrConditonal2: (
  unit => option<('a, 'b)>,
  ('a, 'b) => JsPromise.t<'data>,
  ~config: option<configInterface<('a, 'b), 'data>>,
) => responseInterface<'data> = "default"

@val @module("swr")
external useSwrConditonal3: (
  unit => option<('a, 'b, 'c)>,
  ('a, 'b, 'c) => JsPromise.t<'data>,
  ~config: option<configInterface<('a, 'b, 'c), 'data>>,
) => responseInterface<'data> = "default"

@val @module("swr")
external useSwrConditonal4: (
  unit => option<('a, 'b, 'c, 'd)>,
  ('a, 'b, 'c, 'd) => JsPromise.t<'data>,
  ~config: option<configInterface<('a, 'b, 'c, 'd), 'data>>,
) => responseInterface<'data> = "default"

@val @module("swr")
external useSwrConditonal5: (
  unit => option<('a, 'b, 'c, 'd, 'e)>,
  ('a, 'b, 'c, 'd, 'e) => JsPromise.t<'data>,
  ~config: option<configInterface<('a, 'b, 'c, 'd, 'e), 'data>>,
) => responseInterface<'data> = "default"

@val @module("swr")
external useSwrConditonal6: (
  unit => option<('a, 'b, 'c, 'd, 'e, 'f)>,
  ('a, 'b, 'c, 'd, 'e, 'f) => JsPromise.t<'data>,
  ~config: option<configInterface<('a, 'b, 'c, 'd, 'e, 'f), 'data>>,
) => responseInterface<'data> = "default"
