import IndexRes from "src/Index.js";
import Head from "next/head";

export default function Index(props) {
  return (
    <div>
      <Head>
        <title>Float Capital</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <IndexRes {...props} />
    </div>
  );
}
