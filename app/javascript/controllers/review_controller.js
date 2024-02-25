import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review"
export default class extends Controller {
  static targets = ["star", "reviews"]

  connect() {
    console.log("Hello from review controller");

    this.csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
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

  reviewSubmission = (e) => {
    // Replaces the default submission which forces the page to scroll to top of page
    console.log(e);
    console.log(e.currentTarget);
    e.preventDefault();

    console.log("Putting through post request");

    const form = e.target.closest("form");
    console.log(form);
    const url = form.action;
    console.log(url);
    const formData = new FormData(form);
    console.log(formData);

    fetch(url, {
      method: 'POST',
      headers: {
        // 'Content-Type': 'application/json',
        'X-CSRF-Token': this.csrfToken
      },
      body: formData
    })

    const reviews = this.reviewsTarget;
    const placeholder = reviews.querySelector('#reviews-placeholder');
    if (placeholder) placeholder.remove();

    const stars = form.elements['review[rating]'].value
    let starsHtml = '';
    for (let i = 0; i < stars; i++) {
      starsHtml += '<i class="fa-solid fa-star star"></i>';
    }

    const reviewHTML = `
      <div class="card-review">
        <div class="card-review stars">
          ${starsHtml}
        </div>
        <p class="card-review comment">${form.elements['review[content]'].value}</p>
      </div>
    `
    reviews.insertAdjacentHTML('beforeend', reviewHTML);
  }
}
