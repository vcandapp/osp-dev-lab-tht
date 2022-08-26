{
   "nodes": [
     {
        "name": "compute-0",
        "pm_addr": "10.37.146.177",
        "mac": ["e4:43:4b:4a:30:f1"],
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
            "e4:43:4b:5c:98:b1"
        ],
        "memory": "4096",
        "name": "compute-1",
        "pm_addr": "10.37.146.181",
        "pm_password": "$ipmi_password",
        "pm_type": "pxe_ipmitool",
        "pm_user": "root"
    }
  ]
}
