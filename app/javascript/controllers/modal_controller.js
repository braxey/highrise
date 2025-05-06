import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "form"]
  static values = { open: Boolean }

  connect() {
    if (this.openValue) {
      this.dialogTarget.classList.remove("hidden")
    }
  }

  open(event) {
    event.preventDefault()
    this.dialogTarget.classList.remove("hidden")
  }

  close(event) {
    event.preventDefault()
    this.dialogTarget.classList.add("hidden")
    this.formTarget.reset()
  }
}
