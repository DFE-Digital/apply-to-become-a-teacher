require 'ruby-jmeter'

BASEURL = ENV.fetch('JMETER_TARGET_BASEURL')

test do
  threads count: 1, continue_forever: true, duration: 300 do
    visit name: 'Go to Manage', url: BASEURL + '/provider?jmeter=true'
    think_time 1000, 1
  end
end.jmx
