// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cn from "re-classnames/src/Cn.js";
import * as Form from "./Form.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../../Config.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Contracts from "../../ethereum/Contracts.js";
import * as Formality from "re-formality/src/Formality.js";
import * as TxTemplate from "../Ethereum/TxTemplate.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as ContractActions from "../../ethereum/ContractActions.js";
import * as Formality__ReactUpdate from "re-formality/src/Formality__ReactUpdate.js";

var validators = {
  amount: {
    strategy: /* OnFirstBlur */0,
    validate: (function (param) {
        var amount = param.amount;
        var addressRegex = /^[+]?\d+(\.\d+)?$/;
        if (amount === "") {
          return {
                  TAG: 1,
                  _0: "Amount is required",
                  [Symbol.for("name")]: "Error"
                };
        } else if (addressRegex.test(amount)) {
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

var MintShort = {
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

function MintShort$1(Props) {
  var signer = ContractActions.useSignerExn(undefined);
  var match = ContractActions.useContractFunction(signer);
  var setTxState = match[2];
  var contractExecutionHandler = match[0];
  var tokenAddress = Config.useLongContractAddress(undefined);
  var form = useForm(initialInput, (function (param, _form) {
          var amount = param.amount;
          return Curry._2(contractExecutionHandler, (function (param) {
                        return Contracts.LongShort.make(tokenAddress, param);
                      }), (function (param) {
                        return param.mintShort(amount);
                      }));
        }));
  var match$1 = form.amountResult;
  var tmp;
  tmp = match$1 !== undefined ? (
      match$1.TAG === /* Ok */0 ? React.createElement("div", {
              className: "text-green-600"
            }, "✓") : React.createElement("div", {
              className: "text-red-600"
            }, match$1._0)
    ) : null;
  var match$2 = form.status;
  return React.createElement(TxTemplate.make, {
              children: React.createElement(Form.make, {
                    className: "",
                    onSubmit: (function (param) {
                        console.log("temp");
                        return Curry._1(form.submit, undefined);
                      }),
                    children: React.createElement("div", {
                          className: ""
                        }, React.createElement("h2", {
                              className: "text-xl"
                            }, "Mint Short Tokens"), React.createElement("div", undefined, React.createElement("label", {
                                  htmlFor: "amount"
                                }, "Amount: "), React.createElement("input", {
                                  className: "border-2 border-grey-500",
                                  id: "amount",
                                  disabled: form.submitting,
                                  type: "text",
                                  value: form.input.amount,
                                  onBlur: (function (param) {
                                      return Curry._1(form.blurAmount, undefined);
                                    }),
                                  onChange: (function ($$event) {
                                      return Curry._2(form.updateAmount, (function (_input, value) {
                                                    return {
                                                            amount: value
                                                          };
                                                  }), $$event.target.value);
                                    })
                                }), tmp), React.createElement("div", undefined, React.createElement("button", {
                                  className: "text-lg disabled:opacity-50 bg-green-500 rounded-lg",
                                  disabled: form.submitting
                                }, form.submitting ? "Submitting..." : "Submit"), typeof match$2 === "number" && match$2 !== 0 ? React.createElement("div", {
                                    className: Cn.fromList({
                                          hd: "form-status",
                                          tl: {
                                            hd: "success",
                                            tl: /* [] */0
                                          }
                                        })
                                  }, "✓ Finished Minting") : null))
                  }),
              txState: match[1],
              resetTxState: (function (param) {
                  Curry._1(form.reset, undefined);
                  return Curry._1(setTxState, (function (param) {
                                return /* UnInitialised */0;
                              }));
                })
            });
}

var useLongContractAddress = Config.useLongContractAddress;

var make = MintShort$1;

export {
  useLongContractAddress ,
  MintShort ,
  initialInput ,
  make ,
  
}
/* Form Not a pure module */
