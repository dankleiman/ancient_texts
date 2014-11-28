class HomeController < ApplicationController
  def sitemap
    render xml: open(Sitemap.last.sitemap.url).read
  end

  def robots
    render 'robots.txt.erb'
  end

  def privacy
  end
end
