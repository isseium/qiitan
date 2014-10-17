class Crawler
  
  def self.get(username="isseium", full_scan: false, skip_condition: Proc.new {true}, date: Date.today)
    # フルスキャン（ページングを加味したうえでクロールする）
    if full_scan
      hash_articles = []
      loop.with_index do |_, i|
        pre_articles = JSON.parse(RestClient.get "https://qiita.com/api/v1/users/#{username}/items?page=#{i+1}")
        break if pre_articles.size == 0 
        hash_articles +=  pre_articles
      end
    else
      hash_articles = JSON.parse(RestClient.get "https://qiita.com/api/v1/users/#{username}/items")
    end
    
    user = User.find_or_create_by(name: username)
    
    hash_articles.each do |item|
      next if skip_condition.call(item)
       
      #================================================================================
      # article 更新
      #================================================================================
      article = user.articles.find_or_create_by(uuid: item["uuid"]) do |a|
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
      article.save
      
      #================================================================================
      # article_stat 更新
      #================================================================================
      stat = article.article_stats.find_or_create_by(date: date)
      stat.stock_count = item["stock_count"]
      stat.save
    end

    1
  end

  def self.setLastUpdatedTime
    ts = Time.now.to_i
    Redis.current.set('last_updated_time', ts)
  end

  def self.getLastUpdatedTime
    updated_ts = Redis.current.get('last_updated_time').to_i;
    # MEMO: nil だったら 1970-01-01 が入る
    return Time.at(updated_ts).strftime("%Y-%m-%d %H:%M:%S")
  end

  # 最終更新時間からの経過時間で状態を返してくれる
  def self.getUpdateStatus
    current_ts = Time.now.to_i
    updated_ts = Redis.current.get('last_updated_time').to_i;
    # とりあえず30分以上だったら
    if current_ts - updated_ts > 30 * 60
      return "success"
    else
      return "warning"
    end
  end


end
