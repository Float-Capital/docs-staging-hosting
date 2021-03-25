const primaryColor = "#0d4184";
module.exports = {
  purge: {
    // Specify the paths to all of the template files in your project
    content: [
      "./src/components/**/*.res",
      "./src/layouts/**/*.res",
      "./src/*.res",
    ],
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
      }),
      // // Doesn't include an opacity gradient, rather use direct css
      // backgroundImage: (theme) => ({
      //   "float-pixels": "url('/backgrounds/2.png')",
      // }),
    },
    /* Most of the time we customize the font-sizes,
     so we added the Tailwind default values here for
     convenience */
    fontSize: {
      xxs: ".6rem",
      xs: ".75rem",
      sm: ".875rem",
      base: "1rem",
      lg: "1.125rem",
      xl: "1.25rem",
      "2xl": "1.5rem",
      "3xl": "1.875rem",
      "4xl": "2.25rem",
      "5xl": "3rem",
      "6xl": "4rem",
      /// Below are custom sizes
      // "600px": "600px",
    },
    minWidth: {
      "1/2": "50%",
      "3/4": "75%",
    },
    borderColor: (theme) => ({
      ...theme("colors"),
      DEFAULT: primaryColor,
    }),
    backgroundColor: (theme) => ({
      ...theme("colors"),
      primary: primaryColor,
    }),
    textColor: {
      primary: primaryColor,
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
