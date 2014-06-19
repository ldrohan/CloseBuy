namespace :data do
	desc "Scraping Craigslist Data"
  # task :import => :environment do
  task :scrape => :environment do
  	include ItemsHelper
  	require "nokogiri"
  	require "open-uri"

    page = Nokogiri::HTML(open("http://sfbay.craigslist.org/sss/"))
    @results = page.css('span.pl a')
    @urls = []
   
    @results.each do |url|
    	@urls.push(url['href'])
    end	
   
    @urls.each do |i|
    	listing_page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{i}"))
    	@item = Item.find_or_initialize_by(name: listing_page.css('title').text)
    	@item.name = listing_page.css('title').text
    	if listing_page.at_css('a#replylink')
    		@email = listing_page.css('a#replylink')[0]['href']
    		@item.email = email_scrape
    	end	
   
    	@item.save
    end
  end
end


# page = Nokogiri::HTML(open("http://sfbay.craigslist.org/sby/cto/4518753858.html"))   
		# # puts page.class ==   # => Nokogiri::HTML::Document
		# @title = page.css('title').text
		# @contact = page.css('a#replylink')[0]['href']
		# @contact_phone = page.css('section#postingbody a')[0]['href']
		# @email_info = email_scrape
		# @phone = phone_scrape

		# map = page.css('div#map')
		# @latitude = map[0]["data-latitude"]
		# @longitude = map[0]["data-longitude"]
		# @thumbnails = page.css('div#thumbs a')
