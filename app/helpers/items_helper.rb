module ItemsHelper
	require "phone"
  def email_scrape
    page = Nokogiri::HTML(open("http://sfbay.craigslist.org#{@email}"))
    if page.at_css('a.mailapp')
      return page.at_css('a.mailapp').text
    else
      return nil
    end
  end

  def phone_scrape
		page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{@email}"))
    body = page.css('body').text
    Phoner::Phone.default_country_code = "1"
    Phoner::Phone.default_area_code = "415"
    Phoner::Phone.parse body
  end

  def phone_scrape_body
  	page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{@contact_url}"))
    body = page.css('body').text
    Phoner::Phone.default_country_code = "1"
    Phoner::Phone.default_area_code = "415"
    Phoner::Phone.parse body
  end	
end
