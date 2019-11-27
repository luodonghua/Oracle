SQL> select rowid from t;

ROWID             
------------------
AAASO6AAMAAAAw2AAA

set serveroutput on
declare
    rowid_in           ROWID;
    rowid_type       NUMBER;
    object_number    NUMBER;
    relative_fno     NUMBER;
    block_number     NUMBER;
    row_number       NUMBER;
begin
    rowid_in := 'AAASO6AAMAAAAw2AAA';
    DBMS_ROWID.ROWID_INFO (
        rowid_in,
        rowid_type,
        object_number,
        relative_fno,
        block_number,
        row_number);
    dbms_output.put_line('rowid_type: '||rowid_type);
    dbms_output.put_line('object_number: '||object_number);
    dbms_output.put_line('relative_fno: '||relative_fno);
    dbms_output.put_line('block_number: '||block_number);
    dbms_output.put_line('row_number: '||row_number);
end;
/

SQL> 
SQL> set serveroutput on
SQL> 
SQL> declare
  2      rowid_in           ROWID;
  3      rowid_type       NUMBER;
  4      object_number    NUMBER;
  5      relative_fno     NUMBER;
  6      block_number     NUMBER;
  7      row_number       NUMBER;
  8  begin
  9      rowid_in := 'AAASO6AAMAAAAw2AAA';
 10      DBMS_ROWID.ROWID_INFO (
 11          rowid_in,
 12          rowid_type,
 13          object_number,
 14          relative_fno,
 15          block_number,
 16          row_number);
 17      dbms_output.put_line('rowid_type: '||rowid_type);
 18      dbms_output.put_line('object_number: '||object_number);
 19      dbms_output.put_line('relative_fno: '||relative_fno);
 20      dbms_output.put_line('block_number: '||block_number);
 21      dbms_output.put_line('row_number: '||row_number);
 22  end;
 23  /
rowid_type: 1
object_number: 74682
relative_fno: 12
block_number: 3126
row_number: 0


PL/SQL procedure successfully completed.

SQL> alter system dump datafile 12 block 3126;
System altered.

SQL> select value from v$diag_info where name='Default Trace File';

VALUE                                                                           
--------------------------------------------------------------------------------
/u01/app/oracle/diag/rdbms/orcl/orcl/trace/orcl_ora_13749.trc   



[(orcl)oracle@oracle19c ~]$ cat /u01/app/oracle/diag/rdbms/orcl/orcl/trace/orcl_ora_13749.trc   
Trace file /u01/app/oracle/diag/rdbms/orcl/orcl/trace/orcl_ora_13749.trc
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.5.0.0.0
Build label:    RDBMS_19.3.0.0.0DBRU_LINUX.X64_190417
ORACLE_HOME:    /u01/db
System name:	Linux
Node name:	oracle19c
Release:	3.10.0-1062.4.3.el7.x86_64
Version:	#1 SMP Wed Nov 13 23:58:53 UTC 2019
Machine:	x86_64
Instance name: orcl
Redo thread mounted by this instance: 1
Oracle process number: 43
Unix process pid: 13749, image: oracle@oracle19c


*** 2019-11-27T11:37:19.250802+08:00 (ORCLPDB(3))
*** SESSION ID:(194.8228) 2019-11-27T11:37:19.250859+08:00
*** CLIENT ID:() 2019-11-27T11:37:19.250871+08:00
*** SERVICE NAME:(orclpdb) 2019-11-27T11:37:19.250880+08:00
*** MODULE NAME:(java@oracle19c (TNS V1-V3)) 2019-11-27T11:37:19.250889+08:00
*** ACTION NAME:() 2019-11-27T11:37:19.250898+08:00
*** CLIENT DRIVER:(jdbcoci : 19.3.0.0.0) 2019-11-27T11:37:19.250906+08:00
*** CONTAINER ID:(3) 2019-11-27T11:37:19.250915+08:00
 
