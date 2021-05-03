require("dotenv").config();

const environment = process.env.ENVIRONMENT;

module.exports = {
  title: "Float Capital | Docs",
  tagline: "Onchain decentralized exposure to 100% collatoralized derivatives",
  url:
    environment === "production"
      ? "https://docs.float.capital"
      : "https://stagingdocs.float.capital",
  baseUrl: "/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "favicons/favicon.ico",
  organizationName: "float-capital",
  projectName: "float.Capital docs",
  themeConfig: {
    googleAnalytics: {
      trackingID: "G-C6SBFSRFEQ",
    },
    navbar: {
      title: "",
      logo: {
        alt: "Float Capital Logo",
        src: "img/float-capital-logo-med.png",
        href: "https://float.capital/markets",
      },
      items: [
        // {
        //   to: "https://float.capital",
        //   activeBasePath: "/",
        //   label: "Home",
        //   position: "left",
        // },
        // {
        //   to: "docs/",
        //   activeBasePath: "docs",
        //   label: "Docs",
        //   position: "left",
        // },
        // { to: "blog", label: "Blog", position: "left" },
        {
          href: "https://github.com/float-capital",
          label: "GitHub",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Docs",
          items: [
            {
              label: "Introduction",
              to: "docs/",
            },
            {
              label: "Resources",
              to: "docs/resources/",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "Discord",
              href: "#",
            },
            {
              label: "Twitter",
              href: "#",
            },
          ],
        },
        {
          title: "More",
          items: [
            // {
            //   label: "Home",
            //   to: "https://float.capital",
            // },
            // {
            //   label: "Blog",
            //   to: "blog",
            // },
            {
              label: "GitHub",
              href: "https://github.com/float-capital",
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Float Capital`,
    },
  },
  presets: [
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          // sidebarPath: require.resolve("./sidebars.js"),
          sidebarPath:
            process.env.ENVIRONMENT == "staging"
              ? require.resolve("./staging-sidebars.js")
              : require.resolve("./sidebars.js"),
          // Please change this to your repo.
          editUrl: "https://github.com/",
        },
        // blog: {
        //   showReadingTime: true,
        //   editUrl: "https://github.com/",
        // },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      },
    ],
  ],
  plugins: [
    [
      "docusaurus2-dotenv",
      {
        systemvars: true,
      },
    ],
  ],
};
