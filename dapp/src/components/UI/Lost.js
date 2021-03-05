// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Router from "next/router";

function Lost(Props) {
  var router = Router.useRouter();
  var match = React.useState(function () {
        return false;
      });
  var setShow = match[1];
  var match$1 = router.route;
  if (match$1 === "/") {
    return null;
  } else {
    return React.createElement("div", {
                className: "fixed bottom-3 right-5 flex flex-col items-end"
              }, React.createElement("div", {
                    className: "font-alphbeta text-2xl cursor-pointer",
                    onClick: (function (param) {
                        return Curry._1(setShow, (function (show) {
                                      return !show;
                                    }));
                      })
                  }, "Lost?"), React.createElement("div", {
                    className: "relative overflow-hidden transition-all duration-700",
                    style: {
                      maxHeight: match[0] ? "200px" : "0"
                    }
                  }, React.createElement("ul", undefined, React.createElement("li", undefined, React.createElement("a", {
                                className: "text-sm block text-right hover:bg-white",
                                href: "https://docs.float.capital",
                                target: "_blank"
                              }, "View our docs")), React.createElement("li", undefined, React.createElement("a", {
                                className: "text-sm block text-right hover:bg-white",
                                href: "https://discord.gg/dqDwgrVYcU",
                                target: "_blank"
                              }, "Join our discord")))));
  }
}

var make = Lost;

export {
  make ,
  
}
/* react Not a pure module */
