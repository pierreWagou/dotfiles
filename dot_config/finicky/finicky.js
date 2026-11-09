export default {
  defaultBrowser: {
    name: "Zen",
    profile: "Wagou",
  },
  handlers: [
    {
      match: "*meet.google.com*",
      browser: {
        name: "Zen",
        profile: "Alan",
      },
    },
    {
      match: "*alan*",
      browser: {
        name: "Zen",
        profile: "Alan",
      },
    },
  ],
};
