// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cn from "re-classnames/src/Cn.js";
import * as Form from "./Form.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Config from "../../Config.js";
import * as Ethers from "../../ethereum/Ethers.js";
import * as Belt_Int from "bs-platform/lib/es6/belt_Int.js";
import * as Contracts from "../../ethereum/Contracts.js";
import * as Formality from "re-formality/src/Formality.js";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as TxTemplate from "../Ethereum/TxTemplate.js";
import * as Belt_Option from "bs-platform/lib/es6/belt_Option.js";
import * as Caml_option from "bs-platform/lib/es6/caml_option.js";
import * as RootProvider from "../../libraries/RootProvider.js";
import * as ContractActions from "../../ethereum/ContractActions.js";
import * as Formality__ReactUpdate from "re-formality/src/Formality__ReactUpdate.js";

function useMintContracts(param) {
  var netIdStr = Belt_Option.mapWithDefault(RootProvider.useNetworkId(undefined), "5", (function (prim) {
          return String(prim);
        }));
  return [
          {
            name: "aDai",
            address: Config.getContractAddressString(netIdStr, (function (contract) {
                    return contract.ADai;
                  }))
          },
          {
            name: "Dai",
            address: Config.getContractAddressString(netIdStr, (function (contract) {
                    return contract.Dai;
                  }))
          },
          {
            name: "SyntheticToken",
            address: Config.getContractAddressString(netIdStr, (function (contract) {
                    return contract.LongCoins;
                  }))
          },
          {
            name: "ShortCoins",
            address: Config.getContractAddressString(netIdStr, (function (contract) {
                    return contract.ShortCoins;
                  }))
          }
        ];
}
var validators_tokenAddress = {
  strategy: /* OnFirstBlur */ 0,
  validate: function (param) {
    var validAddress = Ethers.Utils.getAddress(
      Belt_Option.mapWithDefault(param.tokenAddress, "", function (details) {
        return details.address;
      })
    );
    if (validAddress !== undefined) {
      return {
        TAG: 0,
        _0: Caml_option.valFromOption(validAddress),
        [Symbol.for("name")]: "Ok",
      };
    } else {
      return {
        TAG: 1,
        _0: "Address is invalid",
        [Symbol.for("name")]: "Error",
      };
    }
  },
};

var validators_amount = {
  strategy: /* OnFirstBlur */ 0,
  validate: function (param) {
    var amount = param.amount;
    var addressRegex = /^[+]?\d+(\.\d+)?$/;
    if (amount === "") {
      return {
        TAG: 1,
        _0: "Amount is required",
        [Symbol.for("name")]: "Error",
      };
    } else if (addressRegex.test(amount)) {
      return Belt_Option.mapWithDefault(
        Ethers.Utils.parseEther(amount),
        {
          TAG: 1,
          _0: "Couldn't parse Ether value",
          [Symbol.for("name")]: "Error",
        },
        function (etherValue) {
          return {
            TAG: 0,
            _0: etherValue,
            [Symbol.for("name")]: "Ok",
          };
        }
      );
    } else {
      return {
        TAG: 1,
        _0: "Incorrect number format - please use '.' for floating points.",
        [Symbol.for("name")]: "Error",
      };
    }
  },
};

var validators_address = {
  strategy: /* OnFirstSuccessOrFirstBlur */ 3,
  validate: function (param) {
    var validAddress = Ethers.Utils.getAddress(param.address);
    if (validAddress !== undefined) {
      return {
        TAG: 0,
        _0: Caml_option.valFromOption(validAddress),
        [Symbol.for("name")]: "Ok",
      };
    } else {
      return {
        TAG: 1,
        _0: "Address is invalid",
        [Symbol.for("name")]: "Error",
      };
    }
  },
};

var validators = {
  tokenAddress: validators_tokenAddress,
  amount: validators_amount,
  address: validators_address,
};

function initialFieldsStatuses(_input) {
  return {
    tokenAddress: /* Pristine */ 0,
    amount: /* Pristine */ 0,
    address: /* Pristine */ 0,
  };
}

function initialState(input) {
  return {
    input: input,
    fieldsStatuses: {
      tokenAddress: /* Pristine */ 0,
      amount: /* Pristine */ 0,
      address: /* Pristine */ 0,
    },
    collectionsStatuses: undefined,
    formStatus: /* Editing */ 0,
    submissionStatus: /* NeverSubmitted */ 0,
  };
}