Start dump data blocks tsn: 5 file#:12 minblk 3126 maxblk 3126
Block dump from cache:
Dump of buffer cache at level 3 for pdb=3 tsn=5 rdba=50334774
BH (0xcef4e888) file#: 12 rdba: 0x03000c36 (12/3126) class: 1 ba: 0xce00e000
  set: 7 pool: 3 bsz: 8192 bsi: 0 sflg: 2 pwc: 0,28
  dbwrid: 0 obj: 74682 objn: 74682 tsn: [3/5] afn: 12 hint: f
  hash: [0xcef89ba0,0xaee10498] lru: [0xcdf8a448,0xcef4ec40]
  ckptq: [NULL] fileq: [NULL]
  objq: [0xcdf8a470,0x950429d0] objaq: [0xcdf8a480,0x950429c0]
  st: XCURRENT md: NULL fpin: 'ktspbwh2: ktspfmdb' fscn: 0x80e5e1 tch: 13
  flags: block_written_once
  LRBA: [0x0.0.0] LSCN: [0x0] HSCN: [0x80e5e1] HSUB: [1]
  Printing buffer operation history (latest change first):
  cnt: 8
  01. sid:04 L192:kcbbic2:bic:FBD     02. sid:04 L191:kcbbic2:bic:FBW   
  03. sid:04 L602:bic1_int:bis:FWC    04. sid:04 L822:bic1_int:ent:rtn  
  05. sid:04 L832:oswmqbg1:clr:WRT    06. sid:04 L930:kubc:sw:mq        
  07. sid:04 L913:bxsv:sw:objq        08. sid:04 L608:bxsv:bis:FBW      
  09. sid:04 L607:bxsv:bis:FFW        10. sid:02 L464:chg1_mn:bic:FMS   
  11. sid:02 L778:chg1_mn:bis:FMS     12. sid:02 L353:gcur:set:MEXCL    
  13. sid:02 L464:chg1_mn:bic:FMS     14. sid:02 L614:chg1_mn:bis:FBD   
  15. sid:02 L922:klbc:sw:cq          16. sid:02 L778:chg1_mn:bis:FMS   
  buffer tsn: 5 rdba: 0x03000c36 (12/3126)
  scn: 0x80e5e2 seq: 0x01 flg: 0x06 tail: 0xe5e20601
  frmt: 0x02 chkval: 0xb7e6 type: 0x06=trans data
