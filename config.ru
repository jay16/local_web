require "./sinatra"
require "yaml"
ENV["APP_ROOT_PATH"] = File.expand_path(Dir.pwd, __FILE__)

config = YAML.load_file("./config.yaml")
ENV["APP_LOCAL_WEBS"] = Dir.glob(File.join(config["local_web_dir"], "*")).find_all { |t| File.directory?(t) }.join(" ")
run Sinatra::Application
