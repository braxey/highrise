import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "wrapper"]

  connect() {
    this.orignalAvatar = this.wrapperTarget.innerHTML
  }

  update() {
    const file = this.inputTarget.files[0]
    if (!file) {
      return (this.wrapperTarget.innerHTML = this.orignalAvatar)
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      this.wrapperTarget.innerHTML = `
        <div data-slot="avatar" class="relative flex size-10 shrink-0 overflow-hidden rounded-full justify-center items-center">
          <img src="${e.target.result}" alt="Avatar preview" class="aspect-square size-10" data-slot="avatar-image">
        </div>
      `
    }
    reader.readAsDataURL(file)
  }
}
