property :name, String, default: '' # ~FC108

action :install do
  include_recipe 'yum-epel'

  package 'haveged'
  package 'gnupg2' # This now supports no protection

  service 'haveged' do
    supports [:status, :restart]
    action :start
  end
end
