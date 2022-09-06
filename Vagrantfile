Vagrant.configure("2") do |config|
  config.vm.box = "anica-artifact"
  config.vm.provider "virtualbox" do |provider|
    provider.name = "anica-artifact"
    # Adjust those as resources are available, more cores improve the speed substantially.
    # provider.memory = 16384
    # provider.cpus = 8
    provider.memory = 8192
    provider.cpus = 6
  end
  config.vm.network :forwarded_port, guest: 8000, host: 8300
  config.vm.network :forwarded_port, guest: 80, host: 8380
end

