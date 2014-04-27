require "sinatra"
require "haml"

# local web list
get "/" do
  @local_webs = ENV["APP_LOCAL_WEBS"].split.map(&File.method(:basename)) 
  haml :index
end 

get "/refresh" do
  ENV["APP_LOCAL_WEBS"] = Dir.glob(File.join(ENV["LOCAL_WEB_DIR"], "*")).find_all(&File.method(:directory?)).join(" ")
  redirect "/"
end
# render file within 10 levels
# deal with [css, js, html]
# get "/:level1/:level2/..."
(1..10).each do |level|
  get_path = (1..level).map(&:to_s).map(&":level".method(:+)).join("/")
  get "/#{get_path}" do
    render_file = find_exist_first_file
    send_file render_file if render_file and File.exist?(render_file)
  end
end

# traverse all local-web dir to find first exist file
def find_exist_first_file
  if !(local_webs = ENV["APP_LOCAL_WEBS"].split.find_all { |dir| File.basename(dir) == params[:level1] }).empty?
    File.join(local_webs.first, "index.html")
  else
    params_path = params.map(&:first).grep(/level/).sort.map(&params.method(:fetch)).join("/")
    ENV["APP_LOCAL_WEBS"].split.concat([ENV["APP_ROOT_PATH"]])
    .map { |dir| File.join(dir, params_path) }
    .find_all(&File.method(:file?)).first
  end
end

# form helpers
helpers do
  def link_to(content, href=content, options={}); tag(:a, content, options.merge(:href => href)); end
  def tag(name, content, options={})
    "<#{name.to_s}" +
      (options.length > 0 ? " #{hash_to_html_attrs(options)}" : '') +
      (content.nil? ? '>' : ">#{content}</#{name}>")
  end
  
  def hash_to_html_attrs(options={})
    options.keys.sort.reject { |k| options[k].nil? }
    .map { |key| %Q(#{key}="#{fast_escape_html(options[key])}") }
    .join
  end
  
  def fast_escape_html(text);text.to_s.gsub(/\&/,'&amp;').gsub(/\"/,'&quot;').gsub(/>/,'&gt;').gsub(/</,'&lt;'); end
  def javascript_include_tag(*args); %Q(<script src="#{args[0]}"></script>); end
  def stylesheet_link_tag(*args); %Q(<link href="#{args[0]}" media="screen, projection" rel="stylesheet" type="text/css">); end
end

# views
template :index do
%Q(%html
  %head
    %title 本地资源库
    = stylesheet_link_tag "/assets/css/bootstrap.min.css"
    = javascript_include_tag "/assets/js/jquery.1.9.0.js"
    = javascript_include_tag "/assets/js/local_web.js"

  %body{style: "background-color: #CCE8CC;"}
    %header.navbar.navbar-inverse.navbar-fixed-top.bs-docs-nav{:role => "banner",style: "text-shadow: 0 -1px 0 rgba(0,0,0,.15);background-color: #563d7c;border-color: #463265;box-shadow: 0 1px 0 rgba(255,255,255,.1); color: white;"}
      .container
        .navbar-header
          %a.navbar-brand{href:"../"} 本地资源
        %nav.collapse.navbar-collapse.bs-navbar-collapse{:role => "navigation"}
          %ul.nav.navbar-nav.navbar-right
            %li
              %a{onclick: "LocalWeb.refresh();"} 刷新
    .container{style: "margin-top: 55px;"}
      .row
        -@local_webs.each_slice(10).map.each do |cols|
          .col-sm-3
            .row
              -cols.each do |col|
                = link_to col, "/"+col, class: "btn btn-lg btn-primary btn-shadow", style: "min-width: 200px;text-align:left;margin-bottom:10px;"
)
end
