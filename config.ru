require "./sinatra"
require "yaml"

config = YAML.load_file("./config.yaml")
ENV["APP_ROOT_PATH"] = File.expand_path(Dir.pwd, __FILE__)
ENV["LOCAL_WEB_DIR"] = config["local_web_dir"]
ENV["APP_LOCAL_WEBS"] = Dir.glob(File.join(ENV["LOCAL_WEB_DIR"], "*")).find_all(&File.method(:directory?)).join(" ")

#run Sinatra::Application
map("/") { run LocalWeb }
