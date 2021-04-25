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
  @send external click: t => unit = "click"
}

/// All the functions injected by: @testing-library/cypress/add-commands
module RTF = {
  // Single elements
  @val @scope("cy") external findByAltText: string => Element.t = "findByAltText"

  // All elements
  @val @scope("cy") external findAllByText: string => array<Element.t> = "findAllByText"
}
