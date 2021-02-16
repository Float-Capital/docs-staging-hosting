import Dashboard from "src/Dashboard";
import Head from "next/head";

export default function DashboardPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <Dashboard {...props} />
    </div>
  );
}
