require 'mechanize'

class Character < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :memberships
  has_many :affiliations, through: :memberships
  #all of this is terrible, never do this. Abandon hope all ye who enter here
  def populate_table
    agent = Mechanize.new
    page = agent.get "http://starwars.wikia.com/wiki/Obi-Wan_Kenobi"

bio_table = page.search("#Character_infobox")
  rows = bio_table.search "tr"

  results = {}
  rows.each do |r|
  cells = r.search "td"
  if cells.count == 2
    key = cells.first.text.downcase.strip
    value = cells.last.text.strip

    results[key] = value
    end

  #
  # results[affiliations].value
  end
#make affiliation table
# if results[]
#     clubs = results["affiliation"].to_a
#     clubs.each do |s|
#       Affiliation.make_affiliation s
#     end

binding.pry
#make yourself
  nu_char = Character.new(
    name: page.search("#mw-content-text").search("p").search("b").first,
    species: results["species"],
    gender: results["gender"],
    homeworld: results["homeworld"],
    prelude: page.search("#mw-content-text").search("p").first(5),
    image_url:bio_table.search("tr").search("td").search("a").first["href"]
  )

  begin
    nu_char.save!
  rescue => e
    puts "Failed to save #{nu_char} - #{e}"
  end

  # #make membership table
  #make affiliation table
  # if results["affiliation"]

  #     c = results["affiliation"].to_a
      # c.each do |s|
  #     self.memberships.create! affiliation: s

 end
#
#
#


end
