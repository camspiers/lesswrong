set :db_dump_filename do
  "#{stage}.psql.gz"
end

namespace :db do

  desc 'Fetches the latest PostgesQL dump'
  task :fetch_dump, :roles => :db, :only => { :primary => true } do
    # ensure_rake_tasks_present!
    host = roles[:db].servers.first.host
    source = fetch(:remote_db_dump_location, File.join(['', 'usr', 'local', 'backup', 'sql', 'all_databases.00.psql.gz']))
    destination = fetch(:db_dump_location, File.join('db', 'dumps', host))
    unless File.directory?(destination) || File.symlink?(destination)
      FileUtils.mkdir_p destination
      File.chmod 0775, destination # Ensure group has write access
    end
    get source, File.join(destination, db_dump_filename)
  end

end