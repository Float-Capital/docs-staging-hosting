import Login from "src/components/Login/Login";
import Head from "next/head";

export default function LoginPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <Login {...props} />
    </div>
  );
}
