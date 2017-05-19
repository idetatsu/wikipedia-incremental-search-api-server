class Article < ApplicationRecord
	def self.search(keyword)
		if keyword =~ /[A-Z]/
			return where("title GLOB ? OR abstract GLOB ?", "*#{keyword}*", "*#{keyword}*")
		else
			return where("title LIKE ? OR abstract LIKE ?", "%#{keyword}%", "%#{keyword}%")
		end
	end
end
