Setup steps, please reference doc here: https://docs.oracle.com/en-us/iaas/data-safe/doc/create-self-signed-certificate-db-system-client-authentication-enabled.html

#### Scenario 1: Client doesn't import Server certificate/CA amd Server doesn't import client certificate/CA.
(Regardless SSL_CLIENT_AUTHENTICATION=TRUE or FALSE)

Result: connection failed

Message: ORA-29024: Certificate validation failure

#### Scenario 2: Client import Server certificate/CA amd Server doesn't import client certificate/CA.
2.1 Testing with SSL_CLIENT_AUTHENTICATION = FALSE on server

Result: Success

2.2 Testing with SSL_CLIENT_AUTHENTICATION = TRUE on server

Result: Connection failed

Message: ORA-28860: Fatal SSL error

Message in Listener log: 
```
2021-08-02T04:50:44.966526+00:00
02-AUG-2021 04:50:44 * (ADDRESS=(PROTOCOL=tcps)(HOST=10.2.0.80)(PORT=9782)) * <unknown connect data> * 542
TNS-00542: SSL Handshake failed
 TNS-12560: TNS:protocol adapter error
```  

#### Scenario 3: Client import Server certificate/CA amd Server import client certificate/CA.
(Regardless SSL_CLIENT_AUTHENTICATION=TRUE or FALSE)

Result: OK

Take note that 2-way SSL verification only happens if both client and server setting are true.

#### Scenario 4: Built-on Scenario 3, Authenticate user using SSL Certification
```
[oracle@ip-10-2-0-80 ~]$ orapki wallet display -wallet "/u01/app/oracle/wallet" -pwd WalletPasswd123
Oracle PKI Tool Release 23.0.0.0.0 - Production
Version 23.0.0.0.0
Copyright (c) 2004, 2021, Oracle and/or its affiliates. All rights reserved.

Requested Certificates: 
User Certificates:
Subject:        CN=ip-10-2-0-80.ap-southeast-1.compute.internal
Trusted Certificates: 
Subject:        CN=ip-10-2-0-80.ap-southeast-1.compute.internal
Subject:        CN=ip-10-2-0-83.ap-southeast-1.compute.internal
```
##### take note: 1. ops$ and 2. identified externally. (globally is EUS user, not Certificate user)
##### for certification login, need SSL_CLIENT_AUTHENTICATION = TRUE on both client/server

```sql
SQL> CREATE USER ops$clientuser1 IDENTIFIED EXTERNALLY AS 'CN=ip-10-2-0-80.ap-southeast-1.compute.internal';
SQL> grant resource,connect to ops$clientuser1;

[oracle@ip-10-2-0-80 admin]$ sqlplus /@pdb1_ssl
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Aug 2 05:47:28 2021
Version 19.12.0.0.0
Copyright (c) 1982, 2021, Oracle.  All rights reserved.
Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.12.0.0.0
SQL> show user;
USER is "OPS$CLIENTUSER1"
  
SQL> select * from v$session_connect_info where sid=userenv('SID');
{
  "results" : [
    {
      "items" : [
        {
          "sid" : 269,
          "serial#" : 8299,
          "authentication_type" : "GLOBAL",
          "osuser" : "CN=ip-10-2-0-80.ap-southeast-1.compute.internal",
          "network_service_banner" : "",
          "client_charset" : "UTF8",
          "client_connection" : "Homogeneous",
          "client_oci_library" : "Home-based",
          "client_version" : "19.12.0.0.0",
          "client_driver" : "jdbcoci : 19.12.0.0.0",
          "client_lobattr" : "Client Temp Lob Rfc On",
          "client_regid" : 0,
          "con_id" : 3
        },
        {
          "sid" : 269,
          "serial#" : 8299,
          "authentication_type" : "GLOBAL",
          "osuser" : "CN=ip-10-2-0-80.ap-southeast-1.compute.internal",
          "network_service_banner" : "Authentication service for Linux: Version 19.0.1.0.0 - Production",
          "client_charset" : "UTF8",
          "client_connection" : "Homogeneous",
          "client_oci_library" : "Home-based",
          "client_version" : "19.12.0.0.0",
          "client_driver" : "jdbcoci : 19.12.0.0.0",
          "client_lobattr" : "Client Temp Lob Rfc On",
          "client_regid" : 0,
          "con_id" : 3
        },
        {
          "sid" : 269,
          "serial#" : 8299,
          "authentication_type" : "GLOBAL",
          "osuser" : "CN=ip-10-2-0-80.ap-southeast-1.compute.internal",
          "network_service_banner" : "Encryption service for Linux: Version 19.0.1.0.0 - Production",
          "client_charset" : "UTF8",
          "client_connection" : "Homogeneous",
          "client_oci_library" : "Home-based",
          "client_version" : "19.12.0.0.0",
          "client_driver" : "jdbcoci : 19.12.0.0.0",
          "client_lobattr" : "Client Temp Lob Rfc On",
          "client_regid" : 0,
          "con_id" : 3
        },
        {
          "sid" : 269,
          "serial#" : 8299,
          "authentication_type" : "GLOBAL",
          "osuser" : "CN=ip-10-2-0-80.ap-southeast-1.compute.internal",
          "network_service_banner" : "Crypto-checksumming service for Linux: Version 19.0.1.0.0 - Production",
          "client_charset" : "UTF8",
          "client_connection" : "Homogeneous",
          "client_oci_library" : "Home-based",
          "client_version" : "19.12.0.0.0",
          "client_driver" : "jdbcoci : 19.12.0.0.0",
          "client_lobattr" : "Client Temp Lob Rfc On",
          "client_regid" : 0,
          "con_id" : 3
        }
      ]
    }
  ]
}  
```  
  
  


