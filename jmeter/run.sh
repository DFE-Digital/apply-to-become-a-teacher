if [ -z "$JMETER_TARGET_PLAN" ]; then exit 1; fi

bundle exec ruby plans/$JMETER_TARGET_PLAN.rb && \
  bundle exec ruby add_prometheus_xml.rb && \
    jmeter -Jvcap_name=apply -Jvcap_guid=guid -Jvcap_org=dfe -Jvcap_space=bat-prod -Jcf_instance=1 -Jprometheus.ip=0.0.0.0 -Jprometheus.save.jvm=false -Jprometheus.port=8080 -Jprometheus.delay=120 -n -t testplan.jmx
