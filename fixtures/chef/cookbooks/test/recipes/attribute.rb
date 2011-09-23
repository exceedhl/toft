directory "/tmp/stub/#{node.one}" do
  action :create
  recursive true
end

directory "/tmp/stub/#{node.two.two}" do
  action :create
  recursive true
end

directory "/tmp/stub/#{node.two.one}" do
  action :create
  recursive true
end

directory "/tmp/stub/#{node.three}" do
  action :create
  recursive true
end