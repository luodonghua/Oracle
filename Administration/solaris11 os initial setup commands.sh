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
root@solaris11:~# df -h /ips
Filesystem             Size   Used  Available Capacity  Mounted on
rpool/ips               20G    31K        20G     1%    /ips

Tip - For better performance when updating the repository, set atime to off.

root@solaris11:~#  zfs set atime=off rpool/ips
root@solaris11:~# zfs get all rpool/ips
NAME       PROPERTY              VALUE                  SOURCE
rpool/ips  aclinherit            restricted             default
rpool/ips  aclmode               discard                default
rpool/ips  atime                 off                    local
rpool/ips  available             20.0G                  -
rpool/ips  canmount              on                     default
rpool/ips  casesensitivity       mixed                  -
rpool/ips  checksum              on                     default
rpool/ips  compression           off                    default
rpool/ips  compressratio         1.00x                  -
rpool/ips  copies                1                      default
rpool/ips  creation              Sun Dec  1 22:28 2019  -
rpool/ips  dedup                 off                    default
rpool/ips  defaultgroupquota     none                   -
rpool/ips  defaultreadlimit      none                   default
rpool/ips  defaultuserquota      none                   -
rpool/ips  defaultwritelimit     none                   default
rpool/ips  devices               on                     default
rpool/ips  effectivereadlimit    none                   local
rpool/ips  effectivewritelimit   none                   local
rpool/ips  encryption            off                    -
rpool/ips  exec                  on                     default
rpool/ips  keychangedate         -                      default
rpool/ips  keysource             none                   default
rpool/ips  keystatus             none                   -
rpool/ips  logbias               latency                default
rpool/ips  mlslabel              none                   -
rpool/ips  mounted               yes                    -
rpool/ips  mountpoint            /ips                   local
rpool/ips  multilevel            off                    -
rpool/ips  nbmand                off                    default
rpool/ips  normalization         none                   -
rpool/ips  primarycache          all                    default
rpool/ips  quota                 20G                    local
rpool/ips  readlimit             default                default
rpool/ips  readonly              off                    default
rpool/ips  recordsize            128K                   default
rpool/ips  referenced            31K                    -
rpool/ips  refquota              none                   default
rpool/ips  refreservation        none                   default
rpool/ips  rekeydate             -                      default
rpool/ips  reservation           none                   default
rpool/ips  rstchown              on                     default
rpool/ips  secondarycache        all                    default
rpool/ips  setuid                on                     default
rpool/ips  shadow                none                   -
rpool/ips  share.*               ...                    local
rpool/ips  snapdir               hidden                 default
rpool/ips  sync                  standard               default
rpool/ips  type                  filesystem             -
rpool/ips  used                  31K                    -
rpool/ips  usedbychildren        0                      -
rpool/ips  usedbydataset         31K                    -
rpool/ips  usedbyrefreservation  0                      -
rpool/ips  usedbysnapshots       0                      -
rpool/ips  utf8only              off                    -
rpool/ips  version               6                      -
rpool/ips  vscan                 off                    default
rpool/ips  writelimit            default                default
rpool/ips  xattr                 on                     default
rpool/ips  zoned                 off                    default



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


root@solaris11:~# ls -l /root/ips
-rw-r--r--   1 root     root         12K Dec  1 22:32 install-repo.ksh
-rw-r--r--   1 root     root        4.2K Dec  1 22:32 README-zipped-repo.txt
-rw-r--r--   1 root     root         495 Dec  1 22:32 sol-11_4-repo_digest.txt
-rw-r--r--   1 root     root        6.7K Dec  1 22:32 V979527-01.zip
-rw-r--r--   1 root     root        1.8G Dec  1 22:34 V979528-01_1of5.zip
-rw-r--r--   1 root     root        1.7G Dec  1 22:36 V979528-01_2of5.zip
-rw-r--r--   1 root     root        1.7G Dec  1 22:39 V979528-01_3of5.zip
-rw-r--r--   1 root     root        2.0G Dec  1 22:49 V979528-01_4of5.zip
-rw-r--r--   1 root     root        1.8G Dec  1 22:51 V979528-01_5of5.zip

oot@solaris11:~/ips# chmod +x ./install-repo.ksh 
root@solaris11:~/ips# ./install-repo.ksh 
USAGE:
install-repo.ksh -d dest [-s zipsrc] [-i image-name] [-c] [-v] [-I] [-y]

