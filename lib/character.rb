require 'mechanize'

class Character < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :memberships
  has_many :affiliations, through: :memberships
  #all of this is terrible, never do this. Abandon hope all ye who enter here
  def populate_table
    agent = Mechanize.new
    page = agent.get "http://starwars.wikia.com/wiki/Yaddle"



    bio_table = page.search("#Character_infobox")
    rows = bio_table.search "tr"

    results = {}
      rows.each do |r|
        cells = r.search "td"
        if cells.count == 2
          key   = cells.first.text.strip
          value = cells.last.text.strip

          results[key] = value
        end
      end

      #

    #make yourself

    nu_char = Character.new(
    name: page.search("#mw-content-text").search("p").search("b").first,
    species: results["Species"],
    gender: results["Gender"],
    homeworld: results["Homeworld"],
    prelude: page.search('#mw-content-text > p').map { |s| s.text.chomp }.first(5).join("\n"),
    image_url: bio_table.search("tr").search("td").search("a").first["href"]
    )

    begin
      nu_char.save!
    rescue => e
      puts "Failed to save #{nu_char} - #{e}"
    end
binding.pry
    #make membership table
    results["Affiliation"]

  #make affiliation table
  if results["Affiliation"]
    clubs = results["Affiliation"].split("\n")
    clubs.each do |m|
    s = m.split("[")[0]
      nu_affiliation = Affiliation.new(
      name: s.chomp("[")
      )
      begin
        nu_affiliation.save!
      rescue => e
        puts "Failed to save #{nu_affiliation} - #{e}"
      end
    end
  end
  #  make affiliation table
    if results["Affiliation"]

      c = results["Affiliation"].split("\n")
      c.each do |m|
        s = m.split("[")[0]
      binding.pry

         d = Affiliation.where(name:"#{s}")
        q = Character.last
        Character.last.memberships.create affiliation: d.first
      end
    end
  end
end
