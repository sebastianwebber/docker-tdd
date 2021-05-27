module All
  def self.each_component(component)
    Dir.glob("components.d/*").select do |f|
      File.directory? f
    end.map do |f|
      File.basename(f)
    end.select do |f|
      component.nil? || f == component
    end.each do |comp|
      yield Component.new comp
    end
  end
end
