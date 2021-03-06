import AdminTestingPortal from "src/components/Testing/Admin/AdminTestingPortal.js";
import Head from "next/head";

export default function AdminPage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital</title>
        <meta property="og:title" content="Float Capital" key="title" />
      </Head>
      <AdminTestingPortal {...props} />
    </div>
  );
}
