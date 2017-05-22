require 'sqlite3'

sqlite = SQLite3::Database.new('./db/development.sqlite3')
sqlite.execute('CREATE VIRTUAL TABLE fts_articles USING fts4(content TEXT, tokenize=simple)')
file = File.open('./data/enwiki-latest-abstract.xml')

sql = 'INSERT INTO articles (title, abstract, url) VALUES '
num_of_articles = 0
contents = {:title => '', :abstract => '', :url => ''}

sqlite.execute('BEGIN;')
start_time = Time.now
file.each_line.with_index do |line, i|
	 if line.start_with?("<doc>")
		num_of_articles += 1
		if (num_of_articles % 100000 == 0)
			now = Time.now
			elapsed_time = now - start_time
			puts "Elapsed: #{elapsed_time}. #{num_of_articles} articles read. Line #{i}."
		end
	 elsif line.start_with?("<title>")
	 	contents[:title] = line[18..-10]
	 elsif line.start_with?("<abstract>")
	 	contents[:abstract] = line[10..-13]
	 elsif line.start_with?("<url>")
	 	contents[:url] = line[5..-8]
	 elsif line.start_with?("</doc>")
	 	sql << "(\"#{contents[:title]}\",\"#{contents[:abstract]}\",\"#{contents[:url]}\"),"
		contents = {:title => '', :abstract => '', :url => ''}
		if (num_of_articles % 500 == 0)
			sql[-1] = ';'
			sqlite.execute(sql)
			sql = 'INSERT INTO articles (title, url, abstract) VALUES '
		end
	end
end
sql[-1] = ';'
sqlite.execute(sql)
sqlite.execute('COMMIT;')
end_time = Time.now

elapsed_time = end_time - start_time
puts "Elapsed: #{elapsed_time}. #{num_of_articles} articles read."