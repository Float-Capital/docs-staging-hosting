module Props = {

  type definition = {
    prefix: string,
    value: string,
    suffix: React.element
  }

  let createDashboardLiProps = (~suffix=React.null, ~prefix, ~value, ()) => ({
    prefix,
    value,
    suffix
  })

}

@react.component
let make = (~prefix, ~value, ~first, ~suffix) => 
    <li className={first ? "" : "pt-2"}>
        <span className="text-sm mr-2">{prefix->React.string}</span>
        {value->React.string}
        {suffix}
    </li>