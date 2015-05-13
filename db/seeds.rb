# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Cat.create!(birth_date: "2014-01-07", color: "tabby", name: "George", sex: "M")
Cat.create!(birth_date: "2011-07-07", color: "black", name: "John", sex: "M")
Cat.create!(birth_date: "2011-09-07", color: "white", name: "Bill", sex: "M")
Cat.create!(birth_date: "2013-05-07", color: "gray", name: "Sally", sex: "F")
Cat.create!(birth_date: "2012-07-07", color: "ginger", name: "Mary", sex: "F")
