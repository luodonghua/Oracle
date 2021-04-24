# Execute below as root user
cat << EOD > /etc/security/limits.d/oracle-database-preinstall-19c.conf

# oracle-database-preinstall-19c setting for nofile soft limit is 1024
oracle soft nofile 1024

# oracle-database-preinstall-19c setting for nofile hard limit is 65536
oracle hard nofile 65536

# oracle-database-preinstall-19c setting for nproc soft limit is 16384
# refer orabug15971421 for more info.
oracle soft nproc 16384

# oracle-database-preinstall-19c setting for nproc hard limit is 16384
oracle hard nproc 16384

# oracle-database-preinstall-19c setting for stack soft limit is 10240KB
oracle soft stack 10240

# oracle-database-preinstall-19c setting for stack hard limit is 32768KB
oracle hard stack 32768

# oracle-database-preinstall-19c setting for memlock hard limit is maximum of 128GB on x86_64 or 3GB on x86 OR 90 % of RAM
oracle hard memlock 134217728

# oracle-database-preinstall-19c setting for memlock soft limit is maximum of 128GB on x86_64 or 3GB on x86 OR 90% of RAM
oracle soft memlock 134217728

# oracle-database-preinstall-19c setting for data soft limit is 'unlimited'
oracle soft data unlimited

# oracle-database-preinstall-19c setting for data hard limit is 'unlimited'
oracle hard data unlimited

EOD
