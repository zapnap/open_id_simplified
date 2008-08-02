namespace :open_id_authentication do
  namespace :db do
    desc "Clear the authentication tables"
    task :clear => :environment do
      OpenIdAuthentication::DbStore.cleanup_nonces
      OpenIdAuthentication::DbStore.cleanup_associations
    end
  end
end
