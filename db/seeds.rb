# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'json'
require 'open-uri'

puts 'Cleaning database...'
Movie.destroy_all
List.destroy_all
Bookmark.destroy_all

puts 'Setting first lists and movies for database...'
initial_lists = {
  'Timeless Classics' => [
    { title: 'The Godfather', imdbID: 'tt0068646', note: 'The epitome of cinematic artistry. A masterpiece that delves into the depths of loyalty, power, and family.' },
    { title: 'Casablanca', imdbID: 'tt0034583', note: 'An unforgettable story of love and sacrifice in a world on the brink.' },
    { title: 'The Shawshank Redemption', imdbID: 'tt0111161', note: 'A profound testament to hope and friendship against all odds.' },
    { title: 'Gone with the Wind', imdbID: 'tt0031381', note: 'Epic romance and drama set against the American Civil War; its grandeur is unmatched.' },
    { title: 'Citizen Kane', imdbID: 'tt0033467', note: 'A groundbreaking narrative on the complexities of human nature and ambition.' },
    { title: 'Psycho', imdbID: 'tt0054215', note: 'Revolutionized the thriller genre; Hitchcock at his best.' },
    { title: 'Roman Holiday', imdbID: 'tt0046250', note: 'A delightful escape to a bygone era, reminding us of the joys of spontaneous adventure.' },
    { title: 'Rear Window', imdbID: 'tt0047396', note: 'A suspenseful, voyeuristic dive into the lives of others, proving Hitchcock\'s mastery over suspense.' },
    { title: 'Some Like It Hot', imdbID: 'tt0053291', note: 'A comedy that stands the test of time, blending wit, humor, and a bit of romance.' },
    { title: 'Lawrence of Arabia', imdbID: 'tt0056172', note: 'An epic portrayal of desert adventure and the complexity of war.' },
  ],
  'Wizarding World Wonders' => [
    { title: 'Harry Potter and the Sorcerer\'s Stone', imdbID: 'tt0241527', note: 'Where it all began; a magical journey of friendship, courage, and discovery.' },
    { title: 'Harry Potter and the Prisoner of Azkaban', imdbID: 'tt0304141', note: 'The series takes a dark turn, blending mystery, magic, and the importance of the past.' },
    { title: 'Fantastic Beasts and Where to Find Them', imdbID: 'tt3183660', note: 'A new take on the wizarding world, expanding the magic to 1920s America.' },
    { title: 'Harry Potter and the Goblet of Fire', imdbID: 'tt0330373', note: 'A thrilling tournament, new rivalries, and the return of darkness.' },
    { title: 'Harry Potter and the Order of the Phoenix', imdbID: 'tt0373889', note: 'The power of resistance against tyranny; a call to stand up for what\'s right.' },
    { title: 'Fantastic Beasts: The Crimes of Grindelwald', imdbID: 'tt4123430', note: 'Delves deeper into the complexities of Grindelwald\'s character and his influence.' },
    { title: 'Harry Potter and the Half-Blood Prince', imdbID: 'tt0417741', note: 'A mix of adolescent romance and the ominous rise of darkness; Dumbledore\'s trust in Harry solidifies.' },
    { title: 'Harry Potter and the Deathly Hallows: Part 2', imdbID: 'tt1201607', note: 'An epic conclusion; a battle between good and evil that ties up all loose ends.' },
    { title: 'Harry Potter and the Chamber of Secrets', imdbID: 'tt0295297', note: 'Explores the darker corners of Hogwarts and the strength found in loyalty and truth.' },
    { title: 'Harry Potter and the Deathly Hallows: Part 1', imdbID: 'tt0926084', note: 'The beginning of the end; a test of perseverance and friendship outside the safety of Hogwarts.' },
    { title: 'The Lord of the Rings: The Fellowship of the Ring', imdbID: 'tt0120737', note: 'A journey that redefines courage and fellowship; the start of an epic quest.' },
    { title: 'The Lord of the Rings: The Two Towers', imdbID: 'tt0167261', note: 'Continues the epic journey with even greater stakes and deeper character arcs.' },
    { title: 'The Lord of the Rings: The Return of the King', imdbID: 'tt0167260', note: 'A monumental conclusion to an epic saga; the battle for Middle-Earth comes to an end.' },
    { title: 'The Hobbit: An Unexpected Journey', imdbID: 'tt0903624', note: 'Begins the adventure of Bilbo Baggins; a lighter, yet thrilling precursor to the epic Lord of the Rings.' },
    { title: 'The Hobbit: The Desolation of Smaug', imdbID: 'tt1170358', note: 'Delves deeper into the darkness of Middle-Earth, introducing new allies and formidable foes.' },
    { title: 'The Hobbit: The Battle of the Five Armies', imdbID: 'tt2310332', note: 'Concludes Bilbo\'s journey with an epic battle that foreshadows the darkness to come in The Lord of the Rings.' },
  ],
  'Laugh Out Loud' => [
    { title: 'Superbad', imdbID: 'tt0829482', note: 'A hilariously raw depiction of high school friendship and the quest to fit in.' },
    { title: 'The Hangover', imdbID: 'tt1119646', note: 'A bachelor party gone wrong; it\'s as wild as it is funny.' },
    { title: 'Bridesmaids', imdbID: 'tt1478338', note: 'Breaks all the rules of what a \'chick flick\' should be; genuinely funny and heartfelt.' },
    { title: 'Step Brothers', imdbID: 'tt0838283', note: 'The absurdity of delayed adulthood packed with quotable lines.' },
    { title: 'Anchorman: The Legend of Ron Burgundy', imdbID: 'tt0357413', note: 'A cult classic; Will Ferrell at his comedic best.' },
    { title: 'Groundhog Day', imdbID: 'tt0107048', note: 'A clever, existential comedy that\'s both funny and thought-provoking.' },
    { title: 'Monty Python and the Holy Grail', imdbID: 'tt0071853', note: 'Absurd British humor that redefines the idea of a quest narrative.' },
    { title: 'The Big Lebowski', imdbID: 'tt0118715', note: 'A \'dude\' caught in a bizarre series of events; a comedy that\'s become a cultural icon.' },
    { title: 'Airplane!', imdbID: 'tt0080339', note: 'Pioneered a genre of comedy; a masterclass in parody.' },
    { title: 'Tropic Thunder', imdbID: 'tt0942385', note: 'A satire of Hollywood with an unforgettable ensemble cast; it pushes boundaries in the best way.' },
  ],
  'Epic Journeys' => [
    { title: 'The Lord of the Rings: The Fellowship of the Ring', imdbID: 'tt0120737', note: 'A mesmerizing start to an epic journey that redefined fantasy on the big screen.' },
    { title: 'Interstellar', imdbID: 'tt0816692', note: 'An awe-inspiring exploration of space, time, and the love between a father and daughter.' },
    { title: 'Gladiator', imdbID: 'tt0172495', note: 'A gripping tale of revenge and honor; visually stunning and emotionally powerful.' },
    { title: 'Mad Max: Fury Road', imdbID: 'tt1392190', note: 'A relentless, visually spectacular chase across the desert; a masterpiece of action cinema.' },
    { title: 'Avatar', imdbID: 'tt0499549', note: 'A visually stunning journey to another world; groundbreaking use of 3D technology.' },
    { title: 'Inception', imdbID: 'tt1375666', note: 'A mind-bending trip through layered realities; Nolan at his best.' },
    { title: 'The Matrix', imdbID: 'tt0133093', note: 'A revolutionary journey that questions reality and freedom.' },
    { title: 'Braveheart', imdbID: 'tt0112573', note: 'A heroic quest for freedom against tyranny; epic battles and a powerful story.' },
    { title: 'Indiana Jones and the Raiders of the Lost Ark', imdbID: 'tt0082971', note: 'The ultimate adventure; a perfect blend of action, humor, and archaeology.' },
    { title: 'Star Wars: Episode IV - A New Hope', imdbID: 'tt0076759', note: 'The beginning of an iconic space saga; it captured the imagination of generations.' },
  ],
  'Modern Blockbusters' => [
    { title: 'Marvel\'s The Avengers', imdbID: 'tt0848228', note: 'A superhero spectacle; the culmination of Marvel\'s cinematic universe\'s first phase.' },
    { title: 'Black Panther', imdbID: 'tt1825683', note: 'More than a superhero movie; a cultural milestone that celebrates African heritage and unity.' },
    { title: 'Frozen', imdbID: 'tt2294629', note: 'Revolutionized the modern animated feature with its empowering tale and unforgettable music.' },
    { title: 'Inception', imdbID: 'tt1375666', note: 'Made me question the nature of reality; a film that stays with you long after it ends.' },
    { title: 'Jurassic World', imdbID: 'tt0369610', note: 'A thrilling return to the world of dinosaurs; it reignited the franchise for a new generation.' },
    { title: 'The Hunger Games', imdbID: 'tt1392170', note: 'Not just a dystopian adventure, but a thought-provoking commentary on society and spectacle.' },
    { title: 'Wonder Woman', imdbID: 'tt0451279', note: 'Broke barriers and set new standards for female-led superhero films.' },
    { title: 'Gravity', imdbID: 'tt1454468', note: 'A visually mesmerizing tale of survival in space; it left me breathless.' },
    { title: 'The Dark Knight', imdbID: 'tt0468569', note: 'Redefines what a superhero movie can be; a dark, gripping tale with an unforgettable villain.' },
    { title: 'Avatar', imdbID: 'tt0499549', note: 'Its groundbreaking visuals and immersive world-building made me believe in the power of cinema to create new worlds.' },
  ]
}

