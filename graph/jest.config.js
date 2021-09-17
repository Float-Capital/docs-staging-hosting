// Or async function
module.exports = async () => {
  return {
    "rootDir": ".",
    "testPathIgnorePatterns": [
      "<rootDir>/src/", "<rootDir>/node_modules/"]
  };
};
