- name: Storage
  vip: true
  vlan: 102
  name_lower: storage
  ip_subnet: '152.20.16.0/24'
  gateway_ip: '152.20.16.1'
  routes: [{'destination':'152.20.16.0/20', 'nexthop':'152.20.16.1'}]
  allocation_pools: [{'start': '152.20.16.4', 'end': '152.20.16.250'}]
- name: StorageMgmt
  name_lower: storage_mgmt
  vip: true
  vlan: 103
  ip_subnet: '152.20.48.0/24'
  gateway_ip: '152.20.48.1'
  routes: [{'destination':'152.20.48.0/20', 'nexthop':'152.20.48.1'}]
  allocation_pools: [{'start': '152.20.48.4', 'end': '152.20.48.250'}]
- name: InternalApi
  name_lower: internal_api
  vip: true
  vlan: 101
  ip_subnet: '152.20.32.0/24'
  gateway_ip: '152.20.32.1'
  routes: [{'destination':'152.20.32.0/20', 'nexthop':'152.20.32.1'}]
  allocation_pools: [{'start': '152.20.32.4', 'end': '152.20.32.250'}]
- name: Tenant
  vip: false  # Tenant networks do not use VIPs
  name_lower: tenant
  vlan: 104
  ip_subnet: '152.20.0.0/24'
  gateway_ip: '152.20.0.1'
  routes: [{'destination':'152.20.0.0/20', 'nexthop':'152.20.0.1'}]
  allocation_pools: [{'start': '152.20.0.4', 'end': '152.20.0.250'}]
  # Note that tenant tunneling is only compatible with IPv4 addressing at this time.
- name: External
  vip: true
  name_lower: external
  ip_subnet: '172.21.0.0/24'
  allocation_pools: [{'start': '172.21.0.201', 'end': '172.21.0.206'}]
  gateway_ip: '172.21.0.1'
