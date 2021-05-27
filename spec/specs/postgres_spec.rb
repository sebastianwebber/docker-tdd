require "spec_helper"

TargetSupport.for_each_version("postgres") do |instance|
  describe "PostgreSQL #{instance.target.version} image" do
    before :all do
      instance.run(cmd = "tail -f /dev/null")
    end

    after :all do
      instance.delete
    end

    [
      "readline-devel",
      "zlib-devel",
      "gcc",
      "make",
    ].each do |pkg|
      it "should NOT contain the #{pkg} package installed" do
        expect(instance.package_installed?(pkg)).to_not be true
      end
    end

    [
      "readline",
      "zlib",
    ].each do |pkg|
      it "should contain the #{pkg} package installed" do
        expect(instance.package_installed?(pkg)).to be true
      end
    end

    # it "should thrown an error" do
    #   skip "not yet"
    # end

    # include_examples "user examples", instance, "postgres", "/var/lib/postgresql"
  end
end
