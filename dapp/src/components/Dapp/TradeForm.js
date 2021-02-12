// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Form from "../Admin/Form.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../../Config.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Loader from "../UI/Loader.js";
import * as Contracts from "../../ethereum/Contracts.js";
import * as Formality from "re-formality/src/Formality.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as RootProvider from "../../libraries/RootProvider.js";
import * as ContractHooks from "../Admin/ContractHooks.js";
import * as ContractActions from "../../ethereum/ContractActions.js";
import * as Formality__ReactUpdate from "re-formality/src/Formality__ReactUpdate.js";

var validators_isLong = {
  strategy: /* OnFirstChange */1,
  validate: (function (param) {
      return {
              TAG: 0,
              _0: param.isLong,
              [Symbol.for("name")]: "Ok"
            };
    })
};

var validators_isMint = {
  strategy: /* OnFirstChange */1,
  validate: (function (param) {
      return {
              TAG: 0,
              _0: param.isMint,
              [Symbol.for("name")]: "Ok"
            };
    })
};

var validators_amount = {
  strategy: /* OnFirstBlur */0,
  validate: (function (param) {
      var amount = param.amount;
      var amountRegex = /^[+]?\d+(\.\d+)?$/;
      if (amount === "") {
        return {
                TAG: 1,
                _0: "Amount is required",
                [Symbol.for("name")]: "Error"
              };
      } else if (amountRegex.test(amount)) {
        return Belt_Option.mapWithDefault(Ethers.Utils.parseEther(amount), {
                    TAG: 1,
                    _0: "Couldn't parse Ether value",
                    [Symbol.for("name")]: "Error"
                  }, (function (etherValue) {
                      return {
                              TAG: 0,
                              _0: etherValue,
                              [Symbol.for("name")]: "Ok"
                            };
                    }));
      } else {
        return {
                TAG: 1,
                _0: "Incorrect number format - please use '.' for floating points.",
                [Symbol.for("name")]: "Error"
              };
      }
    })
};

var validators = {
  isLong: validators_isLong,
  isMint: validators_isMint,
  amount: validators_amount
};

function initialFieldsStatuses(_input) {
  return {
          isLong: /* Pristine */0,
          isMint: /* Pristine */0,
          amount: /* Pristine */0
        };
}

function initialState(input) {
  return {
          input: input,
          fieldsStatuses: {
            isLong: /* Pristine */0,
            isMint: /* Pristine */0,
            amount: /* Pristine */0
          },
          collectionsStatuses: undefined,
          formStatus: /* Editing */0,
          submissionStatus: /* NeverSubmitted */0
        };
}

function validateForm(input, validators, fieldsStatuses) {
  var match = fieldsStatuses.isLong;
  var match_0 = match ? match._0 : Curry._1(validators.isLong.validate, input);
  var match$1 = fieldsStatuses.isMint;
  var match_0$1 = match$1 ? match$1._0 : Curry._1(validators.isMint.validate, input);
  var match$2 = fieldsStatuses.amount;
  var match_0$2 = match$2 ? match$2._0 : Curry._1(validators.amount.validate, input);
  var isLongResult = match_0;
  var isLongResult$1;
  if (isLongResult.TAG === /* Ok */0) {
    var isMintResult = match_0$1;
    if (isMintResult.TAG === /* Ok */0) {
      var amountResult = match_0$2;
      if (amountResult.TAG === /* Ok */0) {
        return {
                TAG: 0,
                output: {
                  amount: amountResult._0,
                  isMint: isMintResult._0,
                  isLong: isLongResult._0
                },
                fieldsStatuses: {
                  isLong: {
                    _0: isLongResult,
                    _1: /* Shown */0,
                    [Symbol.for("name")]: "Dirty"
                  },
                  isMint: {
                    _0: isMintResult,
                    _1: /* Shown */0,
                    [Symbol.for("name")]: "Dirty"
                  },
                  amount: {
                    _0: amountResult,
                    _1: /* Shown */0,
                    [Symbol.for("name")]: "Dirty"
                  }
                },
                collectionsStatuses: undefined,
                [Symbol.for("name")]: "Valid"
              };
      }
      isLongResult$1 = isLongResult;
    } else {
      isLongResult$1 = isLongResult;
    }
  } else {
    isLongResult$1 = isLongResult;
  }
  return {
          TAG: 1,
          fieldsStatuses: {
            isLong: {
              _0: isLongResult$1,
              _1: /* Shown */0,
              [Symbol.for("name")]: "Dirty"
            },
            isMint: {
              _0: match_0$1,
              _1: /* Shown */0,
              [Symbol.for("name")]: "Dirty"
            },
            amount: {
              _0: match_0$2,
              _1: /* Shown */0,
              [Symbol.for("name")]: "Dirty"
            }
          },
          collectionsStatuses: undefined,
          [Symbol.for("name")]: "Invalid"
        };
}

