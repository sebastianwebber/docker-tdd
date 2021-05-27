class Configuration
  def initialize
    @config = {}
  end

  def to_h
    @config
  end

  def add(key, value)
    return add_array(key, value) if value.class == Array

    add_hash(key, value)
  end

  private

  def add_hash(key, value = {})
    @config[key].merge! value rescue @config[key] = value
  end

  def add_array(key, values = [])
    @config[key] = values
  end

  def method_missing(m, *args, &block)
    return nil unless @config.has_key? m.to_s

    @config[m.to_s]
  end
end
