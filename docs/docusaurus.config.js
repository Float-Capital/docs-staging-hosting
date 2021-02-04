module.exports = {
  title: "Float Capital | Docs",
  tagline: "Onchain decentralized exposure to 100% collatoralized derivatives",
  url: "https://docs.float.capital",
  baseUrl: "/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "favicons/favicon.ico",
  organizationName: "avolabs-io",
  projectName: "float.Capital docs",
  themeConfig: {
    navbar: {
      title: "",
      logo: {
        alt: "Float Capital Logo",
        src: "img/float-capital-logo-med.png",
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
          href: "https://github.com/avolabs-io",
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
            {
              label: "Blog",
              to: "blog",
            },
            {
              label: "GitHub",
              href: "https://github.com/avolabs-io",
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
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          editUrl: "https://github.com/",
        },
        blog: {
          showReadingTime: true,
          editUrl: "https://github.com/",
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      },
    ],
  ],
};
