class User < ActiveRecord::Base
  has_many :articles
  
  def total_point
    sum = 0
    self.articles.each do |a|
      sum += a.point
    end
    
    sum
  end
end
