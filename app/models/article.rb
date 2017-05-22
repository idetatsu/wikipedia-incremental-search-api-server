class Article < ApplicationRecord
	def self.search(keyword)
		return where("title LIKE ? OR abstract LIKE ?", "%#{keyword}%", "%#{keyword}%")
	end
end
