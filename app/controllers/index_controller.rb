class IndexController < ApplicationController
  def index
    @u = User.all
  end
  
  def crawl
    # TODO: ハードコードなのであとで変更
    users = ["isseium", "ganezasan@github", "canno", "te2ka", "s4shiki"]
    users.each do |user|
      Crawler.get user
    end
    
    redirect_to root_url
  end
end
