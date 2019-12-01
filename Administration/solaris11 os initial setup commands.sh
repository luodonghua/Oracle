root@solaris11:~# ipadm
NAME              CLASS/TYPE STATE        UNDER      ADDR
lo0               loopback   ok           --         --
   lo0/v4         static     ok           --         127.0.0.1/8
   lo0/v6         static     ok           --         ::1/128
net0              ip         ok           --         --
   net0/v4        dhcp       ok           --         192.168.31.37/24
   net0/v6        addrconf   ok           --         fe80::a00:27ff:fe09:ef82/10

   root@solaris11:~# dladm show-phys
LINK            MEDIA         STATE      SPEED  DUPLEX    DEVICE
net0            Ethernet      up         1000   full      e1000g0
net1            Ethernet      unknown    0      unknown   e1000g1

root@solaris11:~# ipadm create-ip net1

root@solaris11:~# ipadm
NAME              CLASS/TYPE STATE        UNDER      ADDR
lo0               loopback   ok           --         --
   lo0/v4         static     ok           --         127.0.0.1/8
   lo0/v6         static     ok           --         ::1/128
net0              ip         ok           --         --
   net0/v4        dhcp       ok           --         192.168.31.37/24
   net0/v6        addrconf   ok           --         fe80::a00:27ff:fe09:ef82/10
net1              ip         down         --         --
root@solaris11:~#  ipadm create-addr -T dhcp net1
net1/v4
root@solaris11:~# ipadm
NAME              CLASS/TYPE STATE        UNDER      ADDR
lo0               loopback   ok           --         --
   lo0/v4         static     ok           --         127.0.0.1/8
   lo0/v6         static     ok           --         ::1/128
net0              ip         ok           --         --
   net0/v4        dhcp       ok           --         192.168.31.37/24
   net0/v6        addrconf   ok           --         fe80::a00:27ff:fe09:ef82/10
net1              ip         ok           --         --
   net1/v4        dhcp       ok           --         192.168.56.106/24

root@solaris11:~# dladm show-phys
LINK            MEDIA         STATE      SPEED  DUPLEX    DEVICE
net0            Ethernet      up         1000   full      e1000g0
net1            Ethernet      up         1000   full      e1000g1


root@solaris11:~# svccfg -s dns/client setprop config/nameserver=net_address: 192.168.31.1
root@solaris11:~#  svccfg -s dns/client setprop config/domain = astring: "dbaglobe.com"
root@solaris11:~# svccfg -s name-service/switch setprop config/host = astring: "files dns"
root@solaris11:~# svcadm refresh name-service/switch
root@solaris11:~# svcadm refresh dns/client


