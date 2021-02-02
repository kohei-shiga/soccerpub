# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.first
20.times do
  Article.create!(title: Faker::Book.unique.title, user_id: user.id)
end

Article.find(11, 30).each do |article|
  ActionText::RichText.create!(record_type: 'Article', record_id: article.id, name: 'content', body: Faker::Lorem.sentence)
end