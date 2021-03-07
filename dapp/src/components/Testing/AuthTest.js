// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Form from "./Admin/Form.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Client from "../../data/Client.js";
import * as Globals from "../../libraries/Globals.js";
import * as DbQueries from "../../data/DbQueries.js";
import * as Formality from "re-formality/src/Formality.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as RootProvider from "../../libraries/RootProvider.js";
import * as ContractActions from "../../ethereum/ContractActions.js";
import * as Formality__ReactUpdate from "re-formality/src/Formality__ReactUpdate.js";

var validators = {
  username: {
    strategy: /* OnFirstBlur */0,
    validate: (function (param) {
        var username = param.username;
        if (username.length > 0) {
          return {
                  TAG: 0,
                  _0: username,
                  [Symbol.for("name")]: "Ok"
                };
        } else {
          return {
                  TAG: 1,
                  _0: "Username must have a length greater than zero!",
                  [Symbol.for("name")]: "Error"
                };
        }
      })
  }
};

function initialFieldsStatuses(_input) {
  return {
          username: /* Pristine */0
        };
}

function initialState(input) {
  return {
          input: input,
          fieldsStatuses: {
            username: /* Pristine */0
          },
          collectionsStatuses: undefined,
          formStatus: /* Editing */0,
          submissionStatus: /* NeverSubmitted */0
        };
}

function validateForm(input, validators, fieldsStatuses) {
  var match = fieldsStatuses.username;
  var match$1 = match ? match._0 : Curry._1(validators.username.validate, input);
  if (match$1.TAG === /* Ok */0) {
    return {
            TAG: 0,
            output: {
              username: match$1._0
            },
            fieldsStatuses: {
              username: {
                _0: match$1,
                _1: /* Shown */0,
                [Symbol.for("name")]: "Dirty"
              }
            },
            collectionsStatuses: undefined,
            [Symbol.for("name")]: "Valid"
          };
  } else {
    return {
            TAG: 1,
            fieldsStatuses: {
              username: {
                _0: match$1,
                _1: /* Shown */0,
                [Symbol.for("name")]: "Dirty"
              }
            },
            collectionsStatuses: undefined,
            [Symbol.for("name")]: "Invalid"
          };
  }
}

