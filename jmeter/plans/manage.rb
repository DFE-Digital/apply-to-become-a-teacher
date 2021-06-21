require 'ruby-jmeter'

BASEURL = ENV.fetch('JMETER_TARGET_BASEURL')

def log_in(user_id)
  visit name: 'Provider user signs in', url: BASEURL + '/provider' do
    extract name: 'csrf_token', regex: "content='(.+?)' name='csrf-token'"
  end

  visit name: 'Go to sign in', url: BASEURL + '/provider/sign-in'

  submit name: 'Authenticate', url: BASEURL + '/auth/developer/callback',
    fill_in: { 'uid' => user_id }
end

test do
  cookies clear_each_iteration: true

  %w[dev-support].each do |uid|

    # See interviewing application
    threads count: 1, continue_forever: true, duration: 3600 do
      think_time 1000, 1
      log_in uid
      visit name: 'Filter by interviewing', url: BASEURL + '/provider/applications?commit=Apply+filters&status%5B%5D=interviewing' do
        extract name: 'application_id', regex: 'href="/provider/applications/(\d+)"', match_number: 0
      end
      think_time 1000, 1
      visit name: 'Load interviewing application', url: BASEURL + '/provider/applications/${application_id}'
      think_time 1000, 1
    end

    # See rejected application
    threads count: 1, continue_forever: true, duration: 3600 do
      think_time 1000, 1
      log_in uid
      visit name: 'Filter by rejected', url: BASEURL + '/provider/applications?commit=Apply+filters&status%5B%5D=rejected' do
        extract name: 'application_id', regex: 'href="/provider/applications/(\d+)"', match_number: 0
      end
      think_time 1000, 1
      visit name: 'Load rejected application', url: BASEURL + '/provider/applications/${application_id}'
      think_time 1000, 1
    end

  end
end.jmx
