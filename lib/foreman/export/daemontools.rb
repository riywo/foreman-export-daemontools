require "erb"
require "pathname"
require "foreman/export"

class Foreman::Export::Daemontools < Foreman::Export::Base

  def export
#    super
    error("Must specify a location") unless location

    engine.each_process do |name, process|
      1.upto(engine.formation[name]) do |num|
        export_proc(name, process, num)
      end
    end
  end

  private

  def export_template(name, file=nil, template_root=nil)
    name_without_first = name.split("/")[1..-1].join("/")
    matchers = []
    matchers << File.join(options[:template], name_without_first) if options[:template]
    matchers << File.expand_path("~/.foreman/templates/#{name}")
    matchers << File.expand_path("../../../../data/export/#{name}", __FILE__)
    File.read(matchers.detect { |m| File.exists?(m) })
  end

  def export_proc(name, process, num)
    proc_name  = "#{app}-#{name}-#{num}"
    port       = engine.port_for(process, num)
    env        = engine.env.merge("PORT" => port.to_s)

    proc_dir     = Pathname(location) + proc_name
    log_dir      = options[:log] ? Pathname(options[:log]) : proc_dir + 'log'
    log_main_dir = options[:log] ? log_dir + proc_name : './main'
    env_dir      = proc_dir + 'env'

    proc_dir.mkpath
#    write_file(proc_dir + 'down', '')
    log_dir.mkpath
    log_run = log_dir + 'run'
    write_template("daemontools/daemontools-log-run.erb", log_run, binding)
    log_run.chmod(0755)

    env_dir.mkpath
    Dir.glob(env_dir + "/*").each do |e|
      File.delete(e)
    end
    env.each do |k,v|
      write_file(env_dir + k, v)
    end

    proc_run = proc_dir + 'run'
    write_template("daemontools/daemontools-run.erb", proc_run, binding)
    proc_run.chmod(0755)
  end
end

