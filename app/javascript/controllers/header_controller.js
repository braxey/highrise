import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileDrawer", "mobileOverlay", "dropdownMenu"]

  connect() {
    document.addEventListener("click", this.handleOutsideClick.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick.bind(this))
  }

  // Mobile Menu Toggle
  toggleMobileMenu() {
    const isHidden = this.mobileDrawerTarget.classList.contains("hidden")
    if (isHidden) {
      this.mobileDrawerTarget.classList.remove("hidden")
      this.mobileOverlayTarget.classList.remove("hidden")
      this.mobileDrawerTarget.classList.remove("-translate-x-full")
      this.mobileDrawerTarget.classList.add("translate-x-0")
    } else {
      this.mobileDrawerTarget.classList.add("-translate-x-full")
      this.mobileOverlayTarget.classList.add("hidden")
      this.mobileDrawerTarget.classList.add("hidden")
    }
  }

  // Dropdown Toggle
  toggleDropdown() {
    this.dropdownMenuTarget.classList.toggle("hidden")
  }

  // Close dropdown and mobile menu on outside click
  handleOutsideClick(event) {
    // Close mobile menu if open and click is outside
    if (this.hasMobileDrawerTarget && !this.mobileDrawerTarget.classList.contains("hidden") && !this.element.contains(event.target)) {
      this.mobileDrawerTarget.classList.add("-translate-x-full")
      this.mobileOverlayTarget.classList.add("hidden")
      this.mobileDrawerTarget.classList.add("hidden")
    }

    // Close dropdown if open and click is outside
    if (this.hasDropdownMenuTarget && !this.dropdownMenuTarget.classList.contains("hidden") && !this.element.contains(event.target)) {
      this.dropdownMenuTarget.classList.add("hidden")
    }
  }
}
