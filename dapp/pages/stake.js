import StakeNew from "src/StakeNew";
import Head from "next/head";

export default function StakePage(props) {
  return (
    <>
      <Head>
        <title>Float Capital | Stake</title>
        <meta
          property="og:title"
          content="Float Capital | Stake key"
          key="title"
        />
      </Head>
      <StakeNew {...props} />
    </>
  );
}
