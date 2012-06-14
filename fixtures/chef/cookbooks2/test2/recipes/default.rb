item = data_bag_item("bag3", "item3")
directory "/tmp/test2/#{item['value']}" do
  action :create
  recursive true
end
