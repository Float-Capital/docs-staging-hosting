(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[5785],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return u},kt:function(){return d}});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function c(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=r.createContext({}),l=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},u=function(e){var t=l(e.components);return r.createElement(s.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},m=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,i=e.originalType,s=e.parentName,u=c(e,["components","mdxType","originalType","parentName"]),m=l(n),d=o,y=m["".concat(s,".").concat(d)]||m[d]||p[d]||i;return n?r.createElement(y,a(a({ref:t},u),{},{components:n})):r.createElement(y,a({ref:t},u))}));function d(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=n.length,a=new Array(i);a[0]=m;var c={};for(var s in t)hasOwnProperty.call(t,s)&&(c[s]=t[s]);c.originalType=e,c.mdxType="string"==typeof e?e:o,a[1]=c;for(var l=2;l<i;l++)a[l]=n[l];return r.createElement.apply(null,a)}return r.createElement.apply(null,n)}m.displayName="MDXCreateElement"},2081:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return c},contentTitle:function(){return s},metadata:function(){return l},toc:function(){return u},default:function(){return m}});var r=n(2122),o=n(9756),i=(n(7294),n(3905)),a=["components"],c={id:"mint",title:"Mint",sidebar_label:"Mint",slug:"/mint"},s=void 0,l={unversionedId:"mint",id:"mint",isDocsHomePage:!1,title:"Mint",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/mint.md",sourceDirName:".",slug:"/mint",permalink:"/docs/mint",editUrl:"https://github.com/docs/mint.md",version:"current",frontMatter:{id:"mint",title:"Mint",sidebar_label:"Mint",slug:"/mint"},sidebar:"someSidebar",previous:{title:"Addresses",permalink:"/docs/addresses"},next:{title:"Redeem",permalink:"/docs/redeem"}},u=[{value:"Minting Float synthetic tokens \ud83d\udcb0",id:"minting-float-synthetic-tokens-",children:[]},{value:"Buying Float synthetic tokens on a DEX",id:"buying-float-synthetic-tokens-on-a-dex",children:[]}],p={toc:u};function m(e){var t=e.components,n=(0,o.Z)(e,a);return(0,i.kt)("wrapper",(0,r.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("sub",null,(0,i.kt)("sup",null," NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77 ")),(0,i.kt)("hr",null),(0,i.kt)("h2",{id:"minting-float-synthetic-tokens-"},"Minting Float synthetic tokens \ud83d\udcb0"),(0,i.kt)("p",null,"Minting a token is how you can invest in a market. If you believe a market's price is going to go ",(0,i.kt)("em",{parentName:"p"},"up")," you can mint a long position in that market, inversely, if you believe a market's price is going to go ",(0,i.kt)("em",{parentName:"p"},"down")," then you would mint a short position in that market."),(0,i.kt)("p",null,"For example, if you would like $1 000 long exposure to a certain synthetic asset, you would visit the ",(0,i.kt)("a",{parentName:"p",href:"https://float.capital/"},"markets")," page and select to either ",(0,i.kt)("em",{parentName:"p"},"mint long")," or ",(0,i.kt)("em",{parentName:"p"},"mint short"),". Minting a long position would mint you $1 000 worth of long tokens, giving you long exposure to this synthetic asset."),(0,i.kt)("p",null,"Our synthetic markets currently accept DAI, allowing you to mint your synthetic position."),(0,i.kt)("iframe",{width:"560",height:"315",src:"https://www.youtube.com/embed/ByVBCyQpVvM",title:"YouTube video player",frameborder:"0",allow:"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",allowfullscreen:!0}),(0,i.kt)("h2",{id:"buying-float-synthetic-tokens-on-a-dex"},"Buying Float synthetic tokens on a DEX"),(0,i.kt)("p",null,"You can also simply buy synthetic Float tokens off a decentralized exchange such as ",(0,i.kt)("a",{parentName:"p",href:"https://quickswap.exchange/"},"quickswap")," (liquidity pool coming soon) instead of minting exposure directly from the smart contracts."))}m.isMDXComponent=!0}}]);