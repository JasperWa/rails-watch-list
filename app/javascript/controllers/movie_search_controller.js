import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="movie-search"
export default class extends Controller {
  static targets = ['movie', 'grid'];

  connect() {
    console.log("Hello from movieSearchController");
  }

  search = (e) => {
    e.preventDefault();
    console.log(e);
    console.log(e.currentTarget);
    console.log(this.movieTarget);
    console.log(this.movieTarget.value);
    console.log(this.gridTarget);
    this.retrieveMovies(this.movieTarget.value);
  }

  retrieveMovies = (movieSearch) => {
    const omdbapiUrl = "http://www.omdbapi.com/";
    const apiKey = "8691812a";

    // Here is 2 other API key if the one above doesn't work anymore:
    // - adf1f2d7
    // - 48727053
    // - 8691812a

    const url = `${omdbapiUrl}?s=${movieSearch}&apikey=${apiKey}`;

    fetch(url).then(response => response.json()).then((data) => {
      console.log(data.Search);
      if (data.Search) {
        data.Search.forEach(movie => this.addMovieCard(movie));
      }
    });
  };

  addMovieCard = (movie) => {
    console.log("Creating movie card");
    const cardHTML = `
      <div class='movie-card'>
      <img src=${movie.Poster} alt="Movie poster" class="poster">
      <div class="movie-card-content">
        <h2>${movie.Title}</h2>
        <p><span class="movie-header">Year </span><span class="movie-text">${movie.Year}</span></p>
      </div>
    </div>
    `
    this.gridTarget.insertAdjacentHTML('beforeend', cardHTML)
  };


}
