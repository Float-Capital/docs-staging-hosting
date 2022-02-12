(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[4842],{3905:function(t,e,n){"use strict";n.d(e,{Zo:function(){return u},kt:function(){return h}});var a=n(7294);function r(t,e,n){return e in t?Object.defineProperty(t,e,{value:n,enumerable:!0,configurable:!0,writable:!0}):t[e]=n,t}function o(t,e){var n=Object.keys(t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(t);e&&(a=a.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),n.push.apply(n,a)}return n}function i(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{};e%2?o(Object(n),!0).forEach((function(e){r(t,e,n[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(n,e))}))}return t}function l(t,e){if(null==t)return{};var n,a,r=function(t,e){if(null==t)return{};var n,a,r={},o=Object.keys(t);for(a=0;a<o.length;a++)n=o[a],e.indexOf(n)>=0||(r[n]=t[n]);return r}(t,e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(t);for(a=0;a<o.length;a++)n=o[a],e.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(t,n)&&(r[n]=t[n])}return r}var p=a.createContext({}),s=function(t){var e=a.useContext(p),n=e;return t&&(n="function"==typeof t?t(e):i(i({},e),t)),n},u=function(t){var e=s(t.components);return a.createElement(p.Provider,{value:e},t.children)},c={inlineCode:"code",wrapper:function(t){var e=t.children;return a.createElement(a.Fragment,{},e)}},d=a.forwardRef((function(t,e){var n=t.components,r=t.mdxType,o=t.originalType,p=t.parentName,u=l(t,["components","mdxType","originalType","parentName"]),d=s(n),h=r,m=d["".concat(p,".").concat(h)]||d[h]||c[h]||o;return n?a.createElement(m,i(i({ref:e},u),{},{components:n})):a.createElement(m,i({ref:e},u))}));function h(t,e){var n=arguments,r=e&&e.mdxType;if("string"==typeof t||r){var o=n.length,i=new Array(o);i[0]=d;var l={};for(var p in e)hasOwnProperty.call(e,p)&&(l[p]=e[p]);l.originalType=t,l.mdxType="string"==typeof t?t:r,i[1]=l;for(var s=2;s<o;s++)i[s]=n[s];return a.createElement.apply(null,i)}return a.createElement.apply(null,n)}d.displayName="MDXCreateElement"},1436:function(t,e,n){"use strict";n.r(e),n.d(e,{frontMatter:function(){return l},contentTitle:function(){return p},metadata:function(){return s},toc:function(){return u},default:function(){return d}});var a=n(2122),r=n(9756),o=(n(7294),n(3905)),i=["components"],l={id:"trade-crypto-volatility",title:"Markets unpredictable? Trade volatility.",sidebar_label:"Markets unpredictable? Trade volatility.",slug:"/markets-unpredictable-trade-volatility"},p=void 0,s={permalink:"/blog/markets-unpredictable-trade-volatility",source:"@site/blog/2021-12-23-trade-crypto-volatility.md",title:"Markets unpredictable? Trade volatility.",description:"This is huge.",date:"2021-12-23T00:00:00.000Z",formattedDate:"December 23, 2021",tags:[],readingTime:2.77,truncated:!0,prevItem:{title:"We found the missing link. It was LINK.",permalink:"/blog/we-found-the-missing-link"},nextItem:{title:"Go delta neutral on JOE for dank APR",permalink:"/blog/delta-neutral-joe"}},u=[{value:"Building strats around CVI",id:"building-strats-around-cvi",children:[]},{value:"Big opportunities for CVI arbitrage",id:"big-opportunities-for-cvi-arbitrage",children:[]}],c={toc:u};function d(t){var e=t.components,n=(0,r.Z)(t,i);return(0,o.kt)("wrapper",(0,a.Z)({},c,n,{components:e,mdxType:"MDXLayout"}),(0,o.kt)("img",{src:"/blog-assets/CVI/cvi-launch.png",alt:"cvi launch",width:"100%"}),(0,o.kt)("p",null,"This is huge."),(0,o.kt)("p",null,"We just shipped a ",(0,o.kt)("a",{parentName:"p",href:"https://float.capital/app/markets?marketIndex=5&actionOption=short"},"CVI market"),". Now you can long and short volatility itself."),(0,o.kt)("p",null,"The CVI, or Crypto Volatility Index, tracks the volatility of crypto markets. Lots of price movement = index go up. Price stagnation = index go down."),(0,o.kt)("p",null,"In Float Capital, a long position would appreciate from increased volatility in the markets, and shorts would appreciate from decreasing volatility."),(0,o.kt)("p",null,"But more than just minting a position to try and predict volatility, the CVI can add a lot of value to a DeFi portfolio. Here\u2019s how."),(0,o.kt)("h2",{id:"building-strats-around-cvi"},"Building strats around CVI"),(0,o.kt)("p",null,"There are some power ways you can build CVI exposure into your DeFi strat."),(0,o.kt)("p",null,"Say you\u2019re sitting on a whole bunch of staked positions, or just have a big holding of volatile assets, and you\u2019re worried about a big price drop or bear market."),(0,o.kt)("p",null,"You could open a long on the CVI. Price drops = more volatility, which means a long position benefits."),(0,o.kt)("p",null,"Or say you\u2019re day trading ETH in our ",(0,o.kt)("a",{parentName:"p",href:"https://float.capital/app/markets?marketIndex=2&actionOption=short"},"3x leveraged ETH market"),". To get real value out of day trading, you\u2019re gonna need a lot of volatility."),(0,o.kt)("p",null,"An advanced degen could hedge their day trading chaos by shorting CVI, so that if the markets don\u2019t have much movement, they can still potentially have a winning position."),(0,o.kt)("p",null,"Now let\u2019s say you\u2019re running a delta neutral strat in our ",(0,o.kt)("a",{parentName:"p",href:"https://docs.float.capital/blog/hedge-your-ohm-position/"},"OHM"),", ",(0,o.kt)("a",{parentName:"p",href:"https://docs.float.capital/blog/axs-magic-internet-asset/"},"AXS")," or ",(0,o.kt)("a",{parentName:"p",href:"https://docs.float.capital/blog/delta-neutral-joe/"},"JOE")," market. You\u2019re effectively covered against price volatility, but you\u2019re worried that you\u2019re going to miss out on a big bull run."),(0,o.kt)("p",null,"Boom. Long CVI."),(0,o.kt)("p",null,"Reduced risk delta neutral rewards roll in, and your long CVI position gets big and green when the price moves."),(0,o.kt)("p",null,"Not bad, hey?"),(0,o.kt)("h2",{id:"big-opportunities-for-cvi-arbitrage"},"Big opportunities for CVI arbitrage"),(0,o.kt)("p",null,"Our CVI market isn\u2019t the first such market on-chain."),(0,o.kt)("p",null,"Credit for building this on-chain index goes to the team at ",(0,o.kt)("a",{parentName:"p",href:"https://cvi.finance/"},"CVI")," / ",(0,o.kt)("a",{parentName:"p",href:"https://coti.io/"},"COTI"),"."),(0,o.kt)("p",null,"They identified the need for an on-chain volatility index, and helped ",(0,o.kt)("a",{parentName:"p",href:"https://chain.link/"},"Chainlink")," build the CVI price feed that powers our market."),(0,o.kt)("p",null,"Originally they were the only platform on-chain that allowed for CVI exposure. Now we have one too."),(0,o.kt)("p",null,"That\u2019s a good thing for everyone."),(0,o.kt)("p",null,"Institutional investors, the big dogs, with fat stacks of cash, like having multiple options."),(0,o.kt)("p",null,"Multiple CVI markets will help investors go delta neutral on the market, offsetting long exposure in one protocol with short exposure in another, allowing for reduced risk mining of rewards and incentives."),(0,o.kt)("p",null,"The CVI is the blockchain equivalent of one of TradFi\u2019s most degen indexes, the ",(0,o.kt)("a",{parentName:"p",href:"https://www.investopedia.com/terms/v/vix.asp"},"VIX"),"."),(0,o.kt)("p",null,"The index draws on data from mainstream exchanges, using the prices from 30 day options."),(0,o.kt)("p",null,"These options create an index that tracks the perceived volatility of the crypto markets in the near future."),(0,o.kt)("hr",null),(0,o.kt)("p",null,"This piece is not financial advice. Any kind of DeFi activity comes with risk, and should only be attempted by serious degens who understand this and know how to navigate it."),(0,o.kt)("p",null,"To mint a position in our CVI market go ",(0,o.kt)("a",{parentName:"p",href:"https://float.capital/app/markets?marketIndex=5&actionOption=short"},"here"),"."),(0,o.kt)("p",null,"To learn more about the risks inherent with using Float, read our blog post ",(0,o.kt)("a",{parentName:"p",href:"https://docs.float.capital/blog/apeing-in-responsibly"},"here"),"."),(0,o.kt)("p",null,"To understand how the protocol and our magic internet assets work, read our ",(0,o.kt)("a",{parentName:"p",href:"https://docs.float.capital/docs/"},"docs"),"."),(0,o.kt)("p",null,"If you want to meet the team behind Float Capital, claim your ",(0,o.kt)("a",{parentName:"p",href:"https://docs.float.capital/docs/gems"},"gem role"),", or hang out, come to our ",(0,o.kt)("a",{parentName:"p",href:"https://discord.gg/Ehwz87yTnV"},"Discord"),"."),(0,o.kt)("p",null,"This piece was written by ",(0,o.kt)("a",{parentName:"p",href:"https://twitter.com/CampbellEaston"},"Campbell Easton"),", ",(0,o.kt)("a",{parentName:"p",href:"https://twitter.com/jonjonclark"},"Jon Jon Clark")," and ",(0,o.kt)("a",{parentName:"p",href:"https://twitter.com/DenhamPreen"},"Denham Preen"),"."))}d.isMDXComponent=!0}}]);