// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Js_exn = require("rescript/lib/js/js_exn.js");
var Ethers = require("ethers");
var Js_json = require("rescript/lib/js/js_json.js");
var Belt_Float = require("rescript/lib/js/belt_Float.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var Caml_js_exceptions = require("rescript/lib/js/caml_js_exceptions.js");

function unsafeToOption(unsafeFunc) {
  try {
    return Caml_option.some(Curry._1(unsafeFunc, undefined));
  }
  catch (raw__obj){
    var _obj = Caml_js_exceptions.internalToOCamlException(raw__obj);
    if (_obj.RE_EXN_ID === Js_exn.$$Error) {
      return ;
    }
    throw _obj;
  }
}

var Misc = {
  unsafeToOption: unsafeToOption
};

function makeAbi(abiArray) {
  return abiArray;
}

function min(a, b) {
  if (a.gt(b)) {
    return b;
  } else {
    return a;
  }
}

function max(a, b) {
  if (a.gt(b)) {
    return a;
  } else {
    return b;
  }
}

function t_decoder(json) {
  return Belt_Option.mapWithDefault(Js_json.decodeString(json), {
              TAG: /* Error */1,
              _0: {
                path: "",
                message: "Unable to decode BN",
                value: json
              }
            }, (function (numberStr) {
                return {
                        TAG: /* Ok */0,
                        _0: Ethers.BigNumber.from(numberStr)
                      };
              }));
}

function bnCoder_0(bn) {
  return bn.toString();
}

var bnCoder = [
  bnCoder_0,
  t_decoder
];

var BigNumber = {
  min: min,
  max: max,
  t_decoder: t_decoder,
  bnCoder: bnCoder
};

var Wallet = {};

var Providers = {};

function make(address, abi, providerSigner) {
  return new Ethers.Contract(address, abi, providerSigner._0);
}

var Contract = {
  make: make
};

function parseUnits(amount, unit) {
  return unsafeToOption(function (param) {
              return Ethers.utils.parseUnits(amount, unit);
            });
}

function parseEther(amount) {
  return parseUnits(amount, "ether");
}

function parseEtherUnsafe(amount) {
  return Ethers.utils.parseUnits(amount, "ether");
}

function getAddress(addressString) {
  return unsafeToOption(function (param) {
              return Ethers.utils.getAddress(addressString);
            });
}

function formatEther(__x) {
  return Ethers.utils.formatUnits(__x, "ether");
}

var tenBN = Ethers.BigNumber.from(10);

function make18DecimalsNormalizer(decimals) {
  var multiplierOrDivisor = tenBN.pow(Ethers.BigNumber.from(Math.abs(18 - decimals | 0)));
  if (decimals < 18) {
    return function (num) {
      return num.mul(multiplierOrDivisor);
    };
  } else if (decimals > 18) {
    return function (num) {
      return num.div(multiplierOrDivisor);
    };
  } else {
    return function (num) {
      return num;
    };
  }
}

function normalizeTo18Decimals(num, decimals) {
  return make18DecimalsNormalizer(decimals)(num);
}

function formatEtherToPrecision(number, digits) {
  var digitMultiplier = Math.pow(10.0, digits);
  return String(Math.floor(Belt_Option.getExn(Belt_Float.fromString(Ethers.utils.formatUnits(number, "ether"))) * digitMultiplier) / digitMultiplier);
}

function ethAdrToStr(prim) {
  return prim;
}

function ethAdrToLowerStr(address) {
  return address.toLowerCase();
}

var Utils = {
  parseUnits: parseUnits,
  parseEther: parseEther,
  parseEtherUnsafe: parseEtherUnsafe,
  getAddress: getAddress,
  formatEther: formatEther,
  tenBN: tenBN,
  make18DecimalsNormalizer: make18DecimalsNormalizer,
  normalizeTo18Decimals: normalizeTo18Decimals,
  formatEtherToPrecision: formatEtherToPrecision,
  ethAdrToStr: ethAdrToStr,
  ethAdrToLowerStr: ethAdrToLowerStr
};

exports.Misc = Misc;
exports.makeAbi = makeAbi;
exports.BigNumber = BigNumber;
exports.Wallet = Wallet;
exports.Providers = Providers;
exports.Contract = Contract;
exports.Utils = Utils;
/* tenBN Not a pure module */
