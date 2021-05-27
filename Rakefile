Dir["./lib/*.rb"].sort.each { |f| require f }

desc "build the components"
task :build, [:component] do |t, args|
  All.each_component(args[:component]) do |comp|
    comp.targets.each do |target|
      sh target.build
    end
  end
end