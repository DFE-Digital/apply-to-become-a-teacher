require 'ruby-jmeter'

BASEURL = ENV.fetch('JMETER_TARGET_BASEURL')

def set_headers(api_key)
  header [
    { name: 'Content-Type', value: 'application/json' },
    { name: 'Authorization', value: "Bearer #{api_key}" },
  ]
end

test do
  %w[
    Xp9jU2_2BeDqsRP8Yy8C
  ].each do |api_key|

    # Sync applications (last 90 days) once every hour
    threads count: 1, loops: 2, duration: 3600 do
      set_headers api_key
      params = { since: (Time.now - 7776000).strftime('%Y-%m-%dT%H:%M:%S.%L%z') }
      get name: 'Sync applications',
        url: BASEURL + '/api/v1/applications',
        raw_body: params.to_json { with_xhr }

      think_time 1800000, 1
    end

  end
end.jmx
