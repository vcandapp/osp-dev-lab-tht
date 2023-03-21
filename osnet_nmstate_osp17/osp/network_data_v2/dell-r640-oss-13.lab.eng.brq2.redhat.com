- name: Storage
  vip: true
  vlan: 502
  name_lower: storage
  ip_subnet: '152.50.16.0/24'
  gateway_ip: '152.50.16.1'
  routes: [{'destination':'152.50.16.0/20', 'nexthop':'152.50.16.1'}]
  allocation_pools: [{'start': '152.50.16.4', 'end': '152.50.16.250'}]
- name: StorageMgmt
  name_lower: storage_mgmt
  vip: true
  vlan: 503
  ip_subnet: '152.50.48.0/24'
  gateway_ip: '152.50.48.1'
  routes: [{'destination':'152.50.48.0/20', 'nexthop':'152.50.48.1'}]
  allocation_pools: [{'start': '152.50.48.4', 'end': '152.50.48.250'}]
- name: InternalApi
  name_lower: internal_api
  vip: true
  vlan: 501
  ip_subnet: '152.50.32.0/24'
  gateway_ip: '152.50.32.1'
  routes: [{'destination':'152.50.32.0/20', 'nexthop':'152.50.32.1'}]
  allocation_pools: [{'start': '152.50.32.4', 'end': '152.50.32.250'}]
- name: Tenant
  vip: false  # Tenant networks do not use VIPs
  name_lower: tenant
  vlan: 505
  ip_subnet: '152.50.0.0/24'
  gateway_ip: '152.50.0.1'
  routes: [{'destination':'152.50.0.0/20', 'nexthop':'152.50.0.1'}]
  allocation_pools: [{'start': '152.50.0.4', 'end': '152.50.0.250'}]
  # Note that tenant tunneling is only compatible with IPv4 addressing at this time.
- name: External
  vip: true
  name_lower: external
  ip_subnet: '172.51.0.0/24'
  allocation_pools: [{'start': '172.51.0.201', 'end': '172.51.0.206'}]
  gateway_ip: '172.51.0.1'
