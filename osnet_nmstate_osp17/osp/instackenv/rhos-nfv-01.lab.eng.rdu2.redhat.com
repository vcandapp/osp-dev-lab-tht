{
   "nodes": [
     {
        "name": "compute-0",
        "pm_addr": "10.9.20.140",
        "mac": ["e4:43:4b:4d:d4:cb"],
        "arch": "x86_64",
        "pm_type": "pxe_ipmitool",
        "pm_user": "root",
        "pm_password": "calvin",
        "cpu": "1",
        "memory": "4096",
        "disk": "40"
     }]
}
