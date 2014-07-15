class Item < ActiveRecord::Base
	validates :name, :email, :lat, :long, presence: true
end

