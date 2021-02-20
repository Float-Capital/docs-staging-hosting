import Profile from "src/Profile";
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
      <Profile {...props} />
    </div>
  );
}
