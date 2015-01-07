require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'erb'
require 'json'



set :views, File.expand_path('./application/')
set :public, File.expand_path('./application/')
#defining the datamapper configuration


DataMapper.setup(:default,{
	:adapter => 'sqlite3',
	:host => 'localhost',
	:username => '',
	:password => '',
	:database => 'my_db'
})



#defining the model for Dvd


class  Disk
   include DataMapper::Resource

   property :id, Serial
   property :title, String
   property :tags,  String
   property :created_at, DateTime
   property :updated_at, DateTime
   property :detail, Text
   property :location, String

	DataMapper.finalize
end

DataMapper.auto_upgrade!

get '/' do
   erb :index
end


get '/disk' do #method to list all the post
	@disks = Disk.all :limit => 10, :order => :created_at.desc
	@disks.to_json
end


post '/disk/new' do #method to creating new post
	@disk = Disk.create(params)
	@disk.to_json
end


put '/disk/:id' do |id| #method to handle updating of post
	begin
		@disk = Disk.get id
		@disk.update({:title => params['tags'], :tags => params['tags'], :detail => params['detail'], :location => params['location']})
		#@disk.save
    	@disk.to_json
	rescue => e
		e.to_s
	end
end


delete '/disk/:id' do |id| #method to handle delete of post
	disk = Disk.get(id)
	disk.destroy
end

