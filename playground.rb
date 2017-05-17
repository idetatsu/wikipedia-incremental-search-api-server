file = File.open('./data/enwiki-latest-abstract.xml')

articles = []
num_of_articles = 0
reg = /^<(title|abstract|url)>(.+)<\/.+>$/

file.each_line do |line|
	if line == "<doc>\n"
		articles << {}
		next
	end

	line.match(reg) do |m|
		res = m[1]
		if res == "title"
			num_of_articles += 1
			if num_of_articles % 100000 == 0
				puts "#{num_of_articles} articles read."
			end
			articles.last[:title] = res
		elsif res == "abstract"
			articles.last[:abstracts] = res
		elsif res == "url"
			articles.last[:urls] = res
		end
	end
end

puts articles.size