function useForm(initialInput, onSubmit) {
  var memoizedInitialState = React.useMemo((function () {
          return initialState(initialInput);
        }), [initialInput]);
  var match = Formality__ReactUpdate.useReducer(memoizedInitialState, (function (state, action) {
          if (typeof action === "number") {
            switch (action) {
              case /* BlurIsLongField */0 :
                  var result = Formality.validateFieldOnBlurWithValidator(state.input, state.fieldsStatuses.isLong, validators_isLong, (function (status) {
                          var init = state.fieldsStatuses;
                          return {
                                  isLong: status,
                                  isMint: init.isMint,
                                  amount: init.amount
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
              case /* BlurIsMintField */1 :
                  var result$1 = Formality.validateFieldOnBlurWithValidator(state.input, state.fieldsStatuses.isMint, validators_isMint, (function (status) {
                          var init = state.fieldsStatuses;
                          return {
                                  isLong: init.isLong,
                                  isMint: status,
                                  amount: init.amount
                                };
                        }));
                  if (result$1 !== undefined) {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: result$1,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: state.formStatus,
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  } else {
                    return /* NoUpdate */0;
                  }
              case /* BlurAmountField */2 :
                  var result$2 = Formality.validateFieldOnBlurWithValidator(state.input, state.fieldsStatuses.amount, validators_amount, (function (status) {
                          var init = state.fieldsStatuses;
                          return {
                                  isLong: init.isLong,
                                  isMint: init.isMint,
                                  amount: status
                                };
                        }));
                  if (result$2 !== undefined) {
                    return {
                            TAG: 0,
                            _0: {
                              input: state.input,
                              fieldsStatuses: result$2,
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: state.formStatus,
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  } else {
                    return /* NoUpdate */0;
                  }
              case /* Submit */3 :
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
                                                          TAG: 3,
                                                          _0: input,
                                                          [Symbol.for("name")]: "SetSubmittedStatus"
                                                        });
                                            }),
                                          notifyOnFailure: (function (error) {
                                              return Curry._1(dispatch, {
                                                          TAG: 4,
                                                          _0: error,
                                                          [Symbol.for("name")]: "SetSubmissionFailedStatus"
                                                        });
                                            }),
                                          reset: (function (param) {
                                              return Curry._1(dispatch, /* Reset */6);
                                            }),
                                          dismissSubmissionResult: (function (param) {
                                              return Curry._1(dispatch, /* DismissSubmissionResult */5);
                                            })
                                        });
                            }),
                          [Symbol.for("name")]: "UpdateWithSideEffects"
                        };
                  break;
              case /* DismissSubmissionError */4 :
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
              case /* DismissSubmissionResult */5 :
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
              case /* Reset */6 :
                  return {
                          TAG: 0,
                          _0: initialState(initialInput),
                          [Symbol.for("name")]: "Update"
                        };
              
            }
          } else {
            switch (action.TAG | 0) {
              case /* UpdateIsLongField */0 :
                  var nextInput = Curry._1(action._0, state.input);
                  return {
                          TAG: 0,
                          _0: {
                            input: nextInput,
                            fieldsStatuses: Formality.validateFieldOnChangeWithValidator(nextInput, state.fieldsStatuses.isLong, state.submissionStatus, validators_isLong, (function (status) {
                                    var init = state.fieldsStatuses;
                                    return {
                                            isLong: status,
                                            isMint: init.isMint,
                                            amount: init.amount
                                          };
                                  })),
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: state.formStatus,
                            submissionStatus: state.submissionStatus
                          },
                          [Symbol.for("name")]: "Update"
                        };
              case /* UpdateIsMintField */1 :
                  var nextInput$1 = Curry._1(action._0, state.input);
                  return {
                          TAG: 0,
                          _0: {
                            input: nextInput$1,
                            fieldsStatuses: Formality.validateFieldOnChangeWithValidator(nextInput$1, state.fieldsStatuses.isMint, state.submissionStatus, validators_isMint, (function (status) {
                                    var init = state.fieldsStatuses;
                                    return {
                                            isLong: init.isLong,
                                            isMint: status,
                                            amount: init.amount
                                          };
                                  })),
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: state.formStatus,
                            submissionStatus: state.submissionStatus
                          },
                          [Symbol.for("name")]: "Update"
                        };
              case /* UpdateAmountField */2 :
                  var nextInput$2 = Curry._1(action._0, state.input);
                  return {
                          TAG: 0,
                          _0: {
                            input: nextInput$2,
                            fieldsStatuses: Formality.validateFieldOnChangeWithValidator(nextInput$2, state.fieldsStatuses.amount, state.submissionStatus, validators_amount, (function (status) {
                                    var init = state.fieldsStatuses;
                                    return {
                                            isLong: init.isLong,
                                            isMint: init.isMint,
                                            amount: status
                                          };
                                  })),
                            collectionsStatuses: state.collectionsStatuses,
                            formStatus: state.formStatus,
                            submissionStatus: state.submissionStatus
                          },
                          [Symbol.for("name")]: "Update"
                        };
              case /* SetSubmittedStatus */3 :
                  var input = action._0;
                  if (input !== undefined) {
                    return {
                            TAG: 0,
                            _0: {
                              input: input,
                              fieldsStatuses: {
                                isLong: /* Pristine */0,
                                isMint: /* Pristine */0,
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
                                isLong: /* Pristine */0,
                                isMint: /* Pristine */0,
                                amount: /* Pristine */0
                              },
                              collectionsStatuses: state.collectionsStatuses,
                              formStatus: /* Submitted */1,
                              submissionStatus: state.submissionStatus
                            },
                            [Symbol.for("name")]: "Update"
                          };
                  }
              case /* SetSubmissionFailedStatus */4 :
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
              case /* MapSubmissionError */5 :
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
          updateIsLong: (function (nextInputFn, nextValue) {
              return Curry._1(dispatch, {
                          TAG: 0,
                          _0: (function (__x) {
                              return Curry._2(nextInputFn, __x, nextValue);
                            }),
                          [Symbol.for("name")]: "UpdateIsLongField"
                        });
            }),
          updateIsMint: (function (nextInputFn, nextValue) {
              return Curry._1(dispatch, {
                          TAG: 1,
                          _0: (function (__x) {
                              return Curry._2(nextInputFn, __x, nextValue);
                            }),
                          [Symbol.for("name")]: "UpdateIsMintField"
                        });
            }),
          updateAmount: (function (nextInputFn, nextValue) {
              return Curry._1(dispatch, {
                          TAG: 2,
                          _0: (function (__x) {
                              return Curry._2(nextInputFn, __x, nextValue);
                            }),
                          [Symbol.for("name")]: "UpdateAmountField"
                        });
            }),
          blurIsLong: (function (param) {
              return Curry._1(dispatch, /* BlurIsLongField */0);
            }),
          blurIsMint: (function (param) {
              return Curry._1(dispatch, /* BlurIsMintField */1);
            }),
          blurAmount: (function (param) {
              return Curry._1(dispatch, /* BlurAmountField */2);
            }),
          isLongResult: Formality.exposeFieldResult(state.fieldsStatuses.isLong),
          isMintResult: Formality.exposeFieldResult(state.fieldsStatuses.isMint),
          amountResult: Formality.exposeFieldResult(state.fieldsStatuses.amount),
          input: state.input,
          status: state.formStatus,
          dirty: (function (param) {
              var match = state.fieldsStatuses;
              if (match.isLong || match.isMint || match.amount) {
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
              return Curry._1(dispatch, /* Submit */3);
            }),
          dismissSubmissionError: (function (param) {
              return Curry._1(dispatch, /* DismissSubmissionError */4);
            }),
          dismissSubmissionResult: (function (param) {
              return Curry._1(dispatch, /* DismissSubmissionResult */5);
            }),
          mapSubmissionError: (function (map) {
              return Curry._1(dispatch, {
                          TAG: 5,
                          _0: map,
                          [Symbol.for("name")]: "MapSubmissionError"
                        });
            }),
          reset: (function (param) {
              return Curry._1(dispatch, /* Reset */6);
            })
        };
}

var TradeForm = {
  validators: validators,
  initialFieldsStatuses: initialFieldsStatuses,
  initialCollectionsStatuses: undefined,
  initialState: initialState,
  validateForm: validateForm,
  useForm: useForm
};

var initialInput = {
  amount: "",
  isMint: true,
  isLong: false
};

function useBalanceAndApproved(erc20Address, spender) {
  var match = ContractHooks.useErc20Balance(erc20Address);
  var match$1 = ContractHooks.useERC20Approved(erc20Address, spender);
  return [
          match.data,
          match$1.data
        ];
}

function isGreaterThanApproval(amount, amountApproved) {
  return amount.gt(amountApproved);
}

function isGreaterThanBalance(amount, balance) {
  return amount.gt(balance);
}

function TradeForm$1(Props) {
  var market = Props.market;
  var signer = ContractActions.useSignerExn(undefined);
  var match = ContractActions.useContractFunction(signer);
  var setTxState = match[2];
  var txState = match[1];
  var contractExecutionHandler = match[0];
  ContractActions.useContractFunction(signer);
  var longShortContractAddress = Config.useLongShortAddress(undefined);
  var daiAddressThatIsTemporarilyHardCoded = Config.useDaiAddress(undefined);
  var match$1 = useBalanceAndApproved(daiAddressThatIsTemporarilyHardCoded, longShortContractAddress);
  var optDaiAmountApproved = match$1[1];
  var optDaiBalance = match$1[0];
  var match$2 = useBalanceAndApproved(market.syntheticShort.tokenAddress, longShortContractAddress);
  var match$3 = useBalanceAndApproved(market.syntheticLong.tokenAddress, longShortContractAddress);
  var form = useForm(initialInput, (function (param, _form) {
          var isLong = param.isLong;
          var amount = param.amount;
          if (param.isMint) {
            if (isLong) {
              var arg = market.marketIndex;
              return Curry._2(contractExecutionHandler, (function (param) {
                            return Contracts.LongShort.make(longShortContractAddress, param);
                          }), (function (param) {
                            return param.mintLong(arg, amount);
                          }));
            }
            var arg$1 = market.marketIndex;
            return Curry._2(contractExecutionHandler, (function (param) {
                          return Contracts.LongShort.make(longShortContractAddress, param);
                        }), (function (param) {
                          return param.mintShort(arg$1, amount);
                        }));
          }
          if (isLong) {
            var arg$2 = market.marketIndex;
            return Curry._2(contractExecutionHandler, (function (param) {
                          return Contracts.LongShort.make(longShortContractAddress, param);
                        }), (function (param) {
                          return param.redeemLong(arg$2, amount);
                        }));
          }
          var arg$3 = market.marketIndex;
          return Curry._2(contractExecutionHandler, (function (param) {
                        return Contracts.LongShort.make(longShortContractAddress, param);
                      }), (function (param) {
                        return param.redeemShort(arg$3, amount);
                      }));
        }));
  var match$4 = form.amountResult;
  var formAmount = match$4 !== undefined && match$4.TAG === /* Ok */0 ? Caml_option.some(match$4._0) : undefined;
  var match$5 = form.input.isMint;
  var match$6 = form.input.isLong;
  var match$7;
  if (match$5) {
    var position = match$6 ? "LONG" : "SHORT";
    var exit = 0;
    if (formAmount !== undefined && optDaiBalance !== undefined && optDaiAmountApproved !== undefined) {
      var amountApproved = Caml_option.valFromOption(optDaiAmountApproved);
      var amount = Caml_option.valFromOption(formAmount);
      var prefix = amount.gt(amountApproved) ? "" : "Approve & ";
      console.log([
            Ethers.Utils.formatEther(amount),
            Ethers.Utils.formatEther(amountApproved),
            prefix,
            amount.gt(amountApproved)
          ]);
      var greaterThanBalance = amount.gt(Caml_option.valFromOption(optDaiBalance));
      match$7 = greaterThanBalance ? [
          "Amount is greater than your balance",
          prefix + "2Mint " + position,
          true
        ] : [
          undefined,
          "1MINT " + position,
          false
        ];
    } else {
      exit = 1;
    }
    if (exit === 1) {
      match$7 = [
        undefined,
        "3Mint " + position,
        true
      ];
    }
    
  } else {
    match$7 = match$6 ? [
        undefined,
        "Redeem Long",
        false
      ] : [
        undefined,
        "Redeem Short",
        false
      ];
  }
  var optAdditionalErrorMessage = match$7[0];
  var tmp;
  if (form.input.isMint) {
    var match$8 = form.amountResult;
    var tmp$1;
    var exit$1 = 0;
    var message;
    if (match$8 !== undefined) {
      if (match$8.TAG === /* Ok */0) {
        if (optAdditionalErrorMessage !== undefined) {
          message = optAdditionalErrorMessage;
          exit$1 = 1;
        } else {
          tmp$1 = React.createElement("div", {
                className: "text-green-600"
              }, "✓");
        }
      } else {
        message = match$8._0;
        exit$1 = 1;
      }
    } else if (optAdditionalErrorMessage !== undefined) {
      message = optAdditionalErrorMessage;
      exit$1 = 1;
    } else {
      tmp$1 = null;
    }
    if (exit$1 === 1) {
      tmp$1 = React.createElement("div", {
            className: "text-red-600"
          }, message);
    }
    tmp = React.createElement(React.Fragment, undefined, React.createElement("input", {
              className: "trade-input",
              id: "amount",
              disabled: form.submitting,
              placeholder: "mint",
              type: "text",
              value: form.input.amount,
              onBlur: (function (param) {
                  return Curry._1(form.blurAmount, undefined);
                }),
              onChange: (function ($$event) {
                  return Curry._2(form.updateAmount, (function (input, amount) {
                                return {
                                        amount: amount,
                                        isMint: input.isMint,
                                        isLong: input.isLong
                                      };
                              }), $$event.target.value);
                })
            }), tmp$1);
  } else {
    tmp = React.createElement("input", {
          className: "trade-input",
          placeholder: "redeem"
        });
  }
  var tmp$2;
  if (Config.isDevMode) {
    var txExplererUrl = RootProvider.useEtherscanUrl(undefined);
    var resetTxButton = React.createElement("button", {
          onClick: (function (param) {
              return Curry._1(setTxState, (function (param) {
                            return /* UnInitialised */0;
                          }));
            })
        }, ">>Reset tx<<");
    var tmp$3;
    if (typeof txState === "number") {
      switch (txState) {
        case /* UnInitialised */0 :
            tmp$3 = null;
            break;
        case /* Created */1 :
            tmp$3 = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Processing Transaction ", React.createElement(Loader.make, {})), React.createElement("p", undefined, "Tx created."), React.createElement("div", undefined, React.createElement(Loader.make, {})));
            break;
        case /* Failed */2 :
            tmp$3 = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "The transaction failed."), React.createElement("p", undefined, "This operation isn't permitted by the smart contract."), resetTxButton);
            break;
        
      }
    } else {
      switch (txState.TAG | 0) {
        case /* SignedAndSubmitted */0 :
            tmp$3 = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Processing Transaction ", React.createElement(Loader.make, {})), React.createElement("p", undefined, React.createElement("a", {
                          href: "https://" + txExplererUrl + "/tx/" + txState._0,
                          rel: "noopener noreferrer",
                          target: "_blank"
                        }, "View the transaction on " + txExplererUrl)), React.createElement(Loader.make, {}));
            break;
        case /* Declined */1 :
            tmp$3 = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "The transaction was declined by your wallet, please try again."), React.createElement("p", undefined, "Failure reason: " + txState._0), resetTxButton);
            break;
        case /* Complete */2 :
            var txHash = txState._0.transactionHash;
            tmp$3 = React.createElement(React.Fragment, undefined, React.createElement("h1", undefined, "Transaction Complete "), React.createElement("p", undefined, React.createElement("a", {
                          href: "https://" + txExplererUrl + "/tx/" + txHash,
                          rel: "noopener noreferrer",
                          target: "_blank"
                        }, "View the transaction on " + txExplererUrl)), resetTxButton);
            break;
        
      }
    }
    var formatOptBalance = function (__x) {
      return Belt_Option.mapWithDefault(__x, "Loading", Ethers.Utils.formatEther);
    };
    tmp$2 = React.createElement(React.Fragment, undefined, tmp$3, React.createElement("div", undefined, React.createElement("p", undefined, "dev only component to display balances"), React.createElement("p", undefined, "dai - balance: " + formatOptBalance(optDaiBalance) + " - approved: " + formatOptBalance(optDaiAmountApproved)), React.createElement("p", undefined, "long - balance: " + formatOptBalance(match$3[0]) + " - approved: " + formatOptBalance(match$3[1])), React.createElement("p", undefined, "short - balance: " + formatOptBalance(match$2[0]) + " - approved: " + formatOptBalance(match$2[1]))));
  } else {
    tmp$2 = null;
  }
  return React.createElement("div", {
              className: "screen-centered-container"
            }, React.createElement(Form.make, {
                  className: "trade-form",
                  onSubmit: (function (param) {
                      return Curry._1(form.submit, undefined);
                    }),
                  children: null
                }, React.createElement("h2", undefined, market.name + " (" + market.symbol + ")"), React.createElement("select", {
                      className: "trade-select",
                      disabled: form.submitting,
                      name: "longshort",
                      value: form.input.isLong ? "long" : "short",
                      onBlur: (function (param) {
                          return Curry._1(form.blurAmount, undefined);
                        }),
                      onChange: (function ($$event) {
                          return Curry._2(form.updateIsLong, (function (input, isLong) {
                                        return {
                                                amount: input.amount,
                                                isMint: input.isMint,
                                                isLong: isLong
                                              };
                                      }), $$event.target.value === "long");
                        })
                    }, React.createElement("option", {
                          value: "long"
                        }, "Long 🐮"), React.createElement("option", {
                          value: "short"
                        }, "Short 🐻")), tmp, React.createElement("div", {
                      className: "trade-switch",
                      onClick: (function (param) {
                          return Curry._2(form.updateIsMint, (function (input, isMint) {
                                        return {
                                                amount: input.amount,
                                                isMint: isMint,
                                                isLong: input.isLong
                                              };
                                      }), !form.input.isMint);
                        })
                    }, "↑↓"), form.input.isMint ? React.createElement("input", {
                        className: "trade-input",
                        placeholder: "redeem"
                      }) : React.createElement("input", {
                        className: "trade-input",
                        placeholder: "mint"
                      }), React.createElement("button", {
                      className: "trade-action",
                      disabled: match$7[2]
                    }, match$7[1])), tmp$2);
}

var make = TradeForm$1;

export {
  TradeForm ,
  initialInput ,
  useBalanceAndApproved ,
  isGreaterThanApproval ,
  isGreaterThanBalance ,
  make ,
  
}
/* Form Not a pure module */
