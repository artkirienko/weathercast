// This script logs a welcome message to the console only once per full application load
if (window.welcomeMessageDisplayed === undefined) {
  console.log("Built with ❤️ by Artem Kirienko. *100% Human-made, No AI involved © 2025");
  window.welcomeMessageDisplayed = true;
}
