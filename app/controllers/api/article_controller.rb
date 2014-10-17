class Api::ArticleController < Api::ApiController
  def index
    users = User.all

    # とりあえずグラフのテンプレートつくる
    graph_template = []
    (Date.today.months_ago(1)..Date.today).each do |date|
      graph_template.push({
        "x" => date.strftime("%Y-%m-%d"),
        "y" => 0,
        "item" => []
      })
    end

    # グラフに入れるデータを生成する
    @graphs = []
    users.each do |user|
      user_graph = graph_template.deep_dup
      all_count = 0
      # それぞれの日付にデータを突っ込んでく
      user_graph.each do |graph_parts|
        user.articles.each do |article|
          if Date.parse(article.posted_at) == Date.parse(graph_parts["x"])
            graph_parts["y"] += article.stock_count.to_i
          end
        end
        graph_parts["y"] += all_count # 前日分も反映させて
        all_count = graph_parts["y"] # 当日分をたす
      end

      @graphs.push({
        "key" => user.name.to_s+" ("+user.total_point.to_s+")" ,
        "name" => user.name,
        "total_point" => user.total_point,
        "values" => user_graph
      })

    end
  end
end
