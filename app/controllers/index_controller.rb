class IndexController < ApplicationController
  def index
    @u = User.joins(:articles).group("users.id").order("SUM(stock_count) desc")
    @total_articles = Article.all.count
    @total_stock = Article.sum(:stock_count)
    @estimate = (10000 - @total_stock) / (@total_stock / @total_articles)
    @last_updated_time = Crawler.getLastUpdatedTime
    @update_status = Crawler.getUpdateStatus
    @hot_articles = Article.all.order("stock_count DESC").limit(5) # とりあえず五件
  end

  def crawl
    # TODO: ハードコードなのであとで変更
    users = ["isseium", "ganezasan", "canno", "te2ka", "s4shiki", "sasarkyz"]
    today = Date.today
    users.each do |user|
      Crawler.get user,
        full_scan: true,
        skip_condition: Proc.new { |item|
          # 1ヶ月経過したらスキップ (NOTE: Cheekit 独自仕様)
          Date.parse(item["created_at"]) < (today << 1)
        }
    end

    # 最終更新時刻を更新
    Crawler.setLastUpdatedTime

    redirect_to root_url
  end
end
