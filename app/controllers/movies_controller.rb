class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def search
  end
end
