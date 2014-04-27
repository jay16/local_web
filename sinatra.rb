require "sinatra"
require "haml"

# local web list
get "/" do
  @local_webs = ENV["APP_LOCAL_WEBS"].split.map { |local_web| File.basename(local_web) }
  haml :index
end 

# render file within 10 levels
# deal with [css, js, html]
(1..10).each do |level|
  get_path = (1..level).map { |t| ":level" + t.to_s }.join("/")
  get "/#{get_path}" do
    render_file = find_exist_first_file
    send_file render_file if render_file and File.exist?(render_file)
  end
end

def find_exist_first_file
  if !(local_webs = ENV["APP_LOCAL_WEBS"].split.find_all { |dir| File.basename(dir) == params[:level1] }).empty?
    File.join(local_webs.first, "index.html")
  else
    params_path = params.map(&:first).grep(/level/).sort.map { |k| params[k] }.join("/")
    ENV["APP_LOCAL_WEBS"].split.concat([ENV["APP_ROOT_PATH"]])
    .map { |web_dir| File.join(web_dir, params_path) }
    .find_all { |file_path |  File.exists?(file_path) and File.file?(file_path) }
    .first
  end
end

helpers do
  def link_to(content, href=content, options={}); tag(:a, content, options.merge(:href => href)); end
  # Standard open and close tags
  # EX : tag :h1, "shizam", :title => "shizam"
  # => <h1 title="shizam">shizam</h1>
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

template :index do
%Q(%html
  %head
    %title 本地资源库
    = stylesheet_link_tag "/assets/css/bootstrap.min.css"
  %body{style: "background-color: #CCE8CC;"}
    %header.navbar.navbar-inverse.navbar-fixed-top.bs-docs-nav{:role => "banner",style: "text-shadow: 0 -1px 0 rgba(0,0,0,.15);background-color: #563d7c;border-color: #463265;box-shadow: 0 1px 0 rgba(255,255,255,.1); color: white;"}
      .container
        .row
          .col-sm-8.col-sm-offset-2
            %a.navbar-brand{:href => "../"} 本地资源
    .container{style: "margin-top: 55px;"}
      .row
        .col-sm-8.col-sm-offset-2
          %table.table.table-hover
            -@local_webs.each do |local_web|
              %tr
                %td= link_to local_web, "/"+local_web, class: "btn btn-lg btn-primary btn-shadow", style: "min-width: 200px;text-align:left;"
)
end