# DHCP2YAML
AWK script to parse dhcpd.conf into yaml.

Each subnet must have a newline after declaration, to maintain record seperator. (RS)

Note: newline is set to windows \r\n if unix required change \r\n to \n in both RS and FS.

Feel free to modify for any particular host options. (Mac address matching is currently commented out)

Usage: dhcp_parse.awk <dhcpd conf file> >> <output file>
Usage: dhcp_parse.awk dhcpd.conf >> dhcp.yaml

Example dhcpd.conf

subnet 192.168.50.0 netmask 255.255.255.0 {
  option routers 192.168.50.1;
  option domain-name-servers 192.168.50.5 192.168.50.6;
  default-lease-time 1800;
  min-lease-time 1800;
  max-lease-time 1800;
  pool {
    deny dynamic bootp clients;
    range 192.168.50.10 192.168.50.20;
  }
}

subnet 172.16.50.0 netmask 255.255.0.0 {
  option domain-name "abc.com";
  option domain-name-servers 172.16.50.5 172.16.50.6;
  option routers 172.16.50.1;
  default-lease-time 3600;
  min-lease-time 3600;
  max-lease-time 3600;
  pool {
     deny dynamic bootp clients;
     range 172.16.51.1 172.16.51.254
  }
  host 172.16.50.10 {
    dynamic;
    host-identifier option agent.remote-id "remoteIDhere";
    fixed-address 172.16.50.10;
  }
  host 172.16.50.11 {
    dynamic;
    host-identifier option agent.remote-id "remoteIDhere1";
    fixed-address 172.16.50.11;
  }
  host 172.16.50.12 {
    dynamic;
    host-identifier option agent.remote-id "differentRemote";
    fixed-address 1172.16.50.12;
  }
}

Example output

---
dhcp_subnets:
  192.168.50.0:
    netmask: 255.255.255.0
    routers: 192.168.50.1
    domain_name:
    pools:
      range_start: 192.168.50.10
      range_end: 192.168.50.20
    default_lease: 1800
    min_lease: 1800
    max_lease: 1800
    name_servers:
    - 192.168.50.5
    - 192.168.50.6
    dhcp_hosts:
  172.16.50.0:
    netmask: 255.255.0.0
    routers: 172.16.50.1
    domain_name: abc.com
    pools:
      range_start: 172.16.51.1
      range_end: 172.16.51.254
    default_lease: 3600
    min_lease: 3600
    max_lease: 3600
    name_servers:
    - 172.16.50.5
    - 172.16.50.6
    dhcp_hosts:
      172.16.50.10:
        remote_id: remoteIDhere
        fixed_address: 172.16.50.10
      172.16.50.11:
        remote_id: remoteIDhere1
        fixed_address: 172.16.50.11
      172.16.50.12:
        remote_id: differentRemote
        fixed_address: 1172.16.50.12
