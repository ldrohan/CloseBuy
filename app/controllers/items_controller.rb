class ItemsController < ApplicationController
	before_action :set_item, only: [:show, :update, :destroy]
	respond_to :json
	include ItemsHelper

	def index
		#respond_with Item.all
		page = Nokogiri::HTML(open("http://sfbay.craigslist.org/sby/cto/4518753858.html"))   
		# puts page.class ==   # => Nokogiri::HTML::Document
		@title = page.css('title').text
		@contact = page.css('a#replylink')[0]['href']
		@contact_phone = page.css('section#postingbody a')[0]['href']
		@email_info = email_scrape
		@phone = phone_scrape

		map = page.css('div#map')
		@latitude = map[0]["data-latitude"]
		@longitude = map[0]["data-longitude"]
		@thumbnails = page.css('div#thumbs a')
	end	

	def create
		respond_with Item.create(item_params)
	end
	private
	def set_item
		@item = Item.find(params[:id])
	end	
	def item_params
		params.require(:item).permit(:name, :description, :images, :email, :lat, :long )
	end	
end
