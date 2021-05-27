module Docker
  module Specs
    def file_exists?(file)
      cmd = "test -f #{file}"
      result = container_exec @container_id, cmd, :abort_if_error => false
      result[2] == 0 || nice_out(cmd, result)
    end

    def dir_exists?(dir)
      cmd = "test -d #{dir}"
      result = container_exec @container_id, cmd
      result[2] == 0 || nice_out(cmd, result).to_s
    end

    def package_installed?(pkg)
      cmd = "/bin/rpm -qa --queryformat='%{name}\t%{version}\n'"
      result = nil
      if @rpm_packages.nil?
        result = container_exec @container_id, cmd

        @rpm_packages = result[0][0].split("\n").map do |row|
          row_pkg, row_version = row.strip.split("\t")

          [
            row_pkg,
            row_version,
          ]
        end.to_h.sort.to_h
      end

      check_versions(cmd, result, @rpm_packages, pkg, nil)
    end

    def user_exists?(user)
      cmd = "/bin/grep #{user} /etc/passwd"
      result = container_exec @container_id, cmd
      result[2] == 0 || nice_out(cmd, result).to_s
    end

    private

    def check_versions(cmd, result, ref, pkg, version)
      if result.nil?
        result = [ref, [], 0]
      end

      unless ref.key? pkg
        return nice_out(
                 cmd,
                 result,
                 :msg => "package doesn´t exist or isn´t installed",
                 :package => pkg,
                 :version => version,
               ).to_s
      end

      unless version.nil?
        return nice_out(
                 cmd,
                 result,
                 :msg => "version mismatch",
                 :installed => ref[pkg],
                 :expected => version,
               ).to_s if ref[pkg] != version
      end

      true
    end
  end
end
