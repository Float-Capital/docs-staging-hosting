import React, { useEffect } from "react";
import Layout from "@theme/Layout";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import styles from "./styles.module.css";

function Redirect() {
  // TODO make page a loading component

  useEffect(() => {
    window.location.href = "docs/";
  }, []);

  const context = useDocusaurusContext();
  const { siteConfig = {} } = context;
  return (
    <Layout
      title={`Float Capital Docs ${siteConfig.title}`}
      description="Float Capital Documentation"
    >
      <main>Loading...</main>
    </Layout>
  );
}

export default Redirect;
