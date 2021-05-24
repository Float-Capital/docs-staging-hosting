module OptionallyIntoLink = {
  @react.component
  let make = (~link, ~children) =>
    link->Option.mapWithDefault(children, link => <a href={link}> {children} </a>)
}

module Props = {
  type definition = {
    prefix: string,
    value: string,
    suffix: React.element,
    link: option<string>,
  }

  let createStatsLiProps = (~suffix=React.null, ~prefix, ~value, ~link=?, ()) => {
    prefix: prefix,
    value: value,
    suffix: suffix,
    link: link,
  }
}

@react.component
let make = (~prefix, ~value, ~first, ~suffix, ~link=None) => {
  <OptionallyIntoLink link>
    <li className={first ? "" : "pt-2"}>
      <span className="text-sm mr-2"> {prefix->React.string} </span>
      <span className="text-md"> {value->React.string} {suffix} </span>
    </li>
  </OptionallyIntoLink>
}
