// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Form from "../Form.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as Login from "../Login/Login.js";
import * as React from "react";
import * as Button from "../UI/Button.js";
import * as Config from "../../Config.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Loader from "../UI/Loader.js";
import * as Ethers$1 from "ethers";
import * as Queries from "../../data/Queries.js";
import * as Contracts from "../../ethereum/Contracts.js";
import * as DataHooks from "../../data/DataHooks.js";
import * as Formality from "re-formality/src/Formality.js";
import * as AmountInput from "../UI/AmountInput.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as RootProvider from "../../libraries/RootProvider.js";
import * as ContractHooks from "../Testing/Admin/ContractHooks.js";
import * as ContractActions from "../../ethereum/ContractActions.js";
import * as Formality__ReactUpdate from "re-formality/src/Formality__ReactUpdate.js";

var validators = {
  amount: {
    strategy: /* OnFirstBlur */0,
    validate: (function (param) {
        return Form.Validators.etherNumberInput(param.amount);
      })
  }
};

function initialFieldsStatuses(_input) {
  return {
          amount: /* Pristine */0
        };
}

function initialState(input) {
  return {
          input: input,
          fieldsStatuses: {
            amount: /* Pristine */0
          },
          collectionsStatuses: undefined,
          formStatus: /* Editing */0,
          submissionStatus: /* NeverSubmitted */0
        };
}

