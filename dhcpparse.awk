#!/usr/bin/awk -f

BEGIN {
RS="}\r\n\r\n"
FS="\r\n"
OFS = FS
}

length($0) > 5 { total++
  counter[total] = total
  host=0
  ns=0
  for(i=1;i<=NF;i++) {
    if($i ~ /^subnet/) {
      type[total] = "subnet"
      split($i,arr," ")
      subnetip[total]=arr[2]
      subnetmask[total]=arr[4]
    }
    else if($i ~ /option routers/) {
       split($i,arr," ")
     routers[total] = arr[3]
     gsub(/;/,"",routers[total])
     }
     else if($i ~ /range/) {
      split($i,arr," ")
     rangestart[total]=arr[2]
     rangeend[total]=arr[3]
     gsub(/;/,"",rangeend[total])
    }
    else if($i ~ /domain-name-servers/) {
      split($i,arr," ")
      for(z=1;z<=length(arr);z++){
        if(arr[z] ~ /^[0-9]/){
          ns++
          nameservers[total][ns]=arr[z]
          gsub(/;/,"",nameservers[total][ns])
          gsub(/,/,"",nameservers[total][ns])
        }
      }
    }
    else if($i ~ /domain-name/) {
      split($i,arr," ")
      domain[total]=arr[3]
      gsub(/\"/, "", domain[total])
      gsub(/;/,"",domain[total])
    }
    else if($i ~ /^\s\sdefault-lease-time/) {
      split($i,arr," ")
      deflease[total]=arr[2]
      gsub(/;/, "", deflease[total])
    }
    else if($i ~ /^\s\smin-lease-time/) {
      split($i,arr," ")
      minlease[total]=arr[2]
      gsub(/;/, "", minlease[total])
    }
    else if($i ~ /^\s\smax-lease-time/) {
      split($i,arr," ")
      maxlease[total]=arr[2]
      gsub(/;/, "", maxlease[total])
    }
    else if($i ~ /^\s\shost/) {
      host++
      split($i,arr," ")
      hostname[total][host]=arr[2]
    }
    else if($i ~ /^\s\s\s\shost-identifier/) {
      split($i,arr," ")
      remote[total][host]=arr[4]
      gsub(/"/, "", remote[total][host])
      gsub(/;/,"",remote[total][host])
    }
    else if($i ~ /^\s\s\s\sfixed-address/) {
      split($i,arr," ")
      ip[total][host]=arr[2]
      gsub(/;/,"",ip[total][host])
    }
    else if($i ~ /hardware ethernet/) {
      split($i,arr, " ")
      mac[total][host]=arr[3]
      gsub(/;/,"",mac[total][host])
    }
  }
}
END {
  printf("---\ndhcp_subnets:\n")
  for(i=1;i<=length(counter);i++) {
    if(type[i] == "subnet") {
      printf("  %s:\n    netmask: %s\n    routers: %s\n    domain_name: %s\n    pools:\n      range_start: %s\n      range_end: %s\n    default_lease: %s\n    min_lease: %s\n\
    max_lease: %s\n",subnetip[i],subnetmask[i],routers[i],domain[i],rangestart[i],rangeend[i],deflease[i],minlease[i],maxlease[i])
      printf("    name_servers:\n")
      for(j=1;j<=length(nameservers[i]);j++) {
        printf("    - %s\n",nameservers[i][j])
      }
      printf("    dhcp_hosts:\n")
      for(j=1;j<=length(hostname[i]);j++) {
        printf("      %s:\n        remote_id: %s\n        fixed_address: %s\n",\
        hostname[i][j],remote[i][j],ip[i][j])
        #if(mac[i][j]) {
         # printf("    mac_address: %s\n",mac[i][j])
        #}
      }
    }
  }
}