-d dest   = destination directory to hold repository
-s zipsrc = full path to directory holding zip files. default: current directory
-i image  = name of image: e.g. sol-11_2-repo. default: name found in directory
-c        = compare digests of downloaded zip files
-v        = verify repo after unzipping (minimum Solaris 11.1.7 required)
-I        = create an ISO image
-y        = add to existing repository without prompting for yes or no. Use
            with caution.

Destination directory will contain top-level ISO files including README.
Repository is directly under destination.
ISO image is created in current directory, or zipsrc directory from -s argument.

root@solaris11:~/ips# ./install-repo.ksh -d /ips -s /root/ips
Using V979528-01 files for sol-11_4-repo download.
Uncompressing V979528-01_1of5.zip...done.
Uncompressing V979528-01_2of5.zip...done.   
Uncompressing V979528-01_3of5.zip...done.
Uncompressing V979528-01_4of5.zip...done.
Uncompressing V979528-01_5of5.zip...done.
Repository can be found in /ips.

root@solaris11:/ips# df -h /ips
Filesystem             Size   Used  Available Capacity  Mounted on
rpool/ips               20G    10G      10.0G    51%    /ips

root@solaris11:/ips# zfs set quota=30g rpool/ips

root@solaris11:/ips# zfs list rpool/ips
NAME        USED  AVAIL  REFER  MOUNTPOINT
rpool/ips  10.0G  20.0G  10.0G  /ips

root@solaris11:/ips# df -h /ips
Filesystem             Size   Used  Available Capacity  Mounted on
rpool/ips               30G    10G        20G    34%    /ips

root@solaris11:~/ips# pkgrepo info -s /ips
Failed to set locale: unsupported locale setting.  Falling back to C.
pkgrepo: Unable to set locale; locale package may be broken or
not installed.  Reverting to C locale.
PUBLISHER PACKAGES STATUS           UPDATED
solaris   6431     online           2018-08-17T06:09:37.827853Z

root@solaris11:~/ips# export LC_ALL="en_US.UTF-8"
root@solaris11:~/ips# export LC_CTYPE="en_US.UTF-8"
root@solaris11:~/ips# pkgrepo info -s /ips
PUBLISHER PACKAGES STATUS           UPDATED
solaris   6431     online           2018-08-17T06:09:37.827853Z

root@solaris11:~/ips# cat ~/.bash_profile
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

root@solaris11:~/ips# pkg install oracle-database-preinstall-19c

pkg install: The following pattern(s) did not match any allowable packages.  Try
using a different matching pattern, or refreshing publisher information:

        oracle-database-preinstall-19c

# regularlly update local repo
pkgrecv -s http://pkg.oracle.com/solaris/release/ -d /ips '*'
pkgrepo -s /ips refresh

# alternative way to build local repo from internet repo
pkgrepo create /ips
pkgrecv -s http://pkg.oracle.com/solaris/release/ -d /ips '*'


root@solaris11:~/ips# pkgrepo get -p solaris -s http://pkg.oracle.com/solaris/release
PUBLISHER SECTION    PROPERTY         VALUE
solaris   publisher  alias            
solaris   publisher  prefix           solaris
solaris   repository collection-type  core
solaris   repository description      ""
solaris   repository legal-uris       ()
solaris   repository mirrors          ()
solaris   repository name             ""
solaris   repository origins          ()
solaris   repository refresh-seconds  ""
solaris   repository registration-uri ""
solaris   repository related-uris     ()
root@solaris11:~/ips# pkgrepo get -p solaris -s /ips
PUBLISHER SECTION    PROPERTY         VALUE
solaris   publisher  alias            
solaris   publisher  prefix           solaris
solaris   repository collection-type  core
solaris   repository description      ""
solaris   repository legal-uris       ()
solaris   repository mirrors          ()
solaris   repository name             ""
solaris   repository origins          ()
solaris   repository refresh-seconds  ""
solaris   repository registration-uri ""
solaris   repository related-uris     ()


root@solaris11:/var/log# pkg search -s http://pkg.oracle.com/solaris/release 18c
INDEX       ACTION VALUE                                        PACKAGE
pkg.summary set    Prerequisite package for Oracle Database 18c pkg:/group/prerequisite/oracle/oracle-rdbms-server-18c-preinstall@11.4-11.4.0.0.1.15.0

