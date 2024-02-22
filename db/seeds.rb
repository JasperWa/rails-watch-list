# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'json'
require 'open-uri'

puts 'Cleaning database'
Movie.destroy_all
List.destroy_all
Bookmark.destroy_all

puts 'Initialising API...'
url = 'http://tmdb.lewagon.com/movie/top_rated'
user_serialized = URI.open(url).read
user = JSON.parse(user_serialized)

puts "Adding #{user['results'].length} movies retrieved from API..."

user['results'].each do |movie|
  title = movie['original_title']
  puts "Adding #{title}..."
  overview = movie['overview']
  poster_url = movie['poster_path']
  rating = movie['vote_average'].round(1)

  movie = Movie.new(title:, overview:, poster_url:, rating:)
  movie.save
end