function useForm(initialInput, onSubmit) {
  var memoizedInitialState = React.useMemo((function () {
          return initialState(initialInput);
        }), [initialInput]);
  var match = Formality__ReactUpdate.useReducer(memoizedInitialState, (function (state, action) {
          if (typeof action === "number") {
            switch (action) {
              case /* BlurUsernameField */0 :
                  var result = Formality.validateFieldOnBlurWithValidator(state.input, state.fieldsStatuses.username, validators.username, (function (status) {
                          return {
                                  username: status
                                };
                        }));
                  if (result !== undefined) {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: result,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: state.formStatus,
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  } else {
                    return /* NoUpdate */0;
                  }
              case /* Submit */1 :
                  var match = state.formStatus;
                  if (typeof match !== "number" && match.TAG === /* Submitting */0) {
                    return /* NoUpdate */0;
                  }
                  var match$1 = validateForm(state.input, validators, state.fieldsStatuses);
                  if (match$1.TAG !== /* Valid */0) {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: match$1.fieldsStatuses,
                              collectionsStatuses: match$1.collectionsStatuses,
                              formStatus: /* Editing */0,
                              submissionStatus: /* AttemptedToSubmit */1
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  }
                  var output = match$1.output;
                  var error = state.formStatus;
                  var tmp;
                  tmp = typeof error === "number" || error.TAG !== /* SubmissionFailed */1 ? undefined : Caml_option.some(error._0);
                  return {
                          TAG: 1,
                          _0: {
                            input: state.input,
                            fieldsStatuses: match$1.fieldsStatuses,
                            collectionsStatuses: match$1.collectionsStatuses,
                            formStatus: {
                              TAG: 0,
                              _0: tmp,
                              [Symbol.for("name")]: "Submitting"
                            },
                            submissionStatus: /* AttemptedToSubmit */1
                          },
                          _1: (function (param) {
                              var dispatch = param.dispatch;
                              return Curry._2(onSubmit, output, {
                                          notifyOnSuccess: (function (input) {
                                              return Curry._1(dispatch, {
                                                          TAG: 1,
                                                          _0: input,
                                                          [Symbol.for("name")]: "SetSubmittedStatus"
                                                        });
                                            }),
                                          notifyOnFailure: (function (error) {
                                              return Curry._1(dispatch, {
                                                          TAG: 2,
                                                          _0: error,
                                                          [Symbol.for("name")]: "SetSubmissionFailedStatus"
                                                        });
                                            }),
                                          reset: (function (param) {
                                              return Curry._1(dispatch, /* Reset */4);
                                            }),
                                          dismissSubmissionResult: (function (param) {
                                              return Curry._1(dispatch, /* DismissSubmissionResult */3);
                                            })
                                        });
                            }),
                          [Symbol.for("name")]: "UpdateWithSideEffects"
                        };
                  break;
              case /* DismissSubmissionError */2 :
                  var match$2 = state.formStatus;
                  if (typeof match$2 === "number" || match$2.TAG !== /* SubmissionFailed */1) {
                    return /* NoUpdate */0;
                  } else {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: state.fieldsStatuses,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: /* Editing */0,
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  }
              case /* DismissSubmissionResult */3 :
                  var match$3 = state.formStatus;
                  if (typeof match$3 === "number") {
                    if (match$3 === /* Editing */0) {
                      return /* NoUpdate */0;
                    }
                    
                  } else if (match$3.TAG === /* Submitting */0) {
                    return /* NoUpdate */0;
                  }
                  return {
                          TAG: 0,
                          _0: {
                            input: state.input,
                            fieldsStatuses: state.fieldsStatuses,
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: /* Editing */0,
                            submissionStatus: state.submissionStatus
                          },
                          [Symbol.for("name")]: "Update"
                        };
              case /* Reset */4 :
                  return {
                          TAG: 0,
                          _0: initialState(initialInput),
                          [Symbol.for("name")]: "Update"
                        };
              
            }
          } else {
            switch (action.TAG | 0) {
              case /* UpdateUsernameField */0 :
                  var nextInput = Curry._1(action._0, state.input);
                  return {
                          TAG: 0,
                          _0: {
                            input: nextInput,
                            fieldsStatuses: Formality.validateFieldOnChangeWithValidator(nextInput, state.fieldsStatuses.username, state.submissionStatus, validators.username, (function (status) {
                                    return {
                                            username: status
                                          };
                                  })),
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: state.formStatus,
                            submissionStatus: state.submissionStatus
                          },
                          [Symbol.for("name")]: "Update"
                        };
              case /* SetSubmittedStatus */1 :
                  var input = action._0;
                  if (input !== undefined) {
                    return {
                            TAG: 0,
                            _0: {
                              input: input,
                              fieldsStatuses: {
                                username: /* Pristine */0
                              },
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: /* Submitted */1,
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  } else {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: {
                                username: /* Pristine */0
                              },
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: /* Submitted */1,
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  }
              case /* SetSubmissionFailedStatus */2 :
                  return {
                          TAG: 0,
                          _0: {
                            input: state.input,
                            fieldsStatuses: state.fieldsStatuses,
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: {
                              TAG: 1,
                              _0: action._0,
                              [Symbol.for("name")]: "SubmissionFailed"
                            },
                            submissionStatus: state.submissionStatus
                          },
                          [Symbol.for("name")]: "Update"
                        };
              case /* MapSubmissionError */3 :
                  var map = action._0;
                  var error$1 = state.formStatus;
                  if (typeof error$1 === "number") {
                    return /* NoUpdate */0;
                  }
                  if (error$1.TAG !== /* Submitting */0) {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: state.fieldsStatuses,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: {
                                TAG: 1,
                                _0: Curry._1(map, error$1._0),
                                [Symbol.for("name")]: "SubmissionFailed"
                              },
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  }
                  var error$2 = error$1._0;
                  if (error$2 !== undefined) {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: state.fieldsStatuses,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: {
                                TAG: 0,
                                _0: Caml_option.some(Curry._1(map, Caml_option.valFromOption(error$2))),
                                [Symbol.for("name")]: "Submitting"
                              },
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  } else {
                    return /* NoUpdate */0;
                  }
              
            }
          }
        }));
  var dispatch = match[1];
  var state = match[0];
  var match$1 = state.formStatus;
  var tmp;
  tmp = typeof match$1 === "number" || match$1.TAG !== /* Submitting */0 ? false : true;
  return {
          updateUsername: (function (nextInputFn, nextValue) {
              return Curry._1(dispatch, {
                          TAG: 0,
                          _0: (function (__x) {
                              return Curry._2(nextInputFn, __x, nextValue);
                            }),
                          [Symbol.for("name")]: "UpdateUsernameField"
                        });
            }),
          blurUsername: (function (param) {
              return Curry._1(dispatch, /* BlurUsernameField */0);
            }),
          usernameResult: Formality.exposeFieldResult(state.fieldsStatuses.username),
          input: state.input,
          status: state.formStatus,
          dirty: (function (param) {
              var match = state.fieldsStatuses;
              if (match.username) {
                return true;
              } else {
                return false;
              }
            }),
          valid: (function (param) {
              var match = validateForm(state.input, validators, state.fieldsStatuses);
              if (match.TAG === /* Valid */0) {
                return true;
              } else {
                return false;
              }
            }),
          submitting: tmp,
          submit: (function (param) {
              return Curry._1(dispatch, /* Submit */1);
            }),
          dismissSubmissionError: (function (param) {
              return Curry._1(dispatch, /* DismissSubmissionError */2);
            }),
          dismissSubmissionResult: (function (param) {
              return Curry._1(dispatch, /* DismissSubmissionResult */3);
            }),
          mapSubmissionError: (function (map) {
              return Curry._1(dispatch, {
                          TAG: 3,
                          _0: map,
                          [Symbol.for("name")]: "MapSubmissionError"
                        });
            }),
          reset: (function (param) {
              return Curry._1(dispatch, /* Reset */4);
            })
        };
}

var ChangeUsernameForm = {
  validators: validators,
  initialFieldsStatuses: initialFieldsStatuses,
  initialCollectionsStatuses: undefined,
  initialState: initialState,
  validateForm: validateForm,
  useForm: useForm
};

function AuthTest(Props) {
  var signer = ContractActions.useSignerExn(undefined);
  var userAddress = RootProvider.useCurrentUserExn(undefined);
  var userQuery = Curry.app(DbQueries.GetUser.use, [
        undefined,
        Caml_option.some(Client.createContext(/* DB */1)),
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        {
          userAddress: Globals.ethAdrToLowerStr(userAddress)
        }
      ]);
  var fetchUserDetails = userQuery.fetchMore;
  var match = React.useState(function () {
        return Client.getAuthHeaders(Caml_option.some(userAddress)) !== undefined;
      });
  var setHaveLocalSignInDetails = match[1];
  var match$1 = Curry.app(DbQueries.CreateUser.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined
      ]);
  var createProfileMutateResult = match$1[1];
  var createProfileMutate = match$1[0];
  var match$2 = Curry.app(DbQueries.UpdateUser.use, [
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined
      ]);
  var updateUsernameMutateResult = match$2[1];
  var updateUsernameMutate = match$2[0];
  React.useEffect((function () {
          var match = createProfileMutateResult.data;
          if (match !== undefined) {
            var match$1 = match.createUser;
            if (match$1 !== undefined && match$1.success) {
              Curry._1(setHaveLocalSignInDetails, (function (param) {
                      return true;
                    }));
              Curry._5(fetchUserDetails, undefined, undefined, undefined, undefined, undefined);
            }
            
          }
          
        }), [createProfileMutateResult]);
  React.useEffect((function () {
          var match = updateUsernameMutateResult.data;
          if (match !== undefined && match.update_user !== undefined) {
            Curry._5(fetchUserDetails, undefined, undefined, undefined, undefined, undefined);
          }
          
        }), [updateUsernameMutateResult]);
  var form = useForm({
        username: ""
      }, (function (param, _form) {
          Curry._8(updateUsernameMutate, undefined, Caml_option.some(Client.createContext(/* DB */1)), undefined, undefined, undefined, undefined, undefined, {
                userName: param.username,
                userAddress: Globals.ethAdrToLowerStr(userAddress)
              });
          
        }));
  var match$3 = userQuery.data;
  var tmp;
  if (match$3 !== undefined) {
    var userArray = match$3.user;
    var exit = 0;
    if (match[0] && userArray.length !== 0) {
      var match$4 = Belt_Array.get(userArray, 0);
      var tmp$1;
      if (match$4 !== undefined) {
        var u = match$4.userName;
        tmp$1 = u !== undefined ? React.createElement("div", undefined, "Your username is " + u) : React.createElement("div", undefined, "You have no username!");
      } else {
        tmp$1 = "ERROR";
      }
      var match$5 = form.usernameResult;
      var tmp$2;
      tmp$2 = match$5 !== undefined && match$5.TAG !== /* Ok */0 ? React.createElement("div", {
              className: "text-red-600"
            }, match$5._0) : null;
      tmp = React.createElement("div", undefined, "You are signed in!", tmp$1, React.createElement(Form.make, {
                className: "",
                onSubmit: (function (param) {
                    return Curry._1(form.submit, undefined);
                  }),
                children: null
              }, React.createElement("input", {
                    className: "border-2 border-grey-500",
                    id: "amount",
                    disabled: form.submitting,
                    placeholder: "Username",
                    type: "text",
                    value: form.input.username,
                    onChange: (function ($$event) {
                        return Curry._2(form.updateUsername, (function (param, username) {
                                      return {
                                              username: username
                                            };
                                    }), $$event.target.value);
                      })
                  }), tmp$2, React.createElement("button", {
                    className: "bg-green-500 rounded-lg my-2 block"
                  }, "Change Username")));
    } else {
      exit = 1;
    }
    if (exit === 1) {
      tmp = React.createElement("button", {
            className: "bg-green-500 rounded-lg my-2",
            onClick: (function (param) {
                var uAS = Globals.ethAdrToStr(userAddress);
                signer.signMessage("float.capital-signin-string:" + uAS).then(function (result) {
                      Client.setSignInData(Globals.ethAdrToLowerStr(userAddress), String(result));
                      if (userArray.length !== 0) {
                        return Curry._1(setHaveLocalSignInDetails, (function (param) {
                                      return true;
                                    }));
                      } else {
                        Curry._8(createProfileMutate, undefined, Caml_option.some(Client.createContext(/* DB */1)), undefined, undefined, undefined, undefined, undefined, {
                              userName: undefined
                            });
                        return ;
                      }
                    });
                
              })
          }, "Sign In");
    }
    
  } else {
    tmp = userQuery.error !== undefined ? "Error" : "Loading";
  }
  return React.createElement(React.Fragment, undefined, React.createElement("hr", undefined), tmp);
}

var make = AuthTest;

export {
  ChangeUsernameForm ,
  make ,
  
}
/* Form Not a pure module */