root@solaris11:/var/log# pkg search -s /ips prerequisite
INDEX       ACTION VALUE                                               PACKAGE
pkg.summary set    Prerequisite package for Oracle Database 12.1       pkg:/group/prerequisite/oracle/oracle-rdbms-server-12-1-preinstall@11.4-11.4.0.0.1.15.0
pkg.summary set    Prerequisite package for Oracle Database 18c        pkg:/group/prerequisite/oracle/oracle-rdbms-server-18c-preinstall@11.4-11.4.0.0.1.15.0
pkg.summary set    Prerequisite package for Oracle E-Business Suite 12 pkg:/group/prerequisite/oracle/oracle-ebs-server-R12-preinstall@11.4-11.4.0.0.1.15.0
root@solaris11:/var/log# 


root@solaris11:/var/log# uname -a
SunOS solaris11 5.11 11.4.0.15.0 i86pc i386 i86pc


root@solaris11:~# pkg publisher
PUBLISHER                   TYPE     STATUS P LOCATION
solaris                     origin   online F http://pkg.oracle.com/solaris/release/

root@solaris11:~# pkg unset-publisher solaris
Updating package cache                           1/1 

root@solaris11:~# pkg set-publisher -g /ips solaris

root@solaris11:~# pkg publisher

PUBLISHER                   TYPE     STATUS P LOCATION
solaris                     origin   online F file:///ips/

root@solaris11:~# pkg update
No updates available for this image.

#https://www.thegeekdiary.com/solaris-11-ips-hand-on-lab-creating-ips-repository/
# pkg set-publisher -G '*' -M '*' -g /sol_11_repo solaris
#-G '*' -> Removes all existing origins for the solaris publisher.
#-M '*' -> Removes all existing mirrors for the solaris publisher.
#-g  -> Adds the URI of the newly-created repository as the new origin for the solaris publisher.

root@solaris11:/var/log# pkg info entire
          Name: entire
       Summary: Incorporation to lock all system packages to the same build
   Description: This package constrains system package versions to the same
                build.  WARNING: Proper system update and correct package
                selection depend on the presence of this incorporation.
                Removing this package will result in an unsupported system.
      Category: Meta Packages/Incorporations
         State: Installed
     Publisher: solaris
       Version: 11.4 (Oracle Solaris 11.4.0.0.1.15.0)
        Branch: 11.4.0.0.1.15.0
Packaging Date: August 17, 2018 at 12:42:03 AM
          Size: 2.53 kB
          FMRI: pkg://solaris/entire@11.4-11.4.0.0.1.15.0:20180817T004203Z
root@solaris11:/var/log# 


root@solaris11:/var/log# pkg install -g /ips pkg:/group/prerequisite/oracle/oracle-rdbms-server-18c-preinstall 
           Packages to install: 24
            Services to change:  4
       Create boot environment: No
Create backup boot environment: No

DOWNLOAD                                PKGS         FILES    XFER (MB)   SPEED
Completed                              24/24       486/486  103.9/103.9  9.3M/s

PHASE                                          ITEMS
Installing new actions                     1211/1211
Updating package state database                 Done 
Updating package cache                           0/0 
Updating image state                            Done 
Creating fast lookup database                   Done 
Updating package cache                           1/1 
root@solaris11:/var/log# 
root@solaris11:/var/log# 

root@solaris11:/var/log# groupadd -g 500 oinstall
root@solaris11:/var/log# groupadd -g 501 dba
root@solaris11:/var/log# useradd -u 500 -g oinstall -G dba -m -d /export/home/oracle oracle
80 blocks
root@solaris11:/var/log# passwd oracle
New Password: 
Re-enter new Password: 
passwd: password successfully changed for oracle
root@solaris11:/var/log# mkdir -p /u01/app/oracle /u01/db /u02/oradata /u03/fra
root@solaris11:/var/log# chown -R oracle:oinstall /u01
root@solaris11:/var/log# chown -R oracle:dba /u02 /u03

ot@solaris11:~# 
root@solaris11:~# prctl -n project.max-shm-memory -i project default
project: 3: default
NAME    PRIVILEGE       VALUE    FLAG   ACTION                       RECIPIENT
project.max-shm-memory
        usage               0B   
        privileged      2.42GB      -   deny                                 -
        system          16.0EB    max   deny                                 -

