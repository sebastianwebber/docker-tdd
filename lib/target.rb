require "erb"

class Target
  attr_reader :name, :version, :config

  def initialize(name, version, config)
    @name = name
    @version = version
    @config = config.clone
  end

  def build()
    "docker build #{cmd_flags} #{build_args} #{tag_args} #{work_dir}"
  end

  def all_tags
    @config.tags.map do |tag|
      parse_tag tag
    end
  end

  private

  def tag_args
    all_tags.map do |tag|
      "--tag='#{parse_tag tag}'"
    end.join " "
  end

  def parse_tag(templ)
    values = {
      component: self,
      config: @config,
    }

    ERB.new(templ.strip).result_with_hash(values)
  end

  def work_dir
    "#{Dir.pwd}/components.d/#{@name}"
  end

  def cmd_flags
    {
      "file" => "components.d/#{@name}/Dockerfile",
    }.map do |k, v|
      "--#{k}='#{v}'"
    end.join " "
  end

  def build_args
    @config.build_args["version"] = @version

    @config.build_args.map do |k, v|
      "--build-arg='#{k.upcase}=#{v}'"
    end.join " "
  end
end
