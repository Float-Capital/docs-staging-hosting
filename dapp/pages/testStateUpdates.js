import StateUpdates from "src/components/Testing/StateUpdates";
import Head from "next/head";

export default function StateUpdates(props) {
  return (
    <div>
      <Head>
        <title>Float Capital</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <StateUpdates {...props} />
    </div>
  );
}
