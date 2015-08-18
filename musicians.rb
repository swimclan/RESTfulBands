class Musician < ActiveRecord::Base

	def to_s
		"#{self.name},  Genre: #{self.instrument}"
	end

end