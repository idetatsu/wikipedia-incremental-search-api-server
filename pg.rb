require 'sqlite3'

db = SQLite3::Database.new('./db/development.sqlite3')

sql = 'SELECT MATCHINFO(articles, \'x\') FROM articles WHERE articles MATCH \'Addes\' '
res = db.execute(sql)

res.each do |e|
  p e
end

p res.size
