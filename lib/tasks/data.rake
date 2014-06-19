namespace :data do
  desc "Scraping Craigslist Data"
  # task :import => :environment do
  task :scrape => :environment do

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
    	@item.save
    end
  end
end
