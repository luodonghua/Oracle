**** Install Oracle software binary in silence mode

```sh
[oracle@ip-172-31-11-120 ~]$ unzip DB.19.11.GoldImage.zip -d /u01/db
```
```sh
# Fix permission issue if any 
[root@ip-172-31-11-120 ~]# /bin/chown -HRf oracle:oinstall /u01/db
```
```sh
cd /u01/db
./runInstaller  -silent -ignorePrereqFailure -waitforcompletion \
    oracle.install.option=INSTALL_DB_SWONLY \
    UNIX_GROUP_NAME=oinstall \
    INVENTORY_LOCATION=/u01/app/oraInventory \
    ORACLE_HOME=/u01/db \
    ORACLE_HOME_NAME='OraDB19Home1' \
    ORACLE_BASE=/u01/app/oracle \
    oracle.install.db.InstallEdition=EE \
    oracle.install.db.OSDBA_GROUP=dba \
    oracle.install.db.OSOPER_GROUP=oper \
    oracle.install.db.OSBACKUPDBA_GROUP=backupdba \
    oracle.install.db.OSDGDBA_GROUP=dgdba \
    oracle.install.db.OSKMDBA_GROUP=kmdba \
    oracle.install.db.OSRACDBA_GROUP=racdba \
    SECURITY_UPDATES_VIA_MYORACLESUPPORT=false \
    DECLINE_SECURITY_UPDATES=true
```
```sh
[root@ip-172-31-11-120 ~]# /u01/app/oraInventory/orainstRoot.sh.
[root@ip-172-31-11-120 ~]# /u01/db/root.sh
```

**** Create listener

```sh
export ORACLE_BASE=/u01/app/oracle; \
export ORACLE_HOME=/u01/db; \
/u01/db/bin/netca /orahome /u01/db /instype typical \
/inscomp client,oraclenet,javavm,server,ano /insprtcl tcp \
/cfg local /authadp NO_VALUE \
/responseFile /u01/db/network/install/netca_typ.rsp \
/lisport 1521 /silent /orahnam OraDB19Home1
```

**** Create Database Example 1:

```sh
export ORACLE_HOME=/u01/db; \
export ORACLE_BASE=/u01/app/oracle; \
/u01/db/bin/dbca -silent -createDatabase  \
-emConfiguration NONE  -templateName 'General_Purpose.dbc' \
-storageType FS -datafileDestination '/u01/app/oracle/oradata' \
-datafileJarLocation '/u01/db/assistants/dbca/templates' \
-sampleSchema true -oratabLocation /etc/oratab  \
-runCVUChecks false -continueOnNonFatalErrors true \
-createAsContainerDatabase true \
-numberOfPDBs 1 -pdbName pdb1 \
-gdbName 'orcl' -sid 'orcl' \
-initParams filesystemio_options=setall -ignorePrereqs    
```

**** Create Database Example 2:

```sh
$ORACLE_HOME/bin/dbca -silent -createDatabase \
-templateName General_Purpose.dbc \
-gdbname CDB21 -sid CDB21 -createAsContainerDatabase true \
-numberOfPDBs 1 -pdbName PDB21 -createUserTableSpace true \
-responseFile NO_VALUE -characterSet AL32UTF8 -totalMemory 1800 \
-sysPassword WElcome123## -systemPassword WElcome123## \
-pdbAdminPassword WElcome123## -dbsnmpPassword WElcome123## \
-enableArchive true \
-recoveryAreaDestination /u03/app/oracle/fast_recovery_area \
-recoveryAreaSize 15000 \
-datafileDestination /u02/app/oracle/oradata
```
