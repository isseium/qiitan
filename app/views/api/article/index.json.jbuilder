json.array! @articles do |article|
  json.(article, "name", "total_point" ,"key")

  json.values do
    json.array! article["values"] do |value|
		json.(value , "x" , "y")
    end
  end
end

