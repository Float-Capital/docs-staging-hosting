// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Form = require("./Form.js");
var Curry = require("rescript/lib/js/curry.js");
var Login = require("../pages/Login.js");
var React = require("react");
var Button = require("./UI/Base/Button.js");
var Config = require("../config/Config.js");
var Ethers = require("../ethereum/Ethers.js");
var Loader = require("./UI/Base/Loader.js");
var Queries = require("../data/Queries.js");
var Contracts = require("../ethereum/Contracts.js");
var DataHooks = require("../data/DataHooks.js");
var Formality = require("re-formality/src/Formality.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var AmountInput = require("./UI/Base/AmountInput.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Router = require("next/router");
var RootProvider = require("../libraries/RootProvider.js");
var ModalProvider = require("../libraries/ModalProvider.js");
var ToastProvider = require("./UI/ToastProvider.js");
var ContractActions = require("../ethereum/ContractActions.js");
var MessageUsOnDiscord = require("./Ethereum/MessageUsOnDiscord.js");
var ViewOnBlockExplorer = require("./Ethereum/ViewOnBlockExplorer.js");
var Formality__ReactUpdate = require("re-formality/src/Formality__ReactUpdate.js");

var validators = {
  amount: {
    strategy: /* OnFirstSuccessOrFirstBlur */3,
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

function toNumber(prim) {
  return prim.toNumber();
}

function Unstake$UnstakeTxStatusModal(Props) {
  var txStateUnstake = Props.txStateUnstake;
  var resetFormButton = Props.resetFormButton;
  var match = ModalProvider.useModalDisplay(undefined);
  var hideModal = match.hideModal;
  var showModal = match.showModal;
  React.useEffect((function () {
          if (typeof txStateUnstake === "number") {
            if (txStateUnstake === /* UnInitialised */0) {
              Curry._1(hideModal, undefined);
            } else {
              Curry._1(showModal, React.createElement("div", {
                        className: "text-center m-3"
                      }, React.createElement("p", undefined, "Confirm unstake transaction in your wallet ")));
            }
          } else {
            switch (txStateUnstake.TAG | 0) {
              case /* SignedAndSubmitted */0 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement(Loader.Mini.make, {}), React.createElement("p", undefined, "Unstake transaction pending... "), React.createElement(ViewOnBlockExplorer.make, {
                                txHash: txStateUnstake._0
                              })));
                  break;
              case /* Declined */1 :
                  Curry._1(hideModal, undefined);
                  break;
              case /* Complete */2 :
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("p", undefined, "Transaction complete 🎉"), Curry._1(resetFormButton, undefined)));
                  break;
              case /* Failed */3 :
                  var txHash = txStateUnstake._0;
                  Curry._1(showModal, React.createElement("div", {
                            className: "text-center m-3"
                          }, React.createElement("p", undefined, "The transaction failed."), txHash !== "" ? React.createElement(ViewOnBlockExplorer.make, {
                                  txHash: txHash
                                }) : null, React.createElement(MessageUsOnDiscord.make, {}), Curry._1(resetFormButton, undefined)));
                  break;
              
            }
          }
          
        }), [txStateUnstake]);
  if (typeof txStateUnstake === "number" || txStateUnstake.TAG !== /* Declined */1) {
    return null;
  } else {
    return Curry._1(resetFormButton, undefined);
  }
}

var UnstakeTxStatusModal = {
  make: Unstake$UnstakeTxStatusModal
};

function Unstake$StakeFormInput(Props) {
  var onSubmitOpt = Props.onSubmit;
  var valueOpt = Props.value;
  var optBalanceOpt = Props.optBalance;
  var disabledOpt = Props.disabled;
  var onChangeOpt = Props.onChange;
  var onBlurOpt = Props.onBlur;
  var onMaxClickOpt = Props.onMaxClick;
  var txStateModalOpt = Props.txStateModal;
  var buttonDisabledOpt = Props.buttonDisabled;
  var buttonText = Props.buttonText;
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
  var txStateModal = txStateModalOpt !== undefined ? Caml_option.valFromOption(txStateModalOpt) : null;
  var buttonDisabled = buttonDisabledOpt !== undefined ? buttonDisabledOpt : false;
  return React.createElement(Form.make, {
              className: "",
              onSubmit: onSubmit,
              children: null
            }, React.createElement(AmountInput.make, {
                  value: value,
                  optBalance: optBalance,
                  disabled: disabled,
                  onBlur: onBlur,
                  onChange: onChange,
                  onMaxClick: onMaxClick
                }), React.createElement(Button.make, {
                  onClick: (function (param) {
                      return Curry._1(onSubmit, undefined);
                    }),
                  children: buttonText,
                  disabled: buttonDisabled
                }), txStateModal);
}

var StakeFormInput = {
  make: Unstake$StakeFormInput
};

