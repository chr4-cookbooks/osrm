osrm_map_download 'europe' do
  checksum false
  action :download_if_missing
end
