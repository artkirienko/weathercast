import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["submit"];
  static values = { text: String };

  disable() {
    this.submitTarget.disabled = true;
    this.originalText = this.submitTarget.innerHTML;
    this.submitTarget.innerHTML = this.textValue || this.originalText;
  }

  enable() {
    if (this.submitTarget.disabled) {
      this.submitTarget.disabled = false;
      this.submitTarget.innerHTML = this.originalText;
    }
  }
}
