osrm_map_extract 'europe' do
  stxxl_size 1024
  action :extract_if_missing
end
