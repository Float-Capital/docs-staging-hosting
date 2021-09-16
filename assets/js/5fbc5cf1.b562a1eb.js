(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[207],{3905:function(e,t,r){"use strict";r.d(t,{Zo:function(){return u},kt:function(){return f}});var n=r(7294);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function o(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function l(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?o(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):o(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function i(e,t){if(null==e)return{};var r,n,a=function(e,t){if(null==e)return{};var r,n,a={},o=Object.keys(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||(a[r]=e[r]);return a}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(n=0;n<o.length;n++)r=o[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(a[r]=e[r])}return a}var c=n.createContext({}),p=function(e){var t=n.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):l(l({},t),e)),r},u=function(e){var t=p(e.components);return n.createElement(c.Provider,{value:t},e.children)},s={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},h=n.forwardRef((function(e,t){var r=e.components,a=e.mdxType,o=e.originalType,c=e.parentName,u=i(e,["components","mdxType","originalType","parentName"]),h=p(r),f=a,d=h["".concat(c,".").concat(f)]||h[f]||s[f]||o;return r?n.createElement(d,l(l({ref:t},u),{},{components:r})):n.createElement(d,l({ref:t},u))}));function f(e,t){var r=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var o=r.length,l=new Array(o);l[0]=h;var i={};for(var c in t)hasOwnProperty.call(t,c)&&(i[c]=t[c]);i.originalType=e,i.mdxType="string"==typeof e?e:a,l[1]=i;for(var p=2;p<o;p++)l[p]=r[p];return n.createElement.apply(null,l)}return n.createElement.apply(null,r)}h.displayName="MDXCreateElement"},1203:function(e,t,r){"use strict";r.r(t),r.d(t,{frontMatter:function(){return i},contentTitle:function(){return c},metadata:function(){return p},toc:function(){return u},default:function(){return h}});var n=r(2122),a=r(9756),o=(r(7294),r(3905)),l=["components"],i={id:"api",title:"API",sidebar_label:"API",slug:"/api"},c=void 0,p={unversionedId:"api",id:"api",isDocsHomePage:!1,title:"API",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/api.md",sourceDirName:".",slug:"/api",permalink:"/docs/api",editUrl:"https://github.com/docs/api.md",version:"current",frontMatter:{id:"api",title:"API",sidebar_label:"API",slug:"/api"},sidebar:"someSidebar",previous:{title:"Smart Contracts",permalink:"/docs/smart-contracts"},next:{title:"Resources",permalink:"/docs/resources"}},u=[{value:"Testnet \ud83d\udd17",id:"testnet-",children:[]},{value:"Polygon Alpha Launch",id:"polygon-alpha-launch",children:[]},{value:"Polygon Main Launch",id:"polygon-main-launch",children:[]}],s={toc:u};function h(e){var t=e.components,r=(0,a.Z)(e,l);return(0,o.kt)("wrapper",(0,n.Z)({},s,r,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("sub",null,(0,o.kt)("sup",null," NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77 ")),(0,o.kt)("hr",null),(0,o.kt)("p",null,"Float Capital uses ",(0,o.kt)("a",{parentName:"p",href:"https://thegraph.com/"},"TheGraph"),", a GraphQL API, for querying data from our smart contracts. We will be releasing examples soon on how you can make requests to our GraphQL server."),(0,o.kt)("h2",{id:"testnet-"},"Testnet \ud83d\udd17"),(0,o.kt)("p",null,"The protocol is deployed on the Mumbai testnet. See our Mumbai subgraph ",(0,o.kt)("a",{parentName:"p",href:"https://test.graph.float.capital/subgraphs/name/float-capital/float-capital"},"here"),"."),(0,o.kt)("h2",{id:"polygon-alpha-launch"},"Polygon Alpha Launch"),(0,o.kt)("p",null,"Checkout out details on our alpha launch ",(0,o.kt)("a",{parentName:"p",href:"/docs/alpha"},"here"),". See our alpha subgraph on the polygon network ",(0,o.kt)("a",{parentName:"p",href:"/docs/alpha"},"here"),"."),(0,o.kt)("h2",{id:"polygon-main-launch"},"Polygon Main Launch"),(0,o.kt)("p",null,"Subgraph (Coming soon)"))}h.isMDXComponent=!0}}]);