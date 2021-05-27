require "docker"
require "open3"
require_relative "docker_specs"

class ContainerInstance
  attr_reader :target

  include Docker::Specs

  def initialize(target)
    @target = target
  end

  def run(cmd = "")
    create(cmd)

    start
  end

  def delete
    @container.kill(:signal => "SIGKILL")
    @container.delete(:force => true)
  end

  private

  def create(cmd)
    @container = Docker::Container.create("Image" => @target.all_tags.first, "Entrypoint" => "", "Cmd" => ["/bin/sh", "-c", cmd])
  end

  def start
    @container_id = @container.id[0..12]
    @container.start

    validate_startup
  end

  def validate_startup()
    sleep(5)
    stat = Docker::Container.get @container_id

    puts ">> start status: " + stat.info["State"]["Status"]

    if stat.info["State"]["Status"] == "exited"
      puts ">> Container failed to start. "
      puts ">>"
      @container.streaming_logs(stdout: true, stderr: true) do |stream, chunk|
        puts ">> #{stream}: #{chunk}"
      end

      puts ""
      raise Exception.new "Container is not running. Check the log above. Details: #{stat.info["State"]}"
    end
  end

  def nice_out(cmd, result, **msg)
    stdout, stderr, exit_code = result

    stdout = extract_out(stdout)
    stderr = extract_out(stderr)

    msg.merge!({
      :stdout => stdout,
      :stderr => stderr,
      :exit_code => exit_code,
      :cmd => cmd,
    })

    msg
  end

  def extract_out(out)
    return [] if out.nil? || out.length == 0

    return out if out.is_a? Hash

    # out = unify_array(out)
    out = out.flatten

    out = out[0].split("\n") if out.length == 1

    out = out.map do |r|
      r.strip
    end

    out
  end

  def container_exec(id, cmd, **opts)
    opts.merge!(
      {
        :from => "container_exec",
      }
    )
    cmd = "docker exec #{id} /bin/sh -c \"#{cmd}\""
    stdout, stderr, status = Open3.capture3(cmd)

    result = [stdout.split('\n'), stderr.split('\n'), status.exitstatus]

    unless opts[:abort_if_error] == false
      raise nice_out(cmd, result, opts).to_s if status.exitstatus > 0
    end

    result
  end
end
