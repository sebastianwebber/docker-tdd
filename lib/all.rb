module All
  def self.each_component(component)
    Dir.glob("components.d/*").select do |f|
      File.directory? f
    end.map do |f|
      File.basename(f)
    end.select do |f|
      component.nil? || f == component
    end.map do |comp|
      Component.new comp
    end
  end
end
