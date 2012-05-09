%w{bag1 bag2}.each do |bag_name|
  %w{item1 item2}.each do |item_name|
    item = data_bag_item(bag_name, item_name)
    directory "/tmp/stub/#{item['value']}" do
      action :create
      recursive true
    end
  end
end
