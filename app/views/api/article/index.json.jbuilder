json.array! @graphs do |graph|
  json.(graph, "name", "total_stock" ,"key")

  json.values do
    json.array! graph["values"] do |value|
		json.(value , "x" , "y")
    end
  end
end

