// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function Masonry$Container(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "w-full flex flex-col md:flex-row justify-between"
            }, children);
}

var Container = {
  make: Masonry$Container
};

function Masonry$Divider(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "w-full md:w-1/3 px-3 md:px-0 m-0 md:m-4"
            }, children);
}

var Divider = {
  make: Masonry$Divider
};

function Masonry$Card(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-2 md:mb-5"
            }, children);
}

var Card = {
  make: Masonry$Card
};

function Masonry$Header(Props) {
  var children = Props.children;
  return React.createElement("h1", {
              className: "font-bold text-center pt-5 text-lg font-alphbeta"
            }, children);
}

var Header = {
  make: Masonry$Header
};

export {
  Container ,
  Divider ,
  Card ,
  Header ,
  
}
/* react Not a pure module */
