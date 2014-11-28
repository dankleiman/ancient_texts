class HomeController < ApplicationController
  def sitemap
    # need to look here to load sitemap
    path = Rails.root.join("tmp", "sitemaps", "sitemap.xml")
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