root@solaris11:~# svccfg
svc:> select /network/dns/client
svc:/network/dns/client> listprop
config                                                         application        
config/domain                                                  astring     dbaglobe.com
config/nameserver                                              net_address 192.168.31.1
config/value_authorization                                     astring     solaris.smf.value.name-service.dns.client
dependents                                                     framework          
dependents/network-dns-client_self-assembly-complete           fmri        svc:/milestone/self-assembly-complete
filesystem                                                     dependency         
filesystem/entities                                            fmri        svc:/system/filesystem/minimal
filesystem/grouping                                            astring     require_all
filesystem/restart_on                                          astring     none
filesystem/type                                                astring     service
general                                                        framework          
general/action_authorization                                   astring     solaris.smf.manage.name-service.dns.client
general/entity_stability                                       astring     Unstable
general/single_instance                                        boolean     true
general/value_authorization                                    astring     solaris.smf.manage.name-service.dns.client
loopback                                                       dependency         
loopback/entities                                              fmri        svc:/network/loopback
loopback/grouping                                              astring     require_any
loopback/restart_on                                            astring     error
loopback/type                                                  astring     service
manifestfiles                                                  framework          
manifestfiles/lib_svc_manifest_milestone_config_xml            astring     /lib/svc/manifest/milestone/config.xml
manifestfiles/lib_svc_manifest_network_dns_client_xml          astring     /lib/svc/manifest/network/dns/client.xml
manifestfiles/lib_svc_manifest_system_name-service_upgrade_xml astring     /lib/svc/manifest/system/name-service/upgrade.xml
milestoneconfig_network_dns_client                             dependency         
milestoneconfig_network_dns_client/entities                    fmri        svc:/milestone/config
milestoneconfig_network_dns_client/external                    boolean     true
milestoneconfig_network_dns_client/grouping                    astring     optional_all
milestoneconfig_network_dns_client/restart_on                  astring     none
milestoneconfig_network_dns_client/type                        astring     service
name-service-upgrade_network-dns-client                        dependency         
name-service-upgrade_network-dns-client/entities               fmri        svc:/system/name-service/upgrade:default
name-service-upgrade_network-dns-client/external               boolean     true
name-service-upgrade_network-dns-client/grouping               astring     optional_all
name-service-upgrade_network-dns-client/restart_on             astring     none
name-service-upgrade_network-dns-client/type                   astring     service
network                                                        dependency         
network/entities                                               fmri        svc:/milestone/network
network/grouping                                               astring     optional_all
network/restart_on                                             astring     error
network/type                                                   astring     service
refresh                                                        method             
refresh/exec                                                   astring     "/lib/svc/method/dns-client %m"
refresh/timeout_seconds                                        count       90
refresh/type                                                   astring     method
start                                                          method             
start/exec                                                     astring     "/lib/svc/method/dns-client %m"
start/timeout_seconds                                          count       90
start/type                                                     astring     method
startd                                                         framework          
startd/duration                                                astring     transient
stop                                                           method             
stop/exec                                                      astring     "/lib/svc/method/dns-client %m"
stop/timeout_seconds                                           count       90
stop/type                                                      astring     method
sysconfig                                                      sysconfig          
sysconfig/config_properties                                    astring     "sc_dns_nameserver:config/nameserver" "sc_dns_search:config/search"
sysconfig/group                                                astring     naming_services
tm_common_name                                                 template           
tm_common_name/C                                               ustring     "DNS resolver"
tm_man_resolv_conf5                                            template           
tm_man_resolv_conf5/manpath                                    astring     /usr/share/man
tm_man_resolv_conf5/section                                    astring     5
tm_man_resolv_conf5/title                                      astring     resolv.conf
tm_man_resolver3RESOLV                                         template           
tm_man_resolver3RESOLV/manpath                                 astring     /usr/share/man
tm_man_resolver3RESOLV/section                                 astring     3RESOLV
tm_man_resolver3RESOLV/title                                   astring     resolver
tm_pgpatnt_config                                              template_pg_pattern        
tm_pgpatnt_config/description_C                                ustring     "DNS configuration data used to configure DNS client."
tm_pgpatnt_config/name                                         astring     config
tm_pgpatnt_config/required                                     boolean     false
tm_pgpatnt_config/target                                       astring     this
tm_pgpatnt_config/type                                         astring     application
tm_proppat_nt_config_domain                                    template_prop_pattern        
tm_proppat_nt_config_domain/cardinality_max                    count       1
tm_proppat_nt_config_domain/cardinality_min                    count       1
tm_proppat_nt_config_domain/description_C                      ustring     "The DNS domain name to be used for unqualified hostname queries."
tm_proppat_nt_config_domain/name                               astring     domain
tm_proppat_nt_config_domain/pg_pattern                         astring     tm_pgpatnt_config
tm_proppat_nt_config_domain/required                           boolean     false
tm_proppat_nt_config_domain/type                               astring     astring
tm_proppat_nt_config_nameserver                                template_prop_pattern        
tm_proppat_nt_config_nameserver/cardinality_max                count       3
tm_proppat_nt_config_nameserver/cardinality_min                count       1
tm_proppat_nt_config_nameserver/description_C                  ustring     "The IP address of a DNS nameserver to be used by the resolver."
tm_proppat_nt_config_nameserver/name                           astring     nameserver
tm_proppat_nt_config_nameserver/pg_pattern                     astring     tm_pgpatnt_config
tm_proppat_nt_config_nameserver/required                       boolean     false
tm_proppat_nt_config_nameserver/type                           astring     net_address
tm_proppat_nt_config_options                                   template_prop_pattern        
tm_proppat_nt_config_options/cardinality_max                   count       1
tm_proppat_nt_config_options/cardinality_min                   count       1
tm_proppat_nt_config_options/description_C                     ustring     "The list of resolver configuration option keywords."
tm_proppat_nt_config_options/name                              astring     options
tm_proppat_nt_config_options/pg_pattern                        astring     tm_pgpatnt_config
tm_proppat_nt_config_options/required                          boolean     false
tm_proppat_nt_config_options/type                              astring     astring
tm_proppat_nt_config_search                                    template_prop_pattern        
tm_proppat_nt_config_search/cardinality_max                    count       6
tm_proppat_nt_config_search/cardinality_min                    count       1
tm_proppat_nt_config_search/description_C                      ustring     "The list of DNS domain names to be used for unqualified hostname queries."
tm_proppat_nt_config_search/name                               astring     search
tm_proppat_nt_config_search/pg_pattern                         astring     tm_pgpatnt_config
tm_proppat_nt_config_search/required                           boolean     false
tm_proppat_nt_config_search/type                               astring     astring
tm_proppat_nt_config_sortlist                                  template_prop_pattern        
tm_proppat_nt_config_sortlist/cardinality_max                  count       10
tm_proppat_nt_config_sortlist/cardinality_min                  count       1
tm_proppat_nt_config_sortlist/description_C                    ustring     "The sort order for hostname queries filtered by IP address."
tm_proppat_nt_config_sortlist/name                             astring     sortlist
tm_proppat_nt_config_sortlist/pg_pattern                       astring     tm_pgpatnt_config
tm_proppat_nt_config_sortlist/required                         boolean     false
tm_proppat_nt_config_sortlist/type                             astring     net_address
unconfigure                                                    method             
unconfigure/exec                                               astring     "/lib/svc/method/dns-client unconfigure"
unconfigure/timeout_seconds                                    count       90
unconfigure/type                                               astring     method
svc:/network/dns/client> 


