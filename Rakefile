task :environment do
  require_relative 'config/boot'
  Ralph.boot
end

namespace :db do
  task configure_active_record_tasks: :environment do
    include ActiveRecord::Tasks

    DatabaseTasks.database_configuration = Ralph.database_configs
    DatabaseTasks.db_dir = Ralph.root.join('db')
    DatabaseTasks.env = Ralph.env
    DatabaseTasks.migrations_paths = [Ralph.root.join('db/migrate')]
  end

  desc 'Create database'
  task create: :configure_active_record_tasks do
    DatabaseTasks.create_current
  end

  desc 'Drop database'
  task drop: :configure_active_record_tasks do
    DatabaseTasks.drop_current
  end

  desc 'Run database migrations'
  task migrate: :configure_active_record_tasks do |task|
    ActiveRecord::Base.logger = Ralph.logger
    ActiveRecord::Migration.verbose = false
    ActiveRecord::MigrationContext.new(Ralph.root.join('db/migrate'),
      ActiveRecord::SchemaMigration).migrate
    ActiveRecord::Base.clear_cache!

    Rake::Task['db:schema:dump'].invoke
  end

  desc 'Roll back the last database migration'
  task rollback: :configure_active_record_tasks do |task|
    ActiveRecord::Base.logger = Ralph.logger
    ActiveRecord::Migration.verbose = false
    ActiveRecord::MigrationContext.new(Ralph.root.join('db/migrate'),
      ActiveRecord::SchemaMigration).rollback
    ActiveRecord::Base.clear_cache!

    Rake::Task['db:schema:dump'].invoke
  end

  namespace :migrate do
    desc 'Show database migration status'
    task status: :configure_active_record_tasks do
      DatabaseTasks.migrate_status
    end
  end

  namespace :schema do
    desc 'Dump database schema to db/schema.rb'
    task dump: :configure_active_record_tasks do
      DatabaseTasks.dump_schema(Ralph.current_database_config)
    end

    desc 'Load database schema from db/schema.rb'
    task load: :configure_active_record_tasks do
      DatabaseTasks.load_schema(Ralph.current_database_config)
    end
  end
end

namespace :generate do
  desc 'Generate a new database migration'
  task :migration, [:name] => :environment do |_task, args|
    require_relative 'lib/tasks/generate_migration_task'
    GenerateMigrationTask.new(args.name).run
  end
end
