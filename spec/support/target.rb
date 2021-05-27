module TargetSupport
  def self.for_each_version(selected_component)
    All.each_component(selected_component).each do |comp|
      comp.targets.each do |target|
        yield ContainerInstance.new target
      end
    end
  end
end
