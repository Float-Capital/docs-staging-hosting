@react.component
let make = (~list, ~link=?) => {
  let content =
    <ul className="p-6 py-4 pl-10">
      {list
      ->Array.mapWithIndex((index, {prefix, suffix, value}: DashboardLi.Props.definition) => {
        <DashboardLi
          key={prefix ++ index->Js.String2.make} prefix value suffix first={index == 0}
        />
      })
      ->React.array}
    </ul>

  link->Option.mapWithDefault(content, linkStr =>
    <a href={linkStr} target="_" rel="noopener noreferrer"> {content} </a>
  )
}
