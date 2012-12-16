#!/usr/bin/env rake
require "bundler/gem_tasks"

namespace :spec do
  task :mocked do
    sh "env MOCK_IMGUR=true bundle exec rspec spec/"
  end
end

task :spec => ["spec:mocked", "spec:unmocked"]

task default: "spec:mocked"
