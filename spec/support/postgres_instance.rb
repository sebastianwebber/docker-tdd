class PostgresInstance < ContainerInstance
  def run(opts = {})
    data_dir = "/var/lib/pgsql/data"
    cmd = %{
      /usr/pgsql-#{component_version}/bin/initdb -D #{data_dir} --auth=trust ;
      /usr/pgsql-#{component_version}/bin/postgres
      #{opts.map { |k, v| "-c #{k}=#{v}" }.join(" ")}
      -D #{data_dir}
    }.gsub("\n", "")

    create(cmd)
    start
  end

  def is_ready?
    result = container_exec(
      @container_id,
      "/usr/pgsql-#{component_version}/bin/pg_isready -h localhost",
      :abort_if_error => false,
    )
    result[2] == 0
  end

  def exec_query(query)
    cmd = "/usr/pgsql-#{component_version}/bin/psql -At -h localhost -c '#{query}'"
    result = container_exec(@container_id, cmd, :abort_if_error => false)
    nice_out(cmd, result)
  end

  def component_version
    @target.version.split(".").first
  end
end

module PostgresSupport
  def self.for_each_version(selected_component)
    All.each_component(selected_component).each do |comp|
      comp.targets.each do |target|
        yield PostgresInstance.new target
      end
    end
  end
end