function validateForm(input, validators, fieldsStatuses) {
  var match = fieldsStatuses.tokenAddress;
  var match_0 = match
    ? match._0
    : Curry._1(validators.tokenAddress.validate, input);
  var match$1 = fieldsStatuses.amount;
  var match_0$1 = match$1
    ? match$1._0
    : Curry._1(validators.amount.validate, input);
  var match$2 = fieldsStatuses.address;
  var match_0$2 = match$2
    ? match$2._0
    : Curry._1(validators.address.validate, input);
  var tokenAddressResult = match_0;
  var tokenAddressResult$1;
  if (tokenAddressResult.TAG === /* Ok */ 0) {
    var amountResult = match_0$1;
    if (amountResult.TAG === /* Ok */ 0) {
      var addressResult = match_0$2;
      if (addressResult.TAG === /* Ok */ 0) {
        return {
          TAG: 0,
          output: {
            address: addressResult._0,
            amount: amountResult._0,
            tokenAddress: tokenAddressResult._0,
          },
          fieldsStatuses: {
            tokenAddress: {
              _0: tokenAddressResult,
              _1: /* Shown */ 0,
              [Symbol.for("name")]: "Dirty",
            },
            amount: {
              _0: amountResult,
              _1: /* Shown */ 0,
              [Symbol.for("name")]: "Dirty",
            },
            address: {
              _0: addressResult,
              _1: /* Shown */ 0,
              [Symbol.for("name")]: "Dirty",
            },
          },
          collectionsStatuses: undefined,
          [Symbol.for("name")]: "Valid",
        };
      }
      tokenAddressResult$1 = tokenAddressResult;
    } else {
      tokenAddressResult$1 = tokenAddressResult;
    }
  } else {
    tokenAddressResult$1 = tokenAddressResult;
  }
  return {
    TAG: 1,
    fieldsStatuses: {
      tokenAddress: {
        _0: tokenAddressResult$1,
        _1: /* Shown */ 0,
        [Symbol.for("name")]: "Dirty",
      },
      amount: {
        _0: match_0$1,
        _1: /* Shown */ 0,
        [Symbol.for("name")]: "Dirty",
      },
      address: {
        _0: match_0$2,
        _1: /* Shown */ 0,
        [Symbol.for("name")]: "Dirty",
      },
    },
    collectionsStatuses: undefined,
    [Symbol.for("name")]: "Invalid",
  };
}

