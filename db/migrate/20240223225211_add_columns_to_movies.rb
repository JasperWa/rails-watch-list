class AddColumnsToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :year, :integer
    add_column :movies, :genre, :string
    add_column :movies, :imdbID, :string
  end
end
