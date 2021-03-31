// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "bs-platform/lib/es6/curry.js";
import * as React from "react";
import * as Recharts from "recharts";
import * as BsRecharts__XAxis from "@ahrefs/bs-recharts/src/BsRecharts__XAxis.js";
import * as BsRecharts__YAxis from "@ahrefs/bs-recharts/src/BsRecharts__YAxis.js";
import * as BsRecharts__Tooltip from "@ahrefs/bs-recharts/src/BsRecharts__Tooltip.js";
import * as BsRecharts__ResponsiveContainer from "@ahrefs/bs-recharts/src/BsRecharts__ResponsiveContainer.js";

function LineGraph(Props) {
  var data = [
    {
      name: "Page A",
      uv: 4000,
      pv: 2400,
      amt: 2400
    },
    {
      name: "Page B",
      uv: 3000,
      pv: 1398,
      amt: 2210
    },
    {
      name: "Page C",
      uv: 2000,
      pv: 9800,
      amt: 2290
    },
    {
      name: "Page D",
      uv: 2780,
      pv: 3908,
      amt: 2000
    },
    {
      name: "Page E",
      uv: 1890,
      pv: 4800,
      amt: 2181
    },
    {
      name: "Page F",
      uv: 2390,
      pv: 3800,
      amt: 2500
    },
    {
      name: "Page G",
      uv: 3490,
      pv: 4300,
      amt: 2100
    }
  ];
  return React.createElement(Recharts.ResponsiveContainer, Curry._3(BsRecharts__ResponsiveContainer.makeProps({
                        TAG: 0,
                        _0: 200,
                        [Symbol.for("name")]: "Px"
                      }, {
                        TAG: 0,
                        _0: 300,
                        [Symbol.for("name")]: "Px"
                      })(undefined, undefined, undefined, undefined, undefined), React.createElement(Recharts.LineChart, {
                      data: data,
                      margin: {
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0
                      },
                      children: null
                    }, React.createElement(Recharts.Line, {
                          dataKey: "pv",
                          stroke: "#2078b4"
                        }), React.createElement(Recharts.Tooltip, Curry.app(BsRecharts__Tooltip.makeProps(undefined)(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined), [
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
                              undefined
                            ])), React.createElement(Recharts.XAxis, Curry.app(BsRecharts__XAxis.makeProps(undefined)(undefined, undefined, undefined, undefined, undefined, undefined, "name", undefined, undefined, undefined), [
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
                              undefined,
                              undefined
                            ])), React.createElement(Recharts.YAxis, Curry.app(BsRecharts__YAxis.makeProps(undefined)(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined), [
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
                              undefined
                            ]))), undefined, undefined));
}

var make = LineGraph;

export {
  make ,
  
}
/* react Not a pure module */
