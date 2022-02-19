(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[3122],{3905:function(t,e,r){"use strict";r.d(e,{Zo:function(){return p},kt:function(){return m}});var n=r(7294);function a(t,e,r){return e in t?Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}):t[e]=r,t}function o(t,e){var r=Object.keys(t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(t);e&&(n=n.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),r.push.apply(r,n)}return r}function l(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{};e%2?o(Object(r),!0).forEach((function(e){a(t,e,r[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(r)):o(Object(r)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(r,e))}))}return t}function i(t,e){if(null==t)return{};var r,n,a=function(t,e){if(null==t)return{};var r,n,a={},o=Object.keys(t);for(n=0;n<o.length;n++)r=o[n],e.indexOf(r)>=0||(a[r]=t[r]);return a}(t,e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(t);for(n=0;n<o.length;n++)r=o[n],e.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(t,r)&&(a[r]=t[r])}return a}var s=n.createContext({}),c=function(t){var e=n.useContext(s),r=e;return t&&(r="function"==typeof t?t(e):l(l({},e),t)),r},p=function(t){var e=c(t.components);return n.createElement(s.Provider,{value:e},t.children)},u={inlineCode:"code",wrapper:function(t){var e=t.children;return n.createElement(n.Fragment,{},e)}},d=n.forwardRef((function(t,e){var r=t.components,a=t.mdxType,o=t.originalType,s=t.parentName,p=i(t,["components","mdxType","originalType","parentName"]),d=c(r),m=a,g=d["".concat(s,".").concat(m)]||d[m]||u[m]||o;return r?n.createElement(g,l(l({ref:e},p),{},{components:r})):n.createElement(g,l({ref:e},p))}));function m(t,e){var r=arguments,a=e&&e.mdxType;if("string"==typeof t||a){var o=r.length,l=new Array(o);l[0]=d;var i={};for(var s in e)hasOwnProperty.call(e,s)&&(i[s]=e[s]);i.originalType=t,i.mdxType="string"==typeof t?t:a,l[1]=i;for(var c=2;c<o;c++)l[c]=r[c];return n.createElement.apply(null,l)}return n.createElement.apply(null,r)}d.displayName="MDXCreateElement"},6768:function(t,e,r){"use strict";r.r(e),r.d(e,{frontMatter:function(){return i},contentTitle:function(){return s},metadata:function(){return c},toc:function(){return p},default:function(){return d}});var n=r(2122),a=r(9756),o=(r(7294),r(3905)),l=["components"],i={id:"gas-costs",title:"Gas Costs",sidebar_label:"Gas Costs",slug:"/gas-costs"},s=void 0,c={unversionedId:"gas-costs",id:"gas-costs",isDocsHomePage:!1,title:"Gas Costs",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/gas-costs.md",sourceDirName:".",slug:"/gas-costs",permalink:"/docs/gas-costs",editUrl:"https://github.com/docs/gas-costs.md",version:"current",frontMatter:{id:"gas-costs",title:"Gas Costs",sidebar_label:"Gas Costs",slug:"/gas-costs"},sidebar:"someSidebar",previous:{title:"Stake",permalink:"/docs/stake"},next:{title:"Smart Contracts",permalink:"/docs/smart-contracts"}},p=[{value:"Polygon gas \u26fd",id:"polygon-gas-",children:[]},{value:"Avalanche gas \u26fd",id:"avalanche-gas-",children:[]}],u={toc:p};function d(t){var e=t.components,r=(0,a.Z)(t,l);return(0,o.kt)("wrapper",(0,n.Z)({},u,r,{components:e,mdxType:"MDXLayout"}),(0,o.kt)("sub",null,(0,o.kt)("sup",null," NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77 ")),(0,o.kt)("hr",null),(0,o.kt)("h2",{id:"polygon-gas-"},"Polygon gas \u26fd"),(0,o.kt)("p",null,"Note these costs are subject to change:"),(0,o.kt)("table",null,(0,o.kt)("thead",{parentName:"table"},(0,o.kt)("tr",{parentName:"thead"},(0,o.kt)("th",{parentName:"tr",align:null},"Contract function"),(0,o.kt)("th",{parentName:"tr",align:"center"},"Gas Used"),(0,o.kt)("th",{parentName:"tr",align:"right"},"Estimated Polygon cost at 50 gwei/gas"))),(0,o.kt)("tbody",{parentName:"table"},(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Mint"),(0,o.kt)("td",{parentName:"tr",align:"center"},"600 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$0.01")),(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Stake"),(0,o.kt)("td",{parentName:"tr",align:"center"},"100 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$0.0015")),(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Redeem"),(0,o.kt)("td",{parentName:"tr",align:"center"},"300 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$0.005")),(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Claim"),(0,o.kt)("td",{parentName:"tr",align:"center"},"375 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$0.006")))),(0,o.kt)("h2",{id:"avalanche-gas-"},"Avalanche gas \u26fd"),(0,o.kt)("p",null,"Note these costs are subject to change:"),(0,o.kt)("table",null,(0,o.kt)("thead",{parentName:"table"},(0,o.kt)("tr",{parentName:"thead"},(0,o.kt)("th",{parentName:"tr",align:null},"Contract function"),(0,o.kt)("th",{parentName:"tr",align:"center"},"Gas Used"),(0,o.kt)("th",{parentName:"tr",align:"right"},"Estimated Avalanche cost at 30 gwei/gas"))),(0,o.kt)("tbody",{parentName:"table"},(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Mint"),(0,o.kt)("td",{parentName:"tr",align:"center"},"450 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$1.62")),(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Stake"),(0,o.kt)("td",{parentName:"tr",align:"center"},"410 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$1.58")),(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Redeem"),(0,o.kt)("td",{parentName:"tr",align:"center"},"360 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$1.38")),(0,o.kt)("tr",{parentName:"tbody"},(0,o.kt)("td",{parentName:"tr",align:null},"Claim"),(0,o.kt)("td",{parentName:"tr",align:"center"},"120 000"),(0,o.kt)("td",{parentName:"tr",align:"right"},"$0.40")))))}d.isMDXComponent=!0}}]);