open LetOps;
let deployAndSetupStakerToUnitTest =
    (stakerRef, ~functionName, ~contracts, ~accounts) => {
  let%AwaitThen deployedContracts =
    Helpers.inititialize(
      ~admin=accounts.contents->Array.getUnsafe(0),
      ~exposeInternals=true,
    );
  contracts := deployedContracts;
  let {staker} = contracts^;
  stakerRef := staker;
  let%Await _ =
    (stakerRef^)
    ->StakerSmocked.InternalMock.setupFunctionForUnitTesting(~functionName);
  ();
};