Hex dump of block: st=0, typ_found=1
Dump of memory from 0x00000000CE00E000 to 0x00000000CE010000
0CE00E000 0000A206 03000C36 0080E5E2 06010000  [....6...........]
0CE00E010 0000B7E6 00000001 000123BA 0080E5E1  [.........#......]
0CE00E020 00008000 00320002 03000C30 000E0001  [......2.0.......]
0CE00E030 00000D34 024027EA 0010012D 00002001  [4....'@.-.... ..]
0CE00E040 0080E5E2 00000000 00000000 00000000  [................]
0CE00E050 00000000 00000000 00000000 00000000  [................]
0CE00E060 00000000 00010100 0014FFFF 1F571F6B  [............k.W.]
0CE00E070 00001F57 1F6B0001 00000000 00000000  [W.....k.........]
0CE00E080 00000000 00000000 00000000 00000000  [................]
0CE00E090 03000C31 0000000E 00000000 00000000  [1...............]
0CE00E0A0 00000000 00000000 00000000 00000000  [................]
0CE00E0B0 00000000 00000000 00000000 000002A0  [................]
0CE00E0C0 000123AE 004DBA25 00000000 03000F80  [.#..%.M.........]
0CE00E0D0 00000040 00000000 00000000 00000000  [@...............]
0CE00E0E0 00000000 00000000 00000000 00000000  [................]
        Repeat 9 times
0CE00E180 00000000 00000000 00000000 11111111  [................]
0CE00E190 11111111 11111111 11111111 11111111  [................]
0CE00E1A0 11111111 11111111 11111111 00000000  [................]
0CE00E1B0 00000000 00000000 00000000 00000000  [................]
        Repeat 29 times
0CE00E390 00000000 0080BBF2 00000000 00000000  [................]
0CE00E3A0 00000000 00000000 00000000 00000000  [................]
        Repeat 63 times
0CE00E7A0 00000000 00000000 00000000 41414141  [............AAAA]
0CE00E7B0 41414141 41414141 41414141 41414141  [AAAAAAAAAAAAAAAA]
        Repeat 2 times
0CE00E7E0 41414141 41414141 41414141 00000000  [AAAAAAAAAAAA....]
0CE00E7F0 00000000 00000000 00000000 00000000  [................]
        Repeat 380 times
0CE00FFC0 00000000 00000000 00000000 2C000000  [...............,]
0CE00FFD0 610A0601 20202020 20202020 20610A20  [...a         .a ]
0CE00FFE0 20202020 20202020 2020610A 20202020  [        .a      ]
0CE00FFF0 01202020 20610261 20206103 E5E20601  [   .a.a .a  ....]
Block header dump:  0x03000c36
 Object id on Block? Y
 seg/obj: 0x123ba  csc:  0x000000000080e5e1  itc: 2  flg: E  typ: 1 - DATA
     brn: 0  bdba: 0x3000c30 ver: 0x01 opc: 0
     inc: 0  exflg: 0
 
 Itl           Xid                  Uba         Flag  Lck        Scn/Fsc
0x01   0x0001.00e.00000d34  0x024027ea.012d.10  --U-    1  fsc 0x0000.0080e5e2
0x02   0x0000.000.00000000  0x00000000.0000.00  ----    0  fsc 0x0000.00000000
bdba: 0x03000c36
data_block_dump,data header at 0xce00e064
===============
tsiz: 0x1f98
hsiz: 0x14
pbl: 0xce00e064
     76543210
flag=--------
ntab=1
nrow=1
frre=-1
fsbo=0x14
fseo=0x1f6b
avsp=0x1f57
tosp=0x1f57
0xe:pti[0]	nrow=1	offs=0
0x12:pri[0]	offs=0x1f6b
block_row_dump:
tab 0, row 0, @0x1f6b
tl: 45 fb: --H-FL-- lb: 0x1  cc: 6
col  0: [10]  61 20 20 20 20 20 20 20 20 20
col  1: [10]  61 20 20 20 20 20 20 20 20 20
col  2: [10]  61 20 20 20 20 20 20 20 20 20
col  3: [ 1]  61
col  4: [ 2]  61 20
col  5: [ 3]  61 20 20
end_of_block_dump
BH (0xcef89af0) file#: 12 rdba: 0x03000c36 (12/3126) class: 1 ba: 0xce550000
  set: 8 pool: 3 bsz: 8192 bsi: 0 sflg: 2 pwc: 0,28
  dbwrid: 0 obj: 74670 objn: 74670 tsn: [3/5] afn: 12 hint: f
  hash: [0xaee10498,0xcef4e938] lru: [0xcef89a70,0xcef89d40]
  lru-flags: on_auxiliary_list
  ckptq: [NULL] fileq: [NULL]
  objq: [NULL] objaq: [NULL]
  st: FREE md: NULL fpin: 'kdswh11: kdst_fetch' fscn: 0x80bbff tch: 0 lfb: 70
  flags:
  Printing buffer operation history (latest change first):
  cnt: 11
  01. sid:04 L673:o_wrt_pr:bis:REU    02. sid:02 L144:zibmlt:mk:EXCL    
  03. sid:02 L710:zibmlt:bis:FBP      04. sid:02 L085:zgm:ent:fn        
  05. sid:02 L122:zgb:set:st          06. sid:02 L830:olq1:clr:WRT+CKT  
  07. sid:02 L951:zgb:lnk:objq        08. sid:02 L372:zgb:set:MEXCL     
  09. sid:02 L123:zgb:no:FEN          10. sid:02 L083:zgb:ent:fn        
  11. sid:00 L203:w_ini_dc:bic:FVB  
  Buffer contents not dumped
Block dump from disk:
buffer tsn: 5 rdba: 0x03000c36 (12/3126)
scn: 0x80e5e2 seq: 0x01 flg: 0x06 tail: 0xe5e20601
frmt: 0x02 chkval: 0xb7e6 type: 0x06=trans data
Hex dump of block: st=0, typ_found=1
Dump of memory from 0x00007F9A0BA95000 to 0x00007F9A0BA97000
7F9A0BA95000 0000A206 03000C36 0080E5E2 06010000  [....6...........]
7F9A0BA95010 0000B7E6 00000001 000123BA 0080E5E1  [.........#......]
7F9A0BA95020 00008000 00320002 03000C30 000E0001  [......2.0.......]
7F9A0BA95030 00000D34 024027EA 0010012D 00002001  [4....'@.-.... ..]
7F9A0BA95040 0080E5E2 00000000 00000000 00000000  [................]
7F9A0BA95050 00000000 00000000 00000000 00000000  [................]
7F9A0BA95060 00000000 00010100 0014FFFF 1F571F6B  [............k.W.]
7F9A0BA95070 00001F57 1F6B0001 00000000 00000000  [W.....k.........]
7F9A0BA95080 00000000 00000000 00000000 00000000  [................]
7F9A0BA95090 03000C31 0000000E 00000000 00000000  [1...............]
7F9A0BA950A0 00000000 00000000 00000000 00000000  [................]
7F9A0BA950B0 00000000 00000000 00000000 000002A0  [................]
7F9A0BA950C0 000123AE 004DBA25 00000000 03000F80  [.#..%.M.........]
7F9A0BA950D0 00000040 00000000 00000000 00000000  [@...............]
7F9A0BA950E0 00000000 00000000 00000000 00000000  [................]
        Repeat 9 times
7F9A0BA95180 00000000 00000000 00000000 11111111  [................]
7F9A0BA95190 11111111 11111111 11111111 11111111  [................]
7F9A0BA951A0 11111111 11111111 11111111 00000000  [................]
7F9A0BA951B0 00000000 00000000 00000000 00000000  [................]
        Repeat 29 times
7F9A0BA95390 00000000 0080BBF2 00000000 00000000  [................]
7F9A0BA953A0 00000000 00000000 00000000 00000000  [................]
        Repeat 63 times
7F9A0BA957A0 00000000 00000000 00000000 41414141  [............AAAA]
7F9A0BA957B0 41414141 41414141 41414141 41414141  [AAAAAAAAAAAAAAAA]
        Repeat 2 times
7F9A0BA957E0 41414141 41414141 41414141 00000000  [AAAAAAAAAAAA....]
7F9A0BA957F0 00000000 00000000 00000000 00000000  [................]
        Repeat 380 times
7F9A0BA96FC0 00000000 00000000 00000000 2C000000  [...............,]
7F9A0BA96FD0 610A0601 20202020 20202020 20610A20  [...a         .a ]
7F9A0BA96FE0 20202020 20202020 2020610A 20202020  [        .a      ]
7F9A0BA96FF0 01202020 20610261 20206103 E5E20601  [   .a.a .a  ....]
Block header dump:  0x03000c36
 Object id on Block? Y
 seg/obj: 0x123ba  csc:  0x000000000080e5e1  itc: 2  flg: E  typ: 1 - DATA
     brn: 0  bdba: 0x3000c30 ver: 0x01 opc: 0
     inc: 0  exflg: 0
 
 Itl           Xid                  Uba         Flag  Lck        Scn/Fsc
0x01   0x0001.00e.00000d34  0x024027ea.012d.10  --U-    1  fsc 0x0000.0080e5e2
0x02   0x0000.000.00000000  0x00000000.0000.00  ----    0  fsc 0x0000.00000000
bdba: 0x03000c36
data_block_dump,data header at 0x7f9a0ba95064
===============
tsiz: 0x1f98
hsiz: 0x14
pbl: 0x7f9a0ba95064
     76543210
flag=--------
ntab=1
nrow=1
frre=-1
fsbo=0x14
fseo=0x1f6b
avsp=0x1f57
tosp=0x1f57
0xe:pti[0]	nrow=1	offs=0
0x12:pri[0]	offs=0x1f6b
block_row_dump:
tab 0, row 0, @0x1f6b
tl: 45 fb: --H-FL-- lb: 0x1  cc: 6
col  0: [10]  61 20 20 20 20 20 20 20 20 20
col  1: [10]  61 20 20 20 20 20 20 20 20 20
col  2: [10]  61 20 20 20 20 20 20 20 20 20
col  3: [ 1]  61
col  4: [ 2]  61 20
col  5: [ 3]  61 20 20
end_of_block_dump
Start check mirror blocks: 5 file#:12 minblk 3126 maxblk 3126
ksfdrfms:Mirror Read file=+DATA/ORCL/953189866920530AE055BC6DF83091F8/DATAFILE/users.275.1022021857 fob=0x179f6190 bufp=0x7f9a0ba95000 blkno=3126 nbytes=8192
ksfdafReadMirror: Read success from mirror side=1 logical extent number=0 disk=DISK2 path=/dev/sdd1
Mirror I/O done from ASM disk /dev/sdd1 
ksfdrnms:Mirror Read file=+DATA/ORCL/953189866920530AE055BC6DF83091F8/DATAFILE/users.275.1022021857 fob=0x179f6190 bufp=0x7f9a0b110000 nbytes=8192
ksfdafReadMirror: Read success from mirror side=2 logical extent number=1 disk=DISK3 path=/dev/sde1
ksfdrnms:Mirror Read file=+DATA/ORCL/953189866920530AE055BC6DF83091F8/DATAFILE/users.275.1022021857 fob=0x179f6190 bufp=0x7f9a0b110000 nbytes=8192
End dump data blocks tsn: 5 file#: 12 minblk 3126 maxblk 3126
