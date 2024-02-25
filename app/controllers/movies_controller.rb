class MoviesController < ApplicationController
  before_action :transform_params, only: [:create]

  def index
    @movies = Movie.order(:title)
  end

  def search
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      # Handle success (e.g., redirect or render a success response)
      redirect_to '/movies/search'
    else
      # Handle failure (e.g., render the form again with error messages)
      render '/movies/search', status: :unprocessable_entity
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :poster_url, :rating, :year, :genre)
  end

  def transform_params
    params[:movie] = params[:movie].deep_transform_keys!(&:underscore)
  end
end
