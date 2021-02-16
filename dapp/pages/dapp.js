import Dapp from "src/Dapp";
import Head from "next/head";

export default function DappPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <Dapp {...props} />
    </div>
  );
}
