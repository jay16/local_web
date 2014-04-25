require "sinatra"

configure do
  enable :logging, :static, :sessions 
  enable :dump_errors, :raise_errors, :show_exceptions
  enable :method_override

  set :root,  "./"
  set :views, "./"
  set :public_folder, "./"
  set :js_dir,   "./js"
  set :css_dir, "./css"
  set :cssengine, "css"
end

get "/" do
  send_file "index.html"
end 

get "/:class_file" do
  send_file params[:class_file]
end
#get "/*" do
#  class_file = request.path_info == "/" ? "index.html" : File.basename(request.path_info) 
#  send_file class_file
#end
