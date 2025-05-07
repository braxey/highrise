import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "status"]
  static values = {
    status: String
  }

  connect() {
    this.timeout = null
    this.status = this.statusValue

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

  handleStatusChange(event) {
    const selectedStatus = event.currentTarget.getAttribute("data-value")
    
    if (selectedStatus === this.status) {
      return
    }

    const url = new URL(window.location.href)

    url.searchParams.set("status", selectedStatus)
    url.searchParams.set("page", "1")

    window.location = url.toString()
  }
}
