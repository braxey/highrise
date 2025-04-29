import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "selected", "menu"];

  connect() {
    document.addEventListener("click", this.handleClickOutside.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this));
  }

  toggle(event) {
    event.preventDefault();
    this.menuTarget.classList.toggle("hidden");
  }

  select(event) {
    event.preventDefault();
    const value = event.currentTarget.dataset.value;
    this.inputTarget.value = value;
    this.selectedTarget.textContent = value.charAt(0).toUpperCase() + value.slice(1);
    this.menuTarget.classList.add("hidden");
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
