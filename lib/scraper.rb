require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    #return an array of hashes
    #hash rep a single student card
    #std hashes ex: {:name , :location, :profile_url}
    # .css(value)
    # .attribute

    html = Nokogiri::HTML(open(index_url))
    student_cards = html.css("div.student-card")
    # student_cards = html.css(".student-card")
    student_cards.collect do |card|
      hash = {
          name: card.css('.student-name').text,
          location: card.css('.student-location').text,
          # another way to get profile_url value: card.css('a').attr('href').text
          profile_url: card.css('a').attribute('href').value
      }
      hash
    end
  end

  def self.scrape_profile_page(profile_url)
    #returns a hash like below vvv
    # {:twitter=>"http://twitter.com/flatironschool",
    #   :linkedin=>"https://www.linkedin.com/in/flatironschool",
    #   :github=>"https://github.com/learn-co,
    #   :blog=>"http://flatironschool.com",
    #   :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
    #   :bio=> "I'm a school"
    #  }

    html = Nokogiri::HTML(open(profile_url))

    hash = {}
    # binding.pry
    hash[:profile_quote] = html.css('.vitals-text-container .profile-quote').text
    hash[:bio] = html.css('.description-holder p').text
    links = html.css('.social-icon-container a').map {|nodeset| nodeset.attribute('href').value }

    links.each do |link|
      if link.include?('twitter')
        hash[:twitter] = link
      elsif link.include?('linkedin')
        hash[:linkedin] = link
      elsif link.include?('github')
        hash[:github] = link
      else
        hash[:blog] = link
      end
    end
    hash
  end

end