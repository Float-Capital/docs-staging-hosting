(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[2942],{3905:function(e,n,a){"use strict";a.d(n,{Zo:function(){return f},kt:function(){return C}});var r=a(7294);function t(e,n,a){return n in e?Object.defineProperty(e,n,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[n]=a,e}function c(e,n){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),a.push.apply(a,r)}return a}function d(e){for(var n=1;n<arguments.length;n++){var a=null!=arguments[n]?arguments[n]:{};n%2?c(Object(a),!0).forEach((function(n){t(e,n,a[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):c(Object(a)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(a,n))}))}return e}function o(e,n){if(null==e)return{};var a,r,t=function(e,n){if(null==e)return{};var a,r,t={},c=Object.keys(e);for(r=0;r<c.length;r++)a=c[r],n.indexOf(a)>=0||(t[a]=e[a]);return t}(e,n);if(Object.getOwnPropertySymbols){var c=Object.getOwnPropertySymbols(e);for(r=0;r<c.length;r++)a=c[r],n.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(t[a]=e[a])}return t}var l=r.createContext({}),s=function(e){var n=r.useContext(l),a=n;return e&&(a="function"==typeof e?e(n):d(d({},n),e)),a},f=function(e){var n=s(e.components);return r.createElement(l.Provider,{value:n},e.children)},i={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},b=r.forwardRef((function(e,n){var a=e.components,t=e.mdxType,c=e.originalType,l=e.parentName,f=o(e,["components","mdxType","originalType","parentName"]),b=s(a),C=t,E=b["".concat(l,".").concat(C)]||b[C]||i[C]||c;return a?r.createElement(E,d(d({ref:n},f),{},{components:a})):r.createElement(E,d({ref:n},f))}));function C(e,n){var a=arguments,t=n&&n.mdxType;if("string"==typeof e||t){var c=a.length,d=new Array(c);d[0]=b;var o={};for(var l in n)hasOwnProperty.call(n,l)&&(o[l]=n[l]);o.originalType=e,o.mdxType="string"==typeof e?e:t,d[1]=o;for(var s=2;s<c;s++)d[s]=a[s];return r.createElement.apply(null,d)}return r.createElement.apply(null,a)}b.displayName="MDXCreateElement"},5454:function(e,n,a){"use strict";a.r(n),a.d(n,{frontMatter:function(){return o},contentTitle:function(){return l},metadata:function(){return s},toc:function(){return f},default:function(){return b}});var r=a(2122),t=a(9756),c=(a(7294),a(3905)),d=["components"],o={id:"addresses",title:"Addresses",sidebar_label:"Addresses",slug:"/addresses"},l=void 0,s={unversionedId:"addresses",id:"addresses",isDocsHomePage:!1,title:"Addresses",description:"NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77",source:"@site/docs/addresses.md",sourceDirName:".",slug:"/addresses",permalink:"/docs/addresses",editUrl:"https://github.com/Float-Capital/docs/addresses.md",version:"current",frontMatter:{id:"addresses",title:"Addresses",sidebar_label:"Addresses",slug:"/addresses"},sidebar:"someSidebar",previous:{title:"Governance",permalink:"/docs/governance"},next:{title:"Mint",permalink:"/docs/mint"}},f=[{value:"Polygon",id:"polygon",children:[{value:"Markets",id:"markets",children:[]},{value:"GemNFTs",id:"gemnfts",children:[]}]},{value:"Mumbai testnet",id:"mumbai-testnet",children:[{value:"Contracts",id:"contracts",children:[]},{value:"Markets",id:"markets-1",children:[]},{value:"GemNFTs",id:"gemnfts-1",children:[]}]},{value:"Avalanche",id:"avalanche",children:[{value:"Contracts",id:"contracts-1",children:[]},{value:"Markets",id:"markets-2",children:[]}]}],i={toc:f};function b(e){var n=e.components,a=(0,t.Z)(e,d);return(0,c.kt)("wrapper",(0,r.Z)({},i,a,{components:n,mdxType:"MDXLayout"}),(0,c.kt)("sub",null,(0,c.kt)("sup",null," NOTE: These docs are under active development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77 ")),(0,c.kt)("hr",null),(0,c.kt)("h2",{id:"polygon"},"Polygon"),(0,c.kt)("p",null,"Our Polygon alpha launch contracts.\nJoin our ",(0,c.kt)("a",{parentName:"p",href:"https://discord.gg/qesr2KZAhn"},"discord")," for the latest updates!"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'"contracts": {\n  "FloatToken": "0x01309A1Ec476871760D9Ea454628500BCcc1E011",\n  "FloatCapital_v0": "0xEe0c19f26b3B3A4fb82f466a6023DcD979c27a2F",\n  "GEMS": "0x756218A9476bF7C75a887d9c7aB916DE15AB5Ddf",\n  "LongShort": "0x168a5d1217AEcd258b03018d5bF1A1677A07b733",\n  "Staker": "0xe7C89eb987c415B4233789E5ceC0eE7407d2C47F",\n  "TokenFactory": "0x809C2619a27c58334CAac07470899e4dd0574AEC",\n  "Treasury_v0": "0xeb1bB399997463d8Fd0cb85C89Da0fc958006441",\n  "Dai": "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"\n}\n')),(0,c.kt)("h3",{id:"markets"},"Markets"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'[\n  "Flipp3ning": {\n    "OracleManager": "0x70a760ACD5503A8D6746BC7F00571F570ae0aD44",\n    "LongToken": "0xb10ffC060cc7659f0726c8452a586e30338145cF",\n    "ShortToken": "0x7AD3a979D45E1636558A5c3d8BD8a4dA4cB30349",\n    "YieldManager": "0xce5da4bebBA980BeC39da5b118750A47a23D4B85"\n  },\n  "3TH": {\n    "OracleManager": "0x063fD075441De59ccf0d941fa0500CB0B95Db0c6",\n    "LongToken": "0x5bF9dFB1B27c28e5a1D8e5c5385A1A353eC9D118",\n    "ShortToken": "0x97B0Ba4a8Ba02B8d002C156a7BEdBF5264CC0f7A",\n    "YieldManager": "0x595b1408C9c2BF121c7674E270Ca7aCc0bBf100C"\n  }\n  "2OHMv1": {\n    "OracleManager": "0x4CA98cA34EE279E4966a7C54e6eEFF67d1eD23E9",\n    "LongToken": "0x6735fdd28c71d17C9a26F1cbf0082358Bfb622Ad",\n    "ShortToken": "0x16dcb8d591Bc82f1f2AB33d420B735c60fBc0Be5",\n    "YieldManager": "0x694c240e63CF60a2cD2d38d84D902744640AcCDA"\n  }\n  "2AXS": {\n    "OracleManager": "0x14FaF67A0c01b114e1232d2a9fCc07A7A3856F7A",\n    "LongToken": "0xfb4449b3a2F86B4A99907855Ed6ce4dDC8Cf8247",\n    "ShortToken": "0x3Cb62c423AF4C56f4F47B4565e423Da5592b68cD",\n    "YieldManager": "0x92f29DfceA469ab498ade826FB41d065482B6abA"\n  }\n  "2CVI": {\n    "OracleManager": "0x4533E90F4FE097B406257fC8Ea041c57aD2e5358",\n    "LongToken": "0xf17cEF41655c7aa2987ef5973ea816f0b7Db2735",\n    "ShortToken": "0x67c349467D639A9e0822c079Aee8DF9964308BC9",\n    "YieldManager": "0xB26289Bee42Aa1ad51466dc28e68ab89f0541A7f"\n  }\n  "2LINK": {\n    "OracleManager": "0xaEDADFA7027Eb38749096CC63fA2BFC2b1cF180f",\n    "LongToken": "0x5aDD940aFD2077C7332205d971bdB7eFDA0b1A95",\n    "ShortToken": "0xa5f32126b7F0C893C32caeBF76faab7FAC2b1336",\n    "YieldManager": "0x1372276638bFc1FCe909B05783D91e526B801669"\n  }\n  "2OHMv2": {\n    "OracleManager": "0x4518502fcD88E7d39AD650E0290a8113Baab3077",\n    "LongToken": "0x1545747AB2255B065FB0C0BAdBB80e80BC2D93cE",\n    "ShortToken": "0xE222470497901EF69f7ef3ce4b9830D35Bea945a",\n    "YieldManager": "0x38c23db64e4a22A9f277216a34A88f5a1fB3Cf5e"\n  }\n]\n')),(0,c.kt)("h3",{id:"gemnfts"},"GemNFTs"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'"GemNFT" : "0x220e474CF38D6001727Efff4fC57F8821a55FaFF"\n')),(0,c.kt)("h2",{id:"mumbai-testnet"},"Mumbai testnet"),(0,c.kt)("p",null,"NOTE: these testnet addresses are frequently changing during development \ud83d\udc77\u200d\u2640\ufe0f\ud83d\udc77"),(0,c.kt)("h3",{id:"contracts"},"Contracts"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'"contracts": {\n  "FloatToken": "0x3F23BEE690528BdcF91266f8Ae203e7c096eD9EB",\n  "FloatCapital_v0": "0x77C40394F880dA87b3a93360769c057657f2d6C7",\n  "GEMS": "0x775e5fD997C0866c3D10E3139bb07Ff822400ceE",\n  "LongShort": "0x4E95db55dbF56ebfebB58090b968b118491800A8",\n  "Staker": "0x06fdEB2CC64ABb5cBa94E060eE5A9749Fe7691e2",\n  "TokenFactory": "0x1334926dD7735ff52017187061e03C2172dd98CE",\n  "Treasury_v0": "0x888EbC416f3823100b5d3FB38aD1C6603ebAe718",\n  "Dai": "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F"\n}\n')),(0,c.kt)("h3",{id:"markets-1"},"Markets"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'[\n  "btc": {\n    "OracleManager": "0xFADB7F1BA1c018D6b62A88F1fF2b8a4E5FEE5608",\n    "LongToken": "0x32e922895de13E72bcd4712879625dAb7d3A35b3",\n    "ShortToken": "0xDa365D4d28e450D50E9Cf3081F17418bFd9ADB7d",\n    "YieldManagerBTC": "0x288551a9de11C0aF4BA77D113422AbDA0b4ffA14"\n  },\n  "eth": {\n    "OracleManager": "0x11B9C1a257751692509D363f197433D8fcDB106f"\n    "LongToken": "0xde110beEE58e2Acd21E51158FF904E3BF5122466",\n    "ShortToken": "0x56692a61f16FddDAe7a8466143AabE34E7c59D49",\n    "YieldManagerETH": "0x164cA2b7d86B0c69fe4F0ed6F41f869BE3c440cb"\n  },\n  "matic": {\n    "OracleManager": "0x5DF1C01167f6c4354AAa8DdEb151A55d067Fed5A"\n    "LongToken": "0x9873DC1205806dE6e03B362efD830678c14ff163",\n    "ShortToken": "0xbb21E0b224e42cAE419A81884E1b61D37fd10740",\n    "YieldManagerMATIC": "0xAECb6aAbCF1f72ce1e84D416fE985C896C4a56Aa"\n  }\n  "sand": {\n    "OracleManager": "0x333c8AF3F166f58946777148eDec5f42BC76702f"\n    "LongToken": "0x0abC2F4fF54d33B0C64Ea414F8AD6353BA1C5C5C",\n    "ShortToken": "0xdfF4e78EfE202369A362C3523CBB11b4A3c7B0C7",\n    "YieldManagerSAND": "0x63f58bb60483c5d6304b9ac7fdfc517d2a802e7e"\n  }\n]\n')),(0,c.kt)("h3",{id:"gemnfts-1"},"GemNFTs"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'"GemNFT" : "0x3f2AdE1C7A42B2BA86647F3C26b476D8Ea3E0F15"\n')),(0,c.kt)("h2",{id:"avalanche"},"Avalanche"),(0,c.kt)("h3",{id:"contracts-1"},"Contracts"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'  ["contracts": {\n    "FloatToken": "0x9fB133B2C5218D7DDb97422aa27c0eD04122c944",\n    "FloatCapital_v0": "0x865C1a2388E0E9C2D9b347D8DcAc617E056D16d9",\n    "GEMS": "0xB779a4A28012e12Ff904754bBE72F60423AF0A28",\n    "GemCollectorNFT": "0xEB73D5CbB26536F714785B7864806542f41ab9E5",\n    "LongShort": "0x0db3c59c187ecfa36a9C9f6CFa3664D06c2B5556",\n    "Staker": "0xD2EEAafF35281757F87e4d535763c3d4c35b62C1",\n    "TokenFactory": "0x4B9bd38593A26325218A16805C9D6D3651D9E8d0",\n    "Treasury_v0": "0x4e813624E1E0906e23fa22E2d120b4c4e2F89E4e",\n    "Dai": "0xd586E7F844cEa2F87f50152665BCbc2C279D8d70",\n  }]\n')),(0,c.kt)("h3",{id:"markets-2"},"Markets"),(0,c.kt)("pre",null,(0,c.kt)("code",{parentName:"pre",className:"language-javascript"},'[\n  "2AVAX": {\n    "OracleManager": "0xE22268dB718912dc6A73106dd4ABf34080b1C4e1",\n    "LongToken": "0xa43a73f17ECde987A9127A5cBE46B7923F351c32",\n    "ShortToken": "0xdC883B026F78FF494199778001b23f38edA89d6d",\n    "YieldManager": "0x621cda10820555adAe8506eeC296cB9621E491Ff"\n  },\n  "2JOE": {\n    "OracleManager": "0xEc120de9fFaE289f5b383ffb582F3cC1F449E3aa",\n    "LongToken": "0x6A621D256CFEDa1c10ab0Cbd1Ff8d5310b35e4d3",\n    "ShortToken": "0x1dCAA44bEA82bd135C51b158E5E702e3C1843951",\n    "YieldManager": "0x47a21F14794b6229cc2a1ddfe4498C9e48f1C16c"\n  }\n   "2QI": {\n    "OracleManager": "0x9341437bbb9c7C0Ed5DcaDA60886780aB3C81524",\n    "LongToken": "0xE11c7a822547ba1910a5932472BF3ebFbB6b3C29",\n    "ShortToken": "0x07897e6Fbfb0C05821D6816E2c7e632251b4C23a",\n    "YieldManager": "0xEb2A90ED68017Ac1B068077C5D1537f4C544036C"\n  }\n   "2SPELL": {\n    "OracleManager": "0xD1d169B5898b142EBbEbc3E94Cfa7E05C84e957b",\n    "LongToken": "0x9D11384E518e25184A6DDe0f54E5b141A1441F65",\n    "ShortToken": "0x36a4C537ef66429624537070E30dbc2C53e3B941",\n    "YieldManager": "0xcD62196CC117EA7fd9525ADe37e44d01209e8EBB"\n  }\n]\n')))}b.isMDXComponent=!0}}]);