root@solaris11:~# svcs -xv dns/client:default
svc:/network/dns/client:default (DNS resolver)
 State: online since Sun Dec  1 22:09:02 2019
   See: man -M /usr/share/man -s 5 resolv.conf
   See: man -M /usr/share/man -s 3RESOLV resolver
   See: /var/svc/log/network-dns-client:default.log
Impact: None.


root@solaris11:~# more /var/svc/log/network-dns-client:default.log
[ 2019 Nov 28 11:07:08 Rereading configuration. ]
[ 2019 Nov 28 11:07:08 Enabled. ]
[ 2019 Nov 28 11:07:08 Executing start method ("/lib/svc/method/dns-client start"). ]
[ 2019 Nov 28 11:07:08 Method "start" exited with status 0. ]
[ 2019 Nov 28 11:17:49 Disabled. ]
[ 2019 Dec  1 21:36:48 Disabled. ]
[ 2019 Dec  1 22:01:19 Rereading configuration. ]
[ 2019 Dec  1 22:02:27 Rereading configuration. ]
[ 2019 Dec  1 22:02:39 Rereading configuration. ]
[ 2019 Dec  1 22:02:43 Rereading configuration. ]
[ 2019 Dec  1 22:03:39 Rereading configuration. ]
[ 2019 Dec  1 22:03:54 Rereading configuration. ]
[ 2019 Dec  1 22:09:02 Enabled. ]
[ 2019 Dec  1 22:09:02 Executing start method ("/lib/svc/method/dns-client start"). ]
[ 2019 Dec  1 22:09:02 Method "start" exited with status 0. ]


root@solaris11:~#  svcprop -p config/nameserver dns/client
192.168.31.1
root@solaris11:~# svcprop -p config/search dns/client
svcprop: Couldn t find property group `config/search' for instance `svc:/network/dns/client:default'.
root@solaris11:~# svcprop -p config dns/client
config/domain astring dbaglobe.com
config/nameserver net_address 192.168.31.1
config/value_authorization astring solaris.smf.value.name-service.dns.client
root@solaris11:~# svcadm enable network/dns/client
root@solaris11:~# svcs -xv dns/client:default
svc:/network/dns/client:default (DNS resolver)
 State: online since Sun Dec  1 22:09:02 2019
   See: man -M /usr/share/man -s 5 resolv.conf
   See: man -M /usr/share/man -s 3RESOLV resolver
   See: /var/svc/log/network-dns-client:default.log
