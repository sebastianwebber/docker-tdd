require "yaml"

class Component
  attr_reader :name, :config, :targets

  def initialize(name)
    @name = name
    @config = Configuration.new

    load_all_config

    add_targets
  end

  private

  def add_targets()
    @targets = []
    @config.target_versions.each do |ver|
      @targets.push Target.new @name, ver, @config
    end
  end

  def load_all_config()
    default_cfg = YAML::load_file("./config.yml")
    add_config "build_args", default_cfg
    add_config "tags", default_cfg

    custom_cfg = YAML::load_file("./components.d/#{@name}/config.yml")
    add_config "target_versions", custom_cfg
  end

  def add_config(arg, values)
    @config.add arg, values[arg] if values.has_key? arg
  end
end
