(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[116],{3905:function(e,t,a){"use strict";a.d(t,{Zo:function(){return h},kt:function(){return u}});var n=a(7294);function o(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function i(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function r(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?i(Object(a),!0).forEach((function(t){o(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):i(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function l(e,t){if(null==e)return{};var a,n,o=function(e,t){if(null==e)return{};var a,n,o={},i=Object.keys(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||(o[a]=e[a]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(o[a]=e[a])}return o}var s=n.createContext({}),c=function(e){var t=n.useContext(s),a=t;return e&&(a="function"==typeof e?e(t):r(r({},t),e)),a},h=function(e){var t=c(e.components);return n.createElement(s.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},d=n.forwardRef((function(e,t){var a=e.components,o=e.mdxType,i=e.originalType,s=e.parentName,h=l(e,["components","mdxType","originalType","parentName"]),d=c(a),u=o,f=d["".concat(s,".").concat(u)]||d[u]||p[u]||i;return a?n.createElement(f,r(r({ref:t},h),{},{components:a})):n.createElement(f,r({ref:t},h))}));function u(e,t){var a=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=a.length,r=new Array(i);r[0]=d;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:o,r[1]=l;for(var c=2;c<i;c++)r[c]=a[c];return n.createElement.apply(null,r)}return n.createElement.apply(null,a)}d.displayName="MDXCreateElement"},2501:function(e,t,a){"use strict";a.r(t),a.d(t,{frontMatter:function(){return l},contentTitle:function(){return s},metadata:function(){return c},toc:function(){return h},default:function(){return d}});var n=a(2122),o=a(9756),i=(a(7294),a(3905)),r=["components"],l={id:"future-onchain-assets",title:"Introducing Float Capital: The Future of On-Chain Assets Powered by Chainlink",sidebar_label:"Introducing Float Capital",slug:"/future-onchain-assets"},s=void 0,c={permalink:"/blog/future-onchain-assets",source:"@site/blog/future-onchain-assets.md",title:"Introducing Float Capital: The Future of On-Chain Assets Powered by Chainlink",description:"First up, some massive news. The Float Capital Alpha goes LIVE on Polygon, this Friday, September 17, 2021.",date:"2021-09-16T10:04:08.530Z",formattedDate:"September 16, 2021",tags:[],readingTime:5.565,truncated:!1},h=[{value:"The Flipp3ning!",id:"the-flipp3ning",children:[]},{value:"Did someone say GEMS?",id:"did-someone-say-gems",children:[]},{value:"Under the hood",id:"under-the-hood",children:[]},{value:"About Chainlink",id:"about-chainlink",children:[]},{value:"About Float Capital",id:"about-float-capital",children:[]}],p={toc:h};function d(e){var t=e.components,l=(0,o.Z)(e,r);return(0,i.kt)("wrapper",(0,n.Z)({},p,l,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("p",null,"First up, some massive news. The Float Capital Alpha goes LIVE on Polygon, this ",(0,i.kt)("strong",null,"Friday, September 17, 2021.")),(0,i.kt)("img",{src:"/blog-assets/float-chainlink.png",alt:"float-chainlink",width:"100%"}),(0,i.kt)("p",null,"Given we are pioneering the future of on-chain assets, our Alpha launch relies on safe and up-to-date access to asset prices. For this reason, we are proud to announce that the launch of the Float Capital protocol is powered by ",(0,i.kt)("a",{parentName:"p",href:"http://data.chain.link"},"Chainlink Price Feeds")," on the Polygon mainnet to provide access to high-quality financial market data, helping ensure on-chain assets are properly pegged to the assets they represent."),(0,i.kt)("p",null,"Float allows users to effortlessly turn their crypto dollars into an asset of their choice. Whether it\u2019s crypto assets, commodities, forex, specialized assets (the flippening), and more, we have it covered in an easy, safe, and efficient manner. Under the hood, we have some incredible tech! Pop into our Discord if you\u2019d like to ",(0,i.kt)("a",{parentName:"p",href:"https://discord.gg/Kv8Eda6T"},"learn more"),"."),(0,i.kt)("p",null,(0,i.kt)("img",{alt:"float-landing-app",src:a(8519).Z})),(0,i.kt)("em",null,"The Float UI, live from our test site."),(0,i.kt)("p",null,"In order for our on-chain assets to accurately track the asset prices they represent, we needed a secure and reliable decentralized oracle solution for our protocol. After building in the blockchain space for more than three years and exploring different solutions, we have chosen to integrate Chainlink as it is the most optimal oracle solution for Float."),(0,i.kt)("p",null,"Chainlink Price Feeds are powered by a decentralized network of secure oracle nodes that aggregate data from multiple premium data providers. This helps ensure Float has tamper-proof and efficient access to a diverse range of highly accurate financial market data on a range of different crypto assets, indices, and more. Some of the key reasons we choose Chainlink Price Feeds include:"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"High-Quality Data \u2014 Chainlink Price Feeds source data from numerous premium data aggregators, leading to price data that\u2019s aggregated from hundreds of exchanges, weighted by volume, and cleaned from outliers and suspicious volumes. Chainlink\u2019s data aggregation model helps generate more precise global market prices that are resistant to API downtime, flash crash outliers, and data manipulation attacks like ",(0,i.kt)("a",{parentName:"li",href:"https://blog.chain.link/flash-loans-and-the-importance-of-tamper-proof-oracles/"},"flash loans"),"."),(0,i.kt)("li",{parentName:"ul"},"Secure Node Operators \u2014 Chainlink Price Feeds are secured by independent, security-reviewed, and Sybil-resistant oracle nodes run by leading blockchain DevOps teams, data providers, and traditional enterprises with a strong track record for reliability, even during high gas prices and extreme network congestion."),(0,i.kt)("li",{parentName:"ul"},"Decentralized Network \u2014 Chainlink Price Feeds are decentralized at the data source, oracle node, and oracle network levels, generating strong protections against downtime and tampering by either the data provider or the oracle network."),(0,i.kt)("li",{parentName:"ul"},"Economy of Scale \u2014 Chainlink Price Feeds benefit from an economy of scale effect, where increasing adoption allows multiple projects to collectively use and fund shared oracle networks to fetch commonly required datasets (e.g. ETH/USD). This allows DeFi projects to get premium data quality and robust oracle security for a fraction of the total cost.")),(0,i.kt)("p",null,"Made possible through this Chainlink integration, the first market launching in the Float Alpha this Friday (17th of September), is \u2026."),(0,i.kt)("h2",{id:"the-flipp3ning"},"The Flipp3ning!"),(0,i.kt)("p",null,"The Flippening is a term used to describe the point at which Ether \u2018flips\u2019 Bitcoin through a larger market capitalization. The Flipp3ning is a 3x leveraged position tracking the relative market cap of Ether compared against the market cap of Bitcoin. This allows users to take a position for or against the flippening, allowing users to gain financial exposure to this event."),(0,i.kt)("p",null,"The Chainlink Labs team moves fast, allowing us to build with confidence and scale the protocol and bring you many more markets in Alpha season through the launch of new data feeds. We want to give them a big shout-out for accommodating all our crazy price feed requests with lightning-fast response time and without compromising on security or reliability."),(0,i.kt)("h2",{id:"did-someone-say-gems"},"Did someone say GEMS?"),(0,i.kt)("p",null,(0,i.kt)("img",{parentName:"p",src:"https://float.capital/img/gem.gif",alt:"float-gems"})),(0,i.kt)("p",null,"Users can collect 250 GEMS every day for simply interacting with the Float Capital protocol. We can\u2019t share any more details right now, but it may or may not involve ",(0,i.kt)("a",{parentName:"p",href:"https://chain.link/solutions/chainlink-vrf"},"Chainlink VRF")," in the future. \ud83d\udc40"),(0,i.kt)("h2",{id:"under-the-hood"},"Under the hood"),(0,i.kt)("p",null,"Let\u2019s take a quick technical deep dive."),(0,i.kt)("p",null,"Although an oversimplification, it may be useful to think of Float as a non-expiry futures contract that settles and rolls over into a new contract at every Chainlink oracle update. Based on demand and supply of liquidity in long and short positions on the on-chain asset, new terms will be algorithmically calculated for a given epoch."),(0,i.kt)("p",null,"Whenever a new Chainlink oracle update occurs, we have an update system state hook that will automatically fetch the latest price from the reference contract, adjust system liquidity, and perform incentive actions based on the updated price, before finally incrementing the epoch (or what we sometimes call the index)."),(0,i.kt)("p",null,"This helps ensure that the peg of the on-chain assets matches the asset it represents by incentivizing people to enter the less popular position. Securing this process are Chainlink Price Feeds, which update rapidly on the Polygon network to provide access to the freshest financial market data."),(0,i.kt)("p",null,"\u201cIntegrating the industry-standard Chainlink Price Feeds into the Float Capital protocol has provided us easy access to the high-quality financial market data required to mint on-chain assets in a hyper-reliable and secure manner,\u201d stated Jon Jon Clark, Co-Founder of Float Capital. \u201cWe look forward to expanding our Chainlink integration to include additional secure oracle services, helping grow and bring advanced utility to our products.\u201d"),(0,i.kt)("img",{src:"/blog-assets/model-diagram.jpg",alt:"float-chainlink-diagram",width:"100%"}),(0,i.kt)("h2",{id:"about-chainlink"},"About Chainlink"),(0,i.kt)("p",null,"Chainlink is the industry standard for building, accessing, and selling oracle services needed to power hybrid smart contracts on any blockchain. Chainlink oracle networks provide smart contracts with a way to reliably connect to any external API and leverage secure off-chain computations for enabling feature-rich applications. Chainlink currently secures tens of billions of dollars across DeFi, insurance, gaming, and other major industries, and offers global enterprises and leading data providers a universal gateway to all blockchains."),(0,i.kt)("p",null,"Learn more about Chainlink by visiting ",(0,i.kt)("a",{parentName:"p",href:"https://chain.link/"},"chain.link")," or read the documentation at ",(0,i.kt)("a",{parentName:"p",href:"https://docs.chain.link"},"docs.chain.link"),". To discuss an integration, reach out to an expert."),(0,i.kt)("h2",{id:"about-float-capital"},"About Float Capital"),(0,i.kt)("p",null,(0,i.kt)("a",{parentName:"p",href:"https://float.capital"},"Float Capital")," builds peer-to-peer, yield enhanced on-chain asset markets that allows users to mint assets in a matter of clicks, without the need for over collateralisation or the risk of liquidation."),(0,i.kt)("p",null,"You can ",(0,i.kt)("a",{parentName:"p",href:"https://float.capital/app/"},"test out the protocol"),", UI, and our market mechanisms on the Mumbai Testnet. The alpha launch will go live for real capital on Friday, September 17th. If you want to learn more about how the protocol is designed to maximise your exposure, read our documentation. If you want to join the community, meet the team and vote on upcoming markets, join our ",(0,i.kt)("a",{parentName:"p",href:"https://discord.gg/yyrHVeDd"},"Discord")," or follow us on ",(0,i.kt)("a",{parentName:"p",href:"https://twitter.com/float_capital"},"Twitter"),". The Float Alpha release has various risks such as smart contract, composability, stable coin, network, and financial risk. Please deposit responsibly."))}d.isMDXComponent=!0},8519:function(e,t,a){"use strict";t.Z=a.p+"assets/images/landing-app-4ab1afce7c4acf89612334f944700cdd.png"}}]);