root@solaris11:~# prctl -n project.max-sem-ids -i project default
project: 3: default
NAME    PRIVILEGE       VALUE    FLAG   ACTION                       RECIPIENT
project.max-sem-ids
        privileged        128       -   deny                                 -
        system          16.8M     max   deny                                 -

root@solaris11:~# prctl -n project.max-shm-memory -v 6gb -r -i project default
root@solaris11:~# prctl -n project.max-shm-memory -i project default
project: 3: default
NAME    PRIVILEGE       VALUE    FLAG   ACTION                       RECIPIENT
project.max-shm-memory
        usage               0B   
        privileged      6.00GB      -   deny                                 -
        system          16.0EB    max   deny        


# create Oracle project
root@solaris11:~# projadd -G dba -K "project.max-shm-memory=(privileged,9G,deny)" group.dba
root@solaris11:~# projmod -sK "project.max-sem-ids=(privileged,256,deny)" group.dba

# Not necessary to add oracle user into this group, just to take note project file change only effective after reboot
root@solaris11:~# projmod -U oracle group.dba 
root@solaris11:~# cat /etc/project 
system:0::::
user.root:1::::
noproject:2::::
default:3::::
group.staff:10::::
group.dba:101::oracle:dba:project.max-sem-ids=(privileged,256,deny);project.max-shm-memory=(privileged,9663676416,deny)

# UDP and TCP Kernel Parameters
root@solaris11:~# ipadm show-prop -p smallest_anon_port,largest_anon_port tcp
PROTO PROPERTY              PERM CURRENT      PERSISTENT   DEFAULT      POSSIBLE
tcp   smallest-anon-port    rw   32768        --           32768        1024-65535
tcp   largest-anon-port     rw   65535        --           65535        32768-65535
root@solaris11:~# ipadm set-prop -p smallest_anon_port=9000 tcp
root@solaris11:~# ipadm set-prop -p largest_anon_port=65500 tcp
root@solaris11:~# ipadm set-prop -p smallest_anon_port=9000 udp
root@solaris11:~# ipadm set-prop -p largest_anon_port=65500 udp
root@solaris11:~# ipadm show-prop -p smallest_anon_port,largest_anon_port tcp
PROTO PROPERTY              PERM CURRENT      PERSISTENT   DEFAULT      POSSIBLE
tcp   smallest-anon-port    rw   9000         9000         32768        1024-65500
tcp   largest-anon-port     rw   65500        65500        65535        9000-65535

# Default soft limit & hard limit for shell
root@solaris11:~# ulimit -aS
core file size          (blocks, -c) unlimited
data seg size           (kbytes, -d) unlimited
file size               (blocks, -f) unlimited
open files                      (-n) 256
pipe size            (512 bytes, -p) 10
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 29995
virtual memory          (kbytes, -v) unlimited

root@solaris11:~# ulimit -aH
core file size          (blocks, -c) unlimited
data seg size           (kbytes, -d) unlimited
file size               (blocks, -f) unlimited
open files                      (-n) 65536
pipe size            (512 bytes, -p) 10
stack size              (kbytes, -s) unlimited
cpu time               (seconds, -t) unlimited
max user processes              (-u) 29995
virtual memory          (kbytes, -v) unlimited

# Size of the stack segment of the process, soft (at most 10240), hard (at most 32768)
root@solaris11:~# ulimit -S -s 10240

# Open file descriptors, soft (at least 1024), hard (at least 65536)
root@solaris11:~# ulimit -S -n 1024

# Maximum user processes, soft (at least 2047), hard (at least 16384)
# exist value larger than this.


# Bash Profile for "oracle" user 
# File: /export/home/oracle/.bash_profile 
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

ORACLE_SID=orcl
ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=/u01/db
LD_LIBRARY_PATH=$ORACLE_HOME/lib
PATH=/usr/bin:/usr/local/bin:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch
export ORACLE_SID ORACLE_BASE ORACLE_HOME LD_LIBRARY_PATH PATH

export PS1=$'[(${ORACLE_SID:-"no sid"})\u@\h \W]$ '

alias tailorcl='adrci exec="set home orcl/orcl;show alert -tail -f"'