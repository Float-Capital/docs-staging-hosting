@val @scope("cy") external visit: string => unit = "visit"

module Location = {
  type t = {
    hash: string,
    host: string,
    hostname: string,
    href: string,
    origin: string,
    pathname: string,
    port: int,
    protocol: string,
    search: string,
    toString: unit => string,
  }
  @val @scope("cy") external get: unit => t = "location"
  type locationTypes = [#href | #pathname]
  @val @scope("cy") external getType: locationTypes => t = "location"
}

module Element = {
  type t
  type elementArray

  @send external click: t => t = "click"
  @send external _type: (t, string) => t = "type"
  @send external first: elementArray => t = "first"
  @send external last: elementArray => t = "last"

  type elementChecks = [#exist]
  @send external should: (t, elementChecks) => t = "should"
  @send external shouldAll: (elementArray, elementChecks) => elementArray = "should"
}

/// All the functions injected by: @testing-library/cypress/add-commands
module RTF = {
  // Single elements
  @val @scope("cy") external findByAltText: string => Element.t = "findByAltText"
  @val @scope("cy") external findByPlaceholderText: string => Element.t = "findByPlaceholderText"
  @val @scope("cy") external findByPlaceholderTextRe: Js.Re.t => Element.t = "findByPlaceholderText"

  // All elements
  @val @scope("cy") external findAllByText: string => Element.elementArray = "findAllByText"
  @val @scope("cy") external findAllByTextRe: Js.Re.t => Element.elementArray = "findAllByText"

  type roles = [#button]
  type roleOptions = {
    // exact?: boolean = true,
    // hidden?: boolean = false,
    name: option<Js.Re.t>,
    // normalizer?: NormalizerFn,
    // selected?: boolean,
    // checked?: boolean,
    // pressed?: boolean,
    // expanded?: boolean,
    // queryFallbacks?: boolean,
    // level?: number,
  }
  @val @scope("cy")
  external findByRole: (roles, roleOptions) => Element.t = "findByRole"
}
