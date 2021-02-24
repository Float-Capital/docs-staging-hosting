open Globals

@react.component
let make = () => {
  let user = RootProvider.useCurrentUserExn()
  let userQuery = Queries.UsersState.use({userId: user->ethAdrToStr})

  <div>
    {switch userQuery {
    | {data: Some({user: Some({totalMintedFloat})})} =>
      `you have minted ${totalMintedFloat->FormatMoney.formatEther} FLOAT`->React.string
    | {error: Some(_)} => "Error"->React.string
    | _ => "Loading"->React.string
    }}
  </div>
}