function validateForm(input, validators, fieldsStatuses) {
  var match = fieldsStatuses.amount;
  var match$1 = match ? match._0 : Curry._1(validators.amount.validate, input);
  if (match$1.TAG === /* Ok */0) {
    return {
            TAG: 0,
            output: {
              amount: match$1._0
            },
            fieldsStatuses: {
              amount: {
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
              amount: {
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
              case /* BlurAmountField */0 :
                  var result = Formality.validateFieldOnBlurWithValidator(state.input, state.fieldsStatuses.amount, validators.amount, (function (status) {
                          return {
                                  amount: status
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
              case /* UpdateAmountField */0 :
                  var nextInput = Curry._1(action._0, state.input);
                  return {
                          TAG: 0,
                          _0: {
                            input: nextInput,
                            fieldsStatuses: Formality.validateFieldOnChangeWithValidator(nextInput, state.fieldsStatuses.amount, state.submissionStatus, validators.amount, (function (status) {
                                    return {
                                            amount: status
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
                                amount: /* Pristine */0
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
                                amount: /* Pristine */0
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
          updateAmount: (function (nextInputFn, nextValue) {
              return Curry._1(dispatch, {
                          TAG: 0,
                          _0: (function (__x) {
                              return Curry._2(nextInputFn, __x, nextValue);
                            }),
                          [Symbol.for("name")]: "UpdateAmountField"
                        });
            }),
          blurAmount: (function (param) {
              return Curry._1(dispatch, /* BlurAmountField */0);
            }),
          amountResult: Formality.exposeFieldResult(state.fieldsStatuses.amount),
          input: state.input,
          status: state.formStatus,
          dirty: (function (param) {
              var match = state.fieldsStatuses;
              if (match.amount) {
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

var StakeForm = {
  validators: validators,
  initialFieldsStatuses: initialFieldsStatuses,
  initialCollectionsStatuses: undefined,
  initialState: initialState,
  validateForm: validateForm,
  useForm: useForm
};

var initialInput = {
  amount: ""
};

function useBalanceAndApproved(erc20Address, spender) {
  var match = ContractHooks.useErc20BalanceRefresh(erc20Address);
  var match$1 = ContractHooks.useERC20ApprovedRefresh(erc20Address, spender);
  return [
          match.data,
          match$1.data
        ];
}

function StakeForm$StakeFormInput(Props) {
  var onSubmitOpt = Props.onSubmit;
  var valueOpt = Props.value;
  var optBalanceOpt = Props.optBalance;
  var disabledOpt = Props.disabled;
  var onChangeOpt = Props.onChange;
  var onBlurOpt = Props.onBlur;
  var onMaxClickOpt = Props.onMaxClick;
  var synthetic = Props.synthetic;
  var onSubmit = onSubmitOpt !== undefined ? onSubmitOpt : (function (param) {
        
      });
  var value = valueOpt !== undefined ? valueOpt : "";
  var optBalance = optBalanceOpt !== undefined ? Caml_option.valFromOption(optBalanceOpt) : undefined;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var onChange = onChangeOpt !== undefined ? onChangeOpt : (function (param) {
        
      });
  var onBlur = onBlurOpt !== undefined ? onBlurOpt : (function (param) {
        
      });
  var onMaxClick = onMaxClickOpt !== undefined ? onMaxClickOpt : (function (param) {
        
      });
  return React.createElement(Form.make, {
              className: "",
              onSubmit: onSubmit,
              children: null
            }, React.createElement("div", {
                  className: "px-8 pt-2"
                }, React.createElement("div", {
                      className: "-mb-px flex justify-between"
                    }, React.createElement("div", {
                          className: "no-underline text-teal-dark border-b-2 border-teal-dark tracking-wide font-bold py-3 mr-8",
                          href: "#"
                        }, "Stake ↗️"))), React.createElement(AmountInput.make, {
                  placeholder: "Stake",
                  value: value,
                  optBalance: optBalance,
                  disabled: disabled,
                  onBlur: onBlur,
                  onChange: onChange,
                  onMaxClick: onMaxClick
                }), React.createElement(Button.make, {
                  children: "Stake " + synthetic.tokenType + " " + synthetic.syntheticMarket.name
                }));
}

var StakeFormInput = {
  make: StakeForm$StakeFormInput
};

function StakeForm$ConnectedStakeForm(Props) {
  var tokenId = Props.tokenId;
  var signer = Props.signer;
  var synthetic = Props.synthetic;
  var match = React.useState(function () {
        return function (param) {
          
        };
      });
  var setContractActionToCallAfterApproval = match[1];
  var contractActionToCallAfterApproval = match[0];
  var match$1 = ContractActions.useContractFunction(signer);
  var contractExecutionHandler = match$1[0];
  var match$2 = ContractActions.useContractFunction(signer);
  var setTxStateApprove = match$2[2];
  var txStateApprove = match$2[1];
  var contractExecutionHandlerApprove = match$2[0];
  var stakerContractAddress = Config.useStakerAddress(undefined);
  var user = RootProvider.useCurrentUserExn(undefined);
  var optTokenBalance = DataHooks.Util.graphResponseToOption(DataHooks.useSyntheticTokenBalance(user, synthetic.tokenAddress));
  React.useEffect((function () {
          if (typeof txStateApprove !== "number" && txStateApprove.TAG === /* Complete */2) {
            Curry._1(contractActionToCallAfterApproval, undefined);
            Curry._1(setTxStateApprove, (function (param) {
                    return /* UnInitialised */0;
                  }));
          }
          
        }), [txStateApprove]);
  var form = useForm(initialInput, (function (param, _form) {
          var amount = param.amount;
          var stakeAndEarnImmediatlyFunction = function (param) {
            var arg = Ethers$1.utils.getAddress(tokenId);
            return Curry._2(contractExecutionHandler, (function (param) {
                          return Contracts.Staker.make(stakerContractAddress, param);
                        }), (function (param) {
                          return param.stakeAndEarnImmediately(arg, amount);
                        }));
          };
          Curry._1(setContractActionToCallAfterApproval, (function (param) {
                  return stakeAndEarnImmediatlyFunction;
                }));
          var partial_arg = Ethers$1.utils.getAddress(tokenId);
          var arg = amount.mul(Ethers$1.BigNumber.from("2"));
          return Curry._2(contractExecutionHandlerApprove, (function (param) {
                        return Contracts.Erc20.make(partial_arg, param);
                      }), (function (param) {
                        return param.approve(stakerContractAddress, arg);
                      }));
        }));
  return React.createElement(StakeForm$StakeFormInput, {
              onSubmit: form.submit,
              value: form.input.amount,
              optBalance: optTokenBalance,
              disabled: form.submitting,
              onChange: (function ($$event) {
                  return Curry._2(form.updateAmount, (function (param, amount) {
                                return {
                                        amount: amount
                                      };
                              }), $$event.target.value);
                }),
              onBlur: (function (param) {
                  return Curry._1(form.blurAmount, undefined);
                }),
              onMaxClick: (function (param) {
                  return Curry._2(form.updateAmount, (function (param, amount) {
                                return {
                                        amount: amount
                                      };
                              }), optTokenBalance !== undefined ? Ethers.Utils.formatEther(Caml_option.valFromOption(optTokenBalance)) : "0");
                }),
              synthetic: synthetic
            });
}

var ConnectedStakeForm = {
  make: StakeForm$ConnectedStakeForm
};

function StakeForm$1(Props) {
  var tokenId = Props.tokenId;
  var token = Curry.app(Queries.SyntheticToken.use, [
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
        undefined,
        {
          tokenId: tokenId
        }
      ]);
  var match = React.useState(function () {
        return false;
      });
  var setShowLogin = match[1];
  var optSigner = ContractActions.useSigner(undefined);
  var match$1 = token.data;
  if (token.error !== undefined) {
    console.log("Unable to fetch token");
    return React.createElement(React.Fragment, undefined, "Unable to fetch token");
  }
  if (token.loading) {
    return React.createElement(Loader.make, {});
  }
  if (match$1 === undefined) {
    return React.createElement(React.Fragment, undefined, "Could not find this market - please check the URL carefully.");
  }
  var synthetic = match$1.syntheticToken;
  if (synthetic !== undefined) {
    if (optSigner !== undefined) {
      return React.createElement(StakeForm$ConnectedStakeForm, {
                  tokenId: tokenId,
                  signer: optSigner,
                  synthetic: synthetic
                });
    } else if (match[0]) {
      return React.createElement(Login.make, {});
    } else {
      return React.createElement("div", {
                  onClick: (function (param) {
                      return Curry._1(setShowLogin, (function (param) {
                                    return true;
                                  }));
                    })
                }, React.createElement(StakeForm$StakeFormInput, {
                      disabled: true,
                      synthetic: synthetic
                    }));
    }
  } else {
    return React.createElement(React.Fragment, undefined, "Could not find this market - please check the URL carefully.");
  }
}

var make = StakeForm$1;

export {
  StakeForm ,
  initialInput ,
  useBalanceAndApproved ,
  StakeFormInput ,
  ConnectedStakeForm ,
  make ,
  
}
/* Form Not a pure module */
