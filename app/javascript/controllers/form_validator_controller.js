import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["address"];

  validate(event) {
    if (this.addressTarget.value.trim() === "") {
      event.preventDefault();
      this.addressTarget.focus();
    }
  }
}
