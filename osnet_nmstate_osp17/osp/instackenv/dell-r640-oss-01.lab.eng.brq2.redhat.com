
{
   "nodes": [
     {
        "name": "compute-0",
        "pm_addr": "10.37.146.173",
        "mac": ["e4:43:4b:5c:97:31"],
        "arch": "x86_64",
        "pm_type": "pxe_ipmitool",
        "pm_user": "root",
        "pm_password": "calvin",
        "cpu": "1",
        "memory": "4096",
        "disk": "40"
     },
     {
        "name": "compute-1",
        "pm_addr": "10.37.146.175",
        "mac": ["e4:43:4b:5c:84:11"],
        "arch": "x86_64",
         "pm_type": "pxe_ipmitool",
        "pm_user": "root",
        "pm_password": "calvin",
        "cpu": "1",
        "memory": "4096",
        "disk": "40"
     }]
}
