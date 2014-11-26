class HomeController < ApplicationController
  def sitemap
    path = "https://s3-us-west-2.amazonaws.com/ancientwisdomtextsproduction/sitemap.xml"
    if File.exists?(path)
      render xml: open(path).read
    else
      render text: "Sitemap not found.", status: :not_found
    end
  end

  def robots
    render 'robots.txt.erb'
  end

  def privacy
  end
end
