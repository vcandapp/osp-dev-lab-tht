{
   "nodes": [
    {
        "name": "compute-0",
        "pm_addr": "10.37.146.197",
        "mac": [
            "e4:43:4b:5c:96:81"],
        "arch": "x86_64",
        "pm_type": "pxe_ipmitool",
        "pm_user": "root",
        "pm_password": "calvin",
        "cpu": "1",
        "memory": "4096",
        "disk": "40"
    },
    {
        "arch": "x86_64",
        "cpu": "1",
        "disk": "40",
        "mac": [
            "e4:43:4b:4a:33:81"
        ],
        "memory": "4096",
        "name": "compute-1",
        "pm_addr": "10.37.146.199",
        "pm_password": "calvin",
        "pm_type": "pxe_ipmitool",
        "pm_user": "root"
    }
  ]
}
