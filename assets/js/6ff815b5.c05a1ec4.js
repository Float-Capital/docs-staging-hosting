(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[2909],{3905:function(e,t,a){"use strict";a.d(t,{Zo:function(){return d},kt:function(){return u}});var i=a(7294);function o(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function n(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,i)}return a}function r(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?n(Object(a),!0).forEach((function(t){o(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):n(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function l(e,t){if(null==e)return{};var a,i,o=function(e,t){if(null==e)return{};var a,i,o={},n=Object.keys(e);for(i=0;i<n.length;i++)a=n[i],t.indexOf(a)>=0||(o[a]=e[a]);return o}(e,t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);for(i=0;i<n.length;i++)a=n[i],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(o[a]=e[a])}return o}var s=i.createContext({}),h=function(e){var t=i.useContext(s),a=t;return e&&(a="function"==typeof e?e(t):r(r({},t),e)),a},d=function(e){var t=h(e.components);return i.createElement(s.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return i.createElement(i.Fragment,{},t)}},p=i.forwardRef((function(e,t){var a=e.components,o=e.mdxType,n=e.originalType,s=e.parentName,d=l(e,["components","mdxType","originalType","parentName"]),p=h(a),u=o,y=p["".concat(s,".").concat(u)]||p[u]||c[u]||n;return a?i.createElement(y,r(r({ref:t},d),{},{components:a})):i.createElement(y,r({ref:t},d))}));function u(e,t){var a=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var n=a.length,r=new Array(n);r[0]=p;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:o,r[1]=l;for(var h=2;h<n;h++)r[h]=a[h];return i.createElement.apply(null,r)}return i.createElement.apply(null,a)}p.displayName="MDXCreateElement"},2730:function(e,t,a){"use strict";a.r(t),a.d(t,{frontMatter:function(){return l},contentTitle:function(){return s},metadata:function(){return h},toc:function(){return d},default:function(){return p}});var i=a(2122),o=a(9756),n=(a(7294),a(3905)),r=["components"],l={id:"volatility-decay-intro",title:"Why you won\u2019t have nightmares about volatility decay on Float Capital.",sidebar_label:"Volatility Decay",slug:"/volatility-decay-intro"},s=void 0,h={permalink:"/blog/volatility-decay-intro",source:"@site/blog/2021-12-07-volatility-decay-intro.md",title:"Why you won\u2019t have nightmares about volatility decay on Float Capital.",description:"In this blog we will explore the concept of volatility decay on leveraged assets, which often keeps investors up at night and why this won\u2019t be the case for users on Float Capital.",date:"2021-12-07T00:00:00.000Z",formattedDate:"December 7, 2021",tags:[],readingTime:6.515,truncated:!1,nextItem:{title:"We\u2019re shipping a funding rate. Here\u2019s why and how.",permalink:"/blog/shipping-a-funding-rate"}},d=[{value:"What is volatility decay?",id:"what-is-volatility-decay",children:[]},{value:"What does it look like on Float Capital?",id:"what-does-it-look-like-on-float-capital",children:[{value:"Exposure to the price movements",id:"exposure-to-the-price-movements",children:[]},{value:"Leverage employed",id:"leverage-employed",children:[]},{value:"Absolute difference in price between entry and exit",id:"absolute-difference-in-price-between-entry-and-exit",children:[]},{value:"Magnitude of underlying price movements",id:"magnitude-of-underlying-price-movements",children:[]},{value:"Volatility Decay for short side of 2-OHM market",id:"volatility-decay-for-short-side-of-2-ohm-market",children:[]}]},{value:"In Summary",id:"in-summary",children:[]}],c={toc:d};function p(e){var t=e.components,a=(0,o.Z)(e,r);return(0,n.kt)("wrapper",(0,i.Z)({},c,a,{components:t,mdxType:"MDXLayout"}),(0,n.kt)("img",{src:"/blog-assets/volatility-decay-intro/sleeping-pepe.png",alt:"Sleeping Pepe",width:"100%"}),(0,n.kt)("p",null,"In this blog we will explore the concept of volatility decay on leveraged assets, which often keeps investors up at night and why this won\u2019t be the case for users on Float Capital."),(0,n.kt)("h2",{id:"what-is-volatility-decay"},"What is volatility decay?"),(0,n.kt)("p",null,"Volatility decay is an observation made on leveraged assets, more specifically how their compounded-returns compare to those of the non-leveraged versions. The phenomena arises when a sequence of leveraged movements compound to a value that is different than the leverage multiple of non-leveraged movements, which disproves the perception that investing in leveraged assets will give you exactly leveraged returns."),(0,n.kt)("p",null,"At the core is the fact that the relationship between compounding of returns and compounding of linear multiples of those returns, is not linear."),(0,n.kt)("p",null,"Volatility decay over a period for a leveraged asset can be formalised as: "),(0,n.kt)("p",null,(0,n.kt)("inlineCode",{parentName:"p"},"Volatility Decay = leverage * unleveraged returns - leveraged returns")),(0,n.kt)("p",null,"For example, if no-leverage movements are 5% then -10% respectively, the net return is -5.5% (1.05 * 0.90 = 0.945)."),(0,n.kt)("p",null,"For a 2x leveraged asset, the movements then are 10% and -20%, with net return being -12%.\nSo volatility decay after 2 movements is 2*(-5.5%) - (-12%) = 1%, meaning someone holding a long 2x leveraged asset has underperformed the leverage multiple of a no-leverage asset by 1%."),(0,n.kt)("p",null,"Hence volatility decay implies the leverage, say 2x, can result in returns different to a 2x multiple of non-leveraged returns."),(0,n.kt)("h2",{id:"what-does-it-look-like-on-float-capital"},"What does it look like on Float Capital?"),(0,n.kt)("p",null,"The absolute amount of volatility decay depends on certain factors:"),(0,n.kt)("h3",{id:"exposure-to-the-price-movements"},"Exposure to the price movements"),(0,n.kt)("p",null,"The greater the exposure to leveraged movements, the greater the ","[absolute]"," volatility decay.\nOur floating exposure mechanism means that the overbalanced side of a market will have a smaller degree of volatility decay experienced, as exposure will be less than 100%."),(0,n.kt)("p",null,"For the 2-OHM market, the exposure on the short side has been gradually decreasing, and therefore the size of absolute volatility decay has been decreasing as well \u2013 graph below."),(0,n.kt)("img",{src:"/blog-assets/volatility-decay-intro/exposure-2-ohm.png",alt:"Exposure 2-OHM",width:"100%"}),(0,n.kt)("h3",{id:"leverage-employed"},"Leverage employed"),(0,n.kt)("p",null,"Currently our first 2 markets (Flipp3ning and 3TH) have 3x leverage, whereas our third market has 2x leverage on OHM. When it comes to leverage, there is a trade-off between capital efficiency and volatility decay."),(0,n.kt)("p",null,"For a user wanting to gain vanilla $1000 long exposure to OHM, it means that user has to only mint $500 on long 2-OHM (assuming exposure of 100%) to gain this exposure, allowing users to allocate their capital more efficiently."),(0,n.kt)("p",null,"However, the greater the leverage the greater the potential for volatility decay, and one way to find the correct balance is to observe the historical volatility decay in our markets and see whether they are at acceptable levels."),(0,n.kt)("h3",{id:"absolute-difference-in-price-between-entry-and-exit"},"Absolute difference in price between entry and exit"),(0,n.kt)("p",null,"The greater the difference in underlying price of the asset \u2012 from the time a user enters the market to the time that they exit \u2012 the greater the ","[absolute]"," volatility decay. For example, if a user enters a market when the price of the underlying asset is $100 and then exits when the price is $200, they would experience greater volatility decay than if they exited when the price was $150. The same goes for negative price movements. Note that the volatility decay is not necessarily 0 if the user exited at the same price that they entered."),(0,n.kt)("h3",{id:"magnitude-of-underlying-price-movements"},"Magnitude of underlying price movements"),(0,n.kt)("p",null,"Float Capital updates user\u2019s positions when the oracle price feed of the underlying asset gives a new price. The higher the change in the underlying price, the higher the volatility decay will be for any users with active positions at the time of price update. This effect is compounded when there are multiple price updates of high magnitude in the same direction, and is dampened when there are multiple price updates of high magnitude in opposite directions. For example, if there are 2 positive price movements (not necessarily consecutive) of high magnitude then the volatility decay is higher than if there was 1 positive and 1 negative of the same magnitude. "),(0,n.kt)("p",null,"Note that the only time a user\u2019s volatility decay is affected by large single price movements is if they hold a position in the market at the time of the price movement i.e. historical price movements do not affect new investments."),(0,n.kt)("p",null,"So how high is high? This is something that will be explored in detail in the next blog. But very basically: the relationship between the magnitude of a single price movement and the resulting volatility decay is linear (whose factor/gradient is dependent on the market leverage less 1), and is offset by the volatility decay before the price offset. For ","[a rough]"," example, if the current volatility decay for a user in a 2x leveraged market is 01% and the magnitude of the next price update is 10% then the resulting volatility decay is also 10% ; and in a 3x leveraged market it would be 20%). Note that this is a rough example and may not be entirely accurate."),(0,n.kt)("p",null,"The higher the inherent volatility of the asset, greater the potential volatility decay."),(0,n.kt)("p",null,"To reduce the volatility of the underlying asset as much as possible, Float uses a deviation threshold of 0.5% and a maximum heartbeat of 5 minutes (actually heartbeat for 3TH market is 27 seconds), asset by our oracle provider, Chainlink."),(0,n.kt)("p",null,"This means that the price feed will at least update every heartbeat, but also update sooner if the price changes by more than 0.5% from the previous price."),(0,n.kt)("h3",{id:"volatility-decay-for-short-side-of-2-ohm-market"},"Volatility Decay for short side of 2-OHM market"),(0,n.kt)("img",{src:"/blog-assets/volatility-decay-intro/vol-decay-short-2-ohm.png",alt:"Vol Decay Short 2-OHM",width:"100%"}),(0,n.kt)("p",null,"This graph shows the cumulative returns of 2-OHM (in blue) and OHM (in red) for the short side, as well as the volatility decay so far (in green) assuming that someone had entered the market from 2 Nov 2021 when market was created."),(0,n.kt)("p",null,"We see that volatility decay dropped to -2% in around 5 December 2021, which means that someone holding short 2-OHM would have outperformed someone holding twice the amount in vanilla OHM by 2%."),(0,n.kt)("p",null,"We have observed volatility decay from the short side above \u2013 what does this look like on the long side? A similar calculation can be done for volatility decay on the long side, which does not necessarily produce an equal and opposite value to the short volatility decay. "),(0,n.kt)("p",null,"It is also important to note that because Float Capital is a peer-to-peer market, volatility decay is not lost forever, meaning volatility decay for one side is a gain for the other side on Float Capital, unlike in TradFi where the volatility decay cannot be captured and awarded to someone else."),(0,n.kt)("p",null,"For example, if the long side has experienced a 0.9% volatility decay over a 7-day period, then that 0.9% is retained by the short side."),(0,n.kt)("h2",{id:"in-summary"},"In Summary"),(0,n.kt)("p",null,"Volatility decay is something inevitable when it comes to leveraged assets, and the best is to put measures in place to limit its size."),(0,n.kt)("p",null,"In the article, we explored the mechanisms in place on Float Capital (such as floating exposure and our current practice with Chainlink) which reduce the size of volatility decay as much as possible for users."),(0,n.kt)("p",null,"One view that could be taken toward volatility decay is that it is the cost of using a capital efficient asset, which is achieved by employing leverage."),(0,n.kt)("p",null,"The amount of liquidity that did not shift as a result of volatility decay, will remain on the opposite side of the market (i.e. opposite side benefits from volatility decay on one side)."),(0,n.kt)("p",null,"More technical deep dive coming soon for the wrinkle-brained Floatonians."),(0,n.kt)("p",null,"Happy leveraged trading!"),(0,n.kt)("p",null,"If you want to learn more about Float Capital,",(0,n.kt)("a",{parentName:"p",href:"https://docs.float.capital/docs/"}," check out our docs"),",",(0,n.kt)("a",{parentName:"p",href:"https://docs.float.capital/assets/files/FLOAT_CAPITAL_whitepaper-47161fff19d61864625c9dd681117f29.pdf"}," read our whitepaper"),", or",(0,n.kt)("a",{parentName:"p",href:"https://discord.gg/yssvcFYbV9"}," join our Discord"),"."),(0,n.kt)("p",null,"This piece was written by ",(0,n.kt)("a",{parentName:"p",href:"https://twitter.com/WooSung40265546"},"Woo Sung Dong")," and Stent (Anon)."))}p.isMDXComponent=!0}}]);