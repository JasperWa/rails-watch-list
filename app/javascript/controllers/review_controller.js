import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["star"]

  connect() {
    console.log("Hello from review controller");
  }

  checkRating = (e) => {
    const rating = e.currentTarget.value;
    this.starTargets.forEach((star, index) => {
      if (index < rating) {
        star.style.color = "gold"
      } else {
        star.style.color = "lightgrey"
      }
    });
  };
}
