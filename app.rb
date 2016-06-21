require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end


def seed_db db, barbers
	barbers.each do |barber|
			if !is_barber_exists? db, barber
				db.execute 'insert into Barbers (name) values (?)', [barber]
			end
	end
end

def get_db
		db = SQLite3::Database.new 'barbershop.db'
		db.results_as_hash = true
		return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users" 
	("id" INTEGER PRIMARY KEY AUTOINCREMENT, 
	"Name" VARCHAR, 
	"Phone" VARCHAR, 
	"DateStamp" VARCHAR, 
	"Barber" VARCHAR, 
	"Color" VARCHAR)';


	db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" 
	("id" INTEGER PRIMARY KEY AUTOINCREMENT, 
	"Name" VARCHAR)';

seed_db db, ['Jessie', 'Walter', 'Gus']
end


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
		erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	#хеш

	hh = {  :username => 'Enter your name', 
			:phone => 'Enter phonenumber',
			:datetime => 'Enter date and time' }

	#для пары ключ-значение

	hh.each do |key, value|

		#если параметр пуст
		if params[key] ==''
			#переменной ерор присвоить value из hh 
			#а value из hh - сообщение об ошибке
			#error - сообщение об ошибке
			@error = hh[key]

			return erb :visit
		end	
	end

	
	db = get_db
	db.execute 'insert into
	Users (
		Name,
		Phone,
		DateStamp,
		Barber,
		Color
	)
	values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	erb "OK! Username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"

end


get '/showusers' do
  db = get_db

  @results = db.execute 'select * from Users order by id desc'

  erb	:showusers
end


# get '/contacts' do
# 	erb :contacts
# end

# post '/contacts' do
# 	@text = params[:text]
# 	@username = params[:username]
# 	@mail = params[:mail]


# 	erb "We'll answer your mail, #{@username}"
# end


