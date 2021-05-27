require "spec_helper"

TargetSupport.for_each_version("postgres") do |instance|
  describe "PostgreSQL #{instance.target.version} image" do
    before :all do
      instance.run(cmd = "tail -f /dev/null")
    end

    after :all do
      instance.delete
    end

    it "should thrown an error" do
      skip "not yet"
    end

    # include_examples "user examples", instance, "postgres", "/var/lib/postgresql"
  end
end
