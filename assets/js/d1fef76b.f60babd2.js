(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[2244],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return c},kt:function(){return d}});var a=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function r(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?r(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):r(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,a,o=function(e,t){if(null==e)return{};var n,a,o={},r=Object.keys(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=a.createContext({}),p=function(e){var t=a.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},c=function(e){var t=p(e.components);return a.createElement(s.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},h=a.forwardRef((function(e,t){var n=e.components,o=e.mdxType,r=e.originalType,s=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),h=p(n),d=o,m=h["".concat(s,".").concat(d)]||h[d]||u[d]||r;return n?a.createElement(m,i(i({ref:t},c),{},{components:n})):a.createElement(m,i({ref:t},c))}));function d(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var r=n.length,i=new Array(r);i[0]=h;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:o,i[1]=l;for(var p=2;p<r;p++)i[p]=n[p];return a.createElement.apply(null,i)}return a.createElement.apply(null,n)}h.displayName="MDXCreateElement"},8614:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return l},contentTitle:function(){return s},metadata:function(){return p},toc:function(){return c},default:function(){return h}});var a=n(2122),o=n(9756),r=(n(7294),n(3905)),i=["components"],l={title:"BRB, going multichain.",sidebar_label:"Multichain",slug:"/deploying-to-avalanche"},s=void 0,p={permalink:"/blog/deploying-to-avalanche",source:"@site/blog/2021-12-07-deploying-to-avalanche.md",title:"BRB, going multichain.",description:'Avalanche" width="100%"/>',date:"2021-12-07T00:00:00.000Z",formattedDate:"December 7, 2021",tags:[],readingTime:3.07,truncated:!0,prevItem:{title:"Why you won\u2019t have nightmares about volatility decay on Float Capital.",permalink:"/blog/volatility-decay-intro"},nextItem:{title:"We\u2019re shipping a funding rate. Here\u2019s why and how.",permalink:"/blog/shipping-a-funding-rate"}},c=[],u={toc:c};function h(e){var t=e.components,n=(0,o.Z)(e,i);return(0,r.kt)("wrapper",(0,a.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("img",{src:"/blog-assets/avalanche-asset.png",alt:"Float <> Avalanche",width:"100%"}),(0,r.kt)("p",null,"BRB, our alpha is going multichain."),(0,r.kt)("h1",{id:"were-deploying-on-avalanche"},"We\u2019re deploying on Avalanche"),(0,r.kt)("p",null,"Float Capital is bringing Magic internet Assets to Avalanche."),(0,r.kt)("p",null,"We couldn\u2019t be more stoked."),(0,r.kt)("p",null,"We\u2019ll be going live with AVAX market with 2x leverage. Following that, we\u2019ll be shipping more degen markets for Avalanche native tokens."),(0,r.kt)("p",null,"Now Avalanche users can trade in Float Capital, mint and switch positions, stake and mine alphaFLT tokens, and to build Float positions into existing strategies for even more degenerate effects."),(0,r.kt)("p",null,"The degen traders on Avalanche just got a lot more options."),(0,r.kt)("p",null,"To see what\u2019s possible, check out our case study on ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/blog/hedge-your-ohm-position"},"hedging staked OHM using Float"),". With Olympus DAO deploying on Avalanche too, we might even look at shipping something new for Ohmies."),(0,r.kt)("h1",{id:"whats-different-on-avalanche"},"What\u2019s different on Avalanche"),(0,r.kt)("p",null,"Because our markets need liquidity to balance, we\u2019re being very careful about relaunching markets that we\u2019ve already deployed on Polygon."),(0,r.kt)("p",null,"In the next few weeks we\u2019ll be shipping some absolutely degenerate markets for protocols running on Avalanche. These will allow users to trade, hedge, and mine rewards without leaving Avalanche."),(0,r.kt)("p",null,"No hints yet, but you\u2019ll be able to open leveraged shorts on some of these assets for the very first time, and create tons of new trading and hedging opportunities."),(0,r.kt)("p",null,"We may even experiment with different payment tokens. Currently all our markets accept DAI, but we\u2019re going to use Avalanche to test out some new payment tokens. Say no more for now, but we aren\u2019t talking about stablecoins."),(0,r.kt)("p",null,"All of our Avalanche markets will have a 30 minute heartbeat \u2013 meaning that they receive price updates and process trades at least every 30 minutes. If the price deviation hits a certain threshold, this process will occur sooner."),(0,r.kt)("p",null,"As always our Avalanche markets will be powered by Chainlink price feeds. The Chainlink team has been incredible in helping us bring new feeds to Avalanche, and speeding up the existing ones for our markets. To read more about how we build our markets around Chainlink feeds, click ",(0,r.kt)("a",{parentName:"p",href:"https://medium.com/@Float.Capital/introducing-float-capital-the-future-of-on-chain-assets-powered-by-chainlink-ecdcee774b84?source=user_profile---------6-------------------------------"},"here"),"."),(0,r.kt)("h1",{id:"using-float"},"Using Float"),(0,r.kt)("p",null,"Float Capital allows users to mint Magic Internet Assets with unbelievable ease."),(0,r.kt)("p",null,"Our markets track the price of an underlying asset, and allow you to get long and short exposure in a matter of clicks."),(0,r.kt)("p",null,"To take the pain out of trading, we\u2019ve built a system that removes the need for collateralized debt positions or liquidations."),(0,r.kt)("p",null,"We use a genius set of incentives to help balance markets, by feeding additional rewards to users in underbalanced positions."),(0,r.kt)("p",null,"By staking your position, you can earn alphaFLT as a reward. The token issuance scales with the market balance, so underbalanced APYs get another layer of dank rewards."),(0,r.kt)("p",null,"If you\u2019re a DeFi beginner looking for hands on experience, watch our tutorial series ",(0,r.kt)("a",{parentName:"p",href:"https://www.youtube.com/watch?v=7KUJGY1Zxyo&t=2s"},"here"),"."),(0,r.kt)("p",null,"Float Capital is currently in our alpha deployment. That means we\u2019re live, with real money, but our contracts, mechanism and token aren\u2019t final."),(0,r.kt)("p",null,"In the coming months, when we have a perfect model for Float we\u2019ll ship our V1 product and our FLT token."),(0,r.kt)("p",null,"Until then, you\u2019re perfectly safe to trade within Float and help us grow the protocol. In the meantime you\u2019ll earn alphaFLT, which you\u2019ll be able to redeem for FLT when it launches."),(0,r.kt)("p",null,"Start trading now at ",(0,r.kt)("a",{parentName:"p",href:"https://avalanche.float.capital"},"avalanche.float.capital"),"."),(0,r.kt)("p",null,"Or, if you want to learn more, ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/docs/"},"check out our docs"),", ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/assets/files/FLOAT_CAPITAL_whitepaper-47161fff19d61864625c9dd681117f29.pdf"},"read our whitepaper"),", or ",(0,r.kt)("a",{parentName:"p",href:"https://discord.gg/yssvcFYbV9"},"join our Discord"),"."),(0,r.kt)("p",null,"Having money in DeFi is risky. This piece should not be considered financial advice. To learn more about Float Capital and the risks you could be exposed to by using the protocol, read more ",(0,r.kt)("a",{parentName:"p",href:"https://medium.com/@Float.Capital/apeing-in-responsibly-b8ec8e303a19"},"here"),"."),(0,r.kt)("p",null,"This piece was written by ",(0,r.kt)("a",{parentName:"p",href:"https://twitter.com/CampbellEaston"},"Campbell Easton"),", with input from ",(0,r.kt)("a",{parentName:"p",href:"https://twitter.com/jonjonclark"},"JonJon Clark"),", ",(0,r.kt)("a",{parentName:"p",href:"https://twitter.com/DenhamPreen"},"Denham Preen"),", ",(0,r.kt)("a",{parentName:"p",href:"https://twitter.com/WooSung40265546"},"Woo Sung Dong")," and ",(0,r.kt)("a",{parentName:"p",href:"https://twitter.com/j_o_r_d_y_s"},"Jordyn Laurier"),"."))}h.isMDXComponent=!0}}]);