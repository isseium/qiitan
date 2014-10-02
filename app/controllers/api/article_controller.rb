class Api::ArticleController < Api::ApiController
  def index
    users = User.joins(:articles).group("users.id").order("SUM(stock_count) desc")

    articles = []
    (Date.today.months_ago(1)..Date.today).each{ |i| 
      articles.push({
        "x" => i.year.to_s+"-"+i.strftime("%m").to_s+"-"+i.strftime("%d").to_s,
        "y" => 0,
        "item" => []
      })
    }

    data = []
    users.each do |user|
      tmp = Marshal.load(Marshal.dump(articles))
      p articles
      tmp.each do |tmp_item|
        user.articles.each do |item|
          if Date.parse(item.posted_at) == Date.parse(tmp_item["x"]) then
            tmp_item["y"] += item.stock_count.to_i
          end
          tmp_item["item"].push(item)
        end  
      end
      data.push({
        "key" => user.name.to_s+" ("+user.total_point.to_s+")" ,
        "name" => user.name,
        "total_point" => user.total_point,
        "values" => tmp
      })

      p articles
    end
    # @u = users
    @item = data
    # @item = articles
  end
end