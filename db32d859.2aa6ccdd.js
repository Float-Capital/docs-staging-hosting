(window.webpackJsonp=window.webpackJsonp||[]).push([[21],{89:function(e,t,r){"use strict";r.r(t),r.d(t,"frontMatter",(function(){return i})),r.d(t,"metadata",(function(){return c})),r.d(t,"toc",(function(){return s})),r.d(t,"default",(function(){return u}));var n=r(3),o=r(7),a=(r(0),r(94)),i={id:"security",title:"Security",sidebar_label:"Security",slug:"/security"},c={unversionedId:"security",id:"security",isDocsHomePage:!1,title:"Security",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/security.md",slug:"/security",permalink:"/docs/security",editUrl:"https://github.com/docs/security.md",version:"current",sidebar_label:"Security",sidebar:"someSidebar",previous:{title:"FAQs",permalink:"/docs/faqs"},next:{title:"Overview",permalink:"/docs/overview"}},s=[],l={toc:s};function u(e){var t=e.components,r=Object(o.a)(e,["components"]);return Object(a.b)("wrapper",Object(n.a)({},l,r,{components:t,mdxType:"MDXLayout"}),Object(a.b)("p",null,"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77"),Object(a.b)("hr",null),Object(a.b)("p",null,"Security is something Float takes really seriously. Protocols we have engineered and released in the past for clients hold more than $30 000 000 dollars in value and see daily interaction. Its a great responsibility to engineer safe code that allows users to feel safe when interacting with the protocol."),Object(a.b)("p",null,"To give you a better idea of our smart contract flow, before any code is merged into master, we have other engineers review the changes manually. We also have continuous integration testing in place where a suite of smart contract tests we have written trigger and run before any changes can be merged in. Having audited other protocols in the past, we are acutely aware of many attack vectors and always pay attention to these."),Object(a.b)("p",null,"We are in the process of recording videos where we deep dive and talk through the smart contracts to help give users a better understanding of the underlying protocol."),Object(a.b)("p",null,"We recommend all users to always carefully review protocol code and do detailed research before interacting with any protocol, including Float Capital. Remember, there is no such things as a free lunch, no matter how attractive things may appear!"))}u.isMDXComponent=!0},94:function(e,t,r){"use strict";r.d(t,"a",(function(){return p})),r.d(t,"b",(function(){return y}));var n=r(0),o=r.n(n);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function i(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function c(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?i(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):i(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function s(e,t){if(null==e)return{};var r,n,o=function(e,t){if(null==e)return{};var r,n,o={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var l=o.a.createContext({}),u=function(e){var t=o.a.useContext(l),r=t;return e&&(r="function"==typeof e?e(t):c(c({},t),e)),r},p=function(e){var t=u(e.components);return o.a.createElement(l.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return o.a.createElement(o.a.Fragment,{},t)}},f=o.a.forwardRef((function(e,t){var r=e.components,n=e.mdxType,a=e.originalType,i=e.parentName,l=s(e,["components","mdxType","originalType","parentName"]),p=u(r),f=n,y=p["".concat(i,".").concat(f)]||p[f]||d[f]||a;return r?o.a.createElement(y,c(c({ref:t},l),{},{components:r})):o.a.createElement(y,c({ref:t},l))}));function y(e,t){var r=arguments,n=t&&t.mdxType;if("string"==typeof e||n){var a=r.length,i=new Array(a);i[0]=f;var c={};for(var s in t)hasOwnProperty.call(t,s)&&(c[s]=t[s]);c.originalType=e,c.mdxType="string"==typeof e?e:n,i[1]=c;for(var l=2;l<a;l++)i[l]=r[l];return o.a.createElement.apply(null,i)}return o.a.createElement.apply(null,r)}f.displayName="MDXCreateElement"}}]);