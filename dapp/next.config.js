const bsconfig = require("./bsconfig.json");

// Relative to src/Config - similarly with the `CONFIG_FILE` env variable.
let defaultConfig = "./config.json";

const transpileModules = ["bs-platform"].concat(bsconfig["bs-dependencies"]);
const withTM = require("next-transpile-modules")(transpileModules);

const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js"],
  transpileModules: ["bs-platform"].concat(bsconfig["bs-dependencies"]),
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    config.resolve.alias["config_file"] =
      process.env.CONFIG_FILE || defaultConfig;
    const { isServer } = options;
    if (!isServer) {
      // We shim fs for things like the blog slugs component
      // where we need fs access in the server-side part
      config.node = {
        fs: "empty",
      };
    }
    return config;
  },
};

module.exports = withTM(config);
