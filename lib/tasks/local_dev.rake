desc 'Set up your local development environment with data from Find'
task setup_local_dev_data: :environment do
  puts 'Syncing data from Find...'
  Rails.configuration.providers_to_sync[:codes].each do |code|
    SyncProviderFromFind.call(provider_code: code)
  end

  puts 'Making all the courses open on Apply...'
  Course.update_all(open_on_apply: true)

  FeatureFlag.activate('pilot_open')
end
