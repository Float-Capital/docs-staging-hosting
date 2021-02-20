import Mint from "src/Mint";
import Head from "next/head";

export default function MintPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital | Mint</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <Mint {...props} />
    </div>
  );
}
