json.array! @item do |item|
  json.(item, "name", "total_point" ,"key")

  json.values do
    json.array! item["values"] do |value|
		json.(value , "x" , "y")
    end
  end
end

