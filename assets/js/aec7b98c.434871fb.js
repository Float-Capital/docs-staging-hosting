(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[603],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return c},kt:function(){return d}});var a=n(7294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},i=Object.keys(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var l=a.createContext({}),h=function(e){var t=a.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},c=function(e){var t=h(e.components);return a.createElement(l.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},p=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,i=e.originalType,l=e.parentName,c=s(e,["components","mdxType","originalType","parentName"]),p=h(n),d=r,f=p["".concat(l,".").concat(d)]||p[d]||u[d]||i;return n?a.createElement(f,o(o({ref:t},c),{},{components:n})):a.createElement(f,o({ref:t},c))}));function d(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var i=n.length,o=new Array(i);o[0]=p;var s={};for(var l in t)hasOwnProperty.call(t,l)&&(s[l]=t[l]);s.originalType=e,s.mdxType="string"==typeof e?e:r,o[1]=s;for(var h=2;h<i;h++)o[h]=n[h];return a.createElement.apply(null,o)}return a.createElement.apply(null,n)}p.displayName="MDXCreateElement"},350:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return s},contentTitle:function(){return l},metadata:function(){return h},toc:function(){return c},default:function(){return p}});var a=n(2122),r=n(9756),i=(n(7294),n(3905)),o=["components"],s={id:"shipping-a-funding-rate",title:"We\u2019re shipping a funding rate. Here\u2019s why and how.",sidebar_label:"Funding Rates",slug:"/shipping-a-funding-rate"},l=void 0,h={permalink:"/blog/shipping-a-funding-rate",source:"@site/blog/2021-11-28-shipping-a-funding-rate.md",title:"We\u2019re shipping a funding rate. Here\u2019s why and how.",description:"Float Capital has experienced explosive success with our OHM-USD market and our partnership with Olympus DAO. It has attracted so much capital that for a week during the last month we were the fastest growing derivatives protocol in all of DeFi.",date:"2021-11-28T00:00:00.000Z",formattedDate:"November 28, 2021",tags:[],readingTime:4.66,truncated:!1,nextItem:{title:"Hedge your OHM position with Float Capital",permalink:"/blog/hedge-your-ohm-position"}},c=[],u={toc:c};function p(e){var t=e.components,n=(0,r.Z)(e,o);return(0,i.kt)("wrapper",(0,a.Z)({},u,n,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("img",{src:"/blog-assets/funding-rates/container-ship.jpg",alt:"Floating SHIP",width:"100%"}),(0,i.kt)("h1",{id:"were-shipping-a-funding-rate-heres-why-and-how"},"We\u2019re shipping a funding rate. Here\u2019s why and how."),(0,i.kt)("p",null,"Float Capital has experienced explosive success with our OHM-USD market and our partnership with Olympus DAO. It has attracted so much capital that for a week during the last month we were the fastest growing derivatives protocol in all of DeFi."),(0,i.kt)("p",null,"But the success of the OHM market has raised a new challenge \u2013 the current mechanisms aren\u2019t strong enough to incentivize better market balance between long and short positions with an asset that has a >7000% rebase APY."),(0,i.kt)("p",null,"Because of this the majority of the OHM market positions are short. As a result the short positions are overbalanced and receive minimal short exposure since there is not enough long liquidity to take the other side of the trade. This makes Float a less efficient tool for hedging positions."),(0,i.kt)("p",null,"To correct this we will be introducing a funding rate mechanism to the protocol."),(0,i.kt)("p",null,"Float is still in the alpha stage and constantly refining the protocol to handle any type of market and any kind of asset. Our thesis remains, build, ship, iterate. The OHM market has been an incredible experiment and has shown us our path forward so that when the protocol moves out of alpha we will be able to create any kind of Magic Internet Asset."),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Funding rate")),(0,i.kt)("p",null,"When launching the protocol we initially thought that the leveraged yield incentive (all liquidity earning yield channelled to the underbalanced side) + asymmetric alphaFLT accrual would be enough to cater for this imbalance. However (alphaFLT aside), users going long OHM in Float only receive a 60% leveraged yield from aave for being long in contrast to getting >7000% (rebase rewards) for it by staking their OHM on mainnet."),(0,i.kt)("p",null,(0,i.kt)("em",{parentName:"p"},"Our solution")," - a funding rate! A funding rate is not a concept that we invented. Many perpetuals use funding rates to bring their assets to closely track their underlying. It was ambitious that we thought we could build a protocol that didn\u2019t need this primitive, and not all markets need it. However, the OHM market, I\u2019m sure you will agree, NEEDS a funding rate!"),(0,i.kt)("p",null,(0,i.kt)("em",{parentName:"p"},"What is a funding rate?")," A funding rate is payment made from the overbalanced side to the underbalanced side, to incentivize more balance in the market. More specifically for Float Capital there will be a constant trickle of liquidity from the overbalanced side to the underbalanced side of the market. As the markets become more imbalanced, the funding rate increases. For reference ",(0,i.kt)("a",{parentName:"p",href:"https://ftxpremiums.com/"},"here")," are the funding rates for FTX."),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Float funding rate implementation")),(0,i.kt)("p",null,(0,i.kt)("em",{parentName:"p"},"How will this mechanism work?")," We set a maximum funding rate for the overbalanced side that would only be achieved if the market were completely imbalanced (i.e. there was no liquidity on the underbalanced side). We then scale the funding rate linearly based on the imbalance. This simple formula can be seen ",(0,i.kt)("a",{parentName:"p",href:"https://www.desmos.com/calculator/glkmxykdcx"},"here"),". We have additional parameters that we can introduce later to adjust the shape of this curve, but we believe that the linear curve will be sufficient to create a massive impact while still remaining conservative. We are not expecting the funding rate alone to be enough to rebalance the market alone, rather it will be the second order effect of traders coming into the market to accept the high yields that rebalances the market."),(0,i.kt)("p",null,(0,i.kt)("em",{parentName:"p"},"What is a good initial funding rate setting for this market?")," It is hard to know what kind of risk tolerance the market will have to going-in on the long side of OHM."),(0,i.kt)("p",null,"Given our current market imbalance, an additional APY of 2,000-3,500% could be sufficient. 3,500% with 2x leverage would be equivalent to the maximum longing OHM and staking can earn: ~7,000%. 2,000% is due to the increased capital efficiency of using Float Capital, the market fragmentation of being on a different blockchain and the easy access enabled by the low gas fees of polygon."),(0,i.kt)("p",null,"Being sensibly conservative, the initial proposal for implementation of this funding rate is a maximum of 300% for the OHM market, which at the current exposure of ~10% would mean the short side pays an annualized funding rate of 270%, or an hourly rate 0.03%."),(0,i.kt)("p",null,"This would give long OHM an APY of 2,400%."),(0,i.kt)("p",null,"If that has an underwhelming effect on the market we will take steps to increase it by a reasonable amount the next week, and again until it has the desired effect."),(0,i.kt)("p",null,"If the market rebalances to 50% exposure this would reduce to a funding rate of 150% on the short side and an APY boost on the long side of 300%"),(0,i.kt)("p",null,"A funding rate of 270%, that we expect to reduce over time, is still comfortably below some of the larger funding rates that appear on FTX (which frequently go to 800% at times)."),(0,i.kt)("img",{src:"/blog-assets/funding-rates/ftx-funding-rates.png",alt:"FTX funding rates",width:"100%"}),(0,i.kt)("p",null,"Here is ",(0,i.kt)("a",{parentName:"p",href:"https://github.com/Float-Capital/contracts/commit/11a085fa9f5e433e3d57252cc845d393cd3906b0#r60963608"},"our code"),", which is currently in for a 3rd party audit. We\u2019ve also written numerous tests and the design of our code means this addition is very modular and contained. There is no point in waiting longer than we need to, the plan is to ship this week (pending review)."),(0,i.kt)("img",{src:"/blog-assets/funding-rates/cruise-ship.jpg",alt:"Image of this feature being SHIPPED",width:"100%"}),(0,i.kt)("p",null,"We invite all plebs, apes, chads and degens to give feedback, code review, or any other help!"),(0,i.kt)("p",null,"As always, if you have any questions or want to chat, learn, or gm, come over to ",(0,i.kt)("a",{parentName:"p",href:"https://discord.gg/g6kfUMEwFV"},"our Discord"),"."),(0,i.kt)("p",null,"This piece was written by ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/JasoonS"},"Jason Smythe"),", with invaluable editing and input from ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/jonjonclark"},"Jonathan Clark"),", ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/mjyoungsta"},"Michael Young"),", ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/DenhamPreen"},"Denham Preen"),", ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/PaulFreund18"},"Paul Freund"),", ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/CampbellEaston"},"Campbell Easton")," and ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/WooSung40265546"},"Woo Sung Dong"),"."))}p.isMDXComponent=!0}}]);