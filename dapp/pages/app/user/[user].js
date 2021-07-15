import Head from "next/head";
import User from "src/pages/User";

export default function UserPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital | User</title>
        <meta property="og:title" content="Float Capital | User" key="title" />
      </Head>
      <User {...props} />
    </div>
  );
}
