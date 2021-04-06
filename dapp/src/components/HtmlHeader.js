import Head from "next/head";

const HtmlHeader = ({ page, children }) => (
  <>
    <Head>
      <title>Float Capital | {page}</title>
      <meta
        property="og:title"
        content={`Float Capital | ${page}`}
        key="title"
      />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      {children}
    </Head>
  </>
);

export default HtmlHeader;
