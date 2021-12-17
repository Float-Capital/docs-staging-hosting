(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[8683],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return p},kt:function(){return d}});var o=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function r(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);t&&(o=o.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,o)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?r(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):r(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,o,a=function(e,t){if(null==e)return{};var n,o,a={},r=Object.keys(e);for(o=0;o<r.length;o++)n=r[o],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(o=0;o<r.length;o++)n=r[o],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var i=o.createContext({}),u=function(e){var t=o.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},p=function(e){var t=u(e.components);return o.createElement(i.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return o.createElement(o.Fragment,{},t)}},h=o.forwardRef((function(e,t){var n=e.components,a=e.mdxType,r=e.originalType,i=e.parentName,p=s(e,["components","mdxType","originalType","parentName"]),h=u(n),d=a,k=h["".concat(i,".").concat(d)]||h[d]||c[d]||r;return n?o.createElement(k,l(l({ref:t},p),{},{components:n})):o.createElement(k,l({ref:t},p))}));function d(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var r=n.length,l=new Array(r);l[0]=h;var s={};for(var i in t)hasOwnProperty.call(t,i)&&(s[i]=t[i]);s.originalType=e,s.mdxType="string"==typeof e?e:a,l[1]=s;for(var u=2;u<r;u++)l[u]=n[u];return o.createElement.apply(null,l)}return o.createElement.apply(null,n)}h.displayName="MDXCreateElement"},3718:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return s},contentTitle:function(){return i},metadata:function(){return u},toc:function(){return p},default:function(){return h}});var o=n(2122),a=n(9756),r=(n(7294),n(3905)),l=["components"],s={id:"delta-neutral-joe",title:"Go delta neutral on JOE for dank APR",sidebar_label:"Go delta neutral on JOE for dank APR",slug:"/delta-neutral-joe"},i=void 0,u={permalink:"/blog/delta-neutral-joe",source:"@site/blog/2021-12-16-delta-neutral-joe.md",title:"Go delta neutral on JOE for dank APR",description:"\u201cHave you heard of JOE?\u201d",date:"2021-12-16T00:00:00.000Z",formattedDate:"December 16, 2021",tags:[],readingTime:3.26,truncated:!1,nextItem:{title:"AXS just got a magic internet asset",permalink:"/blog/axs-magic-internet-asset"}},p=[{value:"Going delta neutral",id:"going-delta-neutral",children:[]}],c={toc:p};function h(e){var t=e.components,n=(0,a.Z)(e,l);return(0,r.kt)("wrapper",(0,o.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("img",{src:"/blog-assets/joe/JOE_Launch_Asset.gif",alt:"float joe",width:"100%"}),(0,r.kt)("p",null,"\u201cHave you heard of JOE?\u201d"),(0,r.kt)("p",null,"\u201cJoe who?\u201d"),(0,r.kt)("p",null,"\u201cJOE mama lmao.\u201d"),(0,r.kt)("p",null,"\u2013 ",(0,r.kt)("em",{parentName:"p"},"Excerpt from the funniest conversation ever, 2021.")),(0,r.kt)("p",null,"Trader Joe is one of the core protocols in the Avalanche ecosystem, facilitating swaps, pools and farms, and most recently lending, through their recent Banker Joe launch."),(0,r.kt)("p",null,"Trader Joe is powered by the ",(0,r.kt)("a",{parentName:"p",href:"https://www.coingecko.com/en/coins/joe"},"JOE governance token"),"."),(0,r.kt)("p",null,"Staked JOE earns a neat ~40% APY in the protocol, which can be tapped for another ~40% APY by lending the XJOE you get in Banker Joe."),(0,r.kt)("p",null,"It\u2019s an incredible strat, if the user isn\u2019t worried about price exposure."),(0,r.kt)("p",null,"But we just shipped a magic internet asset for JOE."),(0,r.kt)("p",null,"Now, for the very first time, delta neutral JOE staking is possible."),(0,r.kt)("p",null,"Here\u2019s how."),(0,r.kt)("h2",{id:"going-delta-neutral"},"Going delta neutral"),(0,r.kt)("p",null,"Going delta neutral is a super degen strategy that completely, or partially, removes exposure price movements."),(0,r.kt)("p",null,"In most cases, when prices only go up, price movements are great."),(0,r.kt)("p",null,"But in bearish markets, or when big amounts of wealth are involved, delta neutral strats can allow apes to take an element of risk out of their portfolios."),(0,r.kt)("p",null,"This can be super useful when staking an asset, like JOE, that has tasty rewards for users who can resist unstaking and selling."),(0,r.kt)("p",null,"So what would a delta neutral JOE position look like?"),(0,r.kt)("p",null,"First, get some JOE. If you\u2019re new to Avalanche, swap some AVAX for it on ",(0,r.kt)("a",{parentName:"p",href:"https://traderjoexyz.com/#/home"},"Trader Joe"),"."),(0,r.kt)("p",null,"Then, head over to the ",(0,r.kt)("a",{parentName:"p",href:"https://traderjoexyz.com/#/stake"},"staking dashboard"),", and check out that sweet, sweet APR."),(0,r.kt)("img",{src:"/blog-assets/joe/staking-apr-joe.png",alt:"float joe",width:"100%"}),(0,r.kt)("p",null,"Connect your wallet and select the amount of JOE to stake. Click stake. You\u2019ll need to approve the app, then confirm the transaction."),(0,r.kt)("p",null,"By staking JOE you\u2019ll swap your tokens for XJOE. The ratio of XJOE to JOE is constantly appreciating, so later you\u2019ll be able to swap your XJOE into more JOE than you originally staked."),(0,r.kt)("p",null,"For an added layer of degeneracy, you can take your XJOE and lend it out in ",(0,r.kt)("a",{parentName:"p",href:"https://traderjoexyz.com/#/lending"},"Banker Joe"),"."),(0,r.kt)("p",null,"Now comes the delta neutral part. Head across to ",(0,r.kt)("a",{parentName:"p",href:"https://avalanche.float.capital/app/markets?marketIndex=2&actionOption=short"},"Float Capital\u2019s JOE market"),"."),(0,r.kt)("p",null,"You\u2019ll need to open a short position equivalent to the value of your staked JOE. Make sure you have some DAI to mint a position."),(0,r.kt)("p",null,"There are two variables to take into account when calculating your position."),(0,r.kt)("p",null,"The first is the market\u2019s leverage: in this case 2x."),(0,r.kt)("p",null,"The second is the market\u2019s exposure level. This is shown on the market stats at the bottom of the page, on the lower right hand side."),(0,r.kt)("p",null,"If the short side has 100% exposure, then, because of the 2x leverage, your short will be half the dollar value of your staked JOE. If it\u2019s less than 100%, then we need to do some math."),(0,r.kt)("p",null,"Remember, the exposure can change based on the balance of capital in the market, so you will need to check this and rebalance periodically."),(0,r.kt)("p",null,"To calculate your short you\u2019ll need a few variables:"),(0,r.kt)("p",null,"Your JOE stake = joeStake\nThe short exposure = shortExposure\nThe size of your short position = short"),(0,r.kt)("p",null,"Putting that together we get:"),(0,r.kt)("p",null,"short = joeStake / (2 ","*"," shortExposure)"),(0,r.kt)("p",null,"Or, you can just make a copy of this ",(0,r.kt)("a",{parentName:"p",href:"https://docs.google.com/spreadsheets/d/1Fk7McdHZZNYz4xTJrWajANTUlfzhJoXXGB_AcVIFK20/edit?usp=sharing"},"Google Sheet")," and punch in your figures."),(0,r.kt)("p",null,"Remember to check the exposure level regularly, to make sure that your stake is adequately covered. In the future we\u2019ll be shipping vault contracts which will manage this for you automatically."),(0,r.kt)("p",null,"Good luck you degen."),(0,r.kt)("hr",null),(0,r.kt)("p",null,"This piece is not financial advice. Any kind of DeFi activity comes with risk, and should only be attempted by serious degens who understand this and know how to navigate it."),(0,r.kt)("p",null,"To learn more about the risks inherent with using Float, read our blog post ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/blog/apeing-in-responsibly"},"here"),"."),(0,r.kt)("p",null,"To understand how the protocol and our magic internet assets work, read our ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/docs/"},"docs"),"."),(0,r.kt)("p",null,"If you want to meet the team behind Float Capital, claim your ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/docs/gems"},"gem role"),", or hang out, come to our ",(0,r.kt)("a",{parentName:"p",href:"https://discord.gg/Ehwz87yTnV"},"Discord"),"."),(0,r.kt)("p",null,"This piece was written by ",(0,r.kt)("a",{parentName:"p",href:"https://twitter.com/CampbellEaston"},"Campbell Easton"),"."))}h.isMDXComponent=!0}}]);