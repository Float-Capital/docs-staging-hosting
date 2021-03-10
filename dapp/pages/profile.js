import User from "src/User";
import Head from "next/head";

export default function ProfilePage(props) {
  return (
    <div>
      <Head>
        <title>Float Capital | Profile</title>
        <meta
          property="og:title"
          content="Float Capital | Profile"
          key="title"
        />
      </Head>
      <User {...props} />
    </div>
  );
}
