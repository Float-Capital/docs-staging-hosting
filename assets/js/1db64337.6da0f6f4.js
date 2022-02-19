(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[1372],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return u},kt:function(){return h}});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=r.createContext({}),c=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},u=function(e){var t=c(e.components);return r.createElement(s.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},p=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,i=e.originalType,s=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=c(n),h=o,f=p["".concat(s,".").concat(h)]||p[h]||d[h]||i;return n?r.createElement(f,a(a({ref:t},u),{},{components:n})):r.createElement(f,a({ref:t},u))}));function h(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=n.length,a=new Array(i);a[0]=p;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:o,a[1]=l;for(var c=2;c<i;c++)a[c]=n[c];return r.createElement.apply(null,a)}return r.createElement.apply(null,n)}p.displayName="MDXCreateElement"},3099:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return l},contentTitle:function(){return s},metadata:function(){return c},toc:function(){return u},default:function(){return p}});var r=n(2122),o=n(9756),i=(n(7294),n(3905)),a=["components"],l={id:"overview",title:"Overview",sidebar_label:"Overview",slug:"/overview"},s=void 0,c={unversionedId:"overview",id:"overview",isDocsHomePage:!1,title:"Overview",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/overview.md",sourceDirName:".",slug:"/overview",permalink:"/docs/overview",editUrl:"https://github.com/docs/overview.md",version:"current",frontMatter:{id:"overview",title:"Overview",sidebar_label:"Overview",slug:"/overview"},sidebar:"someSidebar",previous:{title:"Security",permalink:"/docs/security"},next:{title:"Magic Internet Tokens",permalink:"/docs/magic-internet-assets"}},u=[{value:"Basics of the protocol",id:"basics-of-the-protocol",children:[]},{value:"Incentives \ud83d\udcb0",id:"incentives-",children:[{value:"Yield enhancement \ud83d\udcc8",id:"yield-enhancement-",children:[]},{value:"Float token supply rate",id:"float-token-supply-rate",children:[]}]}],d={toc:u};function p(e){var t=e.components,n=(0,o.Z)(e,a);return(0,i.kt)("wrapper",(0,r.Z)({},d,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("sub",null,(0,i.kt)("sup",null," NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77 ")),(0,i.kt)("hr",null),(0,i.kt)("h2",{id:"basics-of-the-protocol"},"Basics of the protocol"),(0,i.kt)("p",null,"In its most basic form, the Float Capital protocol creates a 'peer-to-peer' exposure market where long positions on a market, are offset by short positions on that same market."),(0,i.kt)("p",null,"For example, Imagine Alice has $100 000 of short exposure to a market, while Bob had $100 000 of long exposure to this market. Given this equilibrium, a 1% decrease in the underlying asset price would mean that Alice now has $101 000 of value while bob has $99 000 of value."),(0,i.kt)("p",null,"Given the value of long and short sides are no longer equal, there will be floating exposure. In this case, the short side will only have 99 000 / 101 000 = 98% exposure. Strong incentives exist to always keep exposure close to 100% for both sides."),(0,i.kt)("h2",{id:"incentives-"},"Incentives \ud83d\udcb0"),(0,i.kt)("p",null,"In order to incentivize users to gain exposure to both sides, the long and the short, of the market the float protocol uses two mechanisms; yield enhancement and float token supply rate."),(0,i.kt)("h3",{id:"yield-enhancement-"},"Yield enhancement \ud83d\udcc8"),(0,i.kt)("p",null,"The primary mechanism to incentivize a balancing in the market is through splitting the yield from the underlying collateral to the under-balanced side of the market."),(0,i.kt)("p",null,"For example, Imagine a market with two participants, Alice with a $100 000 long position and Bob with a $500 000 short position. This means there is a total value of $600 000 in the market. The long side of the market is under-balanced and so earns all of the underlying yield. To further expand on this, let's say the annual yield given by Aave for DAI is 10%, if Alice were to deposit her $100 000 in Aave directly she would earn 10% or a $10 000 yield. Alice being in the under-balanced side of the market now earns interest on the total $600 000 in the market, which is $60 000 or 60% of her $100 000 position. In reality the yield is not fixed to 10% but the variable yield floats between 5% - 15% depending on the demand dictated by the borrowers."),(0,i.kt)("h3",{id:"float-token-supply-rate"},"Float token supply rate"),(0,i.kt)("p",null,"Minting a position and staking your market tokens earns Float tokens (",(0,i.kt)("a",{parentName:"p",href:"/docs/float-token"},"Read more on float tokens here"),"). The Float token generation supply rate is greater for the under-balanced side of the market. This is a reward mechanism for users adding ",(0,i.kt)("em",{parentName:"p"},"good liquidity")," to the system. Further incentivizing users to take part in the under-balanced side of the market."),(0,i.kt)("p",null,"Balancing of the market is often dictated by what the actual market is. Some markets by design will naturally have equal amounts of long and short sellers, for example a magic internet asset that follows the cost of gas prices on the ethereum blockchain will tend to fluctuate within a range and therefore it will be more prone to equal amounts of long and short sellers."))}p.isMDXComponent=!0}}]);