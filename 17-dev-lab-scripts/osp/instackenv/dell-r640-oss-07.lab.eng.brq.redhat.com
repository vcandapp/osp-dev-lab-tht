{
   "nodes": [
     {
        "name": "compute-0",
        "pm_addr": "10.37.146.185",
        "mac": ["e4:43:4b:5c:90:e1"],
        "arch": "x86_64",
        "pm_type": "pxe_ipmitool",
        "pm_user": "root",
        "pm_password": "$ipmi_password",
        "cpu": "1",
        "memory": "4096",
        "disk": "40"
     },
    {
        "arch": "x86_64",
        "cpu": "1",
        "disk": "40",
        "mac": [
            "e4:43:4b:5e:1c:21"
        ],
        "memory": "4096",
        "name": "compute-1",
        "pm_addr": "10.37.146.187",
        "pm_password": "$ipmi_password",
        "pm_type": "pxe_ipmitool",
        "pm_user": "root"
    }
  ]
}
