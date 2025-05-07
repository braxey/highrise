import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.timeout = null
    if (this.inputTarget.value) {
      this.inputTarget.focus()
      this.inputTarget.setSelectionRange(this.inputTarget.value.length, this.inputTarget.value.length)
    }
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  handleInputChange() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const value = this.inputTarget.value
      const url = new URL(window.location.href)

      url.searchParams.set("search", value)
      url.searchParams.set("page", "1")

      window.location = url.toString()
    }, 500)
  }
}
