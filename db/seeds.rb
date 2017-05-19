# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

abstract = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Repellendus expedita, eligendi! Impedit voluptatibus laudantium culpa. Consequuntur dolorum asperiores, eos consectetur beatae aspernatur corrupti, natus magnam eligendi quis. Adipisci, quasi assumenda.'
url = 'https://google.com'

articles = Array.new(100)

100.times do |i|
	articles[i] = {title: "Title#{i}", abstract: abstract, url: url}
end

Article.create(articles)