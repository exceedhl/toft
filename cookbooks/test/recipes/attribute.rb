directory "/tmp/#{node.one}" do
  action :create
end

directory "/tmp/#{node.two.two}" do
  action :create
end

directory "/tmp/#{node.two.one}" do
  action :create
end

directory "/tmp/#{node.three}" do
  action :create
end