function Unstake$ConnectedStakeForm(Props) {
  var signer = Props.signer;
  var param = Props.synthetic;
  var match = param.syntheticMarket;
  var marketIndex = match.marketIndex;
  var tokenType = param.tokenType;
  var tokenId = param.id;
  var match$1 = ContractActions.useContractFunction(signer);
  var setTxState = match$1[2];
  var txState = match$1[1];
  var contractExecutionHandler = match$1[0];
  var user = RootProvider.useCurrentUserExn(undefined);
  var optTokenBalance = Belt_Option.flatMap(DataHooks.Util.graphResponseToOption(DataHooks.useStakesForUser(Ethers.Utils.ethAdrToLowerStr(user))), (function (a) {
          return Belt_Option.flatMap(Belt_Array.get(Belt_Array.keep(a, (function (param) {
                                return param.currentStake.syntheticToken.id === tokenId;
                              })), 0), (function (param) {
                        return Caml_option.some(param.currentStake.amount);
                      }));
        }));
  var form = useForm({
        amount: ""
      }, (function (param, _form) {
          var amount = param.amount;
          var arg = marketIndex.toNumber();
          var arg$1 = tokenType === "Long";
          return Curry._2(contractExecutionHandler, (function (param) {
                        return Contracts.Staker.make(Config.staker, param);
                      }), (function (param) {
                        return param.withdraw(arg, arg$1, amount);
                      }));
        }));
  var toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context);
  var router = Router.useRouter();
  var optCurrentUser = RootProvider.useCurrentUser(undefined);
  var userPage = optCurrentUser !== undefined ? "/app/user/" + Ethers.Utils.ethAdrToLowerStr(Caml_option.valFromOption(optCurrentUser)) : "/";
  React.useEffect((function () {
          if (typeof txState === "number") {
            if (txState !== /* UnInitialised */0) {
              Curry._1(toastDispatch, {
                    _0: "Confirm the transaction to unstake",
                    _1: "",
                    _2: /* Info */2,
                    [Symbol.for("name")]: "Show"
                  });
            }
            
          } else {
            switch (txState.TAG | 0) {
              case /* SignedAndSubmitted */0 :
                  Curry._1(toastDispatch, {
                        _0: "Unstake transaction pending",
                        _1: "",
                        _2: /* Info */2,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Declined */1 :
                  Curry._1(toastDispatch, {
                        _0: "The transaction was rejected by your wallet",
                        _1: txState._0,
                        _2: /* Warning */1,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              case /* Complete */2 :
                  Curry._1(toastDispatch, {
                        _0: "Unstake transaction confirmed",
                        _1: "",
                        _2: /* Success */3,
                        [Symbol.for("name")]: "Show"
                      });
                  router.push(userPage);
                  break;
              case /* Failed */3 :
                  Curry._1(toastDispatch, {
                        _0: "The transaction failed",
                        _1: "",
                        _2: /* Error */0,
                        [Symbol.for("name")]: "Show"
                      });
                  break;
              
            }
          }
          
        }), [txState]);
  var resetFormButton = function (param) {
    return React.createElement(Button.make, {
                onClick: (function (param) {
                    Curry._1(form.reset, undefined);
                    return Curry._1(setTxState, (function (param) {
                                  return /* UnInitialised */0;
                                }));
                  }),
                children: "Reset & Unstake Again"
              });
  };
  var match$2 = form.amountResult;
  var formAmount = match$2 !== undefined && match$2.TAG === /* Ok */0 ? Caml_option.some(match$2._0) : undefined;
  var defaultButtonText = "Unstake " + tokenType + " " + match.name;
  var match$3;
  if (formAmount !== undefined && optTokenBalance !== undefined) {
    var greaterThanBalance = Caml_option.valFromOption(formAmount).gt(Caml_option.valFromOption(optTokenBalance));
    match$3 = greaterThanBalance ? [
        "Amount is greater than your balance",
        "Insufficient balance",
        true
      ] : [
        undefined,
        defaultButtonText,
        form.submitting || !Curry._1(form.valid, undefined)
      ];
  } else {
    match$3 = [
      undefined,
      defaultButtonText,
      true
    ];
  }
  return React.createElement(Unstake$StakeFormInput, {
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
              txStateModal: React.createElement(Unstake$UnstakeTxStatusModal, {
                    txStateUnstake: txState,
                    resetFormButton: resetFormButton
                  }),
              buttonDisabled: match$3[2],
              buttonText: match$3[1]
            });
}

var ConnectedStakeForm = {
  make: Unstake$ConnectedStakeForm
};

function Unstake(Props) {
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
    return React.createElement(Loader.Mini.make, {});
  }
  if (match$1 === undefined) {
    return React.createElement(React.Fragment, undefined, "Could not find this market - please check the URL carefully.");
  }
  var synthetic = match$1.syntheticToken;
  if (synthetic !== undefined) {
    if (optSigner !== undefined) {
      return React.createElement(Unstake$ConnectedStakeForm, {
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
                }, React.createElement(Unstake$StakeFormInput, {
                      disabled: true,
                      buttonText: "Unstake " + synthetic.tokenType + " " + synthetic.syntheticMarket.name
                    }));
    }
  } else {
    return React.createElement(React.Fragment, undefined, "Could not find this market - please check the URL carefully.");
  }
}

var make = Unstake;

exports.StakeForm = StakeForm;
exports.toNumber = toNumber;
exports.UnstakeTxStatusModal = UnstakeTxStatusModal;
exports.StakeFormInput = StakeFormInput;
exports.ConnectedStakeForm = ConnectedStakeForm;
exports.make = make;
/* Form Not a pure module */
