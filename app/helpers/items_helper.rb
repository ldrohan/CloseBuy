module ItemsHelper
	def email_scrape
		page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{@email}"))
		if page.at_css('li input')
		  return page.css('li input')[0]['value']
		else 
			return nil  
		end
	end

	def phone_scrape
		  page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{@contact_phone}"))
			page.css('body').text
	end	
end
