module OptionallyIntoLink = DashboardLi.OptionallyIntoLink

@react.component
let make = (~list, ~link=?) => {
  let content =
    <OptionallyIntoLink link>
      <ul className="p-6 pt-3 pl-10">
        {list
        ->Array.mapWithIndex((
          index,
          {prefix, suffix, value, link: liLink}: DashboardLi.Props.definition,
        ) => {
          <DashboardLi
            key={prefix ++ index->Js.String2.make}
            link={liLink}
            prefix
            value
            suffix
            first={index == 0}
          />
        })
        ->React.array}
      </ul>
    </OptionallyIntoLink>

  link->Option.mapWithDefault(content, linkStr => <a href={linkStr} target="_blank"> {content} </a>)
}
