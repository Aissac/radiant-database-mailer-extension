namespace :radiant do
  namespace :extensions do
    namespace :database_mailer do
      
      desc "Runs the migration of the Database Mailer extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        
        DatabaseMailerExtension.migrator.set_schema_version(1) if DatabaseMailerExtension.migrator.current_version > 1
        
        if ENV["VERSION"]
          DatabaseMailerExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          DatabaseMailerExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Database Mailer to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from DatabaseMailerExtension"
        Dir[DatabaseMailerExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(DatabaseMailerExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
