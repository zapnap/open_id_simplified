Rails::Generator::Commands::Create.class_eval do
  def add_routes(resource, template)
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    logger.route "map.resource #{resource}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n#{File.read(source_path(template))}\n"
      end
    end
  end

  def config_gem(name, options={})
    sentinel = 'Rails::Initializer.run do |config|'
    name_and_options = name.inspect
    name_and_options << ", #{options.inspect}" if options.any?
    logger.route "config.gem #{name_and_options}"
    unless options[:pretend]
      gsub_file 'config/environment.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  config.gem #{name_and_options}\n"
      end
    end
  end
end
