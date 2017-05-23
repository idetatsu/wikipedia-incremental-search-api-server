class Article < ApplicationRecord
	def self.search(keyword, page, per_page)
		to_skip = (page - 1) * per_page
		if keyword.empty?
			return self.offset(to_skip).limit(per_page), self.count
		else
			result = self.where("title LIKE ?", "%#{keyword}%").order("LENGTH(title) ASC").offset(to_skip).limit(per_page)
			total = 1000#self.where("title LIKE ? OR abstract LIKE ?",
				#"%#{keyword}%", "%#{keyword}%").count
			return result, total
		end
	end
end
