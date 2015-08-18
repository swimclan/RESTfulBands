class Band < ActiveRecord::Base

	def to_s
		"#{self.name},  Genre: #{self.genre}"
	end

end