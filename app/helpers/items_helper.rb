module ItemsHelper
	def email_scrape
		page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{@contact}"))
		page.css('li input')[0]['value']
	end

	def phone_scrape
		  page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{@contact_phone}"))
			page.css('body').text
	end	
end
