Dir["./lib/*.rb"].sort.each { |f| require f }
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "build the components"
task :build, [:component] do |t, args|
  msg = args[:component].to_s.empty? ? "all components" : args[:component]
  puts ">> building #{msg}..."

  All.each_component(args[:component]).each do |comp|
    comp.targets.each do |target|
      sh target.build
    end
  end
end
