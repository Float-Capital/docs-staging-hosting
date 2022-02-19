(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[6018],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return u},kt:function(){return f}});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var l=r.createContext({}),s=function(e){var t=r.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},u=function(e){var t=s(e.components);return r.createElement(l.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,a=e.originalType,l=e.parentName,u=c(e,["components","mdxType","originalType","parentName"]),d=s(n),f=o,m=d["".concat(l,".").concat(f)]||d[f]||p[f]||a;return n?r.createElement(m,i(i({ref:t},u),{},{components:n})):r.createElement(m,i({ref:t},u))}));function f(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=n.length,i=new Array(a);i[0]=d;var c={};for(var l in t)hasOwnProperty.call(t,l)&&(c[l]=t[l]);c.originalType=e,c.mdxType="string"==typeof e?e:o,i[1]=c;for(var s=2;s<a;s++)i[s]=n[s];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}d.displayName="MDXCreateElement"},9432:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return c},contentTitle:function(){return l},metadata:function(){return s},toc:function(){return u},default:function(){return d}});var r=n(2122),o=n(9756),a=(n(7294),n(3905)),i=["components"],c={id:"governance",title:"Governance",sidebar_label:"Governance",slug:"/governance"},l=void 0,s={unversionedId:"governance",id:"governance",isDocsHomePage:!1,title:"Governance",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/governance.md",sourceDirName:".",slug:"/governance",permalink:"/docs/governance",editUrl:"https://github.com/Float-Capital/docs/governance.md",version:"current",frontMatter:{id:"governance",title:"Governance",sidebar_label:"Governance",slug:"/governance"},sidebar:"someSidebar",previous:{title:"Float Token",permalink:"/docs/float-token"},next:{title:"Addresses",permalink:"/docs/addresses"}},u=[],p={toc:u};function d(e){var t=e.components,c=(0,o.Z)(e,i);return(0,a.kt)("wrapper",(0,r.Z)({},p,c,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("sub",null,(0,a.kt)("sup",null," NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77 ")),(0,a.kt)("hr",null),(0,a.kt)("p",null,"Float token holders will govern important protocol decisions."),(0,a.kt)("p",null,(0,a.kt)("img",{alt:"governance",src:n(4749).Z})),(0,a.kt)("p",null,"The figure above shows the basic flow for the planned governance module. Proposals can be created by users with a sufficient Float balance."),(0,a.kt)("p",null,"Example proposals include"),(0,a.kt)("ol",null,(0,a.kt)("li",{parentName:"ol"},"New markets for the protocol."),(0,a.kt)("li",{parentName:"ol"},"Modifying fee percentages for minting and redeeming."),(0,a.kt)("li",{parentName:"ol"},"Modifying Float token supply parameters within certain\nbounds."),(0,a.kt)("li",{parentName:"ol"},"Whether to add oracles to the oracle manager or switch\noracle providers."),(0,a.kt)("li",{parentName:"ol"},"Choosing a new yield provider")),(0,a.kt)("p",null,"The community of Float token holders then vote on these proposal. While it is planned that the weight of a vote shall be increasing in the amount of Float a user holds, the exact voting mechanism is to be decided. Possibilities here include simple linear voting, quadratic voting, conviction voting and more. It is our aim to optimize the process for increased voter participation and negligible voter cost."),(0,a.kt)("p",null,"The governance module for the protocol is currently under active development."))}d.isMDXComponent=!0},4749:function(e,t,n){"use strict";t.Z=n.p+"assets/images/governance-bd0388f6aa202d341a69d23cf03a7c88.png"}}]);