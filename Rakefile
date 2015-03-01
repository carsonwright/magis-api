require_relative 'config/environment'

namespace :db do

  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrations')
  end

  task :rollback do
    ActiveRecord::Migrator.rollback('db/migrations')
  end

  task :migrate do
    ActiveRecord::Migrator.migrate('db/migrations')
  end

  task :create do
    ActiveRecord::Base.establish_connection(PG_SPEC.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.drop_database PG_SPEC["database"] rescue nil
    ActiveRecord::Base.connection.create_database(PG_SPEC["database"])
  end

end

namespace :generate do
  desc "Generate migration. Specify name in the NAME variable"
  task migration: :environment do
    name = ENV['NAME'] || raise("Specify name: rake g:migration NAME=create_users")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")

    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF.strip_heredoc
        class #{migration_class} < ActiveRecord::Migration
          def self.up
          end
          def self.down
          end
        end
      EOF
    end

    puts "DONE"
    puts path
  end
end
