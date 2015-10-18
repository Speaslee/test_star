require 'sinatra/base'

require './db/setup'
require './lib/all'

class App < Sinatra::Base

get "/" do
  "Star Wars server"
end


  get "/character/:name" do

  s_name = params[:name]
  s = Character.where(name: "#{s_name}")

# if s.affiliations
#   affiliation_hashes = s.affiliations.map do |u|
#     { name: u.name }
#   end
# end

# end

      results= {
      name: s.name,
      species: s.species,
      gender: s.gender,
      homeworld: s.homeworld,
      image_url: image_url,
      affiliation: affiliation_hashes

    }.to_json
  #

end

  #
  get "/affiliation/:affiliation" do
    t_name = params[:affiliation]
    t = Affiliation.where(name: "#{t_name}")

    character_hashes = t.characters.map do |u|
      { name: u.name }
    end


      results = {
        name: t.name,
        characters: character_hashes
  }.to_json
  end

end

App.run!
