// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Form = require("../Form.js");
var Next = require("../../bindings/Next.js");
var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Button = require("../UI/Button.js");
var Config = require("../../Config.js");
var Ethers = require("../../ethereum/Ethers.js");
var Ethers$1 = require("ethers");
var CONSTANTS = require("../../CONSTANTS.js");
var Contracts = require("../../ethereum/Contracts.js");
var DataHooks = require("../../data/DataHooks.js");
var Formality = require("re-formality/src/Formality.js");
var AmountInput = require("../UI/AmountInput.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Router = require("next/router");
var RootProvider = require("../../libraries/RootProvider.js");
var ContractHooks = require("../Testing/Admin/ContractHooks.js");
var ToastProvider = require("../UI/ToastProvider.js");
var ContractActions = require("../../ethereum/ContractActions.js");
var LongOrShortSelect = require("../UI/LongOrShortSelect.js");
var Formality__ReactUpdate = require("re-formality/src/Formality__ReactUpdate.js");
var RedeemSubmitButtonAndTxStatusModal = require("./RedeemSubmitButtonAndTxStatusModal.js");

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

var RedeemForm = {
  validators: validators,
  initialFieldsStatuses: initialFieldsStatuses,
  initialCollectionsStatuses: undefined,
  initialState: initialState,
  validateForm: validateForm,
  useForm: useForm
};

function useBalance(erc20Address) {
  return ContractHooks.useErc20BalanceRefresh(erc20Address).data;
}

function RedeemForm$RedeemFormInput(Props) {
  var onSubmitOpt = Props.onSubmit;
  var valueOpt = Props.value;
  var optBalanceOpt = Props.optBalance;
  var disabledOpt = Props.disabled;
  var onChangeOpt = Props.onChange;
  var onBlurOpt = Props.onBlur;
  var onMaxClickOpt = Props.onMaxClick;
  var onChangeSideOpt = Props.onChangeSide;
  var isLongOpt = Props.isLong;
  var hasBothTokensOpt = Props.hasBothTokens;
  var submitButtonOpt = Props.submitButton;
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
  var onChangeSide = onChangeSideOpt !== undefined ? onChangeSideOpt : (function (param) {
        
      });
  var isLong = isLongOpt !== undefined ? isLongOpt : false;
  var hasBothTokens = hasBothTokensOpt !== undefined ? hasBothTokensOpt : false;
  var submitButton = submitButtonOpt !== undefined ? Caml_option.valFromOption(submitButtonOpt) : null;
  return React.createElement(Form.make, {
              className: "",
              onSubmit: onSubmit,
              children: null
            }, hasBothTokens ? React.createElement(LongOrShortSelect.make, {
                    isLong: isLong,
                    selectPosition: Curry.__1(onChangeSide),
                    disabled: disabled
                  }) : null, React.createElement(AmountInput.make, {
                  placeholder: "Redeem",
                  value: value,
                  optBalance: optBalance,
                  disabled: disabled,
                  onBlur: onBlur,
                  onChange: onChange,
                  onMaxClick: onMaxClick
                }), submitButton);
}

var RedeemFormInput = {
  make: RedeemForm$RedeemFormInput
};

function tokenRedeemPosition(market, isLong, longTokenBalance, shortTokenBalance) {
  var hasLongTokens = longTokenBalance.gt(CONSTANTS.zeroBN);
  var hasShortTokens = shortTokenBalance.gt(CONSTANTS.zeroBN);
  var hasTokens = hasShortTokens || hasLongTokens;
  var hasBothTokens = hasShortTokens && hasLongTokens;
  var match = hasBothTokens ? (
      isLong ? [
          true,
          market.syntheticLong.tokenAddress
        ] : [
          false,
          market.syntheticShort.tokenAddress
        ]
    ) : (
      hasLongTokens ? [
          true,
          market.syntheticLong.tokenAddress
        ] : [
          false,
          market.syntheticShort.tokenAddress
        ]
    );
  return [
          match[0],
          match[1],
          hasTokens,
          hasBothTokens
        ];
}

function isGreaterThanBalance(amount, balance) {
  return amount.gt(balance);
}

function RedeemForm$ConnectedRedeemForm(Props) {
  var signer = Props.signer;
  var market = Props.market;
  var isLong = Props.isLong;
  var router = Router.useRouter();
  var user = RootProvider.useCurrentUserExn(undefined);
  var longTokenBalance = Belt_Option.getWithDefault(DataHooks.Util.graphResponseToOption(DataHooks.useSyntheticTokenBalance(user, market.syntheticLong.tokenAddress)), Ethers$1.BigNumber.from("0"));
  var shortTokenBalance = Belt_Option.getWithDefault(DataHooks.Util.graphResponseToOption(DataHooks.useSyntheticTokenBalance(user, market.syntheticShort.tokenAddress)), Ethers$1.BigNumber.from("0"));
  var match = tokenRedeemPosition(market, isLong, longTokenBalance, shortTokenBalance);
  var isActuallyLong = match[0];
  var match$1 = ContractActions.useContractFunction(signer);
  var setTxState = match$1[2];
  var txState = match$1[1];
  var contractExecutionHandler = match$1[0];
  var marketIndex = market.marketIndex;
  var match$2 = ContractHooks.useErc20BalanceRefresh(match[1]);
  var optTokenBalance = match$2.data;
  var form = useForm({
        amount: ""
      }, (function (param, _form) {
          var amount = param.amount;
          return Curry._2(contractExecutionHandler, (function (param) {
                        return Contracts.LongShort.make(Config.longShort, param);
                      }), isActuallyLong ? (function (param) {
                          return param.redeemLong(marketIndex, amount);
                        }) : (function (param) {
                          return param.redeemShort(marketIndex, amount);
                        }));
        }));
  var toastDispatch = React.useContext(ToastProvider.DispatchToastContext.context);
  var resetFormButton = function (param) {
    return React.createElement(Button.make, {
                onClick: (function (param) {
                    Curry._1(form.reset, undefined);
                    return Curry._1(setTxState, (function (param) {
                                  return /* UnInitialised */0;
                                }));
                  }),
                children: "Reset & Redeem Again"
              });
  };
  var match$3 = form.amountResult;
  var formAmount = match$3 !== undefined && match$3.TAG === /* Ok */0 ? Caml_option.some(match$3._0) : undefined;
  var position = isLong ? "long" : "short";
  var match$4;
  var exit = 0;
  if (formAmount !== undefined && optTokenBalance !== undefined) {
    var greaterThanBalance = Caml_option.valFromOption(formAmount).gt(Caml_option.valFromOption(optTokenBalance));
    match$4 = greaterThanBalance ? [
        "Amount is greater than your balance",
        "Insufficient balance",
        true
      ] : [
        undefined,
        "Redeem " + position + " " + market.name,
        !Curry._1(form.valid, undefined)
      ];
  } else {
    exit = 1;
  }
  if (exit === 1) {
    match$4 = [
      undefined,
      "Redeem " + position + " " + market.name,
      true
    ];
  }
  React.useEffect((function () {
          if (typeof txState === "number") {
            if (txState !== /* UnInitialised */0) {
              Curry._1(toastDispatch, {
                    _0: "Confirm the transaction to redeem tokens",
                    _1: "",
                    _2: /* Info */2,
                    [Symbol.for("name")]: "Show"
                  });
            }
            
          } else {
            switch (txState.TAG | 0) {
              case /* SignedAndSubmitted */0 :
                  Curry._1(toastDispatch, {
                        _0: "Redeem transaction pending",
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
                        _0: "Redeem transaction confirmed",
                        _1: "",
                        _2: /* Success */3,
                        [Symbol.for("name")]: "Show"
                      });
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
  if (match[2]) {
    return React.createElement(RedeemForm$RedeemFormInput, {
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
                onChangeSide: (function (newPosition) {
                    router.query["actionOption"] = newPosition;
                    router.query["token"] = isActuallyLong ? Ethers.Utils.ethAdrToLowerStr(market.syntheticLong.tokenAddress) : Ethers.Utils.ethAdrToLowerStr(market.syntheticShort.tokenAddress);
                    return Next.Router.pushObjShallow(router, {
                                pathname: router.pathname,
                                query: router.query
                              });
                  }),
                isLong: isActuallyLong,
                hasBothTokens: match[3],
                submitButton: React.createElement(RedeemSubmitButtonAndTxStatusModal.make, {
                      txStateRedeem: txState,
                      resetFormButton: resetFormButton,
                      buttonText: match$4[1],
                      buttonDisabled: match$4[2]
                    })
              });
  } else {
    return React.createElement("p", undefined, "No tokens in this market to redeem");
  }
}

var ConnectedRedeemForm = {
  make: RedeemForm$ConnectedRedeemForm
};

function RedeemForm$1(Props) {
  var market = Props.market;
  var isLong = Props.isLong;
  var optSigner = ContractActions.useSigner(undefined);
  var router = Router.useRouter();
  if (optSigner !== undefined) {
    return React.createElement(RedeemForm$ConnectedRedeemForm, {
                signer: optSigner,
                market: market,
                isLong: isLong
              });
  } else {
    return React.createElement("div", {
                onClick: (function (param) {
                    router.push("/login?nextPath=" + router.asPath);
                    
                  })
              }, React.createElement(RedeemForm$RedeemFormInput, {
                    isLong: isLong,
                    hasBothTokens: false
                  }));
  }
}

var make = RedeemForm$1;

exports.RedeemForm = RedeemForm;
exports.useBalance = useBalance;
exports.RedeemFormInput = RedeemFormInput;
exports.tokenRedeemPosition = tokenRedeemPosition;
exports.isGreaterThanBalance = isGreaterThanBalance;
exports.ConnectedRedeemForm = ConnectedRedeemForm;
exports.make = make;
/* Form Not a pure module */
