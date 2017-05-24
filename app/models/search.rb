class Search < ApplicationRecord
	def self.latest(limit)
		return order(updated_at: :desc).first(limit)
	end
end
