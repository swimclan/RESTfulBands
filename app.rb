require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:database => 'restfulbands')

def extend_musicians(band)
	band_members = Musician.where(:band_id => band.id)
	musicians = []
	band_members.each do |member|
		musicians.push(member.as_json)
	end
	band.as_json.merge!(:musicians => musicians)
end

get '/' do
	@band = Band.create(:name => 'Phish', :genre =>'Jam Rock')
	Musician.create(:name => 'Trey Anastasio', :instrument => 'guitar', :favorite_drug => 'heroine', :band_id => @band.id)
	Musician.create(:name => 'Page McConnell', :instrument => 'piano', :favorite_drug => 'life', :band_id => @band.id)
	Musician.create(:name => 'Mike Gordon', :instrument => 'bass guitar', :favorite_drug => 'art', :band_id => @band.id)
	Musician.create(:name => 'John Fishman', :instrument => 'drums', :favorite_drug => 'whering cool dresses', :band_id => @band.id)
	extend_musicians(@band).to_json
end

get '/api/bands' do
	puts 'I am in the method'
	@bands = Band.all
	puts '---------BANDS-----------'
	puts @bands.as_json
	puts '-------------------------'
	ret = Array.new
	@bands.each do |band|
		ret.push(extend_musicians(band))
	end	
	ret.to_json
end

post '/api/bands' do
	band_params = { :name => params[:name], :genre => params[:genre] }
	Band.create(band_params).to_json
end

post '/api/musicians' do
	musician_params = { :name => params[:name], :instrument => params[:instrument], :favorite_drug => params[:favorite_drug], :band_id => params[:band_id] }
	Musician.create(musician_params).to_json
end

patch '/api/bands/:id' do
	@band = Band.find(params[:id])
	# allow the user to modify either key or both
	if params.has_key?(:name) && params.has_key?(:genre)
		band_params = { :name => params[:name], :genre => params[:genre] }
	else
		band_params = params.has_key?('name') ? { :name => params[:name] } : { :genre => params[:genre] } 
	end
	@band.update(band_params).to_json
end

patch '/api/musicians/:id' do
	@musician = Musician.find(params[:id])
	# allow the user to modify any of the musician attributes or all of them
	safe_params = ['name', 'instrument', 'favorite_drug']
	musician_params = {}
	params.keys.each do |param|
		musician_params.merge!(param => params[param]) if safe_params.include?(param)	
	end
	@musician.update(musician_params).to_json
end

delete '/api/bands/:id' do
	Band.find(params[:id]).destroy.to_json
end

delete '/api/musicians/:id' do
	Musician.find(params[:id]).destroy.to_json
end

