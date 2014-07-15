namespace :data do
  desc "Scraping Craigslist Data"
  task :scrape => :environment do
    include ItemsHelper
    require "nokogiri"
    require "open-uri"

    # Scrapes All for sale item URLS from home page
    page = Nokogiri::HTML(open("http://sfbay.craigslist.org/sss/"))
    @results = page.css('span.pl a')
    @urls = []

    @results.each do |url|
      @urls.push(url['href'])
    end

    @urls.each do |i|
      listing_page = Nokogiri::HTML(open("http://sfbay.craigslist.org/#{i}"))
      if listing_page.at_css('div#map')
        @item = Item.find_or_initialize_by(name: listing_page.css('title').text)
        @item.name = listing_page.css('title').text

        # Stores Lat and Long to DB
        map = listing_page.css('div#map')
        @item.lat = map[0]["data-latitude"]
        @item.long = map[0]["data-longitude"]

        # If replylink present on page, email scrape method called from helper
        if listing_page.at_css('a#replylink')
          @email = listing_page.css('a#replylink')[0]['href']
          @item.email = email_scrape
        end

        # If image tag present, main image stored to DB
        if listing_page.at_css('img#iwi')
          @item.image = listing_page.css('img#iwi')[0]['src']
        end

        # Checks contact info button for phone number and saves if present, if not - moves on to scrape body for number.
        if listing_page.at_css('section#postingbody a')
          @contact_url = listing_page.css('section#postingbody a')[0]['href']

          @phone_object = phone_scrape
          @phone_object_body = phone_scrape_body

          if @phone_object != nil
            @item.phone = @phone_object.area_code + @phone_object.number
          elsif @phone_object == nil && @phone_object_body != nil
            @item.phone = @phone_object_body.area_code + @phone_object_body.number
          end
        end

        #Saves item description to database from posting body
        if listing_page.at_css('section#postingbody')
          @item.description = listing_page.css('section#postingbody').text
        end

        @item.save

      end
    end

  end
end
