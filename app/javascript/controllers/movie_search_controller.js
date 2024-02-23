  import { Controller } from "@hotwired/stimulus"

  // Connects to data-controller="movie-search"
  export default class extends Controller {
    static targets = ['movie', 'grid'];

    connect() {
      console.log("Hello from movieSearchController");

      // Setting these as global variables
      this.apiKey = "48727053"; // API key options: adf1f2d7 || 48727053 || 8691812a
      this.omdbapiUrl = "http://www.omdbapi.com/";

      this.csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
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
      const url = `${this.omdbapiUrl}?s=${movieSearch}&apikey=${this.apiKey}`;

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
        <button class="btn btn-primary" data-action="click->movie-search#addMovie" data-imdbID="${movie.imdbID}"><i class="fa-solid fa-film"></i></button>
      </div>
      `
      this.gridTarget.insertAdjacentHTML('beforeend', cardHTML)
    };

    addMovie = (e) => {
      const movieImdbID = e.currentTarget.dataset.imdbid;

      const url = `${this.omdbapiUrl}?i=${movieImdbID}&apikey=${this.apiKey}`;

      fetch(url).then(response => response.json()).then((data) => {
        console.log(data);
        // console.log(data.Title);
        this.moviePostRequest(data);
      });
    };

    moviePostRequest = (data) => {
      console.log("Putting through post request");
      console.log({ title: data.Title, overview: data.Plot });

      fetch('/movies', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken
        },
        body: JSON.stringify({ movie: { title: data.Title, overview: data.Plot }})
      });
    };
  }
