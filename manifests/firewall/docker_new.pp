
### # Generated by iptables-save v1.4.21 on Sat Aug  4 20:33:33 2018
  ### *nat
  ### :PREROUTING ACCEPT [6:920]
  ### :INPUT ACCEPT [2:616]
  ### :OUTPUT ACCEPT [2:120]
  ### :POSTROUTING ACCEPT [2:120]
  ### :DOCKER - [0:0]
  ### -A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
  ### -A OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
  ### -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
  ### -A DOCKER -i docker0 -j RETURN [newly implemented]
### COMMIT
### # Completed on Sat Aug  4 20:33:33 2018
### # Generated by iptables-save v1.4.21 on Sat Aug  4 20:33:33 2018
### *filter
  ### :INPUT ACCEPT [103:7556]
  ### :FORWARD ACCEPT [0:0]
  ### :OUTPUT ACCEPT [55:5176]
### :DOCKER - [0:0]
### :DOCKER-ISOLATION-STAGE-1 - [0:0]
### :DOCKER-ISOLATION-STAGE-2 - [0:0]
### :DOCKER-USER - [0:0]
  ### -A FORWARD -j DOCKER-USER [newly implemented]
  ### -A FORWARD -j DOCKER-ISOLATION-STAGE-1 [newly implemented]
  ### -A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
  ### -A FORWARD -o docker0 -j DOCKER [newly implemented]
  ### -A FORWARD -i docker0 ! -o docker0 -j ACCEPT
  ### -A FORWARD -i docker0 -o docker0 -j ACCEPT
  ### -A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2 [newly implemented]
  ### -A DOCKER-ISOLATION-STAGE-1 -j RETURN [newly implemented]
  ### -A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP [newly implemented]
  ### -A DOCKER-ISOLATION-STAGE-2 -j RETURN [newly implemented]
  ### -A DOCKER-USER -j RETURN [newly implemented]
### COMMIT
### # Completed on Sat Aug  4 20:33:33 2018

# Generated by xtables-save v1.8.2 on Thu Oct  3 01:18:13 2019
### *filter
### :INPUT ACCEPT [26123:8603155]
### :FORWARD ACCEPT [0:0]
### :OUTPUT ACCEPT [471819:146025618]
### :DOCKER - [0:0]
### :DOCKER-ISOLATION-STAGE-1 - [0:0]
### :DOCKER-ISOLATION-STAGE-2 - [0:0]
### :DOCKER-USER - [0:0]
### [0:0] -A FORWARD -j DOCKER-USER
### [0:0] -A FORWARD -j DOCKER-ISOLATION-STAGE-1
### [0:0] -A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
### [0:0] -A FORWARD -o docker0 -j DOCKER
### [0:0] -A FORWARD -i docker0 ! -o docker0 -j ACCEPT
### [0:0] -A FORWARD -i docker0 -o docker0 -j ACCEPT
### [0:0] -A FORWARD -o docker_gwbridge -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
### [0:0] -A FORWARD -o docker_gwbridge -j DOCKER
### [0:0] -A FORWARD -i docker_gwbridge ! -o docker_gwbridge -j ACCEPT
### [0:0] -A FORWARD -i docker_gwbridge -o docker_gwbridge -j DROP
### [0:0] -A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
### [0:0] -A DOCKER-ISOLATION-STAGE-1 -i docker_gwbridge ! -o docker_gwbridge -j DOCKER-ISOLATION-STAGE-2
### [0:0] -A DOCKER-ISOLATION-STAGE-1 -j RETURN
### [0:0] -A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
### [0:0] -A DOCKER-ISOLATION-STAGE-2 -o docker_gwbridge -j DROP
### [0:0] -A DOCKER-ISOLATION-STAGE-2 -j RETURN
### [0:0] -A DOCKER-USER -j RETURN
### COMMIT
# Completed on Thu Oct  3 01:18:13 2019
# Generated by xtables-save v1.8.2 on Thu Oct  3 01:18:13 2019
### *nat
### :PREROUTING ACCEPT [60753:13459711]
### :INPUT ACCEPT [17438:1130615]
### :POSTROUTING ACCEPT [9215:602254]
### :OUTPUT ACCEPT [14257:950975]
### :DOCKER - [0:0]
### [5:280] -A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
### [0:0] -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
### [0:0] -A POSTROUTING -s 172.18.0.0/16 ! -o docker_gwbridge -j MASQUERADE
### [0:0] -A OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
### [0:0] -A DOCKER -i docker0 -j RETURN
### [0:0] -A DOCKER -i docker_gwbridge -j RETURN
### COMMIT
# Completed on Thu Oct  3 01:18:13 2019
# Generated by xtables-save v1.8.2 on Thu Oct  3 01:18:13 2019
### *mangle
### :PREROUTING ACCEPT [0:0]
### :INPUT ACCEPT [0:0]
### :FORWARD ACCEPT [0:0]
### :OUTPUT ACCEPT [0:0]
### :POSTROUTING ACCEPT [0:0]
### COMMIT
### # Completed on Thu Oct  3 01:18:13 2019

class docker::firewall::docker_new {

  Firewallchain <||> -> Firewall <||>

  if "${::network_docker0}/16" == '/16' {
    notify { 'docker::firewall::docker--check-for--network_docker0': message => "${::network_docker0}/16" }
  } else {
    # include docker::firewall::docker
    include docker::firewall::docker_nat
    include docker::firewall::docker_filter
    ### include docker::firewall::docker_mangle is empty

    file { '/var/run/netns':
      ensure => 'link',
      target => '/var/run/docker/netns',
    }

  }

}

