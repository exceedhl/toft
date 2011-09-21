include_recipe 'lxc'

gem_package "cucumber" do
  options "--no-ri --no-rdoc"
end

