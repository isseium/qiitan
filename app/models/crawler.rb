class Crawler
  
  def self.get(username="isseium")
    # auth = "03429a1ab47d4fc49207993c547e0f56"
    json_articles = JSON.parse(RestClient.get "https://qiita.com/api/v1/users/#{username}/items")
    user = User.find_or_create_by(name: username)
    
    today = Date.today
    
    articles = []
    json_articles.each do |item|
      next if Date.parse(item["created_at"]) < (today << 1)
      
      article = Article.find_or_create_by(uuid: item["uuid"]) do |a|
        a.url = item["url"]
        a.posted_at = item["created_at"]
      end
      
      # 情報を更新
      article.title = item["title"]
      article.stock_count = item["stock_count"]
      
      # タグ情報更新
      tags = []
      item["tags"].each do |tag|
        tags.push(Tag.find_or_create_by(name: tag["name"]))
      end

      # 保存
      article.tags = tags
      articles.push(article)
      # article.save
    end
    
    user.articles = articles
    user.save
    
    1
  end
  
end
