require "spec_helper"

PostgresSupport.for_each_version("postgres") do |instance|
  describe "[Functional] PostgreSQL #{instance.target.version} image" do
    before :all do
      instance.run({ unix_socket_directories: "/tmp" })
      sleep(1) until instance.is_ready?
    end

    after :all do
      instance.delete
    end

    include_examples "postgres examples", instance
  end
end
