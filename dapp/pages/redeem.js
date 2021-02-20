import Redeem from "src/Redeem";
import Head from "next/head";

export default function RedeemPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital | Redeem</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <Redeem {...props} />
    </div>
  );
}
