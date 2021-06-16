if [ -z "$JMETER_TARGET_PLAN" ]; then exit 1; fi

bundle exec ruby plans/$JMETER_TARGET_PLAN.rb && \
  bundle exec ruby add_prometheus_xml.rb && \
    jmeter -Jprometheus.ip=0.0.0.0 -Jprometheus.save.jvm=false -n -t testplan.jmx
