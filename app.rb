require "sinatra"
require "mongo"
include Mongo

def get_db_connection
  return @db_connection if @db_connection
  db_url = ENV['MONGOHQ_URL'] || ENV['MONGOLAB_URL'] || "mongodb://localhost:27017/eventform"
  db = URI.parse(db_url)
  db_name = db.path.gsub(/^\//, '')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
  @db_connection
end

db = get_db_connection
events = db['events']

get "/form" do
  erb :form, locals: { title: "Weekly Event Form" }
end

post "/form" do
  event = params
  event["created"] = Time.now
  events.insert(event)
end

get "/api/form" do
  
end