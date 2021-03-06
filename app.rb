require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def get_db
  db = SQLite3::Database.new('./database/barbershop.sqlite')
  db.results_as_hash = true
  db
end

before do
  @barbers = get_db.execute 'select * from barbers order by id'
end

configure do
  # create users
  get_db.execute 'CREATE TABLE IF NOT EXISTS "users" 
  (
    "id" INTEGER PRIMARY KEY  NOT NULL ,
    "username" VARCHAR NOT NULL  DEFAULT (null) ,
    "phone" VARCHAR OT NULL ,
    "datestamp" VARCHAR NOT NULL ,
    "barber" VARCHAR NOT NULL ,
    "color" VARCHAR NOT NULL 
  )'


  # create and insert barbers
  get_db.execute 'CREATE TABLE IF NOT EXISTS "barbers"
  (
    "id" INTEGER PRIMARY KEY  NOT NULL ,
    "name" VARCHAR NOT NULL  DEFAULT (null)
  )'
  barbers = [
            {:id => 1, :name => 'Jessie Pinkman'},
            {:id => 2, :name => 'Walter White'},
            {:id => 3, :name => 'Gus Fring'},
            {:id => 4, :name => 'Antonio Jazz'},
            {:id => 5, :name => 'Victoria Ice'}
            ]
  
  barbers.each do |barber|
      get_db.execute 'INSERT OR IGNORE INTO barbers(id, name) VALUES(?, ?)',[barber[:id], barber[:name]]
  end

end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/contacts' do
  erb :contacts
end

get '/visit' do
	erb :visit
end

get '/showusers' do
  @users = get_db.execute 'select * from users order by id'
  @headers = @users[0].keys.select{|a| !a.is_a? Integer}
  erb :showusers
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]
  @error = []

  hash_errors = {
    :username => "Введите имя",
    :phone => "Введите телефон",
    :datetime => "Введите дату"
  }


  hash_errors.each {|key, value| @error << value if params[key] == ''}
  if @error.size!= 0
    return (erb :visit)
  end


  get_db.execute 'insert into Users (username, phone, datestamp, barber, color)
       values(?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]


	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end

post '/contacts' do
  require 'pony'
  @email = params[:email]
  @message = params[:message]
  @error = []

  hash_errors = {
    :email => "Введите почту",
    :message => "Введите текст письма"
  }
  hash_errors.each {|key, value| @error << value if params[key] == ''}

  if @error.size!= 0
    return (erb :visit)
  end

  erb "OK, to mail #{@email} send message."
end