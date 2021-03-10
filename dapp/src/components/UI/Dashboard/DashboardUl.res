@react.component
let make = (~list) =>
  <ul className="p-6 pt-3 pl-10">
    {list
    ->Array.mapWithIndex((index, x: DashboardLi.Props.definition) => {
      <DashboardLi
        key={x.prefix ++ x.value}
        prefix={x.prefix}
        value={x.value}
        suffix={x.suffix}
        first={index == 0}
      />
    })
    ->React.array}
  </ul>
