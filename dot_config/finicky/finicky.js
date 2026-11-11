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
    {
      match: "*oidc.eu-central-1.amazonaws.com*",
      browser: {
        name: "Zen",
        profile: "Alan",
      },
    },
    {
      match: "*datadoghq*",
      browser: {
        name: "Zen",
        profile: "Alan",
      },
    },
  ],
};