function useForm(initialInput, onSubmit) {
  var memoizedInitialState = React.useMemo(
    function () {
      return initialState(initialInput);
    },
    [initialInput]
  );
  var match = Formality__ReactUpdate.useReducer(
    memoizedInitialState,
    function (state, action) {
      if (typeof action === "number") {
        switch (action) {
          case /* BlurTokenAddressField */ 0:
            var result = Formality.validateFieldOnBlurWithValidator(
              state.input,
              state.fieldsStatuses.tokenAddress,
              validators_tokenAddress,
              function (status) {
                var init = state.fieldsStatuses;
                return {
                  tokenAddress: status,
                  amount: init.amount,
                  address: init.address,
                };
              }
            );
            if (result !== undefined) {
              return {
                TAG: 0,
                _0: {
                  input: state.input,
                  fieldsStatuses: result,
                  collectionsStatuses: state.collectionsStatuses,
                  formStatus: state.formStatus,
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
              };
            } else {
              return /* NoUpdate */ 0;
            }
          case /* BlurAmountField */ 1:
            var result$1 = Formality.validateFieldOnBlurWithValidator(
              state.input,
              state.fieldsStatuses.amount,
              validators_amount,
              function (status) {
                var init = state.fieldsStatuses;
                return {
                  tokenAddress: init.tokenAddress,
                  amount: status,
                  address: init.address,
                };
              }
            );
            if (result$1 !== undefined) {
              return {
                TAG: 0,
                _0: {
                  input: state.input,
                  fieldsStatuses: result$1,
                  collectionsStatuses: state.collectionsStatuses,
                  formStatus: state.formStatus,
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
              };
            } else {
              return /* NoUpdate */ 0;
            }
          case /* BlurAddressField */ 2:
            var result$2 = Formality.validateFieldOnBlurWithValidator(
              state.input,
              state.fieldsStatuses.address,
              validators_address,
              function (status) {
                var init = state.fieldsStatuses;
                return {
                  tokenAddress: init.tokenAddress,
                  amount: init.amount,
                  address: status,
                };
              }
            );
            if (result$2 !== undefined) {
              return {
                TAG: 0,
                _0: {
                  input: state.input,
                  fieldsStatuses: result$2,
                  collectionsStatuses: state.collectionsStatuses,
                  formStatus: state.formStatus,
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
              };
            } else {
              return /* NoUpdate */ 0;
            }
          case /* Submit */ 3:
            var match = state.formStatus;
            if (typeof match !== "number" && match.TAG === /* Submitting */ 0) {
              return /* NoUpdate */ 0;
            }
            var match$1 = validateForm(
              state.input,
              validators,
              state.fieldsStatuses
            );
            if (match$1.TAG !== /* Valid */ 0) {
              return {
                TAG: 0,
                _0: {
                  input: state.input,
                  fieldsStatuses: match$1.fieldsStatuses,
                  collectionsStatuses: match$1.collectionsStatuses,
                  formStatus: /* Editing */ 0,
                  submissionStatus: /* AttemptedToSubmit */ 1,
                },
                [Symbol.for("name")]: "Update",
              };
            }
            var output = match$1.output;
            var error = state.formStatus;
            var tmp;
            tmp =
              typeof error === "number" ||
              error.TAG !== /* SubmissionFailed */ 1
                ? undefined
                : Caml_option.some(error._0);
            return {
              TAG: 1,
              _0: {
                input: state.input,
                fieldsStatuses: match$1.fieldsStatuses,
                collectionsStatuses: match$1.collectionsStatuses,
                formStatus: {
                  TAG: 0,
                  _0: tmp,
                  [Symbol.for("name")]: "Submitting",
                },
                submissionStatus: /* AttemptedToSubmit */ 1,
              },
              _1: function (param) {
                var dispatch = param.dispatch;
                return Curry._2(onSubmit, output, {
                  notifyOnSuccess: function (input) {
                    return Curry._1(dispatch, {
                      TAG: 3,
                      _0: input,
                      [Symbol.for("name")]: "SetSubmittedStatus",
                    });
                  },
                  notifyOnFailure: function (error) {
                    return Curry._1(dispatch, {
                      TAG: 4,
                      _0: error,
                      [Symbol.for("name")]: "SetSubmissionFailedStatus",
                    });
                  },
                  reset: function (param) {
                    return Curry._1(dispatch, /* Reset */ 6);
                  },
                  dismissSubmissionResult: function (param) {
                    return Curry._1(dispatch, /* DismissSubmissionResult */ 5);
                  },
                });
              },
              [Symbol.for("name")]: "UpdateWithSideEffects",
            };
            break;
          case /* DismissSubmissionError */ 4:
            var match$2 = state.formStatus;
            if (
              typeof match$2 === "number" ||
              match$2.TAG !== /* SubmissionFailed */ 1
            ) {
              return /* NoUpdate */ 0;
            } else {
              return {
                TAG: 0,
                _0: {
                  input: state.input,
                  fieldsStatuses: state.fieldsStatuses,
                  collectionsStatuses: state.collectionsStatuses,
                  formStatus: /* Editing */ 0,
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
              };
            }
          case /* DismissSubmissionResult */ 5:
            var match$3 = state.formStatus;
            if (typeof match$3 === "number") {
              if (match$3 === /* Editing */ 0) {
                return /* NoUpdate */ 0;
              }
            } else if (match$3.TAG === /* Submitting */ 0) {
              return /* NoUpdate */ 0;
            }
            return {
              TAG: 0,
              _0: {
                input: state.input,
                fieldsStatuses: state.fieldsStatuses,
                collectionsStatuses: state.collectionsStatuses,
                formStatus: /* Editing */ 0,
                submissionStatus: state.submissionStatus,
              },
              [Symbol.for("name")]: "Update",
            };
          case /* Reset */ 6:
            return {
              TAG: 0,
              _0: initialState(initialInput),
              [Symbol.for("name")]: "Update",
            };
        }
      } else {
        switch (action.TAG | 0) {
          case /* UpdateTokenAddressField */ 0:
            var nextInput = Curry._1(action._0, state.input);
            return {
              TAG: 0,
              _0: {
                input: nextInput,
                fieldsStatuses: Formality.validateFieldOnChangeWithValidator(
                  nextInput,
                  state.fieldsStatuses.tokenAddress,
                  state.submissionStatus,
                  validators_tokenAddress,
                  function (status) {
                    var init = state.fieldsStatuses;
                    return {
                      tokenAddress: status,
                      amount: init.amount,
                      address: init.address,
                    };
                  }
                ),
                collectionsStatuses: state.collectionsStatuses,
                formStatus: state.formStatus,
                submissionStatus: state.submissionStatus,
              },
              [Symbol.for("name")]: "Update",
            };
          case /* UpdateAmountField */ 1:
            var nextInput$1 = Curry._1(action._0, state.input);
            return {
              TAG: 0,
              _0: {
                input: nextInput$1,
                fieldsStatuses: Formality.validateFieldOnChangeWithValidator(
                  nextInput$1,
                  state.fieldsStatuses.amount,
                  state.submissionStatus,
                  validators_amount,
                  function (status) {
                    var init = state.fieldsStatuses;
                    return {
                      tokenAddress: init.tokenAddress,
                      amount: status,
                      address: init.address,
                    };
                  }
                ),
                collectionsStatuses: state.collectionsStatuses,
                formStatus: state.formStatus,
                submissionStatus: state.submissionStatus,
              },
              [Symbol.for("name")]: "Update",
            };
          case /* UpdateAddressField */ 2:
            var nextInput$2 = Curry._1(action._0, state.input);
            return {
              TAG: 0,
              _0: {
                input: nextInput$2,
                fieldsStatuses: Formality.validateFieldOnChangeWithValidator(
                  nextInput$2,
                  state.fieldsStatuses.address,
                  state.submissionStatus,
                  validators_address,
                  function (status) {
                    var init = state.fieldsStatuses;
                    return {
                      tokenAddress: init.tokenAddress,
                      amount: init.amount,
                      address: status,
                    };
                  }
                ),
                collectionsStatuses: state.collectionsStatuses,
                formStatus: state.formStatus,
                submissionStatus: state.submissionStatus,
              },
              [Symbol.for("name")]: "Update",
            };
          case /* SetSubmittedStatus */ 3:
            var input = action._0;
            if (input !== undefined) {
              return {
                TAG: 0,
                _0: {
                  input: input,
                  fieldsStatuses: {
                    tokenAddress: /* Pristine */ 0,
                    amount: /* Pristine */ 0,
                    address: /* Pristine */ 0,
                  },
                  collectionsStatuses: state.collectionsStatuses,
                  formStatus: /* Submitted */ 1,
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
              };
            } else {
              return {
                TAG: 0,
                _0: {
                  input: state.input,
                  fieldsStatuses: {
                    tokenAddress: /* Pristine */ 0,
                    amount: /* Pristine */ 0,
                    address: /* Pristine */ 0,
                  },
                  collectionsStatuses: state.collectionsStatuses,
                  formStatus: /* Submitted */ 1,
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
              };
            }
          case /* SetSubmissionFailedStatus */ 4:
            return {
              TAG: 0,
              _0: {
                input: state.input,
                fieldsStatuses: state.fieldsStatuses,
                collectionsStatuses: state.collectionsStatuses,
                formStatus: {
                  TAG: 1,
                  _0: action._0,
                  [Symbol.for("name")]: "SubmissionFailed",
                },
                submissionStatus: state.submissionStatus,
              },
              [Symbol.for("name")]: "Update",
            };
          case /* MapSubmissionError */ 5:
            var map = action._0;
            var error$1 = state.formStatus;
            if (typeof error$1 === "number") {
              return /* NoUpdate */ 0;
            }
            if (error$1.TAG !== /* Submitting */ 0) {
              return {
                TAG: 0,
                _0: {
                  input: state.input,
                  fieldsStatuses: state.fieldsStatuses,
                  collectionsStatuses: state.collectionsStatuses,
                  formStatus: {
                    TAG: 1,
                    _0: Curry._1(map, error$1._0),
                    [Symbol.for("name")]: "SubmissionFailed",
                  },
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
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
                    _0: Caml_option.some(
                      Curry._1(map, Caml_option.valFromOption(error$2))
                    ),
                    [Symbol.for("name")]: "Submitting",
                  },
                  submissionStatus: state.submissionStatus,
                },
                [Symbol.for("name")]: "Update",
              };
            } else {
              return /* NoUpdate */ 0;
            }
        }
      }
    }
  );
  var dispatch = match[1];
  var state = match[0];
  var match$1 = state.formStatus;
  var tmp;
  tmp =
    typeof match$1 === "number" || match$1.TAG !== /* Submitting */ 0
      ? false
      : true;
  return {
    updateTokenAddress: function (nextInputFn, nextValue) {
      return Curry._1(dispatch, {
        TAG: 0,
        _0: function (__x) {
          return Curry._2(nextInputFn, __x, nextValue);
        },
        [Symbol.for("name")]: "UpdateTokenAddressField",
      });
    },
    updateAmount: function (nextInputFn, nextValue) {
      return Curry._1(dispatch, {
        TAG: 1,
        _0: function (__x) {
          return Curry._2(nextInputFn, __x, nextValue);
        },
        [Symbol.for("name")]: "UpdateAmountField",
      });
    },
    updateAddress: function (nextInputFn, nextValue) {
      return Curry._1(dispatch, {
        TAG: 2,
        _0: function (__x) {
          return Curry._2(nextInputFn, __x, nextValue);
        },
        [Symbol.for("name")]: "UpdateAddressField",
      });
    },
    blurTokenAddress: function (param) {
      return Curry._1(dispatch, /* BlurTokenAddressField */ 0);
    },
    blurAmount: function (param) {
      return Curry._1(dispatch, /* BlurAmountField */ 1);
    },
    blurAddress: function (param) {
      return Curry._1(dispatch, /* BlurAddressField */ 2);
    },
    tokenAddressResult: Formality.exposeFieldResult(
      state.fieldsStatuses.tokenAddress
    ),
    amountResult: Formality.exposeFieldResult(state.fieldsStatuses.amount),
    addressResult: Formality.exposeFieldResult(state.fieldsStatuses.address),
    input: state.input,
    status: state.formStatus,
    dirty: function (param) {
      var match = state.fieldsStatuses;
      if (match.tokenAddress || match.amount || match.address) {
        return true;
      } else {
        return false;
      }
    },
    valid: function (param) {
      var match = validateForm(state.input, validators, state.fieldsStatuses);
      if (match.TAG === /* Valid */ 0) {
        return true;
      } else {
        return false;
      }
    },
    submitting: tmp,
    submit: function (param) {
      return Curry._1(dispatch, /* Submit */ 3);
    },
    dismissSubmissionError: function (param) {
      return Curry._1(dispatch, /* DismissSubmissionError */ 4);
    },
    dismissSubmissionResult: function (param) {
      return Curry._1(dispatch, /* DismissSubmissionResult */ 5);
    },
    mapSubmissionError: function (map) {
      return Curry._1(dispatch, {
        TAG: 5,
        _0: map,
        [Symbol.for("name")]: "MapSubmissionError",
      });
    },
    reset: function (param) {
      return Curry._1(dispatch, /* Reset */ 6);
    },
  };
}

var AdminMintForm = {
  validators: validators,
  initialFieldsStatuses: initialFieldsStatuses,
  initialCollectionsStatuses: undefined,
  initialState: initialState,
  validateForm: validateForm,
  useForm: useForm,
};

var initialInput = {
  address: "",
  amount: "",
  tokenAddress: undefined,
};

function Mint(Props) {
  var ethersWallet = Props.ethersWallet;
  var match = ContractActions.useContractFunction(ethersWallet);
  var setTxState = match[2];
  var contractExecutionHandler = match[0];
<<<<<<< Updated upstream
  var contracts = useMintContracts(undefined);
  var form = useForm(initialInput, (function (param, _form) {
          var tokenAddress = param.tokenAddress;
          var amount = param.amount;
          var address = param.address;
          return Curry._2(contractExecutionHandler, (function (param) {
                        return Contracts.TestErc20.make(tokenAddress, param);
                      }), (function (param) {
                        return param.mint(address, amount);
                      }));
        }));
=======
  var form = useForm(initialInput, function (param, _form) {
    var tokenAddress = param.tokenAddress;
    var amount = param.amount;
    var address = param.address;
    return Curry._2(
      contractExecutionHandler,
      function (param) {
        return Contracts.TestErc20.make(tokenAddress, param);
      },
      function (param) {
        return param.mint(address, amount);
      }
    );
  });
>>>>>>> Stashed changes
  var match$1 = form.addressResult;
  var tmp;
  tmp =
    match$1 !== undefined
      ? match$1.TAG === /* Ok */ 0
        ? React.createElement(
            "div",
            {
              className: "text-green-600",
            },
            "✓"
          )
        : React.createElement(
            "div",
            {
              className: "text-red-600",
            },
            match$1._0
          )
      : null;
  var match$2 = form.amountResult;
  var tmp$1;
  tmp$1 =
    match$2 !== undefined
      ? match$2.TAG === /* Ok */ 0
        ? React.createElement(
            "div",
            {
              className: "text-green-600",
            },
            "✓"
          )
        : React.createElement(
            "div",
            {
              className: "text-red-600",
            },
            match$2._0
          )
      : null;
  var match$3 = form.input.tokenAddress;
  var match$4 = form.tokenAddressResult;
  var tmp$2;
  tmp$2 =
    match$4 !== undefined
      ? match$4.TAG === /* Ok */ 0
        ? React.createElement(
            "div",
            {
              className: "text-green-600",
            },
            "✓"
          )
        : React.createElement(
            "div",
            {
              className: "text-red-600",
            },
            match$4._0
          )
      : null;
  var match$5 = form.status;
  return React.createElement(TxTemplate.make, {
<<<<<<< Updated upstream
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
                            }, "Mint"), React.createElement("div", {
                              className: ""
                            }, React.createElement("label", {
                                  htmlFor: "address"
                                }, "Address: "), React.createElement("input", {
                                  className: "border-2 border-grey-500",
                                  id: "address",
                                  disabled: form.submitting,
                                  type: "text",
                                  value: form.input.address,
                                  onBlur: (function (param) {
                                      return Curry._1(form.blurAddress, undefined);
                                    }),
                                  onChange: (function ($$event) {
                                      return Curry._2(form.updateAddress, (function (input, value) {
                                                    return {
                                                            address: value,
                                                            amount: input.amount,
                                                            tokenAddress: input.tokenAddress
                                                          };
                                                  }), $$event.target.value);
                                    })
                                }), tmp), React.createElement("div", undefined, React.createElement("label", {
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
                                      return Curry._2(form.updateAmount, (function (input, value) {
                                                    return {
                                                            address: input.address,
                                                            amount: value,
                                                            tokenAddress: input.tokenAddress
                                                          };
                                                  }), $$event.target.value);
                                    })
                                }), tmp$1), React.createElement("div", undefined, React.createElement("label", {
                                  htmlFor: "contractToMinFor"
                                }, "Contract to mint for:"), React.createElement("select", {
                                  className: "push-lg",
                                  id: "contractToMinFor",
                                  disabled: form.submitting,
                                  name: "contractToMinFor",
                                  onBlur: (function (param) {
                                      return Curry._1(form.blurTokenAddress, undefined);
                                    }),
                                  onChange: (function ($$event) {
                                      return Curry._2(form.updateTokenAddress, (function (input, value) {
                                                    return {
                                                            address: input.address,
                                                            amount: input.amount,
                                                            tokenAddress: value
                                                          };
                                                  }), Belt_Array.get(contracts, Belt_Option.getWithDefault(Belt_Int.fromString($$event.target.value), 0)));
                                    })
                                }, match$3 !== undefined ? null : React.createElement("option", {
                                        value: "999"
                                      }, "Select a token"), Belt_Array.mapWithIndex(contracts, (function (i, contract) {
                                        return React.createElement("option", {
                                                    value: String(i)
                                                  }, contract.name);
                                      }))), tmp$2), React.createElement("div", undefined, React.createElement("button", {
                                  className: "text-lg disabled:opacity-50 bg-green-500 rounded-lg",
                                  disabled: form.submitting
                                }, form.submitting ? "Submitting..." : "Submit"), typeof match$5 === "number" && match$5 !== 0 ? React.createElement("div", {
                                    className: Cn.fromList({
                                          hd: "form-status",
                                          tl: {
                                            hd: "success",
                                            tl: /* [] */0
                                          }
                                        })
                                  }, "✓ Finished Minting") : null))
=======
    children: React.createElement(Form.make, {
      className: "",
      onSubmit: function (param) {
        console.log("temp");
        return Curry._1(form.submit, undefined);
      },
      children: React.createElement(
        "div",
        {
          className: "",
        },
        React.createElement(
          "h2",
          {
            className: "text-xl",
          },
          "Mint"
        ),
        React.createElement(
          "div",
          {
            className: "",
          },
          React.createElement(
            "label",
            {
              htmlFor: "address",
            },
            "Address: "
          ),
          React.createElement("input", {
            className: "border-2 border-grey-500",
            id: "address",
            disabled: form.submitting,
            type: "text",
            value: form.input.address,
            onBlur: function (param) {
              return Curry._1(form.blurAddress, undefined);
            },
            onChange: function ($$event) {
              return Curry._2(
                form.updateAddress,
                function (input, value) {
                  return {
                    address: value,
                    amount: input.amount,
                    tokenAddress: input.tokenAddress,
                  };
                },
                $$event.target.value
              );
            },
          }),
          tmp
        ),
        React.createElement(
          "div",
          undefined,
          React.createElement(
            "label",
            {
              htmlFor: "amount",
            },
            "Amount: "
          ),
          React.createElement("input", {
            className: "border-2 border-grey-500",
            id: "amount",
            disabled: form.submitting,
            type: "text",
            value: form.input.amount,
            onBlur: function (param) {
              return Curry._1(form.blurAmount, undefined);
            },
            onChange: function ($$event) {
              return Curry._2(
                form.updateAmount,
                function (input, value) {
                  return {
                    address: input.address,
                    amount: value,
                    tokenAddress: input.tokenAddress,
                  };
                },
                $$event.target.value
              );
            },
          }),
          tmp$1
        ),
        React.createElement(
          "div",
          undefined,
          React.createElement(
            "label",
            {
              htmlFor: "contractToMinFor",
            },
            "Contract to mint for:"
          ),
          React.createElement(
            "select",
            {
              className: "push-lg",
              id: "contractToMinFor",
              disabled: form.submitting,
              name: "contractToMinFor",
              onBlur: function (param) {
                return Curry._1(form.blurTokenAddress, undefined);
              },
              onChange: function ($$event) {
                return Curry._2(
                  form.updateTokenAddress,
                  function (input, value) {
                    return {
                      address: input.address,
                      amount: input.amount,
                      tokenAddress: value,
                    };
                  },
                  Belt_Array.get(
                    contracts[5],
                    Belt_Option.getWithDefault(
                      Belt_Int.fromString($$event.target.value),
                      0
                    )
                  )
                );
              },
            },
            match$3 !== undefined
              ? null
              : React.createElement(
                  "option",
                  {
                    value: "999",
                  },
                  "Select a token"
                ),
            Belt_Array.mapWithIndex(contracts[5], function (i, contract) {
              return React.createElement(
                "option",
                {
                  value: String(i),
                },
                contract.name
              );
            })
          ),
          tmp$2
        ),
        React.createElement(
          "div",
          undefined,
          React.createElement(
            "button",
            {
              className: "text-lg disabled:opacity-50 bg-green-500 rounded-lg",
              disabled: form.submitting,
            },
            form.submitting ? "Submitting..." : "Submit"
          ),
          typeof match$5 === "number" && match$5 !== 0
            ? React.createElement(
                "div",
                {
                  className: Cn.fromList({
                    hd: "form-status",
                    tl: {
                      hd: "success",
                      tl: /* [] */ 0,
                    },
>>>>>>> Stashed changes
                  }),
                },
                "✓ Finished Minting"
              )
            : null
        )
      ),
    }),
    txState: match[1],
    resetTxState: function (param) {
      Curry._1(form.reset, undefined);
      return Curry._1(setTxState, function (param) {
        return /* UnInitialised */ 0;
      });
    },
  });
}

var make = Mint;

<<<<<<< Updated upstream
export {
  useMintContracts ,
  AdminMintForm ,
  initialInput ,
  make ,
  
}
=======
export { contracts, AdminMintForm, initialInput, make };
>>>>>>> Stashed changes
/* Form Not a pure module */
