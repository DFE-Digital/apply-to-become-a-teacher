# See: # https://raw.githubusercontent.com/johrstrom/jmeter-prometheus-plugin/master/docs/examples/simple_prometheus_example.jmx

prometheus_xml = <<PROMETHEUS_LISTENER_CONFIG
        </hashTree>
        <com.github.johrstrom.listener.PrometheusListener guiclass="com.github.johrstrom.listener.gui.PrometheusListenerGui" testclass="com.github.johrstrom.listener.PrometheusListener" testname="Prometheus listener" enabled="true">
          <collectionProp name="prometheus.collector_definitions">
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">the response time for a jsr223 sampler</stringProp>
              <stringProp name="collector.metric_name">jsr223_rt_as_hist</stringProp>
              <stringProp name="collector.type">HISTOGRAM</stringProp>
              <collectionProp name="collector.labels">
                <stringProp name="102727412">label</stringProp>
              </collectionProp>
              <stringProp name="collector.quantiles_or_buckets">100,500,1000,3000</stringProp>
              <stringProp name="listener.collector.listen_to">samples</stringProp>
              <stringProp name="listener.collector.measuring">ResponseTime</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">the response time for a jsr223 sampler</stringProp>
              <stringProp name="collector.metric_name">jsr223_rt_as_summary</stringProp>
              <stringProp name="collector.type">SUMMARY</stringProp>
              <collectionProp name="collector.labels">
                <stringProp name="50511102">category</stringProp>
                <stringProp name="102727412">label</stringProp>
                <stringProp name="3059181">code</stringProp>
              </collectionProp>
              <stringProp name="collector.quantiles_or_buckets">0.75,0.5|0.95,0.1|0.99,0.01</stringProp>
              <stringProp name="listener.collector.measuring">ResponseTime</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">the total number of samplers</stringProp>
              <stringProp name="collector.metric_name">jsr223_count_total</stringProp>
              <stringProp name="collector.type">COUNTER</stringProp>
              <collectionProp name="collector.labels">
                <stringProp name="102727412">label</stringProp>
              </collectionProp>
              <stringProp name="collector.quantiles_or_buckets"></stringProp>
              <stringProp name="listener.collector.measuring">CountTotal</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">the total number of successful samplers</stringProp>
              <stringProp name="collector.metric_name">jsr223_success_total</stringProp>
              <stringProp name="collector.type">COUNTER</stringProp>
              <collectionProp name="collector.labels">
                <stringProp name="102727412">label</stringProp>
              </collectionProp>
              <stringProp name="collector.quantiles_or_buckets"></stringProp>
              <stringProp name="listener.collector.measuring">SuccessTotal</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">the response size for a jsr223 sampler</stringProp>
              <stringProp name="collector.metric_name">jsr223_rsize_as_hist</stringProp>
              <stringProp name="collector.type">HISTOGRAM</stringProp>
              <collectionProp name="collector.labels"/>
              <stringProp name="collector.quantiles_or_buckets">100,500,1000,3000</stringProp>
              <stringProp name="listener.collector.measuring">ResponseSize</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">success ratio of the can_fail_sampler</stringProp>
              <stringProp name="collector.metric_name">jsr223_can_fail</stringProp>
              <stringProp name="collector.type">SUCCESS_RATIO</stringProp>
              <collectionProp name="collector.labels"/>
              <stringProp name="collector.quantiles_or_buckets"></stringProp>
              <stringProp name="listener.collector.measuring">SuccessRatio</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">the latency (ttfb) for a jsr223 sampler</stringProp>
              <stringProp name="collector.metric_name">jsr223_latency_as_hist</stringProp>
              <stringProp name="collector.type">HISTOGRAM</stringProp>
              <collectionProp name="collector.labels">
                <stringProp name="102727412">label</stringProp>
              </collectionProp>
              <stringProp name="collector.quantiles_or_buckets">100,500,1000,3000</stringProp>
              <stringProp name="listener.collector.measuring">Latency</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">the idle time for a jsr223 sampler</stringProp>
              <stringProp name="collector.metric_name">jsr223_idle_time</stringProp>
              <stringProp name="collector.type">SUMMARY</stringProp>
              <collectionProp name="collector.labels"/>
              <stringProp name="collector.quantiles_or_buckets">0.75,0.5|0.95,0.1|0.99,0.01</stringProp>
              <stringProp name="listener.collector.measuring">IdleTime</stringProp>
            </elementProp>
            <elementProp name="" elementType="com.github.johrstrom.listener.ListenerCollectorConfig">
              <stringProp name="collector.help">default help string</stringProp>
              <stringProp name="collector.metric_name">jsr223_assertions</stringProp>
              <stringProp name="collector.type">SUCCESS_RATIO</stringProp>
              <collectionProp name="collector.labels">
                <stringProp name="102727412">label</stringProp>
              </collectionProp>
              <stringProp name="collector.quantiles_or_buckets"></stringProp>
              <stringProp name="listener.collector.measuring">SuccessRatio</stringProp>
              <stringProp name="listener.collector.listen_to">assertions</stringProp>
            </elementProp>
          </collectionProp>
          <stringProp name="TestPlan.comments">This listener &quot;measures&quot; everything, sometimes in summaries, sometimes in histograms.</stringProp>
        </com.github.johrstrom.listener.PrometheusListener>
PROMETHEUS_LISTENER_CONFIG

output = File.open('testplan.jmx', 'w')

File.foreach('ruby-jmeter.jmx') do |line|
  output.puts line

  if line =~ /<\/HTTPSamplerProxy>/
    output.puts prometheus_xml
  end
end

output.close
