RSpec.shared_examples "user examples" do |instance, user, home_dir|
  it "has the #{user} user" do
    expect(instance.user_exists?(user)).to be true
  end

  it "has the HOME dir set on #{home_dir}" do
    expect(instance.dir_exists?(home_dir)).to be true

    result = instance.exec("cat /etc/passwd | grep '^#{user}:' | cut -d : -f 6")
    expect(result[:stdout].first).to eq(home_dir), result.to_s
  end
end
