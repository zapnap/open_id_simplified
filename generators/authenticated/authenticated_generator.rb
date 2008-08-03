require File.expand_path(File.dirname(__FILE__) + "/lib/generator_commands.rb")

class AuthenticatedGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'create_open_id_tables.rb', 'db/migrate', :migration_file_name=>'create_open_id_tables'
      m.file 'user.rb', 'app/models/user.rb'
      m.file 'identity_url.rb', 'app/models/identity_url.rb'
      m.file 'sessions_controller.rb', 'app/controllers/sessions_controller.rb'

      m.directory 'app/views/sessions'
      m.file 'new.html.erb', 'app/views/sessions/new.html.erb'

      m.file 'user_test.rb', 'test/unit/user_test.rb'
      m.file 'identity_url_test.rb', 'test/unit/identity_url_test.rb'
      m.file 'sessions_controller_test.rb', 'test/functional/sessions_controller_test.rb'

      m.add_routes :session, 'routes.rb'
      m.config_gem 'ruby-openid', :lib => 'openid', :version => '>= 2.0.4'
      m.config_gem 'mocha', :version => '>= 0.9.0'
    end
  end
end
