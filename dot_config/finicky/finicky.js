// Managed by chezmoi.
// URLs containing "alan" open in the Alan profile of Zen.
// Everything else falls through to Finicky's default handling.
// Requires Finicky 4.4+ for Firefox-family profile support.
export default {
  // Required by Finicky 4.4+. Everything that isn't an Alan URL goes
  // to the Wagou profile (registered ini name; resolves to the live
  // personal dir).
  defaultBrowser: {
    name: "Zen",
    profile: "Wagou",
  },
  handlers: [
    {
      // String glob (not a function): no matcher-signature risk on 4.4,
      // and declarative rules render in Finicky's Rules UI.
      // Native `profile` form per upstream PR #508 (tested on Zen):
      // resolves via profiles.ini and launches with -n plus the URL.
      match: "*alan*",
      browser: {
        name: "Zen",
        profile: "Alan",
      },
    },
  ],
};
