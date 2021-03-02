open Globals

module ChangeUsernameForm = %form(
  type input = {username: string}
  type output = {username: string }
  let validators = {
    username: {
      strategy: OnFirstBlur,
      validate: ({username}) => {
        if(username->Js.String.length>0){
          username->Ok
        }else{
          Error("Username must have a length greater than zero!")
        }
      },
    },
  }
)


@react.component
let make = () => {
  let signer = ContractActions.useSignerExn()
  let userAddress = RootProvider.useCurrentUserExn()

  let userQuery = DbQueries.GetUser.use(
    ~context=Client.createContext(Client.DB), 
    {userAddress: Some(userAddress->ethAdrToLowerStr)}
  )

  let { fetchMore: fetchUserDetails } = userQuery;

  let (haveLocalSignInDetails, setHaveLocalSignInDetails) = React.useState(() =>Client.getAuthHeaders(~user=Some(userAddress)) != None)

  let (createProfileMutate, createProfileMutateResult) = DbQueries.CreateUser.use()

  let (updateUsernameMutate, updateUsernameMutateResult) = DbQueries.UpdateUser.use()

  React.useEffect1(() => {
    switch(createProfileMutateResult){
    | ({data: Some({createUser: Some({success: true})})}) => {
      setHaveLocalSignInDetails(_ => true)
      let _ = fetchUserDetails()
    }
    | _ => ()
    }
    None
  },
  [createProfileMutateResult])

  React.useEffect1(() => {
    switch(updateUsernameMutateResult){
    | ({data: Some({update_user: Some({returning: _})})}) => let _ = fetchUserDetails()
    | _ => ()
    }
    None
  },
  [updateUsernameMutateResult])

  let form = ChangeUsernameForm.useForm(~initialInput={username:""},~onSubmit=({username}, _form)=>{
    let _ = updateUsernameMutate(~context=Client.createContext(Client.DB), {
      userAddress: userAddress->ethAdrToLowerStr,
      userName: username
    })
  })


  <>
    <hr/>
    {switch (userQuery, haveLocalSignInDetails) {
    | ({ data: Some({user: userArray})}, true) when userArray->Array.length > 0 => {
      <div>
        {"You are signed in!"->React.string}
        { switch(
          userArray[0]
        ){
          | Some({ userName : None }) => {
            <div>
              {`You have no username!`->React.string}
            </div>
          }
          | Some({ userName: Some(u)}) => {
            <div>
              {`Your username is ${u}`->React.string}
            </div>
          }
          | _ => "ERROR"->React.string
        }
        }
        <Form
        className=""
        onSubmit={() => {
          form.submit()
        }}>
        <input 
          id="amount"
          value={form.input.username}
          disabled=form.submitting
          onChange={event => form.updateUsername((_, username) => {
              username,
          }, (event->ReactEvent.Form.target)["value"])}
          className="border-2 border-grey-500"
          placeholder={"Username"}
          type_="text"/>
          {switch form.usernameResult {
          | Some(Error(message)) => <div className="text-red-600"> {message->React.string} </div>
          | _ => React.null
          }}
        <button className="bg-green-500 rounded-lg my-2 block">
          {"Change Username"->React.string}
        </button>
        </Form>
      </div>
      }
    | ({ data: Some({user: userArray})}, _) => {
      <button className="bg-green-500 rounded-lg my-2"
        onClick={_ => {
          let uAS = userAddress->ethAdrToStr
          let _ = Ethers.Wallet.signMessage(
            signer,
            `float.capital-signin-string:${uAS}`,
          )->JsPromise.map(result => {
            Client.setSignInData(~ethAddress=userAddress->ethAdrToLowerStr, ~ethSignature=result->Js.String2.make)
            if(userArray->Array.length > 0){
              setHaveLocalSignInDetails((_) => true)
            }else{
              // create profile
              let _ = createProfileMutate(
              ~context=Client.createContext(Client.DB),
              {userName: None})
            }
          })
        }}>
        {"Sign In"->React.string}
      </button>
      }
    | ({error: Some(_)}, _) => "Error"->React.string
    | (_,_) => "Loading"->React.string
    }}
  </>
}

