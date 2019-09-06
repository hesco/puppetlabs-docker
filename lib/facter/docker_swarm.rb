require 'json'

Facter.add(:docker_swarm) do
  setcode do
    services_hash = {}
    services_hash['service_ids'] = []
    docker_hostname = Facter::Core::Execution.exec('hostname -f')
    docker_binary = Facter::Core::Execution.exec('/usr/bin/which docker')
    docker_running = Facter::Core::Execution.exec('/bin/pidof dockerd > /dev/null; echo $?')
    if docker_binary !~ %r{docker}
      services_hash['docker_host'] = 'not a docker host'
    elsif docker_running != 0
      services_hash['docker_status'] = 'docker installed but not running' 
    else
      swarm_status = Facter::Core::Execution.exec("#{docker_binary} info -f '{{json .Swarm.ControlAvailable }}'")
      if swarm_status == false
        services_hash['docker_host'] = docker_hostname
        services_hash['swarm'] = 'docker host not running swarm'
      else
        swarm_metadata = Facter::Core::Execution.exec("#{docker_binary} info -f '{{json .Swarm }}'")
        services_hash['services'] = {} 
        services_hash['swarm'] = JSON.parse(swarm_metadata)
        services_hash['docker_host'] = docker_hostname
        service_count = 0
        service_array = Facter::Core::Execution.exec("#{docker_binary} service ls | /usr/bin/awk '{ print $2 }' | /bin/grep -v NAME").split(%{\n})
        if service_array
          service_array.each do |service_id|
            service_count += 1
            service_inspect_json = Facter::Core::Execution.exec("#{docker_binary} service inspect #{service_id}")
            service_meta_data = JSON.parse(service_inspect_json)
            services_hash['services'][service_id] = service_meta_data[0]
            services_hash['service_ids'].push(service_id)
          end
        end
        services_hash['service_count'] = service_count
      end
    end
    services_hash
  end
end