def create_movie(movie)
  new_movie = Movie.new
  new_movie.title = movie[:title]
  new_movie.imdbID = movie[:imdbID]

  imdb_data = retrieve_movie(new_movie.imdbID)
  return nil unless imdb_data['response'] == 'true' # Guard clause to only execute the rest if this is true

  new_movie.year = imdb_data[:Year]
  new_movie.overview = imdb_data[:Plot]
  new_movie.rating = imdb_data[:imdbRating]
  new_movie.genre = imdb_data[:Genre]
  new_movie.save
end

puts 'Initialising API...'
def retrieve_movie(imdbID)
  api_keys = %w[48727053 adf1f2d7 8691812a]
  api_keys.each do |key|
    url = "http://www.omdbapi.com/?i=#{imdbID}&apikey=#{key}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    return user if user['response'] == 'true'
  end
  user # This will have user['response'] as false
end

initial_lists.each do |name, movies|
  new_list = List.create(name:)
  movies.each do |movie|
    new_movie = create_movie(movie)
    next unless new_movie

    bookmark = Bookmark.new
    bookmark.list = new_list
    bookmark.movie = new_movie
    bookmark.comment = movie[:note]
    bookmark.save
  end
end

# !!! PREVIOUS APPROACH BASED ON LE WAGON API !!!

# Setting these as global variables
# url = 'http://tmdb.lewagon.com/movie/top_rated'
# user_serialized = URI.open(url).read
# user = JSON.parse(user_serialized)

# puts 'Initialising API...'
# url = 'http://tmdb.lewagon.com/movie/top_rated'
# user_serialized = URI.open(url).read
# user = JSON.parse(user_serialized)

# puts "Adding #{user['results'].length} movies retrieved from API..."

# user['results'].each do |movie|
#   title = movie['original_title']
#   puts "Adding #{title}..."
#   overview = movie['overview']
#   poster_url = movie['poster_path']
#   rating = movie['vote_average'].round(1)

#   movie = Movie.new(title:, overview:, poster_url:, rating:)
#   movie.save
# end
