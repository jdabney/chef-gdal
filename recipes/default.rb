gdal_version = node['gdal']['version']
gdal_folder = node['gdal']['folder_version'] || gdal_version

tarball = "gdal-#{gdal_version}.tar"
tarball_gz = "gdal-#{gdal_version}.tar.gz"
gdal_url = node['gdal']['download_url'] || "http://download.osgeo.org/gdal/#{gdal_version}/#{tarball_gz}"

remote_file "#{Chef::Config[:file_cache_path]}/#{tarball_gz}" do
  source gdal_url
  mode "0644"
  action :create_if_missing
end

bash "install_gdal_#{gdal_version}" do
  cwd cwd Chef::Config[:file_cache_path]
  user "root"
  code <<-EOF
    tar xzvf #{tarball_gz}
    cd gdal-#{gdal_folder}
    ./configure && make && make install
    ldconfig
  EOF
  command ""
  creates "/usr/local/bin/gdal-config"
  action :run
end
