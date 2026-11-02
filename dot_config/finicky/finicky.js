// Managed by chezmoi.
// URLs containing "alan" open in the Alan profile of Zen.
// Everything else falls through to Finicky's default handling.
// Requires Finicky 4.4+ for Firefox-family profile support.
export default {
  handlers: [
    {
      match: (url) => url.href.toLowerCase().includes("alan"),
      browser: {
        name: "Zen",
        profile: "Alan",
      },
    },
  ],
};
