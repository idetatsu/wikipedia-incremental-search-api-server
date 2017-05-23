class Article < ApplicationRecord
	def self.search(keyword, page, per_page)
		to_skip = (page - 1) * per_page
		if keyword.empty?
			articles = self.offset(to_skip).limit(per_page)
			total = count_by_sql("SELECT MAX(ROWID) FROM articles")
			return articles, total
		else
			urls = find_by_sql("SELECT url FROM articles WHERE articles MATCH \'#{keyword}\' LIMIT \'#{per_page}\' OFFSET \'#{to_skip}\' ")
			highlighted_titles = find_by_sql("SELECT SNIPPET(articles, '<mark>', '</mark>', '<mark>...</mark>', 0, 64) FROM articles WHERE articles MATCH \'#{keyword}\' LIMIT \'#{per_page}\' OFFSET \'#{to_skip}\' ")
			highlighted_abstracts = find_by_sql("SELECT SNIPPET(articles, '<mark>', '</mark>', '<mark>...</mark>', 2, 64) FROM articles WHERE articles MATCH \'#{keyword}\' LIMIT \'#{per_page}\' OFFSET \'#{to_skip}\' ")

			counts = urls.size
			articles = Array.new(counts){Hash.new}
			articles.each_with_index do |entry, i|
				entry[:title] = highlighted_titles[i].attributes.values[0]
				entry[:abstract] = highlighted_abstracts[i].attributes.values[0]
				entry[:url] = urls[i].attributes.values[0]
			end

			total = count_by_sql("SELECT COUNT(*) FROM articles WHERE articles MATCH \'#{keyword}\' ")
			return articles, total
		end
	end
end
