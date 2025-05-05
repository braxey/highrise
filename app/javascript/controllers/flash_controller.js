import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { hideAfter: Number }

  connect() {
    setTimeout(() => {
      this.element.classList.add("opacity-0")
      setTimeout(() => this.element.remove(), 300)
    }, this.hideAfterValue || 2000)
  }
}
