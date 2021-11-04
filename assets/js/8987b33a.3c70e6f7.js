(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[972],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return u},kt:function(){return y}});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function s(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?s(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):s(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},s=Object.keys(e);for(r=0;r<s.length;r++)n=s[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var s=Object.getOwnPropertySymbols(e);for(r=0;r<s.length;r++)n=s[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var a=r.createContext({}),l=function(e){var t=r.useContext(a),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},u=function(e){var t=l(e.components);return r.createElement(a.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},f=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,s=e.originalType,a=e.parentName,u=c(e,["components","mdxType","originalType","parentName"]),f=l(n),y=o,h=f["".concat(a,".").concat(y)]||f[y]||p[y]||s;return n?r.createElement(h,i(i({ref:t},u),{},{components:n})):r.createElement(h,i({ref:t},u))}));function y(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var s=n.length,i=new Array(s);i[0]=f;var c={};for(var a in t)hasOwnProperty.call(t,a)&&(c[a]=t[a]);c.originalType=e,c.mdxType="string"==typeof e?e:o,i[1]=c;for(var l=2;l<s;l++)i[l]=n[l];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}f.displayName="MDXCreateElement"},159:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return c},contentTitle:function(){return a},metadata:function(){return l},toc:function(){return u},default:function(){return f}});var r=n(2122),o=n(9756),s=(n(7294),n(3905)),i=["components"],c={id:"synthetic-asset-tokens",title:"Synthetic Asset Tokens",sidebar_label:"Synthetic Asset Tokens",slug:"/synthetic-asset-tokens"},a=void 0,l={unversionedId:"synthetic-asset-tokens",id:"synthetic-asset-tokens",isDocsHomePage:!1,title:"Synthetic Asset Tokens",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/synthetic-asset-tokens.md",sourceDirName:".",slug:"/synthetic-asset-tokens",permalink:"/docs/synthetic-asset-tokens",editUrl:"https://github.com/docs/synthetic-asset-tokens.md",version:"current",frontMatter:{id:"synthetic-asset-tokens",title:"Synthetic Asset Tokens",sidebar_label:"Synthetic Asset Tokens",slug:"/synthetic-asset-tokens"},sidebar:"someSidebar",previous:{title:"Overview",permalink:"/docs/overview"},next:{title:"Float Token",permalink:"/docs/float-token"}},u=[],p={toc:u};function f(e){var t=e.components,n=(0,o.Z)(e,i);return(0,s.kt)("wrapper",(0,r.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,s.kt)("sub",null,(0,s.kt)("sup",null," NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77 ")),(0,s.kt)("hr",null),(0,s.kt)("p",null,"Two types of ",(0,s.kt)("a",{parentName:"p",href:"/docs/faqs#what-is-a-synthetic-asset"},"synthetic tokens")," are created for each synthetic market, which are synthetic long and synthetic short tokens. Synthetic long tokens benefit from the price appreciation \ud83d\udcc8 of the underlying asset. Synthetic short tokens benefit from the price depreciation \ud83d\udcc9 of the underlying asset."),(0,s.kt)("p",null,"I.e. Imagine the synthetic market is for Gold. If you buy $100 worth of long Gold tokens, and the price of Gold increase, the value of your token will increase."),(0,s.kt)("p",null,"These Synthetic Tokens are ERC20 tokens using the Open Zeppelin library which are created dynamically whenever a new synthetic market is created."),(0,s.kt)("p",null,(0,s.kt)("a",{parentName:"p",href:"/docs/addresses"},"View the synthetic token addresses here")))}f.isMDXComponent=!0}}]);