class User < ActiveRecord::Base
  has_many :articles
  
  def total_point
    sum = 0
    self.articles.each do |a|
      sum += a.point
    end
    
    sum
  end
  
  def total_point_with_upper_limit
    sum = 0
    self.articles.each do |a|
      sum += a.point_with_upper_limit
    end
    
    sum
  end
end
