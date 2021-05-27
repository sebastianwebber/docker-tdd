RSpec.shared_examples "postgres examples" do |instance|
  it "can run queries with JIT without errors" do
    result = instance.exec_query("set jit=on; set jit_above_cost = 0.0001; EXPLAIN(ANALYZE) select generate_series(1, 1000);")

    expect(result[:exit_code]).to eq(0), result.to_s
  end

  include_examples "postgres extensions examples", instance
end

RSpec.shared_examples "postgres extensions examples" do |instance|
  [
    "pg_stat_statements",
  ].each do |ext|
    it "can create the #{ext} extension" do
      result = instance.exec_query("CREATE EXTENSION #{ext} CASCADE;")

      expect(result[:exit_code]).to eq(0), result.to_s
    end
  end
end