Impact: None.
root@solaris11:~# nslookup
> yahoo.com
Server:         192.168.31.1
Address:        192.168.31.1#53

Non-authoritative answer:
Name:   yahoo.com
Address: 98.138.219.231
Name:   yahoo.com
Address: 98.138.219.232
Name:   yahoo.com
Address: 98.137.246.8
Name:   yahoo.com
Address: 72.30.35.9
Name:   yahoo.com
Address: 72.30.35.10
Name:   yahoo.com
Address: 98.137.246.7
> exit

root@solaris11:~# zpool status
  pool: rpool
 state: ONLINE
  scan: none requested
config:

        NAME      STATE      READ WRITE CKSUM
        rpool     ONLINE        0     0     0
          c1t0d0  ONLINE        0     0     0

errors: No known data errors
root@solaris11:~# zpool list
NAME   SIZE  ALLOC  FREE  CAP  DEDUP  HEALTH  ALTROOT
rpool  200G  10.0G  190G   5%  1.00x  ONLINE  -
root@solaris11:~# 

root@solaris11:~# zfs create -o mountpoint=/ips -o quota=20g rpool/ips
cannot create 'rpool/ips': dataset already exists
root@solaris11:~# df -h /ips
Filesystem             Size   Used  Available Capacity  Mounted on
rpool/ips               20G    31K        20G     1%    /ips
root@solaris11:~# 

root@solaris11:~# zfs create -o mountpoint=/u01 -o quota=20g rpool/u01
root@solaris11:~# zfs create -o mountpoint=/u02 -o quota=20g rpool/u02
root@solaris11:~# zfs create -o mountpoint=/u02 -o quota=30g rpool/u03
root@solaris11:~# zfs create -o mountpoint=/u03 -o quota=30g rpool/u03


root@solaris11:~# zfs list
NAME                               USED  AVAIL  REFER  MOUNTPOINT
rpool                             10.0G   187G  4.32M  /rpool
rpool/ROOT                        3.01G   187G    31K  none
rpool/ROOT/solaris                3.01G   187G  2.64G  /
rpool/ROOT/solaris/var             316M   187G   315M  /var
rpool/VARSHARE                    31.9M   187G  2.75M  /var/share
rpool/VARSHARE/kvol               27.7M   187G    31K  /var/share/kvol
rpool/VARSHARE/kvol/dump_summary  1.22M   187G  1.02M  -
rpool/VARSHARE/kvol/ereports      10.2M   187G  10.0M  -
rpool/VARSHARE/kvol/kernel_log    16.2M   187G  16.0M  -
rpool/VARSHARE/pkg                  63K   187G    32K  /var/share/pkg
rpool/VARSHARE/pkg/repositories     31K   187G    31K  /var/share/pkg/repositories
rpool/VARSHARE/sstore             1.29M   187G  1.29M  /var/share/sstore/repo
rpool/VARSHARE/tmp                  31K   187G    31K  /var/tmp
rpool/VARSHARE/zones                31K   187G    31K  /system/zones
rpool/dump                        5.00G   187G  5.00G  -
rpool/export                        63K   187G    32K  /export
rpool/export/home                   31K   187G    31K  /export/home
rpool/ips                           31K  20.0G    31K  /ips
rpool/swap                        2.00G   187G  2.00G  -
rpool/u01                           31K  20.0G    31K  /u01
rpool/u02                           31K  20.0G    31K  /u02
rpool/u03                           31K  30.0G    31K  /u03


root@solaris11:~# zfs list rpool/swap
NAME         USED  AVAIL  REFER  MOUNTPOINT
rpool/swap  2.00G   185G  2.00G  -
root@solaris11:~# zfs volsize=8g rpool/swap
root@solaris11:~# zfs list rpool/swap
NAME         USED  AVAIL  REFER  MOUNTPOINT
rpool/swap  8.00G   178G  8.00G  -

root@solaris11:~# swap -lh
swapfile                 dev            swaplo      blocks        free
/dev/zvol/dsk/rpool/swap 231,1              4K        2.0G        2.0G 
/dev/zvol/dsk/rpool/swap 231,1            2.0G        6.0G        6.0G 


