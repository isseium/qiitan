class Article < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  
  def point_unit
    self.tags.each do |tag|
      return 100 if tag["name"] == "Titanium"
    end
    
    return 50
  end
  
  def point
    return stock_count * point_unit
  end
  
  def point_with_upper_limit
    return (stock_count * point_unit > 5000)?5000:(stock_count * point_unit)
  end
end
