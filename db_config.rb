
options = {
    adapter: 'postgresql',
    database: 'eatmygrub_library'
  }
  
  ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)