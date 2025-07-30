import { Controller } from "@hotwired/stimulus"

// This Stimulus controller manages the display of temperature units (°C or °F).
// It hides/shows elements with specific data-temperature-target attributes
// based on which temperature unit toggle is clicked
export default class extends Controller {
  static targets = ["celsius", "fahrenheit", "celsiusToggle", "fahrenheitToggle"]

  connect() {
    this.showCelsius();
  }

  showCelsius() {
    this.celsiusTargets.forEach(el => el.style.display = "inline");
    this.fahrenheitTargets.forEach(el => el.style.display = "none");

    this.celsiusToggleTarget.classList.add("active");
    this.fahrenheitToggleTarget.classList.remove("active");
  }

  showFahrenheit() {
    this.celsiusTargets.forEach(el => el.style.display = "none");
    this.fahrenheitTargets.forEach(el => el.style.display = "inline");

    this.fahrenheitToggleTarget.classList.add("active");
    this.celsiusToggleTarget.classList.remove("active");
  }
}
