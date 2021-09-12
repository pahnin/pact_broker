#!/usr/bin/env ruby
begin

  $LOAD_PATH << "#{Dir.pwd}/lib"
  require "pact_broker/test/http_test_data_builder"
  base_url = ENV["PACT_BROKER_BASE_URL"] || "http://localhost:9292"

  td = PactBroker::Test::HttpTestDataBuilder.new(base_url)
  td.delete_pacticipant("AutoDetectTestProvider")
    .create_environment(name: "prod", production: true)
    .create_pacticipant("AutoDetectTestProvider")
    .create_tagged_pacticipant_version(pacticipant: "AutoDetectTestProvider", version: "1", tag: "main")
    .deploy_to_prod(pacticipant: "AutoDetectTestProvider", version: "1")
    .publish_pact(consumer: "AutoDetectTestConsumer", provider: "AutoDetectTestProvider", consumer_version: "1", tag: "feat/x", content_id: "2111")
    .publish_pact(consumer: "AutoDetectTestConsumer", provider: "AutoDetectTestProvider", consumer_version: "2", tag: "feat/y", content_id: "21asdfd")

rescue StandardError => e
  puts "#{e.class} #{e.message}"
  puts e.backtrace
  exit 1
end
