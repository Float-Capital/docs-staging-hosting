const primaryColor = "#0d4184";
const primaryLightColor = "#1151A6";
const lightGold = "#fff3e6";
const pastelBlue = "#AAD4EC";
const pastelPurple = "#cec8e8";
const pastelOrange = "#fcded4";
const pastelPink = "#f1d7e4";
const pastelDarkBlue = "#7497c6";
const pastelYellow = "#E2F6F7";
const pastelLightBlue = "#AAC0D8";
module.exports = {
  purge: {
    // Specify the paths to all of the template files in your project
    content: ["./src/**/*.res"],
    options: {
      safelist: ["html", "body"],
    },
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      textColor: (theme) => ({
        ...theme("colors"),
        primary: primaryColor,
        "primary-light": primaryLightColor,
        "pastel-blue": pastelBlue,
        "pastel-purple": pastelPurple,
        "pastel-orange": pastelOrange,
        "pastel-pink": pastelPink,
        "pastel-dark-blue": pastelDarkBlue,
        "pastel-yellow": pastelYellow,
        "pastel-light-blue": pastelLightBlue,
      }),
      width: {
        "1/8": "12%",
      },
    },
    /* Most of the time we customize the font-sizes,
     so we added the Tailwind default values here for
     convenience */
    fontSize: {
      xxxs: ".5rem",
      xxs: ".6rem",
      xs: ".75rem",
      sm: ".875rem",
      base: "1rem",
      lg: "1.125rem",
      xl: "1.25rem",
      "2xl": "1.5rem",
      "2.5xl": "1.65rem",
      "3xl": "1.875rem",
      "4xl": "2.25rem",
      "5xl": "3rem",
      "6xl": "4rem",
    },
    minWidth: {
      "1/2": "50%",
      "3/4": "75%",
      340: "340px",
      400: "400px",
      500: "500px",
      56: "56px",
    },
    minHeight: {
      "1/2": "50%",
      "3/4": "75%",
      full: "100%",
      "half-screen": "50vh",
      "market-interaction-card": "16.5rem",
      screen: "100vh",
    },
    borderColor: (theme) => ({
      ...theme("colors"),
      DEFAULT: primaryColor,
      "primary-light": primaryLightColor,
      "pastel-blue": pastelBlue,
      "pastel-purple": pastelPurple,
      "pastel-orange": pastelOrange,
      "pastel-pink": pastelPink,
      "pastel-dark-blue": pastelDarkBlue,
      "pastel-yellow": pastelYellow,
      "pastel-light-blue": pastelLightBlue,
    }),
    backgroundColor: (theme) => ({
      ...theme("colors"),
      primary: primaryColor,
      "primary-light": primaryLightColor,
      "light-gold": lightGold,
      "pastel-blue": pastelBlue,
      "pastel-purple": pastelPurple,
      "pastel-orange": pastelOrange,
      "pastel-pink": pastelPink,
      "pastel-dark-blue": pastelDarkBlue,
      "pastel-yellow": pastelYellow,
      "pastel-light-blue": pastelLightBlue,
    }),
    textColor: {
      primary: primaryColor,
      "primary-light": primaryLightColor,
      "pastel-blue": pastelBlue,
      "pastel-purple": pastelPurple,
      "pastel-orange": pastelOrange,
      "pastel-pink": pastelPink,
      "pastel-dark-blue": pastelDarkBlue,
      "pastel-yellow": pastelYellow,
      "pastel-light-blue": pastelLightBlue,
    },
    letterSpacing: {
      tighter: "-.05em",
      tight: "-.025em",
      normal: "0",
      wide: ".025em",
      wider: ".05em",
      widest: ".1em",
      "btn-text": "0.2em",
    },
    /* We override the default font-families with our own default prefs  */
    fontFamily: {
      sans: [
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      serif: [
        "Georgia",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      mono: [
        "Menlo",
        "Monaco",
        "Consolas",
        "Roboto Mono",
        "SFMono-Regular",
        "Segoe UI",
        "Courier",
        "monospace",
      ],
      alphbeta: ["alphbeta"],
      vt323: ["vt323"],
      arimo: ["arimo"],
      default: ["menlo", "sans-serif"],
    },
  },
  variants: {
    width: ["responsive"],
    extend: {
      backgroundColor: ["active"],
      translate: ["active"],
      textColor: ["active"],
      outline: ["active"],
    },
  },
  plugins: [],
};
