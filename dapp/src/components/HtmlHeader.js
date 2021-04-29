import Head from "next/head";

const HtmlHeader = ({ page, children }) => (
  <>
    <Head>
      <title>Float Capital | {page}</title>
      <link rel="shortcut icon" href="/favicons/favicon.ico" />
      <meta
        property="og:title"
        content={`Float Capital | ${page}`}
        key="title"
      />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <script
        async
        src="https://www.googletagmanager.com/gtag/js?id=G-CP1WC8846P"
      ></script>
      <script
        dangerouslySetInnerHTML={{
          __html: `
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', 'G-CP1WC8846P');
        `,
        }}
      />
      {children}
    </Head>
  </>
);

export default HtmlHeader;
