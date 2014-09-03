class IndexController < ApplicationController
  def index
    @u = User.all
    @total_articles = Article.all.count
    @total_stock = Article.sum(:stock_count)
  end
  
  def crawl
    # TODO: ハードコードなのであとで変更
    users = ["isseium", "ganezasan", "canno", "te2ka", "s4shiki"]
    users.each do |user|
      Crawler.get user
    end
    
    redirect_to root_url
  end
end
