class GenerateMigrationTask
  def initialize(migration_name)
    @migration_name = migration_name
  end

  def run
    write_migration
    log_created_path
  end

  private

  def active_record_version
    ActiveRecord::Migration.current_version
  end

  def log_created_path
    relative_path = migration_path.relative_path_from(Dir.pwd)
    Ralph.logger.debug("Created #{relative_path}")
  end

  def migration_class_name
    @migration_name.underscore.camelize
  end

  def migration_file_name
    "#{migration_timestamp}_#{@migration_name.underscore}.rb"
  end

  def migration_path
    Ralph.root.join('db/migrate', migration_file_name)
  end

  def migration_template
    Ralph.root.join('lib/tasks/templates/migration.erb').read
  end

  def migration_timestamp
    @migration_timestamp ||= Time.now.strftime('%Y%m%d%H%M%S')
  end

  def rendered_migration
    ERB.new(migration_template).result_with_hash(active_record_version: active_record_version,
      migration_class_name: migration_class_name)
  end

  def write_migration
    migration_path.write(rendered_migration)
  end
end
