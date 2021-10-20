(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[217],{3905:function(e,t,n){"use strict";n.d(t,{Zo:function(){return h},kt:function(){return u}});var i=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function r(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,i)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?r(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):r(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,i,a=function(e,t){if(null==e)return{};var n,i,a={},r=Object.keys(e);for(i=0;i<r.length;i++)n=r[i],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(i=0;i<r.length;i++)n=r[i],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var l=i.createContext({}),p=function(e){var t=i.useContext(l),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},h=function(e){var t=p(e.components);return i.createElement(l.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return i.createElement(i.Fragment,{},t)}},d=i.forwardRef((function(e,t){var n=e.components,a=e.mdxType,r=e.originalType,l=e.parentName,h=s(e,["components","mdxType","originalType","parentName"]),d=p(n),u=a,m=d["".concat(l,".").concat(u)]||d[u]||c[u]||r;return n?i.createElement(m,o(o({ref:t},h),{},{components:n})):i.createElement(m,o({ref:t},h))}));function u(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var r=n.length,o=new Array(r);o[0]=d;var s={};for(var l in t)hasOwnProperty.call(t,l)&&(s[l]=t[l]);s.originalType=e,s.mdxType="string"==typeof e?e:a,o[1]=s;for(var p=2;p<r;p++)o[p]=n[p];return i.createElement.apply(null,o)}return i.createElement.apply(null,n)}d.displayName="MDXCreateElement"},3920:function(e,t,n){"use strict";n.r(t),n.d(t,{frontMatter:function(){return s},contentTitle:function(){return l},metadata:function(){return p},toc:function(){return h},default:function(){return d}});var i=n(2122),a=n(9756),r=(n(7294),n(3905)),o=["components"],s={id:"flipp3ning-backetesting",title:"Backtesting the Flipp3ning market: Visualizing market evolution",sidebar_label:"Backtesting the Flipp3ning market",slug:"/flipp3ning-backetesting"},l="Float Capital Presents: Backtesting the Flipp3ning market",p={permalink:"/blog/flipp3ning-backetesting",source:"@site/blog/2021-09-22-flipp3ning-backtesting.md",title:"Backtesting the Flipp3ning market: Visualizing market evolution",description:"**Disclaimer**: The modelling process below was done ahead of the Alpha launch and so the results will be different to the Alpha Experience",date:"2021-09-22T00:00:00.000Z",formattedDate:"September 22, 2021",tags:[],readingTime:7.535,truncated:!1,nextItem:{title:"Float Capital Presents: A New Era of Synthetic Assets",permalink:"/blog/new-era-synthetic-assets"}},h=[{value:"<strong>Modelling purpose</strong>",id:"modelling-purpose",children:[]},{value:"<strong>Data</strong>",id:"data",children:[]},{value:"<strong>Protocol mechanisms</strong>",id:"protocol-mechanisms",children:[]},{value:"<strong>Other assumptions</strong>",id:"other-assumptions",children:[]},{value:"<strong>Results and insights</strong>",id:"results-and-insights",children:[]},{value:"<strong>Observation of the Alpha experience</strong>",id:"observation-of-the-alpha-experience",children:[]},{value:"<strong>Learn more</strong>",id:"learn-more",children:[]}],c={toc:h};function d(e){var t=e.components,n=(0,a.Z)(e,o);return(0,r.kt)("wrapper",(0,i.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("p",null,(0,r.kt)("em",{parentName:"p"},(0,r.kt)("strong",{parentName:"em"},"Disclaimer"),": The modelling process below was done ahead of the Alpha launch and so the results will be different to the Alpha Experience")),(0,r.kt)("h3",{id:"modelling-purpose"},(0,r.kt)("strong",{parentName:"h3"},"Modelling purpose")),(0,r.kt)("p",null,"For the Alpha launch, we modelled the ",(0,r.kt)("strong",{parentName:"p"},"evolution of market liquidity")," under our first market, the Flipp3ning using ",(0,r.kt)("strong",{parentName:"p"},"historical data"),".\nThis has helped us unlock insights required for fine-tuning the parameters used in the protocol mechanisms. "),(0,r.kt)("p",null,"A useful by-product of this is being able to share the results and insights with the community and future FLT token holders, who will eventually ",(0,r.kt)("strong",{parentName:"p"},"champion")," the governance of Float Capital DAO."),(0,r.kt)("p",null,"As one can reasonably expect, the results of the modelling process depend largely on the data as well as the assumptions made - let's talk briefly about them before interpreting the results."),(0,r.kt)("h3",{id:"data"},(0,r.kt)("strong",{parentName:"h3"},"Data")),(0,r.kt)("p",null,"We chose the Flipp3ning as the on-chain asset for modelling, the first market on Float Capital in the Alpha launch.\nThis is a 3x leveraged version of the Flippening, which is calculated as market capitalization of ETH over market capitalization of BTC. "),(0,r.kt)("p",null,"The market movements of ETH and BTC can tend to be quite correlated at times as most outside speculation of crypto does not differentiate between coins, hence the reason for the 3x leverage to increase the volatility of the on-chain asset."),(0,r.kt)("p",null,"The modelling process runs over 30 days\u2019 worth of data, recorded at an hourly interval; the actual heartbeat (frequency) of price feed in the Alpha and mainnet launch will actually be approximately 5 minutes, so we observed greater volatility in this data than we would observe on the protocol."),(0,r.kt)("img",{src:"/blog-assets/backtesting-flipp3ning/flipp3ning-historical.png",alt:"flipp3ning-backetesting",width:"100%"}),(0,r.kt)("h3",{id:"protocol-mechanisms"},(0,r.kt)("strong",{parentName:"h3"},"Protocol mechanisms")),(0,r.kt)("p",null,"Float Capital is a peer-to-peer synthetic asset marketplace where each market provides users with the option to take both long and short positions (for more information on Float Capital, click ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/docs/"},"here"),"). Based on the total liquidity on each side (long and short), the one with the less liquidity (the undercapitalized side) will have 100% exposure to price movements and the one with more liquidity (the overcapitalized side) will have exposure equal to the ratio of the undercapitalized side to overcapitalized side (for example, if long has $100 and short has $90, short side will have 100% exposure and long side will have 90/100 = 90% exposure). This floating exposure mechanism ensures that the gains/losses due to price movements are always 100% collateralized in the protocol."),(0,r.kt)("p",null,"Then you might ask, for a given on-chain asset with a price trajectory, will one side not be greater than the other?"),(0,r.kt)("p",null,"Yes, and hence enter the balancing incentives. "),(0,r.kt)("p",null,"In Float Capital, users who mint positions in the undercapitalized side earn a portion of the yield that is generated by putting the total liquidity locked in the market into AAVE. Users with positions in the overcapitalized side do not receive any portion of the yield.\nThe balance of the yield is sent to the Treasury DAO and will provide price support for FLT tokens that are in circulation (for the Alpha launch, alphaFLT tokens will be issued instead of FLT tokens).\nThis incentivizes the users to balance the markets and hence bring the exposure of the overcapitalized side closer to 100%. This additional yield is calculated using a curve (click ",(0,r.kt)("a",{parentName:"p",href:"https://ipfs.io/ipfs/QmXsW4cHtxpJ5BFwRcMSUw7s5G11Qkte13NTEfPLTKEx4x"},"here")," for formula and ",(0,r.kt)("a",{parentName:"p",href:"https://www.desmos.com/calculator/pnl43tfv5b"},"here")," for graph).\nThere are further incentives in the form of higher FLT token issuance to users who stake on-chain tokens of the undercapitalized side, but we will cover the fine details of FLT token in another article.\nIn short, the FLT token is a rewards token to incentivise liquidity provision with mechanisms for profit share and price support while also acting as a governance token for the protocol."),(0,r.kt)("h3",{id:"other-assumptions"},(0,r.kt)("strong",{parentName:"h3"},"Other assumptions")),(0,r.kt)("p",null,"Given the protocol mechanisms above and the price feeds, we project 2 types of liquidity injections into the system.\nOne is for the initial liquidity that float capital will inject into the system to ensure that the exposure for the users stays as close to 100% for the immediate future (until whales come to play) and the other for the subsequent liquidity that users will inject based on the market movements."),(0,r.kt)("p",null,"The user liquidity has been further divided into 2 types - ",(0,r.kt)("em",{parentName:"p"},"performance-based")," and ",(0,r.kt)("em",{parentName:"p"},"incentive-based"),".\n",(0,r.kt)("em",{parentName:"p"},"Performance-based")," users will assess the recent performance of the on-chain asset in determining whether to enter long or short positions, whereas ",(0,r.kt)("em",{parentName:"p"},"incentive-based")," users will assess the excess yield to determine whether to enter long or short positions.\nThe total user liquidity amount is set by multiplying the assumptions for average liquidity per user and the number of users interacting with the protocol."),(0,r.kt)("p",null,"An initial liquidity of $50,000 was split 50:50 between long and short sides and a total user liquidity of $150 was assumed per time interval."),(0,r.kt)("h3",{id:"results-and-insights"},(0,r.kt)("strong",{parentName:"h3"},"Results and insights")),(0,r.kt)("h4",{id:"5050-split-between-performance-based-and-incentive-based-users"},"50:50 split between ",(0,r.kt)("em",{parentName:"h4"},"performance-based")," and ",(0,r.kt)("em",{parentName:"h4"},"incentive-based")," users"),(0,r.kt)("img",{src:"/blog-assets/backtesting-flipp3ning/model-50-50.png",alt:"flipp3ning-backetesting",width:"100%"}),(0,r.kt)("p",null,"The liquidity on either side remains relatively balanced until the half-way point, as no significant fluctuations of the historical data are observed and the incentive-based users are injecting liquidity to capture the additional incentive and thereby balance the two sides."),(0,r.kt)("p",null,"Given the large upswing of the Flipp3ning around the half-way point, we observe that the long liquidity starts becoming significantly overcapitalized due to a couple of reasons:"),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"Increase in price of the Flipp3ning transfers liquidity from short to long side."),(0,r.kt)("li",{parentName:"ol"},"Upward trend of the Flipp3ning triggers ",(0,r.kt)("em",{parentName:"li"},"performance-based")," users to mint long, who are hoping to capture future gains.")),(0,r.kt)("p",null,"At this point, exposure for the long liquidity starts decreasing significantly and the yield share for the undercapitalized (short) side starts increasing from 0, to incentivize users to mint positions in the short side."),(0,r.kt)("h4",{id:"2080-split-between-performance-based-and-incentive-based-users"},"20:80 split between ",(0,r.kt)("em",{parentName:"h4"},"performance-based")," and ",(0,r.kt)("em",{parentName:"h4"},"incentive-based")," users"),(0,r.kt)("img",{src:"/blog-assets/backtesting-flipp3ning/model-20-80.png",alt:"flipp3ning-backetesting",width:"100%"}),(0,r.kt)("p",null,"Here we observe a greater tendency towards a balanced market, as a larger portion of users are assumed to inject liquidity to capture the balancing incentives in the protocol."),(0,r.kt)("p",null,"The benefit of the markets being balanced come in a direct and indirect forms - exposure of the undercapitalized side remains as close to 100% as possible and majority of the yield share is accrued to the Treasury DAO which will provide a price support to FLT tokens issued to users."),(0,r.kt)("p",null,"The actual percentage of users who inject liquidity into the undercapitalized side will be determined by the relative gain of the balancing incentives to the possibility of impermanent loss in reality."),(0,r.kt)("h4",{id:"8020-split-between-performance-based-and-incentive-based-users"},"80:20 split between ",(0,r.kt)("em",{parentName:"h4"},"performance-based")," and ",(0,r.kt)("em",{parentName:"h4"},"incentive-based")," users"),(0,r.kt)("img",{src:"/blog-assets/backtesting-flipp3ning/model-80-20.png",alt:"flipp3ning-backetesting",width:"100%"}),(0,r.kt)("p",null,"A higher percentage of ",(0,r.kt)("em",{parentName:"p"},"performance-based")," users will lead to greater divergence from an equilibrium between long and short sides, and this will amplify the balancing incentives for incentive-based users."),(0,r.kt)("p",null,"An interesting observation is that the exposure curve for 20:80 split and 80:20 split scenarios take on a similar shape around the half-way point when the Flipp3ning experiences a large gain over a short period.\nIf total liquidity in the market is considerably larger than the assumed user liquidity injections, any up/down swings of price will drown out user liquidity injections."),(0,r.kt)("p",null,"One thing to note is that the modelling process does not consider the higher FLT token issuance for the users who stake on the undercapitalized side yet, which may in practice result in higher rate of reversion towards an equilibrium between short and long liquidity."),(0,r.kt)("h3",{id:"observation-of-the-alpha-experience"},(0,r.kt)("strong",{parentName:"h3"},"Observation of the Alpha experience")),(0,r.kt)("p",null,"A ",(0,r.kt)("strong",{parentName:"p"},"massive")," positive is that we can compare the expected experience from the modelling to the Alpha experience! "),(0,r.kt)("img",{src:"/blog-assets/backtesting-flipp3ning/massive.png",alt:"flipp3ning-backetesting",width:"50%"}),(0,r.kt)("p",null,"Straight off the bat, the major difference to the model was that the ",(0,r.kt)("strong",{parentName:"p"},"initial liquidity")," from Float Capital was $20,000, with $10,000 in long and short at the launch."),(0,r.kt)("p",null,"But more importanly, only after 6 days since launch, we are sitting with TVL of $160,000+ in the protocol (one of few instances where I'm happy to be wrong about my assumptions)."),(0,r.kt)("p",null,"And the balance between long and short? Drum roll please...."),(0,r.kt)("p",null,"Long side has ",(0,r.kt)("strong",{parentName:"p"},"100% exposure")," and short side has ",(0,r.kt)("strong",{parentName:"p"},"98.73% exposure!")),(0,r.kt)("p",null,"Even though the short side has been ",(0,r.kt)("strong",{parentName:"p"},"DOMINATING")," since the launch, the balancing incentives have really outdone themselves in balancing the market."),(0,r.kt)("img",{src:"/blog-assets/backtesting-flipp3ning/flipp3ning-alpha.png",alt:"flipp3ning-backetesting",width:"100%"}),(0,r.kt)("p",null,"These observations give us some powerful learnings, which can be fed into the next iteration of the modelling:"),(0,r.kt)("ol",null,(0,r.kt)("li",{parentName:"ol"},"Predicting liquidity injection into the protocol is difficult, so the best solution may be run Monte Carlo simulations across different liquidity injection levels."),(0,r.kt)("li",{parentName:"ol"},"The unmodelled incentive of FLT tokens (alphaFLT in the Alpha) may have a significant influence in incentivizing markets to be balanced."),(0,r.kt)("li",{parentName:"ol"},"The overall balancing incentives seem to be really strong, so we may need to assume a higher proportion of ",(0,r.kt)("em",{parentName:"li"},"incentive-based")," users. ")),(0,r.kt)("p",null,(0,r.kt)("em",{parentName:"p"},"This piece was researched and written by Woo Sung Dong with data support from Denham Preen and Jon Jon Clark, and editing support from Jason Smythe and Campbell Easton.")),(0,r.kt)("h3",{id:"learn-more"},(0,r.kt)("strong",{parentName:"h3"},"Learn more")),(0,r.kt)("p",null,"If you want to learn even more about Float Capital, you can visit the ",(0,r.kt)("a",{parentName:"p",href:"https://docs.float.capital/"},"docs section")," of our website."),(0,r.kt)("p",null,"If you want breaking news, memes and announcements, follow us on ",(0,r.kt)("a",{parentName:"p",href:"https://twitter.com/float_capital"},"Twitter"),"."),(0,r.kt)("p",null,"If you want to join the community, meet the team and get involved in the future of Float Capital, join our ",(0,r.kt)("a",{parentName:"p",href:"https://discord.gg/StYzV8MP"},"Discord"),"."))}d.isMDXComponent=!0}}]);