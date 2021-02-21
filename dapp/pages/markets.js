import Markets from "src/Markets";
import Head from "next/head";

export default function MarketsPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital | Markets</title>
        <meta
          property="og:title"
          content="Float Capital | Markets"
          key="title"
        />
      </Head>
      <Markets {...props} />
    </div>
  );
}
