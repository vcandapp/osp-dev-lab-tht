{
   "nodes": [
     {  
        "name": "compute-0",
        "pm_addr": "10.37.146.191",
        "mac": ["e4:43:4b:5c:96:71"],
        "arch": "x86_64",
         "pm_type": "pxe_drac",
        "pm_user": "root",
        "pm_password": "calvin",
        "cpu": "1",
        "memory": "4096",
        "disk": "40"
     },
     {  
        "name": "compute-1",
        "pm_addr": "10.37.146.193",
        "mac": ["e4:43:4b:5c:97:c1"],
        "arch": "x86_64",
         "pm_type": "pxe_drac",
        "pm_user": "root",
        "pm_password": "calvin",
        "cpu": "1",
        "memory": "4096",
        "disk": "40"
     }]
}
