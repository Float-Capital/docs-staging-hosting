import "styles/main.css";

import Head from "next/head";

// Note:
// Just renaming $$default to ResApp alone
// doesn't help FastRefresh to detect the
// React component, since an alias isn't attached
// to the original React component function name.
import ResApp from "src/App.js";

// The following code comes form here: https://levelup.gitconnected.com/improve-ux-of-your-next-js-app-in-3-minutes-with-page-loading-indicator-3a42211330u
import Router from "next/router";
import withGA from "next-ga";
import NProgress from "nprogress"; //nprogress module
import "nprogress/nprogress.css"; //styles of nprogress//Binding events.
Router.events.on("routeChangeStart", (_url, options) => {
  if (!options?.shallow) {
    NProgress.start();
  }
});
Router.events.on("routeChangeComplete", (_url, options) => {
  if (!options?.shallow) {
    NProgress.done();
  }
});
Router.events.on("routeChangeError", (_url, options) => {
  if (!options?.shallow) {
    NProgress.done();
  }
});

const googleAnalyticsMeasurementId = "G-CP1WC8846P";

// Note:
// We need to wrap the make call with
// a Fast-Refresh conform function name,
// (in this case, uppercased first letter)
//
// If you don't do this, your Fast-Refresh will
// not work!
const App = (props) => (
  <div>
    <Head>
      <link rel="shortcut icon" href="/favicons/favicon.ico" />
    </Head>
    <ResApp {...props} />
  </div>
);

export default withGA(googleAnalyticsMeasurementId, Router)(App);
