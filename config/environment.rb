require 'json'
require 'grape'
require 'pg'
require 'yaml'
require 'bcrypt'
require 'active_record'
require 'digest/sha1'
require 'pathname'

path = Pathname.new(__FILE__).parent.parent

$:.unshift File.dirname(__FILE__)
env = (ENV['RACK_ENV'] || :development)

require 'bundler'
require 'erb'

I18n.enforce_available_locales = true

db_config = YAML.load(ERB.new(File.read("config/database.yml")).result)["development"]

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :host     => db_config["host"],
  :database => db_config["database"],
  :encoding => 'utf8',
  :pool => 20
)

specific_environment = "config/environments/development.rb"

PG_SPEC = db_config

require specific_environment if File.exists? specific_environment


Dir["config/initializers/**/*.rb"].each {|f| require f}

class Api < Grape::API
  format :json
  
  helpers do
    def declared_params
      declared(params, include_missing: false)
    end

    def current_user
      if env["HTTP_ACCESS_TOKEN"]
        @current_user ||= User.find_by(token: env["HTTP_ACCESS_TOKEN"])
      end
    end

    def authenticate_user!
      error!('401 Unauthorized', 401) unless current_user
    end
  end
end

require 'image_uploader'

Dir["models/*.rb"].each {|f| require path + f}
Dir["api/*.rb"].each {|f| require path + f}
Dir["api/**/*.rb"].each {|f| require path + f}
