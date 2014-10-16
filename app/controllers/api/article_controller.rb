class Api::ArticleController < Api::ApiController
  def index
    users = User.all

    values = []
    (Date.today.months_ago(1)..Date.today).each do |i| 
      values.push({
        "x" => i.year.to_s+"-"+i.strftime("%m").to_s+"-"+i.strftime("%d").to_s,
        "y" => 0,
        "item" => []
      })
    end 

    articles = []
    users.each do |user|
      tmp_values = Marshal.load(Marshal.dump(values))
      # p articles
      all_count = 0
      tmp_values.each do |tmp_item|
        user.articles.each do |item|
          if Date.parse(item.posted_at) == Date.parse(tmp_item["x"]) then
            tmp_item["y"] += item.stock_count.to_i
          end
          tmp_item["item"].push(item)
        end  
        tmp_item["y"] += all_count # 前日分も反映させて
        all_count = tmp_item["y"] # 当日分をたす
      end
      articles.push({
        "key" => user.name.to_s+" ("+user.total_point.to_s+")" ,
        "name" => user.name,
        "total_point" => user.total_point,
        "values" => tmp_values
      })

      # p articles
    end
    # @u = users
    @articles = articles
    # @item = articles
  end
end
