require 'sqlite3'

def get_elapsed_time(start_time)
	now = Time.now
	return now - start_time
end

# Constants
QUERY_PREFIX = 'INSERT INTO articles (title, abstract, url) VALUES '
DEFAULT_ARTICLE = {:title => '', :abstract => '', :url => ''}

# Initialization.
articles_count = 0
query = QUERY_PREFIX.clone
article = DEFAULT_ARTICLE.clone

# Start time measuring.
start_time = Time.now
# Open the XML.
file = File.open('data/enwiki-latest-abstract.xml')
# Connect to database.
db = SQLite3::Database.new('./db/development.sqlite3')
# Create table for articles with FTS4 indexing.
db.execute('CREATE VIRTUAL TABLE articles USING fts4("title" TEXT, "url" TEXT, "abstract" TEXT, tokenize=simple)')
# Use manual transaction for quicker processing. 
db.execute('BEGIN;')
file.each_line.with_index do |line, line_count|
	 if line.start_with?("<doc>")
		article = DEFAULT_ARTICLE.clone
		articles_count += 1
		if (articles_count % 100000 == 0)
			elapsed_time = get_elapsed_time(start_time)
			puts "Elapsed: #{elapsed_time}. #{articles_count} articles read. Line #{line_count}."
		end
	 elsif line.start_with?("<title>")
	 	article[:title] = line[18..-10]
	 elsif line.start_with?("<abstract>")
	 	article[:abstract] = line[10..-13]
	 elsif line.start_with?("<url>")
	 	article[:url] = line[5..-8]
	 elsif line.start_with?("</doc>")
	 	query << "(\"#{article[:title]}\",\"#{article[:abstract]}\",\"#{article[:url]}\"),"
		if (articles_count % 500 == 0)
			query[-1] = ';'
			db.execute(query)
			query = QUERY_PREFIX.clone
		end
	end
end
# Execute the remaining query.
query[-1] = ';'
db.execute(query)
db.execute('COMMIT;')

elapsed_time = get_elapsed_time(start_time)
puts "Elapsed: #{elapsed_time}. #{articles_count} articles read."
