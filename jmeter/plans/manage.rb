require 'ruby-jmeter'

BASEURL = ENV.fetch('JMETER_TARGET_BASEURL')

test do
  cookies clear_each_iteration: true

  threads count: 1, loops: 1 do
    visit name: 'Provider user signs in', url: BASEURL + '/provider' do
      extract regex: "content='(.+?)' name='csrf-token'", name: 'csrf-token'
    end

    visit name: 'Go to sign in', url: BASEURL + '/provider/sign-in'

    submit name: 'Authenticate', url: BASEURL + '/auth/developer/callback',
      fill_in: { 'uid' => 'dev-support' }

    visit name: 'Filter by interviewing', url: BASEURL + '/provider/applications?commit=Apply+filters&status%5B%5D=interviewing' do
      extract name: 'application_id', regex: 'href="/provider/applications/(\d+)"', match_number: 0
    end

    visit name: 'Load interviewing application', url: BASEURL + '/provider/applications/${application_id}'
  end

  threads count: 1, loops: 1 do
    visit name: 'Provider user signs in', url: BASEURL + '/provider' do
      extract regex: "content='(.+?)' name='csrf-token'", name: 'csrf-token'
    end

    visit name: 'Go to sign in', url: BASEURL + '/provider/sign-in'

    submit name: 'Authenticate', url: BASEURL + '/auth/developer/callback',
      fill_in: { 'uid' => 'dev-1N1' }

    visit name: 'Filter by rejected', url: BASEURL + '/provider/applications?commit=Apply+filters&status%5B%5D=rejected' do
      extract name: 'application_id', regex: 'href="/provider/applications/(\d+)"', match_number: 0
    end

    visit name: 'Load rejected application', url: BASEURL + '/provider/applications/${application_id}'
  end
end.jmx
