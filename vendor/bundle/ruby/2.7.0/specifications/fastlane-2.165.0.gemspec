# -*- encoding: utf-8 -*-
# stub: fastlane 2.165.0 ruby credentials_manager/lib pem/lib snapshot/lib frameit/lib match/lib fastlane_core/lib deliver/lib scan/lib supply/lib cert/lib fastlane/lib spaceship/lib pilot/lib gym/lib precheck/lib screengrab/lib sigh/lib produce/lib

Gem::Specification.new do |s|
  s.name = "fastlane".freeze
  s.version = "2.165.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "docs_url" => "https://docs.fastlane.tools" } if s.respond_to? :metadata=
  s.require_paths = ["credentials_manager/lib".freeze, "pem/lib".freeze, "snapshot/lib".freeze, "frameit/lib".freeze, "match/lib".freeze, "fastlane_core/lib".freeze, "deliver/lib".freeze, "scan/lib".freeze, "supply/lib".freeze, "cert/lib".freeze, "fastlane/lib".freeze, "spaceship/lib".freeze, "pilot/lib".freeze, "gym/lib".freeze, "precheck/lib".freeze, "screengrab/lib".freeze, "sigh/lib".freeze, "produce/lib".freeze]
  s.authors = ["Jorge Revuelta H".freeze, "Matthew Ellis".freeze, "Felix Krause".freeze, "Josh Holtz".freeze, "Danielle Tomlinson".freeze, "J\u00E9r\u00F4me Lacoste".freeze, "Kohki Miki".freeze, "Maksym Grebenets".freeze, "Aaron Brager".freeze, "Jimmy Dee".freeze, "Max Ott".freeze, "Luka Mirosevic".freeze, "Manu Wallner".freeze, "Jan Piotrowski".freeze, "Stefan Natchev".freeze, "Andrew McBurney".freeze, "Fumiya Nakamura".freeze, "Iulian Onofrei".freeze, "Olivier Halligon".freeze, "Joshua Liebowitz".freeze, "Daniel Jankowski".freeze, "Helmut Januschka".freeze]
  s.date = "2020-10-23"
  s.description = "The easiest way to automate beta deployments and releases for your iOS and Android apps".freeze
  s.email = ["fastlane@krausefx.com".freeze]
  s.executables = ["bin-proxy".freeze, "fastlane".freeze]
  s.files = ["bin/bin-proxy".freeze, "bin/fastlane".freeze]
  s.homepage = "https://fastlane.tools".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "3.1.4".freeze
  s.summary = "The easiest way to automate beta deployments and releases for your iOS and Android apps".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<slack-notifier>.freeze, [">= 2.0.0", "< 3.0.0"])
    s.add_runtime_dependency(%q<xcodeproj>.freeze, [">= 1.13.0", "< 2.0.0"])
    s.add_runtime_dependency(%q<xcpretty>.freeze, ["~> 0.3.0"])
    s.add_runtime_dependency(%q<terminal-notifier>.freeze, [">= 2.0.0", "< 3.0.0"])
    s.add_runtime_dependency(%q<terminal-table>.freeze, [">= 1.4.5", "< 2.0.0"])
    s.add_runtime_dependency(%q<plist>.freeze, [">= 3.1.0", "< 4.0.0"])
    s.add_runtime_dependency(%q<CFPropertyList>.freeze, [">= 2.3", "< 4.0.0"])
    s.add_runtime_dependency(%q<addressable>.freeze, [">= 2.3", "< 3.0.0"])
    s.add_runtime_dependency(%q<multipart-post>.freeze, ["~> 2.0.0"])
    s.add_runtime_dependency(%q<word_wrap>.freeze, ["~> 1.0.0"])
    s.add_runtime_dependency(%q<tty-screen>.freeze, [">= 0.6.3", "< 1.0.0"])
    s.add_runtime_dependency(%q<tty-spinner>.freeze, [">= 0.8.0", "< 1.0.0"])
    s.add_runtime_dependency(%q<babosa>.freeze, [">= 1.0.3", "< 2.0.0"])
    s.add_runtime_dependency(%q<colored>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<commander-fastlane>.freeze, [">= 4.4.6", "< 5.0.0"])
    s.add_runtime_dependency(%q<excon>.freeze, [">= 0.71.0", "< 1.0.0"])
    s.add_runtime_dependency(%q<faraday-cookie_jar>.freeze, ["~> 0.0.6"])
    s.add_runtime_dependency(%q<faraday>.freeze, ["~> 1.0"])
    s.add_runtime_dependency(%q<faraday_middleware>.freeze, ["~> 1.0"])
    s.add_runtime_dependency(%q<fastimage>.freeze, [">= 2.1.0", "< 3.0.0"])
    s.add_runtime_dependency(%q<gh_inspector>.freeze, [">= 1.1.2", "< 2.0.0"])
    s.add_runtime_dependency(%q<highline>.freeze, [">= 1.7.2", "< 2.0.0"])
    s.add_runtime_dependency(%q<json>.freeze, ["< 3.0.0"])
    s.add_runtime_dependency(%q<mini_magick>.freeze, [">= 4.9.4", "< 5.0.0"])
    s.add_runtime_dependency(%q<rubyzip>.freeze, [">= 2.0.0", "< 3.0.0"])
    s.add_runtime_dependency(%q<security>.freeze, ["= 0.1.3"])
    s.add_runtime_dependency(%q<xcpretty-travis-formatter>.freeze, [">= 0.0.3"])
    s.add_runtime_dependency(%q<dotenv>.freeze, [">= 2.1.1", "< 3.0.0"])
    s.add_runtime_dependency(%q<bundler>.freeze, [">= 1.12.0", "< 3.0.0"])
    s.add_runtime_dependency(%q<simctl>.freeze, ["~> 1.6.3"])
    s.add_runtime_dependency(%q<jwt>.freeze, [">= 2.1.0", "< 3"])
    s.add_runtime_dependency(%q<google-api-client>.freeze, [">= 0.37.0", "< 0.39.0"])
    s.add_runtime_dependency(%q<google-cloud-storage>.freeze, [">= 1.15.0", "< 2.0.0"])
    s.add_runtime_dependency(%q<emoji_regex>.freeze, [">= 0.1", "< 4.0"])
    s.add_runtime_dependency(%q<aws-sdk-s3>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.9.0"])
    s.add_development_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.4.1"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry-byebug>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry-rescue>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry-stack_explorer>.freeze, [">= 0"])
    s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.11"])
    s.add_development_dependency(%q<webmock>.freeze, ["~> 3.8"])
    s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.8.13"])
    s.add_development_dependency(%q<rubocop>.freeze, ["= 0.49.1"])
    s.add_development_dependency(%q<rubocop-require_tools>.freeze, [">= 0.1.2"])
    s.add_development_dependency(%q<rb-readline>.freeze, [">= 0"])
    s.add_development_dependency(%q<rest-client>.freeze, [">= 1.8.0"])
    s.add_development_dependency(%q<fakefs>.freeze, ["~> 1.2.1"])
    s.add_development_dependency(%q<sinatra>.freeze, ["~> 2.0.8"])
    s.add_development_dependency(%q<xcov>.freeze, ["~> 1.4.1"])
    s.add_development_dependency(%q<climate_control>.freeze, ["~> 0.2.0"])
  else
    s.add_dependency(%q<slack-notifier>.freeze, [">= 2.0.0", "< 3.0.0"])
    s.add_dependency(%q<xcodeproj>.freeze, [">= 1.13.0", "< 2.0.0"])
    s.add_dependency(%q<xcpretty>.freeze, ["~> 0.3.0"])
    s.add_dependency(%q<terminal-notifier>.freeze, [">= 2.0.0", "< 3.0.0"])
    s.add_dependency(%q<terminal-table>.freeze, [">= 1.4.5", "< 2.0.0"])
    s.add_dependency(%q<plist>.freeze, [">= 3.1.0", "< 4.0.0"])
    s.add_dependency(%q<CFPropertyList>.freeze, [">= 2.3", "< 4.0.0"])
    s.add_dependency(%q<addressable>.freeze, [">= 2.3", "< 3.0.0"])
    s.add_dependency(%q<multipart-post>.freeze, ["~> 2.0.0"])
    s.add_dependency(%q<word_wrap>.freeze, ["~> 1.0.0"])
    s.add_dependency(%q<tty-screen>.freeze, [">= 0.6.3", "< 1.0.0"])
    s.add_dependency(%q<tty-spinner>.freeze, [">= 0.8.0", "< 1.0.0"])
    s.add_dependency(%q<babosa>.freeze, [">= 1.0.3", "< 2.0.0"])
    s.add_dependency(%q<colored>.freeze, [">= 0"])
    s.add_dependency(%q<commander-fastlane>.freeze, [">= 4.4.6", "< 5.0.0"])
    s.add_dependency(%q<excon>.freeze, [">= 0.71.0", "< 1.0.0"])
    s.add_dependency(%q<faraday-cookie_jar>.freeze, ["~> 0.0.6"])
    s.add_dependency(%q<faraday>.freeze, ["~> 1.0"])
    s.add_dependency(%q<faraday_middleware>.freeze, ["~> 1.0"])
    s.add_dependency(%q<fastimage>.freeze, [">= 2.1.0", "< 3.0.0"])
    s.add_dependency(%q<gh_inspector>.freeze, [">= 1.1.2", "< 2.0.0"])
    s.add_dependency(%q<highline>.freeze, [">= 1.7.2", "< 2.0.0"])
    s.add_dependency(%q<json>.freeze, ["< 3.0.0"])
    s.add_dependency(%q<mini_magick>.freeze, [">= 4.9.4", "< 5.0.0"])
    s.add_dependency(%q<rubyzip>.freeze, [">= 2.0.0", "< 3.0.0"])
    s.add_dependency(%q<security>.freeze, ["= 0.1.3"])
    s.add_dependency(%q<xcpretty-travis-formatter>.freeze, [">= 0.0.3"])
    s.add_dependency(%q<dotenv>.freeze, [">= 2.1.1", "< 3.0.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.12.0", "< 3.0.0"])
    s.add_dependency(%q<simctl>.freeze, ["~> 1.6.3"])
    s.add_dependency(%q<jwt>.freeze, [">= 2.1.0", "< 3"])
    s.add_dependency(%q<google-api-client>.freeze, [">= 0.37.0", "< 0.39.0"])
    s.add_dependency(%q<google-cloud-storage>.freeze, [">= 1.15.0", "< 2.0.0"])
    s.add_dependency(%q<emoji_regex>.freeze, [">= 0.1", "< 4.0"])
    s.add_dependency(%q<aws-sdk-s3>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.9.0"])
    s.add_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.4.1"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
    s.add_dependency(%q<pry-rescue>.freeze, [">= 0"])
    s.add_dependency(%q<pry-stack_explorer>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.11"])
    s.add_dependency(%q<webmock>.freeze, ["~> 3.8"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.8.13"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.49.1"])
    s.add_dependency(%q<rubocop-require_tools>.freeze, [">= 0.1.2"])
    s.add_dependency(%q<rb-readline>.freeze, [">= 0"])
    s.add_dependency(%q<rest-client>.freeze, [">= 1.8.0"])
    s.add_dependency(%q<fakefs>.freeze, ["~> 1.2.1"])
    s.add_dependency(%q<sinatra>.freeze, ["~> 2.0.8"])
    s.add_dependency(%q<xcov>.freeze, ["~> 1.4.1"])
    s.add_dependency(%q<climate_control>.freeze, ["~> 0.2.0"])
  end
end
