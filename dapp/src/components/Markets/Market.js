// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Mint from "../../Mint.js";
import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Redeem from "../Redeem/Redeem.js";
import Link from "next/link";
import * as Belt_Array from "bs-platform/lib/es6/belt_Array.js";
import * as MarketCard from "./MarketCard.js";
import * as PriceGraph from "../PriceGraph.js";

function Market$Tab(Props) {
  var selectedOpt = Props.selected;
  var text = Props.text;
  var onClickOpt = Props.onClick;
  var selected = selectedOpt !== undefined ? selectedOpt : false;
  var onClick = onClickOpt !== undefined ? onClickOpt : (function (param) {
        
      });
  var bg = selected ? "bg-white" : "bg-gray-100";
  var opacity = selected ? "bg-opacity-70" : "opacity-70";
  var margin = selected ? "pb-1.5" : "mb-0.5";
  return React.createElement("li", {
              className: "mr-3 mb-0"
            }, React.createElement("div", {
                  className: bg + "  " + opacity + "  " + margin + " cursor-pointer inline-block rounded-t-lg py-1 px-4",
                  onClick: onClick
                }, text));
}

var Tab = {
  make: Market$Tab
};

var allTabs = [
  /* Mint */0,
  /* Redeem */1,
  /* Stake */2,
  /* Unstake */3
];

function tabToStr(tab) {
  switch (tab) {
    case /* Mint */0 :
        return "Mint";
    case /* Redeem */1 :
        return "Redeem";
    case /* Stake */2 :
        return "Stake";
    case /* Unstake */3 :
        return "Unstake";
    
  }
}

function Market$MarketInteractionCard(Props) {
  var match = React.useState(function () {
        return /* Mint */0;
      });
  var setSelected = match[1];
  var selected = match[0];
  return React.createElement("div", {
              className: "flex-1  p-1 mb-2 "
            }, React.createElement("ul", {
                  className: "list-reset flex items-end"
                }, Belt_Array.map(allTabs, (function (tab) {
                        return React.createElement(Market$Tab, {
                                    selected: tab === selected,
                                    text: tabToStr(tab),
                                    onClick: (function (param) {
                                        return Curry._1(setSelected, (function (param) {
                                                      return tab;
                                                    }));
                                      })
                                  });
                      }))), React.createElement("div", {
                  className: "rounded-b-lg rounded-r-lg flex flex-col bg-white bg-opacity-70 shadow-lg"
                }, selected !== 0 ? React.createElement(Mint.Mint.make, {}) : React.createElement(Mint.Mint.make, {})));
}

var MarketInteractionCard = {
  allTabs: allTabs,
  tabToStr: tabToStr,
  make: Market$MarketInteractionCard
};

function Market(Props) {
  var marketData = Props.marketData;
  return React.createElement("div", undefined, React.createElement(Link, {
                  href: "/markets",
                  children: React.createElement("div", {
                        className: "uppercase text-sm text-gray-600 hover:text-gray-500 cursor-pointer mt-2"
                      }, "◀", React.createElement("span", {
                            className: "text-xs"
                          }, " Back to markets"))
                }), React.createElement("div", {
                  className: "flex flex-col md:flex-row justify-center items-stretch"

                }, React.createElement(Market$MarketInteractionCard, {}), React.createElement("div", {

                      className: "flex-1 w-full min-h-10 p-1 mb-2 ml-8 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg"
                    }, React.createElement(PriceGraph.make, {
                          marketName: marketData.name
                        }))), React.createElement(MarketCard.make, {
                  marketData: marketData
                }));
}

var make = Market;

export {
  Tab ,
  MarketInteractionCard ,
  make ,
  
}
/* Mint Not a pure module */
