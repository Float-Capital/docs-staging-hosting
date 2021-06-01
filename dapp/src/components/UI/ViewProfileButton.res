@react.component
let make = () => {
  let optCurrentUser = RootProvider.useCurrentUser()

  let userPage = switch optCurrentUser {
  | Some(address) => `/user/${address->Ethers.Utils.ethAdrToLowerStr}`
  | None => `/`
  }

  <Next.Link href={userPage}>
    <button
      className="w-44 h-12 text-sm my-2 shadow-md rounded-lg border-2 focus:outline-none border-gray-200 hover:bg-gray-200 flex justify-center items-center mx-auto">
      <span className="mx-2"> {"View Profile"->React.string} </span>
    </button>
  </Next.Link>
}
