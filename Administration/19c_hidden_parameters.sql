SELECT /*+ use_hash(x y) */
    x.inst_id,
    x.indx + 1,
    ksppinm,
    ksppity,
    ksppstvl,
    ksppstdvl,
    ksppstdfl,
    ksppstdf,
    decode(bitand(ksppiflg / 256, 1), 1, 'TRUE', 'FALSE'),
    decode(bitand(ksppiflg / 65536, 3), 1, 'IMMEDIATE', 2, 'DEFERRED',
           3, 'IMMEDIATE', 'FALSE'),
    decode(bitand(ksppiflg / 524288, 1), 1, 'TRUE', 'FALSE'),
    decode(bitand(ksppiflg, 4), 4, 'FALSE', decode(bitand(ksppiflg / 65536, 3), 0, 'FALSE', 'TRUE')),
    decode(bitand(ksppstvf, 7), 1, 'MODIFIED', 4, 'SYSTEM_MOD',
           'FALSE'),
    decode(bitand(ksppstvf, 2), 2, 'TRUE', 'FALSE'),
    decode(bitand(ksppilrmflg / 64, 1), 1, 'TRUE', 'FALSE'),
    decode(bitand(ksppilrmflg / 268435456, 1), 1, 'TRUE', 'FALSE'),
    ksppdesc,
    ksppstcmnt,
    ksppihash,
    y.con_id
FROM
    x$ksppi    x,
    x$ksppcv   y
WHERE
    ( x.indx = y.indx )
    AND bitand(ksppiflg, 268435456) = 0
    AND ( ( translate(ksppinm, '_', '$') NOT LIKE '$$%' )
          AND ( ( translate(ksppinm, '_', '$') NOT LIKE '$%' )
                OR ( ksppstdf = 'FALSE' )
                OR ( bitand(ksppstvf, 5) > 0 ) ) )
;

-- get all hidden parameters

SELECT /*+ use_hash(x y) */
    ksppinm name,
    ksppstvl value,
    ksppdesc description
FROM
    x$ksppi    x,
    x$ksppcv   y
WHERE
    ( x.indx = y.indx )
    AND bitand(ksppiflg, 268435456) = 0;

/****************

NAME	VALUE	DESCRIPTION
_appqos_qt	10	System Queue time retrieval interval
_appqos_po_multiplier	1000	Multiplier for PC performance objective value
_appqos_cdb_setting	0	QoSM CDB Performance Class Setting
_ior_serialize_fault	0	inject fault in the ior serialize code
_shutdown_completion_timeout_mins	60	minutes for shutdown operation to wait for sessions to complete
_inject_startup_fault	0	inject fault in the startup code
_wait_outlier_detection_enable	OFF	Enable wait outlier detection module?
_wait_outlier_event_names		Wait events to watch for outliers
_wait_outlier_lambda_x1000	1500	Lambda (in thousands) to compute outliers
_wait_outlier_dump_flags	0	Wait Outlier Dump Flags
_wait_outlier_min_waits	10	Minimum waits required to enable wait outliers detection
_wait_outlier_num_outliers	600	Max number of outliers tracked
_spin_count	2000	Amount to spin waiting for a latch
_latch_miss_stat_sid	0	Sid of process for which to collect latch stats
_max_sleep_holding_latch	4	max time to sleep while holding a latch
_max_exponential_sleep	0	max sleep during exponential backoff
_other_wait_threshold	0	threshold wait percentage for event wait class Other
_other_wait_event_exclusion		exclude event names from _other_wait_threshold calculations
_use_vector_post	TRUE	use vector post
_latch_class_0		latch class 0
_latch_class_1		latch class 1
_latch_class_2		latch class 2
_latch_class_3		latch class 3
_latch_class_4		latch class 4
_latch_class_5		latch class 5
_latch_class_6		latch class 6
_latch_class_7		latch class 7
_latch_classes		latch classes override
_ultrafast_latch_statistics	TRUE	maintain fast-path statistics for ultrafast latches
_enable_reliable_latch_waits	TRUE	Enable reliable latch waits
_latch_wait_list_pri_sleep_secs	1	Time to sleep on latch wait list until getting priority
_wait_breakup_time_csecs	300	Wait breakup time (in centiseconds)
_wait_breakup_threshold_csecs	600	Wait breakup threshold (in centiseconds)
_disable_wait_state		Disable wait state
_wait_tracker_num_intervals	0	Wait Tracker number of intervals
_wait_tracker_interval_secs	10	Wait Tracker number of seconds per interval
_wait_samples_max_time_secs	120	Wait Samples maximum time in seconds
_wait_samples_max_sections	40	Wait Samples maximum sections
_wait_yield_mode	yield	Wait Yield - Mode
_wait_yield_hp_mode	yield	Wait Yield - High Priority Mode
_wait_yield_sleep_time_msecs	1	Wait Yield - Sleep Time (in milliseconds)
_wait_yield_sleep_freq	100	Wait Yield - Sleep Frequency
_wait_yield_yield_freq	20	Wait Yield - Yield Frequency
_post_wait_queues_num_per_class		Post Wait Queues - Num Per Class
_super_shared_enable	FALSE	enable super shared mode for latches
_super_shared_conversion_threshold	300	conversion threshold limit for supershared mode
_super_shared_max_exclusive_conversions	4	Maximum consecutive exclusive conversions to convert a super shared latch
__wait_test_param	0	wait test parameter
__latch_test_param	0	latch test parameter
_latch_pause_mode	static	Latch pause mode
_latch_pause_count	0	Latch pause count
lock_name_space		lock name space used for generating lock names for standby/clone database
processes	300	user processes
sessions	474	user and system sessions
_min_sys_process	2	minimum system processess
_enable_dynamic_sessions	FALSE	dynamic session SOs
_dynamic_sessions_inc_count	1000	dynamic session increment count
_dynamic_sessions_force_timeout	30	dynamic session force timeout
_dynamic_sessions_min_force_timeout	5	dynamic min session force timeout
_dynamic_sessions_wait_timeout	100	dynamic session wait timeout for new session
_max_dynamic_sessions	474	max dynamic session count
_dynamic_sessions_max_oom_timeout	300	dynamic session max timeout for out of memory
_session_prediction_failover_buffer	0	session prediction failover buffer
_so_percent_upper_bound_strt	70	SO percent upper bound start
_so_percent_upper_bound_final	90	SO percent upper bound final
_so_percent_lower_bound_strt	60	SO percent lower bound start
_so_percent_lower_bound_final	80	SO percent lower bound final
_session_percent_rampup_start	474	session SO percent rampup start
_session_percent_rampup_end	474	session SO percent rampup end
_so_max_inc	20000	SO max inc
timed_statistics	TRUE	maintain internal timing statistics
timed_os_statistics	0	internal os statistic gathering interval in seconds
resource_limit	TRUE	master switch for resource limit
license_max_sessions	0	maximum number of non-system user sessions allowed
license_sessions_warning	0	warning level for number of non-system user sessions
_session_idle_bit_latches	0	one latch per session or a latch per group of sessions
_ksu_diag_kill_time	5	number of seconds ksuitm waits before killing diag
_ksuitm_dont_kill_dumper	FALSE	delay inst. termination to allow processes to dump
_disable_image_check	FALSE	Disable Oracle executable image checking
_num_longop_child_latches	3	number of child latches for long op array
_longops_per_latch	64	number of longops to allocate per latch
_longops_enabled	TRUE	longops stats enabled
_test_ksusigskip	5	test the function ksusigskip
long_module_action	TRUE	Use longer module and action
_disable_kcbhxor_osd	FALSE	disable kcbh(c)xor OSD functionality
_disable_kgghshcrc32_osd	FALSE	disable kgghshcrc32chk OSD functionality
_disable_system_state	4294967294	disable system state dump
_system_state_runtime_limit	4294967294	runtime limit for system state dump
_system_state_cputime_limit	4294967294	cputime limit for system state dump
_disable_system_state_wait_samples	FALSE	Disable system state dump - wait samples
_session_wait_history	10	enable session wait history collection
_pkt_enable	FALSE	enable progressive kill test
_pkt_start	FALSE	start progressive kill test instrumention
_pkt_pmon_interval	50	PMON process clean-up interval (cs)
_collapse_wait_history	FALSE	collapse wait history
_short_stack_timeout_ms	30000	short stack timeout in ms
_sga_early_trace	0	sga early trace event
_kill_session_dump	FALSE	Process dump on kill session immediate
_logout_storm_rate	0	number of processes that can logout in a second
_logout_storm_timeout	5	timeout in centi-seconds for time to wait between retries
_logout_storm_retrycnt	600	maximum retry count for logouts
_ksuitm_addon_trccmd		command to execute when dead processes don't go away
_timeout_actions_enabled	TRUE	enables or disables KSU timeout actions
_idle_session_kill_enabled	TRUE	enables or disables resource manager session idle limit checks
_session_allocation_latches	3	one latch per group of sessions
standby_db_preserve_states	NONE	Preserve state cross standby role transition
_suspended_session_timeout	300	Timeout to kill suspended sess aft switchover
_wait_for_busy_session	10	Wait time before killing active sessions during switchover
_process_allocation_slots	100	process allocation slots
instance_abort_delay_time	0	time to delay an internal initiated abort (in seconds)
_show_login_pdb_sessions	FALSE	return logon pdb container id from v$session
_disable_highres_ticks	FALSE	disable high-res tick counter
_disable_os_time_page	FALSE	disable OS time page
_timer_precision	10	VKTM timer precision in milli-sec
_dbrm_quantum		DBRM quantum
_highres_drift_allowed_sec	1	allowed highres timer drift for VKTM
_lowres_drift_allowed_sec	5	allowed lowres timer drift for VKTM
_vktm_assert_thresh	30	soft assert threshold VKTM timer drift
_iorm_tout	1000	IORM scheduler timeout value in msec
__oracle_base	/u01/app/oracle	ORACLE_BASE
_rman_roundrobin_placement		Numa round robin placement for RMAN procs
_process_heartbeat_range	3	Process heartbeat range
_max_shutdown_abort_secs	10	Maximum wait time for shutdown abort in seconds
_cpu_count_startup	0	Startup number of CPUs for this instance
cpu_count	3	maximum number of CPUs
cpu_min_count	3	minimum number of CPUs required
_disable_cpu_check	FALSE	disable cpu_count check
_available_core_count	0	number of cores for this instance
_cpu_eff_thread_multiplier		CPU effective thread multiplier
_single_process	FALSE	run without detached processes
_dbg_proc_startup	FALSE	debug process startup
_enqueue_deadlock_time_sec	5	requests with timeout <= this will not have deadlock detection
_enqueue_sync_retry_attempts	15	max number of times the bg process to retry synchronous enqueue open if it failed because master could not allocate memory
_enqueue_sync_sim_mem_error	FALSE	simulate master instance running out of memory when synchronously getting a remotely mastered enqueue
_number_cached_attributes	10	maximum number of cached attributes per instance
instance_groups		list of instance group names
_number_cached_group_memberships	2048	maximum number of cached group memberships
_number_group_memberships_per_cache_line	6	maximum number of group memberships per cache line
_ksim_time_monitor	auto	ksim layer time dynamic monitor and statistics
_group_membership_bucket_scan_timeout	5	ksimpoll group membership bucket scan timeout
_group_membership_bucket_batch_size	8	ksimpoll group membership bucket batch size
_group_membership_entries_per_bucket	100	ksimpoll group membership entries per bucket
_kss_quiet	TRUE	if TRUE access violations during kss dumps are not recorded
_kss_callstack_type		state object callstack trace type
event		debug event control - default null string
_oradebug_force	FALSE	force target processes to execute oradebug commands?
_ksdxdocmd_default_timeout_ms	30000	default timeout for internal oradebug commands
_ksdxdocmd_enabled	TRUE	if TRUE ksdxdocmd* invocations are enabled
_ksdx_charset_ratio	0	ratio between the system and oradebug character set
_oradebug_cmds_at_startup		oradebug commands to execute at instance startup
_disable_oradebug_commands	none	disable execution of certain categories of oradebug commands
_watchpoint_on	FALSE	is the watchpointing feature turned on?
_ksdxw_num_sgw	10	number of watchpoints to be shared by all processes
_ksdxw_num_pgw	10	number of watchpoints on a per-process basis
_ksdxw_stack_depth	4	number of PCs to collect in the stack when watchpoint is hit
_ksdxw_stack_readable	FALSE	dump readable stack when watchpoint is hit
_ksdxw_cini_flg	0	ksdxw context initialization flag
_ksdxw_nbufs	1000	ksdxw number of buffers in buffered mode
_hw_watchpoint_on	TRUE	is the HW watchpointing feature turned on?
sga_max_size	2415919104	max total SGA size
_enable_shared_pool_durations	TRUE	temporary to disable/enable kgh policy
_NUMA_pool_size	Not specified	aggregate size in bytes of NUMA pool
_enable_NUMA_optimization	FALSE	Enable NUMA specific optimizations
_enable_NUMA_support	FALSE	Enable NUMA support and optimizations
_enable_NUMA_interleave	TRUE	Enable NUMA interleave mode
_touch_sga_pages_during_allocation	FALSE	touch SGA pages during allocation
use_large_pages	TRUE	Use large pages if available (TRUE/FALSE/ONLY)
_max_largepage_alloc_time_secs	10	Maximum number of seconds to spend on largepage allocation
_use_hugetlbfs_for_SGA	FALSE	Enable HugeTLBFS usage for SGA
_hugetlbfs_mount_point_for_sga		HugeTLBFS mount point to be used
_use_hugetlbfs_per_granule	FALSE	Enable file per granule with HugeTLBFS
_dump_10261_level	0	Dump level for event 10261, 1=>minimal dump 2=>top pga dump
_numa_shift_enabled	TRUE	Enable NUMA shift
_numa_shift_value	0	user defined value for numa nodes shift
_freeze_kgh_timestamp	FALSE	prevent heap manager timestamp from advancing
pre_page_sga	TRUE	pre-page sga for process
shared_memory_address	0	SGA starting address (low order 32-bits on 64-bit platforms)
hi_shared_memory_address	0	SGA starting address (high order 32-bits on 64-bit platforms)
_use_ism	TRUE	Enable Shared Page Tables - ISM
lock_sga	FALSE	Lock entire SGA in physical memory
_NUMA_instance_mapping	Not specified	Set of nodes that this instance should run on
_simulator_upper_bound_multiple	2	upper bound multiple of pool size
_simulator_pin_inval_maxcnt	16	maximum count of invalid chunks on pin list
_simulator_lru_rebalance_thresh	10240	LRU list rebalance threshold (count)
_simulator_lru_rebalance_sizthr	5	LRU list rebalance threshold (size)
_simulator_bucket_mindelta	8192	LRU bucket minimum delta
_simulator_lru_scan_count	8	LRU scan count
_simulator_internal_bound	10	simulator internal bound percent
_simulator_reserved_obj_count	1024	simulator reserved object count
_simulator_reserved_heap_count	4096	simulator reserved heap count
_simulator_sampling_factor	2	sampling factor for the simulator
_realfree_heap_max_size	32768	minimum max total heap size, in Kbytes
_realfree_heap_pagesize	65536	hint for real-free page size in bytes
_realfree_pq_heap_pagesize	65536	hint for pq real-free page size in bytes
_realfree_heap_mode	0	mode flags for real-free heap
_use_realfree_heap	TRUE	use real-free based allocator for PGA memory
_pga_large_extent_size	1048576	PGA large extent size
_uga_cga_large_extent_size	262144	UGA/CGA large extent size
_total_large_extent_memory	0	Total memory for allocating large extents
_use_ism_for_pga	TRUE	Use ISM for allocating large extents
_private_memory_address		Start address of large extent memory segment
_kgh_restricted_trace	0	trace level for heap dump-restricted mode
_kgh_restricted_subheaps	180	number of subheaps in heap restricted mode
_kgh_free_list_min_effort	12	typical number of free list chunks to visit
_ksm_shared_pool_stats_num_pdb	8	number of pdbs to dump shared pool info for
_ksm_shared_pool_stats_minsz	524288	min value for printing stats
_ksm_sp_rcr_hits	10	hits to make object recurrent
_mem_annotation_sh_lev	0	shared memory annotation collection level
_mem_annotation_pr_lev	0	private memory annotation collection level
_mem_annotation_scale	1	memory annotation pre-allocation scaling
_mem_annotation_store	FALSE	memory annotation in-memory store
_4031_dump_bitvec	67194879	bitvec to specify dumps prior to 4031 error
_4031_max_dumps	100	Maximum number of 4031 dumps for this process
_4031_dump_interval	300	Dump 4031 error once for each n-second interval
_4031_sga_dump_interval	3600	Dump 4031 SGA heapdump error once for each n-second interval
_4031_sga_max_dumps	10	Maximum number of SGA heapdumps
_4030_dump_bitvec	4095	bitvec to specify dumps prior to 4030 error
_numa_trace_level	0	numa trace event
_mem_std_extent_size	4096	standard extent size for fixed-size-extent heaps
_kgsb_threshold_size	16777216	threshold size for base allocator
_endprot_chunk_comment	chk 10235 dflt	chunk comment for selective overrun protection
_endprot_heap_comment	hp 10235 dflt	heap comment for selective overrun protection
_endprot_subheaps	TRUE	selective overrun protection for subeheaps
_alloc_perm_as_free	FALSE	allocate permanent chunks as freeable
_ksm_pre_sga_init_notif_delay_secs	0	seconds to delay instance startup at sga initialization (pre)
_ksm_post_sga_init_notif_delay_secs	0	seconds to delay instance startup at sga initialization (post)
_defer_sga_enabled	FALSE	Enable deferred shared memory allocation for SGA
_defer_sga_min_total_defer_segs_sz	107374182400	Minimum total deferred segs size for defer sga allocation
_defer_sga_alloc_chunk_size	1073741824	Chunk size for defer sga allocation
_defer_sga_min_spsz_at_startup	53687091200	Minimum shared pool size at startup with deferred sga enabled
_defer_sga_test_alloc_intv	0	SA** sleeps for N secs before allocating a deferred segment
_sga_alloc_slaves_term_timeout_secs	120	Termination timeout in secs for SA** slaves
_ksmlsaf	0	KSM log alloc and free
processor_group_name		Name of the processor group that this instance should run in.
_pga_limit_target_perc	200	default percent of pga_aggregate_target for pga_aggregate_limit
_pga_limit_watch_perc	50	percentage of limit to have processes watch
_pga_limit_time_to_interrupt	2	seconds to wait until direct interrupt
_pga_limit_interrupt_smaller	FALSE	whether to interrupt smaller eligible processes
_pga_limit_time_until_idle	15	seconds to wait before treating process as idle
_pga_limit_time_until_killed	15	seconds to wait before killing session over limit
_pga_limit_use_immediate_kill	TRUE	use immediate kill for sessions over limit
_pga_limit_dump_summary	TRUE	dump PGA summary when signalling ORA-4036
_pga_limit_watch_size	104857600	bytes of PGA usage at which process will begin watching limit
_pga_limit_min_req_size	4194304	bytes of PGA usage below which process will not get ORA-4036
_pga_limit_check_wait_time	1000000	microseconds to wait for over limit confirmation
_pga_limit_simulated_physmem_size	0	bytes of physical memory to determine pga_aggregate_limit with
_pga_limit_physmem_perc	90	default percent of physical memory for pga_aggregate_limit and SGA
_max_physmem_perc_sga	80	maximum percentage of physical memory for SGA
_max_physmem_perc_mmt	90	maximum percentage of physical memory for memory_max_target
_pga_limit_per_process_minimum	3145728	pga_aggregate_limit per-process minimum
_pga_auto_snapshot_threshold	524288000	bytes of PGA memory in one process to trigger detail snapshot
_pga_auto_snapshot_percentage	20	percent growth of PGA memory for additional snapshots
_pga_detail_combine_auto	FALSE	combine auto and manual PGA memory detail snapshots
_memory_adi_enabled	TRUE	enable memory application data integrity
_memory_adi_precise_errors	FALSE	enable precise memory application data integrity errors
_sga_heap_chunk_alignment	FALSE	force SGA heap chunk alignment
_sga_heap_chunk_alignment_disabled	FALSE	force SGA heap chunks not to be aligned
_memory_adi_bytes_per_alloc	0	bytes per allocation to get memory application data integrity
_memory_adi_extend	FALSE	enable ADI for kgh headers and free memory
_memory_adi_heap_mask	610	enable ADI versioning for these heaps
_memory_adi_module_mask	0	bit mask of modules to enable ADI versioning
_NUMA_bind_mode	default	Numa bind mode
_pdb_vm_max_size		PDB SGA maximum virtual memory size
allow_group_access_to_sga	FALSE	Allow read access for SGA to users of Oracle owner group
_gas_partition_size	0	Global Address Space Partition Size for each instance
_suspend_4036_timeout	14400	pga timeout in seconds for 4036
_suspend_4031_timeout	14400	sga timeout in seconds for 4031
_heap_dump_timeout	60	timeout in seconds for heap dump
_pga_in_sga_param1		pga in sga param1
_pga_in_sga_param2		pga in sga param2
_pga_in_sga_param3		pga in sga param4
_pga_in_sga_param4		pga in sga param4
_pga_in_sga_param5		pga in sga param4
sga_min_size	0	Minimum, guaranteed size of PDB's SGA
__sga_current_size	0	Current size for PDB SGA
__shared_pool_size	654311424	Actual size in bytes of shared pool
shared_pool_size	0	size in bytes of shared pool
__large_pool_size	16777216	Actual size in bytes of large pool
large_pool_size	0	size in bytes of large pool
__java_pool_size	167772160	Actual size in bytes of java pool
java_pool_size	0	size in bytes of java pool
__streams_pool_size	33554432	Actual size in bytes of streams pool
streams_pool_size	0	size in bytes of the streams pool
__unified_pga_pool_size	0	Actual size in bytes of unified pga pool
_unified_pga_pool_size	0	size in bytes of the unified pga pool
_large_pool_min_alloc	65536	minimum allocation size in bytes for the large allocation pool
shared_pool_reserved_size	31876710	size in bytes of reserved area of shared pool
_shared_pool_reserved_pct	5	percentage memory of the shared pool allocated for the reserved area
_shared_pool_reserved_min_alloc	4400	minimum allocation size in bytes for reserved area of shared pool
java_soft_sessionspace_limit	0	warning limit on size in bytes of a Java sessionspace
java_max_sessionspace_size	0	max allowed size in bytes of a Java sessionspace
_kghdsidx_count	1	max kghdsidx count
pga_aggregate_limit	2147483648	limit of aggregate PGA memory for the instance or PDB
_pga_limit_tracing	0	trace pga_aggregate_limit activity
_force_java_pool_zero	FALSE	force java pool size to be zero bytes
_pga_aggregate_xmem_limit	0	limit of aggregate PGA XMEM memory consumed by the instance
_parameter_spfile_sync	FALSE	SPFILE sync mode
_test_param_1	25	test parmeter 1 - integer
_test_param_2		test parameter 2 - string
_test_param_3		test parameter 3 - string
_test_param_4		test parameter 4 - string list
_test_param_5	25	test parmeter 5 - deprecated integer
_test_param_6	0	test parmeter 6 - size (ub8)
_test_param_7	100, 1100, 2100, 3100, 4100	test parameter 7 - big integer list
_test_param_8	20	test parameter 8 - cdb tests
_test_param_9		test parameter 9 - umbrella param
_test_param_9_1	0	test parameter 9_1 - cascade param1
_test_param_9_2	0_startup	test parameter 9_2 - cascade param2
_test_param_9_3	1_startup, 2_startup, 3_startup	test parameter 9_3 - cascade param3
_test_param_10		test parameter 10 - string param
_test_param_10_bi	10	test parameter 10 - bigint param
_test_param_10_i		test parameter 10 - int param
_test_param_11_base	3	test parameter 11 base
_test_param_11_dep	0_STARTUP, 1_STARTUP, 2_STARTUP	test parameter 11 dependent
_test_param_12	0	test parameter 12 - int param
spfile	+DATA/ORCL/PARAMETERFILE/spfileorcl.ora	server parameter file
instance_type	RDBMS	type of instance to be executed
_disable_instance_params_check	FALSE	disable instance type check for ksp
_parameter_table_block_size	2048	parameter table block size
_high_priority_processes	LMS*|LM1*|LM2*|LM3*|LM4*|LM5*|LM6*|LM7*|LM8*|LM9*	High Priority Process Name Mask
_highest_priority_processes	VKTM	Highest Priority Process Name Mask
_os_sched_high_priority	1	OS high priority level
_os_sched_highest_priority	1	OS highest priority level
_ksb_restart_clean_time	30000	process uptime for restarts
_ksb_restart_policy_times	0, 60, 120, 240	process restart policy times in seconds
_bg_spawn_diag_opts	0	background processes spawn diagnostic options
_static_backgrounds		static backgrounds
_mpmt_enabled_backgrounds	*	mpmt enabled backgrounds
_background_process_opts	0	Misc BG procs parameter
_ksd_test_param	999	KSD test parmeter
uniform_log_timestamp_format	TRUE	use uniform timestamp formats vs pre-12.2 formats
_kse_die_timeout	60000	amount of time a dying process is spared by PMON (in centi-secs)
_stack_guard_level	0	stack guard level
_kse_pc_table_size	256	kse pc table cache size
_kse_signature_entries	0	number of entries in the kse stack signature cache
_kse_signature_limit	7	number of stack frames to cache per kse signature
_kse_snap_ring_size	0	ring buffer to debug internal error 17090
_kse_snap_ring_record_stack	FALSE	should error snap ring entries show a short stack trace
_kse_snap_ring_suppress	942 1403	List of error numbers to suppress in the snap error history
_kse_snap_ring_disable	FALSE	set to TRUE or FALSE to disable or enable error logging
_kse_trace_int_msg_clear	FALSE	enables soft assert of KGECLEAERERROR is cleares an interrupt message
_system_api_interception_debug	FALSE	enable debug tracing for system api interception
_kse_ssnt	FALSE	disables symbol translation in short stacks to make them faster
_kse_alt_stack_sig_syms	25	The number of top symbols used for the alternate stack signature
_kse_auto_core	FALSE	generate core for unexpected SIGSEGV/SIGBUS
_messages	600	message queue resources - dependent on # processes & # buffers
_enqueue_locks	5680	locks for managed enqueues
_enqueue_resources	2304	resources for enqueues
_enqueue_hash	983	enqueue hash table length
_enqueue_debug_multi_instance	FALSE	debug enqueue multi instance
_enqueue_hash_chain_latches	3	enqueue hash chain latches
_enqueue_deadlock_scan_secs	0	deadlock scan interval
_enqueue_deadlock_detect_all_global_locks	FALSE	enable deadlock detection on all global enqueues
_enqueue_paranoia_mode_enabled	FALSE	enable enqueue layer advanced debugging checks
_ksi_trace		KSI trace string of lock type(s)
_ksi_trace_bucket	SHARED	memory tracing: use ksi-private or rdbms-shared bucket
_ksi_trace_bucket_size	LCK1:1048576-REST:8192	KSI trace bucket size in bytes (format: ""LCK1:<n>-REST:<m>"")
_ksi_clientlocks_enabled	TRUE	if TRUE, DLM-clients can provide the lock memory
_ksi_pdb_checks	TRUE	if TRUE (default), do consistency checks on PDB IDs
_trace_processes	ALL	enable KST tracing in process
_trace_events		trace events enabled at startup
_trace_buffers	ALL:256	trace buffer sizes per process
_trace_dump_static_only	FALSE	if TRUE filter trace dumps to always loaded dlls
_trace_dump_all_procs	FALSE	if TRUE on error buckets of all processes will be dumped to the current trace file
_trace_dump_cur_proc_only	FALSE	if TRUE on error just dump our process bucket
_trace_dump_client_buckets	TRUE	if TRUE dump client (ie. non-kst) buckets
_cdmp_diagnostic_level	2	cdmp directory diagnostic level
nls_language	ENGLISH	NLS language name
nls_territory	SINGAPORE	NLS territory name
nls_sort		NLS linguistic definition name
nls_date_language	ENGLISH	NLS date language name
nls_date_format		NLS Oracle date format
nls_currency		NLS local currency symbol
nls_numeric_characters		NLS numeric characters
nls_iso_currency		NLS ISO currency territory name
nls_calendar		NLS calendar system name
nls_time_format		time format
nls_timestamp_format		time stamp format
nls_time_tz_format		time with timezone format
nls_timestamp_tz_format		timestamp with timezone format
nls_dual_currency		Dual currency symbol
nls_comp	BINARY	NLS comparison
nls_length_semantics	BYTE	create columns using byte or char semantics by default
nls_nchar_conv_excp	FALSE	NLS raise an exception instead of allowing implicit conversion
_nchar_imp_cnv	TRUE	NLS allow Implicit Conversion between CHAR and NCHAR
_nls_parameter_sync_enabled	TRUE	enables or disables updates to v$parameter whenever an alter session statement modifies various nls parameters
_ioslave_issue_count	500	IOs issued before completion check
_ioslave_batch_count	1	Per attempt IOs picked
disk_asynch_io	TRUE	Use asynch I/O for random access devices
tape_asynch_io	TRUE	Use asynch I/O requests for tape devices
_io_slaves_disabled	FALSE	Do not use I/O slaves
dbwr_io_slaves	0	DBWR I/O slaves
_lgwr_io_slaves	0	LGWR I/O slaves
_arch_io_slaves	0	ARCH I/O slaves
_backup_disk_io_slaves	0	BACKUP Disk I/O slaves
backup_tape_io_slaves	FALSE	BACKUP Tape I/O slaves
_fg_iorm_slaves	1	ForeGround I/O slaves for IORM
_backup_io_pool_size	1048576	memory to reserve from the large pool
_disable_file_locks	FALSE	disable file locks for control, data, redo log files
_ksfd_verify_write	FALSE	verify asynchronous writes issued through ksfd
_disable_odm	FALSE	disable odm feature
_enable_fast_file_zero	TRUE	enable fast file zero code path
_enable_kernel_io_outliers	FALSE	enable kernel I/O outlier feature
fileio_network_adapters		Network Adapters for File I/O
_enable_list_io	FALSE	Enable List I/O
filesystemio_options	none	IO operations on filesystem files
dnfs_batch_size	4096	Max number of dNFS asynch I/O requests queued per session
_dnfs_rdma_max	1048576	Maximum size of dNFS RDMA transfer
_dnfs_rdma_min	8192	Minimum size of dNFS RDMA transfer
_dnfs_rdma_enable	rman	Enable dNFS RDMA transfers
_omf	enabled	enable/disable OMF
_aiowait_timeouts	100	Number of aiowait timeouts before error is reported
_io_shared_pool_size	4194304	Size of I/O buffer pool from SGA
_max_io_size	1048576	Maximum I/O size in bytes for sequential file accesses
_io_statistics	TRUE	if TRUE, ksfd I/O statistics are collected
_disk_sector_size_override	FALSE	if TRUE, OSD sector size could be overridden
_simulate_disk_sectorsize	0	Enables skgfr to report simulated physical disk sector size
_simulate_logical_sectorsize	0	Enables skgfr to report simulated logical disk sector size
_enable_asyncvio	FALSE	enable asynch vectored I/O
_iocalibrate_max_ios	0	iocalibrate max I/Os per process
_iocalibrate_init_ios	2	iocalibrate init I/Os per process
clonedb	FALSE	clone database
instant_restore	FALSE	instant repopulation of datafiles
_io_outlier_threshold	500	Latency threshold for io_outlier table
_io_internal_test	0	I/O internal testing parameter
_lgwr_io_outlier	0	LGWR I/O outlier frequency
_io_osd_param	1	OSD specific parameter
_fob_dgaalloc	TRUE	Fob structure allocation from Domain Global Area memory
_fob_ospshare	TRUE	Fob structure and file descriptor sharing between threads with-in an OSP in MPMT environment
_ksfd_fob_pct	0	percentage of FOB state objects allocation
_disksize_binary_search	FALSE	if set, perform binary search to get disk size if IOCTL fails
_instant_file_create	FALSE	enable instant file creation on sparse media
http_proxy		http_proxy
ssl_wallet		ssl_wallet
_db_file_direct_io_count	1048576	Sequential I/O buf size
_cell_fast_file_create	TRUE	Allow optimized file creation path for Cells
_cell_fast_file_restore	TRUE	Allow optimized rman restore for Cells
_file_size_increase_increment	67108864	Amount of file size increase increment, in bytes
ofs_threads	4	Number of OFS threads
_ofs_write_buffer_size	1048576	OFS write buffer size in bytes
_reset_maxcap_history	10	reset maxcap history periods
_use_dynamic_shares	1	use dynamic shares
_dynamic_share_range_factor	2	dynamic share range factor
_cpu_util_adj_force	0	force cpu util adjustment
_cpu_util_adj_target	0	cpu utilization adjustment target
_low_server_threshold	0	low server thresholds
_high_threshold_delta	65535	high threshold delta
_min_lwt_lt	24	minimum low threshold for LWTs
_max_lwt_cpu_ratio	2	ratio to determine the maximum CPUs for LWTs
_active_session_idle_limit	5	active session idle limit
_active_session_legacy_behavior	FALSE	active session legacy behavior
resource_manager_cpu_allocation	3	Resource Manager CPU allocation
_resource_manager_plan		resource mgr top plan for internal use
resource_manager_plan	SCHEDULER[0x4D58]:DEFAULT_MAINTENANCE_PLAN	resource mgr top plan
_vkrm_schedule_interval	10	VKRM scheduling interval
_dbrm_dynamic_threshold	989922280	DBRM dynamic threshold setting
_rm_superlong_threshold	0	DBRM superlong threshold setting
_resource_manager_always_off	FALSE	disable the resource manager always
_io_resource_manager_always_on	FALSE	io resource manager always on
_enable_os_cpu_rm	FALSE	Enable OS CPU Resource Management
_max_small_io	0	IORM:max number of small I/O's to issue
_max_large_io	0	IORM:max number of large I/O's to issue
_auto_assign_cg_for_sessions	FALSE	auto assign CGs for sessions
_rm_numa_simulation_pgs	0	number of PGs for numa simulation in resource manager
_rm_numa_simulation_cpus	0	number of cpus for each pg for numa simulation in resource manager
_rm_numa_sched_enable	TRUE	Is Resource Manager (RM) related NUMA scheduled policy enabled
_dbrm_runchk	32769000	Resource Manager Diagnostic Running Thread Check
_dbrm_short_wait_us	300	Resource Manager short wait length
_dbrm_num_runnable_list	0	Resource Manager number of runnable list per NUMA node
_db_check_cell_hints	FALSE	
_pqq_enabled	TRUE	Enable Resource Manager based Parallel Statement Queuing
db_performance_profile		Database performance category
_rm_force_caging	FALSE	
_min_sys_percentage		
_min_autotask_percentage		
max_iops	0	MAX IO per second
max_mbps	0	MAX MB per second
_db_cache_max_sz	0	
_shared_pool_max_sz	0	
max_idle_time	0	maximum session idle time in minutes
max_idle_blocker_time	0	maximum idle time for a blocking session in minutes
_rm_exadata_pdb_cpu_cnt	FALSE	Use PDB CPU cnt for Exadata smart scan
_rm_exadata_partition_fc	FALSE	Partition flash cache for Exadata
_rm_exadata_pdb_cpu_cnt_mult	2	Multiplication factor for PDB cpu count
_rm_atp_cpu_cnt_scale	1	Scaling factor for cpu count in ATP
_pqq_debug_txn_act	FALSE	pq queuing transaction active
_ksr_unit_test_processes	0	number of ksr unit test processes
_ksv_spawn_control_all	FALSE	control all spawning of background slaves
_ksv_max_spawn_fail_limit	5	bg slave spawn failure limit
_ksv_pool_wait_timeout	600	bg slave pool wait limit
_ksv_pool_hang_kill_to	0	bg slave pool terminate timeout
_ksvppktmode	0	ksv internal pkt test
_ksv_static_flags1	0	ksv static flags 1 - override default behavior
_ksv_dynamic_flags1	0	ksv dynamic flags 1 - override default behavior
_ksv_slave_exit_timeout	120	slave exit timeout
_result_cache_rac_rolling	0	Result Cache RAC rolling safety level
_bug27355984_xt_preproc_timeout	100	external table preprocessor timeout
_third_spare_parameter		third spare parameter - integer
_session_modp_list	2	send session's modified parameter list to client
_fifth_spare_parameter		fifth spare parameter - integer
_sixth_spare_parameter		sixth spare parameter - integer
_seventh_spare_parameter		seventh spare parameter - integer
_eighth_spare_parameter		eighth spare parameter - integer
_ninth_spare_parameter		ninth spare parameter - integer
_tenth_spare_parameter		tenth spare parameter - integer
_eleventh_spare_parameter		eleventh spare parameter - integer
_twelfth_spare_parameter		twelfth spare parameter - integer
_thirteenth_spare_parameter		thirteenth spare parameter - integer
_fourteenth_spare_parameter		fourteenth spare parameter - integer
_fifteenth_spare_parameter		fifteenth spare parameter - integer
_sixteenth_spare_parameter		sixteenth spare parameter - integer
_seventeenth_spare_parameter		seventeenth spare parameter - integer
_eighteenth_spare_parameter		eighteenth spare parameter - integer
_nineteenth_spare_parameter		nineteenth spare parameter - integer
_twentieth_spare_parameter		twentieth spare parameter - integer
_twenty-first_spare_parameter		twenty-first spare parameter - integer
_twenty-second_spare_parameter		twenty-second spare parameter - integer
_twenty-third_spare_parameter		twenty-third spare parameter - integer
_twenty-fourth_spare_parameter		twenty-fourth spare parameter - integer
_twenty-fifth_spare_parameter		twenty-fifth spare parameter - integer
_twenty-sixth_spare_parameter		twenty-sixth spare parameter - integer
_twenty-seventh_spare_parameter		twenty-seventh spare parameter - integer
_twenty-eighth_spare_parameter		twenty-eighth spare parameter - integer
_twenty-ninth_spare_parameter		twenty-ninth spare parameter - integer
_thirtieth_spare_parameter		thirtieth spare parameter - integer
_thirty-first_spare_parameter		thirty-first spare parameter - integer
_thirty-second_spare_parameter		thirty-second spare parameter - integer
_thirty-third_spare_parameter		thirty-third spare parameter - integer
_thirty-fourth_spare_parameter		thirty-fourth spare parameter - integer
_thirty-fifth_spare_parameter		thirty-fifth spare parameter - integer
_thirty-sixth_spare_parameter		thirty-sixth spare parameter - integer
_thirty-seventh_spare_parameter		thirty-seventh spare parameter - integer
_thirty-eighth_spare_parameter		thirty-eighth spare parameter - integer
_thirty-ninth_spare_parameter		thirty-ninth spare parameter - integer
_fortieth_spare_parameter		fortieth spare parameter - integer
_forty-first_spare_parameter		forty-first spare parameter - integer
_forty-second_spare_parameter		forty-second spare parameter - integer
_forty-third_spare_parameter		forty-third spare parameter - integer
_forty-fourth_spare_parameter		forty-fourth spare parameter - integer
_forty-fifth_spare_parameter		forty-fifth spare parameter - integer
_forty-sixth_spare_parameter		forty-sixth spare parameter - integer
_forty-seventh_spare_parameter		forty-seventh spare parameter - integer
_forty-eighth_spare_parameter		forty-eighth spare parameter - integer
_forty-ninth_spare_parameter		forty-ninth spare parameter - integer
_fiftieth_spare_parameter		fiftieth spare parameter - integer
_fifty-first_spare_parameter		fifty-first spare parameter - integer
_fifty-second_spare_parameter		fifty-second spare parameter - integer
_fifty-third_spare_parameter		fifty-third spare parameter - integer
_fifty-fourth_spare_parameter		fifty-fourth spare parameter - integer
_fifty-fifth_spare_parameter		fifty-fifth spare parameter - integer
_fifty-sixth_spare_parameter		fifty-sixth spare parameter - integer
_fifty-seventh_spare_parameter		fifty-seventh spare parameter - integer
_fifty-eighth_spare_parameter		fifty-eighth spare parameter - integer
_fifty-ninth_spare_parameter		fifty-ninth spare parameter - integer
_sixtieth_spare_parameter		sixtieth spare parameter - integer
_sixty-first_spare_parameter		sixty-first spare parameter - integer
_sixty-second_spare_parameter		sixty-second spare parameter - integer
_sixty-third_spare_parameter		sixty-third spare parameter - integer
_sixty-fourth_spare_parameter		sixty-fourth spare parameter - integer
_sixty-fifth_spare_parameter		sixty-fifth spare parameter - integer
_sixty-sixth_spare_parameter		sixty-sixth spare parameter - integer
_sixty-seventh_spare_parameter		sixty-seventh spare parameter - integer
_sixty-eighth_spare_parameter		sixty-eighth spare parameter - integer
_sixty-ninth_spare_parameter		sixty-ninth spare parameter - integer
_seventieth_spare_parameter		seventieth spare parameter - integer
_seventy-first_spare_parameter		seventy-first spare parameter - integer
_seventy-second_spare_parameter		seventy-second spare parameter - integer
_seventy-third_spare_parameter		seventy-third spare parameter - integer
_seventy-fourth_spare_parameter		seventy-fourth spare parameter - integer
_seventy-fifth_spare_parameter		seventy-fifth spare parameter - integer
_seventy-sixth_spare_parameter		seventy-sixth spare parameter - integer
_seventy-seventh_spare_parameter		seventy-seventh spare parameter - integer
_seventy-eighth_spare_parameter		seventy-eighth spare parameter - integer
_seventy-ninth_spare_parameter		seventy-ninth spare parameter - integer
_eightieth_spare_parameter		eightieth spare parameter - integer
_optimizer_auto_index_allow	AUTO	Controls Auto Index
_eighty-second_spare_parameter		eighty-second spare parameter - string
_eighty-third_spare_parameter		eighty-third spare parameter - string
_eighty-fourth_spare_parameter		eighty-fourth spare parameter - string
_eighty-fifth_spare_parameter		eighty-fifth spare parameter - string
_eighty-sixth_spare_parameter		eighty-sixth spare parameter - string
_eighty-seventh_spare_parameter		eighty-seventh spare parameter - string
_eighty-eighth_spare_parameter		eighty-eighth spare parameter - string
_eighty-ninth_spare_parameter		eighty-ninth spare parameter - string
_ninetieth_spare_parameter		ninetieth spare parameter - string
_ninety-first_spare_parameter		ninety-first spare parameter - string
_ninety-second_spare_parameter		ninety-second spare parameter - string
_ninety-third_spare_parameter		ninety-third spare parameter - string
_ninety-fourth_spare_parameter		ninety-fourth spare parameter - string
_ninety-fifth_spare_parameter		ninety-fifth spare parameter - string
_ninety-sixth_spare_parameter		ninety-sixth spare parameter - string
_ninety-seventh_spare_parameter		ninety-seventh spare parameter - string
_ninety-eighth_spare_parameter		ninety-eighth spare parameter - string
_ninety-ninth_spare_parameter		ninety-ninth spare parameter - string
_one-hundredth_spare_parameter		one-hundredth spare parameter - string
_one-hundred-and-first_spare_parameter		one-hundred-and-first spare parameter - string
_one-hundred-and-second_spare_parameter		one-hundred-and-second spare parameter - string
_one-hundred-and-third_spare_parameter		one-hundred-and-third spare parameter - string
_one-hundred-and-fourth_spare_parameter		one-hundred-and-fourth spare parameter - string
_one-hundred-and-fifth_spare_parameter		one-hundred-and-fifth spare parameter - string
_one-hundred-and-sixth_spare_parameter		one-hundred-and-sixth spare parameter - string
_one-hundred-and-seventh_spare_parameter		one-hundred-and-seventh spare parameter - string
_one-hundred-and-eighth_spare_parameter		one-hundred-and-eighth spare parameter - string
_one-hundred-and-ninth_spare_parameter		one-hundred-and-ninth spare parameter - string
_one-hundred-and-tenth_spare_parameter		one-hundred-and-tenth spare parameter - string
_one-hundred-and-eleventh_spare_parameter		one-hundred-and-eleventh spare parameter - string
_one-hundred-and-twelfth_spare_parameter		one-hundred-and-twelfth spare parameter - string
_one-hundred-and-thirteenth_spare_parameter		one-hundred-and-thirteenth spare parameter - string
_one-hundred-and-fourteenth_spare_parameter		one-hundred-and-fourteenth spare parameter - string
_one-hundred-and-fifteenth_spare_parameter		one-hundred-and-fifteenth spare parameter - string
_one-hundred-and-sixteenth_spare_parameter		one-hundred-and-sixteenth spare parameter - string
_one-hundred-and-seventeenth_spare_parameter		one-hundred-and-seventeenth spare parameter - string
_one-hundred-and-eighteenth_spare_parameter		one-hundred-and-eighteenth spare parameter - string
_one-hundred-and-nineteenth_spare_parameter		one-hundred-and-nineteenth spare parameter - string
_one-hundred-and-twentieth_spare_parameter		one-hundred-and-twentieth spare parameter - string
_one-hundred-and-twenty-first_spare_parameter		one-hundred-and-twenty-first spare parameter - string
_one-hundred-and-twenty-second_spare_parameter		one-hundred-and-twenty-second spare parameter - string
_one-hundred-and-twenty-third_spare_parameter		one-hundred-and-twenty-third spare parameter - string
_one-hundred-and-twenty-fourth_spare_parameter		one-hundred-and-twenty-fourth spare parameter - string
_one-hundred-and-twenty-fifth_spare_parameter		one-hundred-and-twenty-fifth spare parameter - string
_one-hundred-and-twenty-sixth_spare_parameter		one-hundred-and-twenty-sixth spare parameter - string
_one-hundred-and-twenty-seventh_spare_parameter		one-hundred-and-twenty-seventh spare parameter - string
_one-hundred-and-twenty-eighth_spare_parameter		one-hundred-and-twenty-eighth spare parameter - string
_one-hundred-and-twenty-ninth_spare_parameter		one-hundred-and-twenty-ninth spare parameter - string
_one-hundred-and-thirtieth_spare_parameter		one-hundred-and-thirtieth spare parameter - string
ignore_session_set_param_errors		Ignore errors during alter session param set
_one-hundred-and-thirty-second_spare_parameter		one-hundred-and-thirty-second spare parameter - string list
_one-hundred-and-thirty-third_spare_parameter		one-hundred-and-thirty-third spare parameter - string list
_one-hundred-and-thirty-fourth_spare_parameter		one-hundred-and-thirty-fourth spare parameter - string list
_one-hundred-and-thirty-fifth_spare_parameter		one-hundred-and-thirty-fifth spare parameter - string list
_one-hundred-and-thirty-sixth_spare_parameter		one-hundred-and-thirty-sixth spare parameter - string list
_one-hundred-and-thirty-seventh_spare_parameter		one-hundred-and-thirty-seventh spare parameter - string list
_one-hundred-and-thirty-eighth_spare_parameter		one-hundred-and-thirty-eighth spare parameter - string list
_one-hundred-and-thirty-ninth_spare_parameter		one-hundred-and-thirty-ninth spare parameter - string list
_one-hundred-and-fortieth_spare_parameter		one-hundred-and-fortieth spare parameter - string list
_grant_unlimited_tablespace_role	FALSE	Allow UNLIMITED TABLESPACE privilege grant to database roles
_disable_inheritpriv_grant_public	FALSE	Disable inherit privilege grant to PUBLIC for newly created users
_bug29274428_modsvc_call_out_enabled	FALSE	one-hundred-and-forty-third spare parameter - boolean
_bug29394014_allow_triggers_on_vpd_table	FALSE	Allow triggers on VPD protected table in DM
_bug29386835_enable_per_container_acl	FALSE	Enable Per Container ACL
_bug29302220_tcpinfo_statistics_save_atexit	FALSE	TCP Info Statistics Save At Exit
_one-hundred-and-forty-seventh_spare_parameter	FALSE	one-hundred-and-forty-seventh spare parameter - boolean
_one-hundred-and-forty-eighth_spare_parameter	FALSE	one-hundred-and-forty-eighth spare parameter - boolean
_one-hundred-and-forty-ninth_spare_parameter	FALSE	one-hundred-and-forty-ninth spare parameter - boolean
_one-hundred-and-fiftieth_spare_parameter	FALSE	one-hundred-and-fiftieth spare parameter - boolean
_one-hundred-and-fifty-first_spare_parameter	FALSE	one-hundred-and-fifty-first spare parameter - boolean
_one-hundred-and-fifty-second_spare_parameter	FALSE	one-hundred-and-fifty-second spare parameter - boolean
_bug29903454_ksws_enable_alb	FALSE	enable ALB metrics processing
_one-hundred-and-fifty-fourth_spare_parameter	FALSE	one-hundred-and-fifty-fourth spare parameter - boolean
_one-hundred-and-fifty-fifth_spare_parameter	FALSE	one-hundred-and-fifty-fifth spare parameter - boolean
_one-hundred-and-fifty-sixth_spare_parameter	FALSE	one-hundred-and-fifty-sixth spare parameter - boolean
_one-hundred-and-fifty-seventh_spare_parameter	FALSE	one-hundred-and-fifty-seventh spare parameter - boolean
_one-hundred-and-fifty-eighth_spare_parameter	FALSE	one-hundred-and-fifty-eighth spare parameter - boolean
_one-hundred-and-fifty-ninth_spare_parameter	FALSE	one-hundred-and-fifty-ninth spare parameter - boolean
_one-hundred-and-sixtieth_spare_parameter	FALSE	one-hundred-and-sixtieth spare parameter - boolean
_one-hundred-and-sixty-first_spare_parameter	FALSE	one-hundred-and-sixty-first spare parameter - boolean
_one-hundred-and-sixty-second_spare_parameter	FALSE	one-hundred-and-sixty-second spare parameter - boolean
_one-hundred-and-sixty-third_spare_parameter	FALSE	one-hundred-and-sixty-third spare parameter - boolean
_one-hundred-and-sixty-fourth_spare_parameter	FALSE	one-hundred-and-sixty-fourth spare parameter - boolean
_one-hundred-and-sixty-fifth_spare_parameter	FALSE	one-hundred-and-sixty-fifth spare parameter - boolean
_one-hundred-and-sixty-sixth_spare_parameter	FALSE	one-hundred-and-sixty-sixth spare parameter - boolean
_one-hundred-and-sixty-seventh_spare_parameter	FALSE	one-hundred-and-sixty-seventh spare parameter - boolean
_one-hundred-and-sixty-eighth_spare_parameter	FALSE	one-hundred-and-sixty-eighth spare parameter - boolean
_one-hundred-and-sixty-ninth_spare_parameter	FALSE	one-hundred-and-sixty-ninth spare parameter - boolean
_one-hundred-and-seventieth_spare_parameter	FALSE	one-hundred-and-seventieth spare parameter - boolean
_one-hundred-and-seventy-first_spare_parameter	FALSE	one-hundred-and-seventy-first spare parameter - boolean
_one-hundred-and-seventy-second_spare_parameter	FALSE	one-hundred-and-seventy-second spare parameter - boolean
_one-hundred-and-seventy-third_spare_parameter	FALSE	one-hundred-and-seventy-third spare parameter - boolean
_one-hundred-and-seventy-fourth_spare_parameter	FALSE	one-hundred-and-seventy-fourth spare parameter - boolean
_one-hundred-and-seventy-fifth_spare_parameter	FALSE	one-hundred-and-seventy-fifth spare parameter - boolean
_one-hundred-and-seventy-sixth_spare_parameter	FALSE	one-hundred-and-seventy-sixth spare parameter - boolean
_one-hundred-and-seventy-seventh_spare_parameter	FALSE	one-hundred-and-seventy-seventh spare parameter - boolean
_one-hundred-and-seventy-eighth_spare_parameter	FALSE	one-hundred-and-seventy-eighth spare parameter - boolean
_one-hundred-and-seventy-ninth_spare_parameter	FALSE	one-hundred-and-seventy-ninth spare parameter - boolean
_one-hundred-and-eightieth_spare_parameter	FALSE	one-hundred-and-eightieth spare parameter - boolean
_one-hundred-and-eighty-first_spare_parameter	FALSE	one-hundred-and-eighty-first spare parameter - boolean
_one-hundred-and-eighty-second_spare_parameter	FALSE	one-hundred-and-eighty-second spare parameter - boolean
_one-hundred-and-eighty-third_spare_parameter	FALSE	one-hundred-and-eighty-third spare parameter - boolean
_one-hundred-and-eighty-fourth_spare_parameter	FALSE	one-hundred-and-eighty-fourth spare parameter - boolean
_one-hundred-and-eighty-fifth_spare_parameter	FALSE	one-hundred-and-eighty-fifth spare parameter - boolean
_one-hundred-and-eighty-sixth_spare_parameter	FALSE	one-hundred-and-eighty-sixth spare parameter - boolean
_one-hundred-and-eighty-seventh_spare_parameter	FALSE	one-hundred-and-eighty-seventh spare parameter - boolean
_one-hundred-and-eighty-eighth_spare_parameter	FALSE	one-hundred-and-eighty-eighth spare parameter - boolean
_one-hundred-and-eighty-ninth_spare_parameter	FALSE	one-hundred-and-eighty-ninth spare parameter - boolean
_one-hundred-and-ninetieth_spare_parameter	FALSE	one-hundred-and-ninetieth spare parameter - boolean
_one-hundred-and-ninety-first_spare_parameter	FALSE	one-hundred-and-ninety-first spare parameter - boolean
_one-hundred-and-ninety-second_spare_parameter	FALSE	one-hundred-and-ninety-second spare parameter - boolean
_one-hundred-and-ninety-third_spare_parameter	FALSE	one-hundred-and-ninety-third spare parameter - boolean
_one-hundred-and-ninety-fourth_spare_parameter	FALSE	one-hundred-and-ninety-fourth spare parameter - boolean
_one-hundred-and-ninety-fifth_spare_parameter	FALSE	one-hundred-and-ninety-fifth spare parameter - boolean
_one-hundred-and-ninety-sixth_spare_parameter	FALSE	one-hundred-and-ninety-sixth spare parameter - boolean
_one-hundred-and-ninety-seventh_spare_parameter	FALSE	one-hundred-and-ninety-seventh spare parameter - boolean
_one-hundred-and-ninety-eighth_spare_parameter	FALSE	one-hundred-and-ninety-eighth spare parameter - boolean
_one-hundred-and-ninety-ninth_spare_parameter	FALSE	one-hundred-and-ninety-ninth spare parameter - boolean
_two-hundredth_spare_parameter	FALSE	two-hundredth spare parameter - boolean
_two-hundred-and-first_spare_parameter	FALSE	two-hundred-and-first spare parameter - boolean
_two-hundred-and-second_spare_parameter	FALSE	two-hundred-and-second spare parameter - boolean
_two-hundred-and-third_spare_parameter	FALSE	two-hundred-and-third spare parameter - boolean
_two-hundred-and-fourth_spare_parameter	FALSE	two-hundred-and-fourth spare parameter - boolean
_two-hundred-and-fifth_spare_parameter	FALSE	two-hundred-and-fifth spare parameter - boolean
_two-hundred-and-sixth_spare_parameter	FALSE	two-hundred-and-sixth spare parameter - boolean
_two-hundred-and-seventh_spare_parameter	FALSE	two-hundred-and-seventh spare parameter - boolean
_two-hundred-and-eighth_spare_parameter	FALSE	two-hundred-and-eighth spare parameter - boolean
_two-hundred-and-ninth_spare_parameter	FALSE	two-hundred-and-ninth spare parameter - boolean
_two-hundred-and-tenth_spare_parameter	FALSE	two-hundred-and-tenth spare parameter - boolean
_two-hundred-and-eleventh_spare_parameter	FALSE	two-hundred-and-eleventh spare parameter - boolean
_two-hundred-and-twelfth_spare_parameter	FALSE	two-hundred-and-twelfth spare parameter - boolean
_two-hundred-and-thirteenth_spare_parameter	FALSE	two-hundred-and-thirteenth spare parameter - boolean
_two-hundred-and-fourteenth_spare_parameter	FALSE	two-hundred-and-fourteenth spare parameter - boolean
_two-hundred-and-fifteenth_spare_parameter	FALSE	two-hundred-and-fifteenth spare parameter - boolean
_two-hundred-and-sixteenth_spare_parameter	FALSE	two-hundred-and-sixteenth spare parameter - boolean
_two-hundred-and-seventeenth_spare_parameter	FALSE	two-hundred-and-seventeenth spare parameter - boolean
_two-hundred-and-eighteenth_spare_parameter	FALSE	two-hundred-and-eighteenth spare parameter - boolean
_two-hundred-and-nineteenth_spare_parameter	FALSE	two-hundred-and-nineteenth spare parameter - boolean
_two-hundred-and-twentieth_spare_parameter	FALSE	two-hundred-and-twentieth spare parameter - boolean
_ksipc_mode	0	ksipc mode
_inet_cluster_interconnects		InetTable Cluster Interconnects
_ksipc_loopback_ips		KSIPC Loopback IP addresses
_ksipc_service_level		Configure service level for clients on a per transport basis
_ksipc_window_size		Configure IPC Windowing Value for clients on a per transport basis
_ksipc_cksum_level		Configure IPC Checksum level for clients on a per transport basis
_ksipc_common_sl		Configure a single SL value for all client/transport combinations
_ksipc_service_mask	1	KSIPC Service Mask
_ksipc_heap_extent	1048576	KSIPC Heap Extent Size
_ksipc_mga_segment_size	268435456	KSIPC MGA Segment Size
_ksipc_group_sz	1024	Configure KSIPC group size
_ksipcsnsrv		Configure Shared Nothing Server Name
_ipc_aggr_limit_percentage	40	KSIPC memory as a percentage of PGA aggregate limit
_ksipc_trace_bucket	PRIVATE	memory tracing: use ksipc-private or rdbms-shared bucket
_ksipc_trace_bucket_size	IPC0:1048576-REST:8192	KSIPC trace bucket size in bytes (format: ""IPC0:<n>-REST:<m>"")
_ksipc_libipc_path		over-ride default location of libipc
_ksipc_wait_flags	0	tune ksipcwait
_ksipc_spare_param1	0	ksipc spare param 1
_ksipc_spare_param2		ksipc spare param 2
_ksipc_spare_param3	0	ksipc spare param 3
_ksipc_spare_param4	0	ksipc spare param 4
_ksipc_spare_param5	0	ksipc spare param 5
_ksipc_skgxp_library_path		over-ride default location of lib skgxp
_ksipc_skgxp_compat_library_path		over-ride default location of lib skgxp compat
_ksipc_ipclw_library_path		over-ride default location of lib ipclw
_ksipc_ipclw_enable_param		ipclw parameter enablement
_ksipc_ipclw_conn_dump	0	Configure IPCLW connection dump rate
_ksipc_ipclw_cksum_enable	0	Configure IPCLW cksum
_ksipc_ipclw_spare_param1		ksipc ipclw spare parameter 1
_ksipc_ipclw_spare_param2		ksipc ipclw spare parameter 2
_ksipc_ipclw_spare_param3		ksipc ipclw spare parameter 3
_ksipc_ipclw_spare_param4		ksipc ipclw spare parameter 4
_ksipc_ipclw_spare_param5		ksipc ipclw spare parameter 5
_ksipc_ipclw_spare_param6		ksipc ipclw spare parameter 6
_ksipc_ipclw_spare_param7		ksipc ipclw spare parameter 7
_ksipc_ipclw_spare_param8		ksipc ipclw spare parameter 8
_ksipc_aspc_enabled	FALSE	is KSIPC Address Space Support Enabled
_ksxp_send_timeout	300	set timeout for sends queued with the inter-instance IPC
_ksxp_ping_enable	TRUE	disable dynamic loadin of lib skgxp
_ksxp_ping_polling_time	0	max. arrays for ipc statistics
_ksxp_disable_dynamic_loading	FALSE	disable dynamic loadin of lib skgxp
_ksxp_disable_rolling_migration	FALSE	disable possibility of starting rolling migration
_skgxp_udp_use_tcb	TRUE	disable use of high speek timer
_ksxp_disable_ipc_stats	FALSE	disable ipc statistics
_ksxp_max_stats_bkts	0	max. arrays for ipc statistics
_ksxp_init_stats_bkts	0	initial number arrays for ipc statistics
_ksxp_stats_mem_lmt	0	limit ipc statistics memory. this parameter is a percentage value
cluster_interconnects		interconnects for RAC use
_rm_cluster_interconnects		interconnects for RAC use (RM)
_ksxp_disable_clss	0	disable CLSS interconnects
_ksxp_dump_timeout	20	set timeout for kjzddmp request
_ksxp_diagmode	OFF	set to OFF to disable automatic slowsend diagnostics
_skgxp_reaping	1000	tune skgxp OSD reaping limit
_ksxp_reaping	50	tune ksxp layer reaping limit
_ksxp_wait_flags	0	tune ksxpwait
_ksxp_lw_post_flags	0	tune ksxp post (lw)
_ksxp_control_flags	0	modify ksxp behavior
_skgxp_udp_hiwat_warn	1000	ach hiwat mark warning interval
_skgxp_udp_ach_reaping_time	120	time in minutes before idle ach's are reaped
_skgxp_udp_timed_wait_seconds	5	time in seconds before timed wait is invoked
_skgxp_udp_timed_wait_buffering	1024	diagnostic log buffering space (in bytes) for timed wait (0 means unbufferd
_skgxp_udp_keep_alive_ping_timer_secs	300	connection idle time in seconds before keep alive is initiated. min: 30 sec max: 1800 sec default: 300 sec
_disable_duplex_link	TRUE	Turn off connection duplexing
_diag_diagnostics	TRUE	Turn off diag diagnostics
_disable_interface_checking	FALSE	disable interface checking at startup
_skgxp_udp_interface_detection_time_secs	60	time in seconds between interface detection checks
_skgxp_udp_lmp_on	FALSE	enable UDP long message protection
_skgxp_udp_lmp_mtusize	0	MTU size for UDP LMP testing
_skgxp_udp_enable_dynamic_credit_mgmt	0	Enables dynamic credit management
_skgxp_udp_ack_delay	0	Enables delayed acks
_skgxp_gen_ant_ping_misscount	3	ANT protocol ping miss count
_skgxp_gen_rpc_no_path_check_in_sec	5	ANT ping protocol miss count
_skgxp_gen_rpc_timeout_in_sec	300	VRPC request timeout when ANT enabled
_skgxp_gen_ant_off_rpc_timeout_in_sec	30	VRPC request timeout when ANT disabled
_skgxp_min_zcpy_len	0	IPC threshold for zcpy operation (default = 0 - disabled)
_skgxp_min_rpc_rcv_zcpy_len	0	IPC threshold for rpc rcv zcpy operation (default = 0 - disabled)
_skgxp_zcpy_flags	0	IPC zcpy options flags
_skgxp_ctx_flags1	0	IPC debug options flags (oss)
_skgxp_ctx_flags1mask	0	IPC debug options flags mask (oss)
_skgxp_dynamic_protocol	0	IPC protocol override (!0/-1=*,2=UDP,3=RDS,0x1000=ipc_X)
_skgxp_inets		limit SKGXP networks (oss)
_ksxp_skgxp_inets		limit SKGXP networks
_skgxp_ant_options		SKGXP ANT options (oss)
_ksxp_skgxp_ant_options		SKGXP ANT options
_skgxp_rgn_ports	0	region socket limits (0xFFFFNNXX): F=flags, N=min, X=max
_ksxp_skgxp_ctx_flags1	0	IPC debug options flags (RAC)
_ksxp_skgxp_ctx_flags1mask	0	IPC debug options flags mask (RAC)
_ksxp_skgxp_dynamic_protocol	4096	IPC protocol override (RAC) (0/-1=*,2=UDP,3=RDS,!0x1000=ipc_X)
_ksxp_skgxp_rgn_ports	0	region socket limits (0xFFFFNNXX): F=flags, N=min, X=max
_ksxp_dynamic_skgxp_param		dynamic skgxp parameters
_ksxp_if_config	0	ksxp if config flags
_ksxp_exa_ip_config	0	ksxp exa ip config
_ksxp_ksmsq_ip_config	0	ksxp ksmsq ip config
_ksxp_compat_flags	0	ksxp compat flags
_ksxp_spare_param1		KSXP Spare Parameter 1
_ksxp_validate_cnh_life_cycle	0	enable validation of ksxp connection life cycle
_skgxp_spare_param1		ipc oss spare parameter 1
_ksxp_skgxp_spare_param1		ipc ksxp spare parameter 1
_skgxp_spare_param2		ipc oss spare parameter 2
_ksxp_skgxp_spare_param2		ipc ksxp spare parameter 2
_skgxp_spare_param3		ipc oss spare parameter 3
_ksxp_skgxp_spare_param3		ipc ksxp spare parameter 3
_skgxp_spare_param4		ipc oss spare parameter 4
_ksxp_xrc_cm_port		override XRC CM port
_skgxp_spare_param5		ipc oss spare parameter 5
_skgxpg_last_parameter	27	last defined skgxpg parameter - oss
_ksxp_skgxpg_last_parameter	27	last defined skgxpg parameter - ksxp
_ksxp_testing	0	KSXP test parameter
_ksxp_reporting_process	LMD0	reporting process for KSXP
_ksxp_unit_test_byte_transformation	FALSE	enable byte transformation unit test
_ksxp_ipclw_enabled	1	enable ipclw for KSXP
_ipc_config_opts_stat	0	static config for ipclw startup
_ipc_config_opts_dyn	0	Dyn config for ipclw startup
_ksipc_efchecks	3	Check HCA/OS version for Exafusion
_ksxp_save_sockets	0	Limit foreground process's sockets
_ksxp_save_sockets_pattern	*	Process pattern on which sockets saving is active
_ksxp_ipclw_ptswinsz	8	KSXP port conn send window
_ksmd_protect_mode	off	KSMD protect mode for catching stale access
_ksmd_trace	0	ksmd tracing
_ksmg_granule_size	16777216	granule size in bytes
file_mapping	FALSE	enable file mapping
_filemap_dir		FILEMAP directory
_object_statistics	TRUE	enable the object level statistics collection
_object_stats_max_entries	3072	Maximum number of entries to be tracked per stat
_datapump_conv_pga_lim	0	pga limit for Data Pump conventional path bind array size
_datapump_metadata_buffer_size	131072	specifies buffer size for metadata file I/O
_datapump_tabledata_buffer_size	262144	specifies buffer size for table data file I/O
_datapump_compressbas_buffer_size	0	specifies buffer size for BASIC compression algorithm
max_datapump_jobs_per_pdb	100	maximum number of concurrent Data Pump Jobs per PDB
max_datapump_parallel_per_job	50	maximum number of parallel processes per Data Pump Job
_datapump_gather_stats_on_load	FALSE	Gather table statistics during Data Pump load rather thanimporting statistics from the dump file. This should be set to TRUE in the lockdown profile in a DWCS environment.
service_names	orcl	service names supported by the instance
__dg_broker_service_names		service names for broker use
_enable_rlb	TRUE	enable RLB metrics processing
_enable_midtier_affinity	TRUE	enable midtier affinity metrics processing
_midtier_affinity_cluswait_prc_threshold	6	cluster wait precentage threshold to enter affinity
_midtier_affinity_goodness_threshold	2000	goodness gradient threshold to dissolve affinity
_service_cleanup_timeout	30	timeout to peform service cleanup
_disable_modsvc_refresh		disable modify service cache refresh
_max_services	8200	maximum number of database services
_kswsas_ht_log_size	7	kswsas_ht_log_size
_ksws_java_patching	999	java patching mode
_kswsas_db_svc_mapping		Map db service name to different service
_kswsas_num_jp_slaves	0	Number of slaves for java patching
_kswsas_drain_kill_batch_size	5	Batch size for killing non-drained sessions
_ksws_goodness_control	1	KSWS Goodness Control to Manually override
_kswsas_close_pdb_on_lstsvc	TRUE	Close a PDB when the last user service is stopped
_enable_plcmnt_pol_usage	FALSE	enable placement policy usage
_plcmnt_template_svc_name		service placement template name
_disable_health_check	FALSE	Disable Health Check
threaded_execution	FALSE	Threaded Execution Mode
_mpmt_enabled	FALSE	MPMT mode enabled
_mpmt_prefer_enabled	TRUE	MPMT prefer mode enabled
_mpmt_single_process_instance	FALSE	MPMT - single process instance mode enabled
_mpmt_procs_per_osp	100	max procs per osp
_mpmt_use_fthread	FALSE	MPMT - Use Fthreads
_mpmt_fthread_mode	0	MPMT - Fthreads Mode for FG/BG/ALL
_prespawn_enabled	FALSE	Is prespawn enabled
_prespawn_min_count	10	prespawn minimum count
_prespawn_batch_count	20	prespawn batch count
_prespawn_fg_init_count	0	prespawn foreground init count
_prespawn_bg_init_count	0	prespawn background init count
_proc_grp_enabled	3	proc-group enabled
_proc_grp_numa_map		proc-group map string
_spawn_diag_thresh_secs	30	thread spawn diagnostic minimal threshold in seconds
_spawn_diag_opts	0	thread spawn diagnostic options
_sched_delay_sample_interval_ms	1000	scheduling delay sampling interval in ms
_sched_delay_max_samples	4	scheduling delay maximum number of samples
_sched_delay_sample_collection_thresh_ms	200	scheduling delay sample collection duration threshold ms
_sched_delay_measurement_sleep_us	1000	scheduling delay mesurement sleep us
_sched_delay_os_tick_granularity_us	16000	os tick granularity used by scheduling delay calculations
_min_time_between_psp0_diag_secs	300	minimum time between PSP0 diagnostic used for flow control
_NUMA_float_spawner	FALSE	float process spawner
_accept_versions		List of parameters for rolling operation
_disable_rolling_patch	0	Disable Rolling Patch Feature
_rolling_patchlevel		Set Rolling Patch Level for RDBMS instance
_hang_analysis_num_call_stacks	3	hang analysis num call stacks
_local_hang_analysis_interval_secs	3	the interval at which local hang analysis is run
_deadlock_resolution_level	1	automatic deadlock resolution level
_deadlock_resolution_incidents_enabled	TRUE	create incidents during deadlock resolution
_deadlock_resolution_incidents_always	FALSE	create incidents when resolving any deadlock?
_deadlock_resolution_min_wait_timeout_secs	60	the minimum wait timeout required for deadlock resolution
_deadlock_resolution_signal_process_thresh_secs	60	the amount of time given to process a deadlock resolution signal
_heur_deadlock_resolution_secs	0	the heuristic wait time per node for deadlock resolution
_deadlock_diagnostic_level	2	automatic deadlock resolution diagnostics level
_deadlock_record_to_alert_log	TRUE	record resolved deadlocks to the alert log
_blocking_sess_graph_cache_size		blocking session graph cache size in bytes
_diag_proc_enabled	TRUE	enable hung process diagnostic API
_diag_proc_stack_capture_type	1	hung process diagnostic API stack capture type
_diag_proc_max_time_ms	30000	hung process diagnostic API max wait time in milliseconds
_hang_msg_checksum_enabled	TRUE	enable hang graph message checksum
_kspol_tac_timeout	5	timeouts for TAC registerd by kspol
_disable_12751	FALSE	disable policy timeout error (ORA-12751)
_diskmon_pipe_name		DiSKMon skgznp pipe name
_dskm_health_check_cnt	20	DiSKMon health check counter
_dskm_single_instance	FALSE	DSKM and Diskmon operating in Single Instance mode
_exadata_feature_on	FALSE	Exadata Feature On
_ksmb_debug	0	ksmb debug flags
_pmon_enable_dead_blkrs	TRUE	look for dead blockers during PMON cleanup
_pmon_dead_blkrs_scan_rate_secs	3	rate to scan for dead blockers during cleanup (in seconds)
_pmon_dead_blkrs_alive_chk_rate_secs	3	rate to check blockers are alive during cleanup (in seconds)
_pmon_dead_blkrs_max_cleanup_attempts	5	max attempts per blocker while checking dead blockers
_pmon_dead_blkrs_max_blkrs	50	max blockers to check during cleanup
_pmon_cleanup_max_dfs	100	max dfs elements during cleanup
_pmon_max_consec_posts	5	PMON max consecutive posts in main loop
_dead_process_scan_interval	60	PMON dead process scan interval (in seconds)
_main_dead_process_scan_interval	0	PMON main dead process scan interval (in seconds)
_pmon_idle_scan_interval	60	PMON idle scan interval (in seconds)
_cleanup_timeout	150	timeout value for PMON cleanup
_cleanup_timeout_flags	0	flags for PMON cleanup timeout
_pmon_min_slaves	0	Minimum number of PMON slaves
_pmon_max_slaves	10	Maximum number of PMON slaves
_pmon_slaves_arr_size	150	Array size for PMON slaves
_pmon_trees_per_slave	10	PMON cleanup: trees per slave
_pmon_new_slave_secs	30	PMON cleanup: new slave (in seconds)
_pmon_slave_stop_secs	60	PMON cleanup: slave stop limit (in seconds)
_pmon_incr_slaves	3	PMON cleanup: slave increment
_pmon_exitnfy_enabled	FALSE	PMON Exit notification enabled
_use_platform_compression_lib	TRUE	Enable platform optimized compression implementation
_use_platform_encryption_lib	TRUE	Enable platform optimized encryption implementation
_use_hybrid_encryption_mode	FALSE	Enable platform optimized encryption in hybrid mode
_xengem_diagmode	OFF	set to OFF to disable VM GEM support and functionalities
_xengem_devname	DEFAULT	override default VM GEM device name used by skgvm
_xengem_enabled	TRUE	Enable OVM GEM support
_ksmsq_hintmaxinst	1024	KSMSQ Hint Max Instances
_ksmsq_hintmaxproc	300	KSMSQ Hint Max Processes
_lthread_cleanup_intv_secs	1	interval for cleaning lightweight threads in secs
_lthread_enabled	TRUE	Enable lightweight threads
_lthread_debug	FALSE	Enable Debugging mode for lightweight threads
_lthread_max_spawn_time_csecs	12000	maximum time interval a spawner will wait for a lthread to get ready
_lthread_spawn_check_intv_ms	10	time interval for a spawner to check for spawnee to get ready
_lthread_clnup_pmon_softkill_wait_secs	1	wait timeout for PMON between soft kill and hard kill of lthreads
_lthread_clnup_spawner_sk_wait_secs	30	timeout for spawner between soft kill and hard kill of lthreads
_lthread_clnup_hk_wait_secs	3	timeout after hard killing operation for lthread to exit
_lthread_step_debugging	FALSE	Enable Step wise Debugging mode for lightweight threads
_lthread_idle_timeout_secs	600	Idle timeout in seconds for LWTs to terminate
clonedb_dir		CloneDB Directory
_maxrpop_files_inst	4	Maxmimum files rpop works on per instance
_maxrpop_instances	8	Maxmimum rpop file instances 
_use_large_pages_for_mga	FALSE	MGA largepage enabled
_use_fallocate_for_mga	FALSE	MGA fallocate enabled
_mga_large_page_path		large page path
_ksgl_max_dyn_latches	1024	Maximum number of KSGL dynamic latches
_ksgl_ltchs_held_ctxt	8	Average number of latches held per KSGL context
_ksrma_enabled	off	turn ksrma off, make it automatic, or turn on CMI or KSMSQ provider. Default is off
_ksrma_gsm_base_addr		Base Address to use for GSM
_gsm_pool_size	134217728	Global Shared Memory size
enable_dnfs_dispatcher	FALSE	Enable DNFS Dispatcher
_force_cloud_on	FALSE	simulate EHCC code path enable in Cloud Database
_cloud_service_sim	0	simulate cloud services in Database
_oracle_employee_testing	FALSE	Switch on all features for the purpose of testing
_quarantine_enabled	TRUE	quarantine: enable
_quarantine_max_objs	10000	quarantine: max number of objects
_quarantine_max_mem	1	quarantine: max amount of memory
_quarantine_per_hour	60	quarantine: limit per hour
_test_xmem_alloc_size	0	unit test xmem alloc size
_use_platform_hash_function	TRUE	control use of platform specific hash function
_dbnest_enable	NONE	dbNest enable
_instance_dbnest_name		Instance dbNest Name
_dbnest_pdb_scm_level	STRICT1	PDB SCM Level
_dbnest_pdb_fs_type	DEFAULT	PDB FS Type
_dbnest_pdb_fs_conf		PDB Filesystem configuration
_dbnest_pdb_scm_conf		PDB SCM configuration
_dbnest_stage_dir		Staging directory configuration
_capability_simulate		Simulate the capabilities for testing
_cstats_enabled	FALSE	Core stat monitoring enabled
_enable_nvm_dispatcher	FALSE	Enable NVM Dispatcher
_nvm_dispatchers	3	number of NVM Dispatcher Slaves
_nvm_dispatcher_bind_policy	1	NVM Dispatcher binding policy
_enable_tcpinfo_statistics	238	Enable TCP Info Statistics
_session_fast_lrg_prediction	FALSE	use short interval for session SO prediction
_session_prediction_interval	10080	session SO prediction interval
_session_use_periodic_prediction	TRUE	use session SO periodic prediction
_session_use_linear_prediction	TRUE	use session SO lin-reg prediction
_session_save_prediction	FALSE	save session prediction for next instance startup
_session_max_pred_increase	20000	session SO max predicted increase
_connect_string_params_after_logon_triggers	0	set connect string session parameters after logon triggers
_connect_string_params_unalterable	0	make connect string session parameters unalterable
_workload_attributes_spare_param	0	connect string workload behavior spare param
_workload_attributes		session workload attributes
_diag_daemon	TRUE	start DIAG daemon
_dump_system_state_scope	local	scope of sysstate dump during instance termination
_dump_trace_scope	global	scope of trace dump during a process crash
_dump_interval_limit	120	trace dump time interval limit (in seconds)
_dump_max_limit	5	max number of dump within dump interval
_diag_dump_timeout	30	timeout parameter for SYNC dump
_diag_dump_request_debug_level	1	DIAG dump request debug level (0-2)
_diag_crashdump_level	10	parameter for systemstate dump level, used by DIAG during crash
_full_diag_on_rim	FALSE	rim nodes have full DIA* function
_diag_large_packets	TRUE	DIA* large packets support
_hang_detection_enabled	TRUE	Hang Management detection
_hang_deadlock_resolution_enabled	TRUE	Hang Management deadlock resolution enabled
_hang_cross_boundary_hang_detection_enabled	TRUE	Hang Management Cross Boundary detection
_hang_cross_cluster_hang_detection_enabled	TRUE	Hang Management Cross Cluster detection
_hang_asm_hang_resolution_enabled	FALSE	Hang Management ASM hang resolution enabled
_hang_application_hang_resolution_enabled	FALSE	Hang Management application related hang resolution enabled
_hang_singleton_detection_rw_enabled	FALSE	Hang Management singleton detection enabled for read-write
_hang_singleton_resolution_rw_enabled	FALSE	Hang Management singleton resolution enabled for read-write
_hang_trace_interval	32	Hang Management trace interval in seconds
_hang_root_ha_phase_trigger_time	300	Hang Management root HA phase trigger time
_hang_hung_session_ewarn_percent	34	Hang Management hung session early warning percentage
_hang_max_session_hang_time	96	Hang Management maximum session hang time in seconds
_hang_hang_blocked_session_delta_percent_threshold	20	Hang Manager hang's blocked session delta percent threshold
_hang_blocked_session_percent_threshold	0	Hang Manager fast-track blocked session percent threshold
_hang_ft_min_degrading_samples_percent_threshold	60	Hang Manager fast-track minimum degrading samples threshold
_hang_resolution_scope	OFF	Hang Management hang resolution scope
_hang_allow_resolution_on_single_nonrac	FALSE	Hang Management allow resolution on single non-RAC instances
_hang_max_instance_allow_node_eviction	1	Hang Manager maximum instance count to allow node eviction
_hang_resolution_policy	HIGH	Hang Management hang resolution policy
_hang_resolution_confidence_promotion	FALSE	Hang Management hang resolution confidence promotion
_hang_resolution_global_hang_confidence_promotion	FALSE	Hang Management hang resolution global hang confidence promotion
_hang_resolution_allow_archiving_issue_termination	TRUE	Hang Management hang resolution allow archiving issue termination
_hang_resolution_promote_process_termination	TRUE	Hang Management hang resolution promote process termination
_hang_promote_process_termination_interval	70	Hang Management promote process termination interval in seconds
_hang_resolution_percent_hung_sessions_threshold	300	Hang Manager hang resolution percent hung sessions threshold
_hang_resolution_percent_hung_sessions_threshold2	5000	Hang Manager hang resolution percent hung sessions threshold2
_hang_signature_list_match_output_frequency	10	Hang Signature List matched output frequency
_hang_hang_analyze_output_hang_chains	TRUE	if TRUE hang manager outputs hang analysis hang chains
_hang_short_stacks_output_enabled	TRUE	if TRUE hang manager outputs short stacks
_hm_analysis_oradebug_sys_dump_level	0	the oradebug system state level for hang manager hang analysis
_global_hang_analysis_interval_secs	10	the interval at which global hang analysis is run
_hang_verification_interval	46	Hang Management verification interval in seconds
_hang_intersecting_chains_scanning_enabled	TRUE	Hang Management intersecting chains scanning is allowed
_hang_log_verified_hangs_to_alert	FALSE	Hang Management log verified hangs to alert log
_hang_log_io_hung_sessions_to_alert	FALSE	Hang Management log sessions hung on IO to alert log
_hang_log_important_hangs_to_alert	TRUE	Hang Management log important hangs to alert log
_hang_appl_issue_session_threshold	0	Hang Management application issue session threshold
_hang_ignored_hangs_interval	300	Time in seconds ignored hangs must persist after verification
_hang_ignored_hang_count	1	Hang Management ignored hang count
_hang_ignore_hngmtrc_interval	150	Hang Management ignore hang metric dependent hang interval
_hang_hs_hang_metrics_enabled	TRUE	Hang Management Hang Specific hang metrics enabled
_hang_metrics_recent_bitmap_threshold	50	Hang Management Hang Metric recent bitmap threshold
_hang_metrics_older_bitmap_threshold	25	Hang Management Hang Metric older bitmap threshold
_hang_monitor_archiving_related_hang_interval	300	Time in seconds ignored hangs must persist after verification
_hang_hiload_promoted_ignored_hang_count	2	Hang Management high load or promoted ignored hang count
_hang_delay_resolution_for_libcache	TRUE	Hang Management delays hang resolution for library cache
_hang_terminate_session_replay_enabled	TRUE	Hang Management terminates sessions allowing replay
_hang_long_wait_time_threshold	0	Long session wait time threshold in seconds
_hang_lws_file_count	5	Number of trace files for long waiting sessions
_hang_lws_file_space_limit	100000000	File space limit for current long waiting session trace file
_hang_base_file_count	5	Number of trace files for the normal base trace file
_hang_base_file_space_limit	100000000	File space limit for current normal base trace file
_hang_running_in_lrg	FALSE	Hang Management running in lrg
_hang_bool_spare1	TRUE	Hang Management bool 1
_hang_bool_spare2	TRUE	Hang Management bool 2
_hang_int_spare1	0	Hang Management int 1
_hang_int_spare2	0	Hang Management int 2
_hang_hiprior_session_attribute_list		Hang Management high priority session attribute list
_hang_enable_processstate	TRUE	Enable Process State Dumping
_hang_enable_nodeeviction	TRUE	Enable Hang Manager node eviction
_diag_xm_enabled	FALSE	If TRUE, DIAG allows message exchanges across DB/ASM boundary
_hm_xm_enabled	TRUE	If TRUE, DIA0 allows message exchanges across DB/ASM boundary
_trace_navigation_scope	global	enabling trace navigation linking
_max_protocol_support	10000	Max occurrence protocols supported in a process
_lm_check_ges_resource	0	GES: additional checks during resource allocation (0|1|2|3)
_lm_optmode_switch	0	GES: Optmode switching for enqueues (none, manual, stats-driven)
_lm_hash_control	1	bit field controlling the hashing behavior of the lock manager
_lm_lms	0	number of background gcs server processes to start
gcs_server_processes	0	number of background gcs server processes to start
_lm_dynamic_lms	FALSE	dynamic lms invocation
_lm_max_lms	0	max. number of background global cache server processes
_ges_server_processes	1	number of background global enqueue server processes
_lm_activate_lms_threshold	100	threshold value to activate an additional lms
_lm_lmd_waittime	8	default wait time for lmd in centiseconds
_lm_lms_waittime	3	default wait time for lms in centiseconds
_lm_procs	1088	number of client processes configured for cluster database
_lm_lms_priority_dynamic	TRUE	enable lms priority modification
_lm_lms_rt_threshold		maximum number of real time lms processes on machine
_lm_lms_opt_priority	TRUE	enable freeslot lms priority optimization
_lm_lms_priority_check_frequency	60000	frequency of LMS priority decisions in milliseconds
_lm_db_rank	6	rank of this DB for process priority purposes
_lm_db_ranks		ranks of DBs on this node
_lm_ress	6000	number of resources configured for cluster database
_lm_locks	12000	number of enqueues configured for cluster database
_lm_master_weight	1	master resource weight for this instance
active_instance_count		number of active instances in the cluster database
_active_instance_count		number of active instances in the cluster database
_active_standby_fast_reconfiguration	TRUE	if TRUE optimize dlm reconfiguration for active/standby OPS
_lm_enq_rcfg	TRUE	if TRUE enables enqueue reconfiguration
_lm_asm_enq_hashing	TRUE	if TRUE makes ASM use enqueue master hashing for fusion locks
_lm_xids	1196	number of transaction IDs configured for cluster database
_lm_res_part	128	number of resource partition configured for gcs
_lm_drm_window	0	dynamic remastering bucket window size
_lm_drm_max_requests	100	dynamic remastering maximum affinity requests processed together
_lm_drm_xlatch	0	dynamic remastering forced exclusive latches
_lm_drm_disable	0	disable drm in different level
_lm_drm_disable_kjfc	FALSE	disable drm at kjfc level
_lm_contiguous_res_count	128	number of contiguous blocks that will hash to the same HV bucket
_lm_num_pt_buckets	8192	number of buckets in the object affinity hash table
_lm_num_pt_latches	128	number of latches in the object affinity hash table
_lm_node_join_opt	FALSE	cluster database node join optimization in reconfig
_lm_no_sync	TRUE	skip reconfiguration/drm syncr/synca messaging
_lm_non_fault_tolerant	FALSE	disable cluster database fault-tolerance mode
_lm_cache_res_cleanup	25	percentage of cached resources should be cleanup
_lm_cache_allocated_res_ratio	50	ratio of cached over allocated resources 
_lm_cache_res_skip_cleanup	20	multiple of iniital res cache below which cleanup is skipped
_lm_cache_res_cleanup_tries	10	max number of batches of cached resources to free per cleanup
_lm_cache_res_type	TMHWHVDI	cache resource: string of lock types(s)
_lm_cache_enqueue		string of enqueues to cache at the client: separate by |, use DECIMAL identifiers or '*' as wildcard, eg. AK-12-*
_lm_reloc_use_mhint	FALSE	if TRUE, AR-/AH-enqueues use mastering hints
_lm_cache_lvl0_cleanup	0	how often to cleanup level 0 cache res (in sec)
_lm_cache_res_options	0	ges resource cache options
_ogms_home		GMS home directory
_lm_sync_timeout	163	Synchronization timeout for DLM reconfiguration steps
_lm_ticket_active_sendback	50	Flow control ticket active sendback threshold
_lm_rcfg_timeout	489	dlm reconfiguration timeout
_lm_rcfg_kjcdump_time	60	dlm reconfiguration communication dump interval
_lm_enq_lock_freelist		Number of ges enqueue element freelist
_lm_enqueue_freelist	3	Number of enqueue freelist
_lm_dd_interval	10	dd time interval in seconds
_lm_dd_scan_interval	5	dd scan interval in seconds
_lm_dd_search_cnt	3	number of dd search per token get
_lm_dd_max_search_time	180	max dd search time per token
_lm_dd_maxdump	50	max number of locks to be dumped during dd validation 
_lm_dd_ignore_nodd	FALSE	if TRUE nodeadlockwait/nodeadlockblock options are ignored
_lm_enqueue_blocker_dump_timeout	120	enqueue blocker dump timeout
_lm_enqueue_blocker_dump_timeout_cnt	30	enqueue blocker dump timeout count
_lm_enqueue_blocker_kill_timeout	0	enqueue blocker kill timeout
_dlmtrace		Trace string of global enqueue type(s)
_lm_tx_delta	16	TX lock localization delta
_lm_proc_freeze_timeout	70	reconfiguration: process freeze timeout
_lm_deferred_msg_timeout	163	deferred message timeout
_lm_use_new_defmsgtmo_action	TRUE	use new defered msg queue timeout action
_lm_dump_null_lock	FALSE	dump null lock in state dump
_lm_file_affinity		mapping between file id and master instance number
_lm_file_read_mostly		mapping between read-mostly file id and master instance number
_lm_enable_aff_benefit_stats	FALSE	enables affinity benefit computations if TRUE
_lm_num_bnft_stats_buckets	1	number of buckets in the benefit stats hash table
_lm_drm_banned_objs		list of objects not allowed to do drm
_lm_drm_max_banned_objs	235	maximum number of objects not allowed to do drm
_lm_share_lock_opt	TRUE	if TRUE enables share lock optimization
_lm_share_lock_pdbisolation	TRUE	if TRUE enables share lock optimization with pdb isolation
_lm_enq_iso_enabled	TRUE	if TRUE enables enqueue isolation
_lm_res_hash_bucket	0	number of resource hash buckets
_lm_res_tm_hash_bucket	0	number of extra TM resource hash buckets
_ges_diagnostics	TRUE	if TRUE enables GES diagnostics
_fair_remote_cvt	FALSE	if TRUE enables fair remote convert
_lm_rcvr_hang_check_frequency	20	receiver hang check frequency in seconds
_lm_rcvr_hang_allow_time	70	receiver hang allow time in seconds
_lm_rcvr_hang_kill	TRUE	to kill receiver hang
_lm_rcvr_hang_check_system_load	TRUE	examine system load when check receiver health
_lm_rcvr_hang_systemstate_dump_level	0	systemstate dump level upon receiver hang
_lm_rcvr_hang_cfio_kill	FALSE	to kill receiver hang at control file IO
_lm_lmon_nowait_latch	TRUE	if TRUE makes lmon get nowait latches with timeout loop
_ges_dd_debug	1	if 1 or higher enables GES deadlock detection debug diagnostics
_lm_global_posts	TRUE	if TRUE deliver global posts to remote nodes
_rcfg_parallel_replay	TRUE	if TRUE enables parallel replay and cleanup at reconfiguration
_parallel_replay_msg_limit	4000	Number of messages for each round of parallel replay
_rcfg_parallel_fixwrite	TRUE	if TRUE enables parallel fixwrite at reconfiguration
_parallel_fixwrite_bucket	1000	Number of buckets for each round of fix write
_rcfg_parallel_verify	FALSE	if TRUE enables parallel verify at reconfiguration
_rcfg_disable_verify	TRUE	if TRUE disables verify at reconfiguration
_drm_parallel_freeze	TRUE	if TRUE enables parallel drm freeze
_dump_rcvr_ipc	TRUE	if TRUE enables IPC dump at instance eviction time
_ges_health_check	0	if greater than 0 enables GES system health check
_kill_enqueue_blocker	2	if greater than 0 enables killing enqueue blocker
_lm_psrcfg	TRUE	enable pseudo reconfiguration
_lm_single_inst_affinity_lock	FALSE	enable single instance affinity lock optimization
_lm_preregister_css_restype	CF	enqueue type that requires pre-registration to css
_inquiry_retry_interval	3	if greater than 0 enables inquiry retry after specified interval
_lm_drm_object_scan	TRUE	enable/disable object scan to force full table scan always
_lm_spare_threads	0	number of spare threads to be created by the GPnP master
_lm_spare_undo	0	number of spare undo tablespaces to be created by GPnP master
_lm_rcvinst	TRUE	instance inheritance
_lm_use_gcr	TRUE	use GCR module if TRUE
_lm_use_tx_tsn	TRUE	use undo tsn affinity master as TX enqueue master
_lm_local_hp_enq	TRUE	use static file affinity for HP enqueue mastership
_lm_broadcast_res	enable_broadcast	Enable broadcast of highest held mode of resource.
_gcs_testing	0	GCS testing parameter
_gcs_pkey_history	16384	number of pkey remastering history
_lm_drm_we_size	2000	size of drm wait events statistics
_lm_drm_we_interval	60	drm wait events collection interval in seconds
_read_mostly_instance	FALSE	indicates this is a read_mostly instance
_read_mostly_instance_qa_control	0	internal parameter to control read mostly instance QA
_read_mostly_slave_timeout	20	Time to wait on read mostly node when hub not available
_read_only_slave_timeout	30	Time to wait on read only node when hub not available
_read_mostly_enable_logon	FALSE	Read mostly/ Read only  instances enable non-privileged logons
_ges_designated_master	TRUE	designated master for GES and GCS resources
_lm_big_cluster_optimizations	TRUE	enable certain big cluster optimizations in drm
_ges_lmd_mapping	*	enqueue to lmd mapping
_ges_hash_groups	*	enqueue hash table groups
_ges_default_lmds	*	default lmds for enqueue hashing
_ges_nres_divide	0	how to divide number of enqueue resources among hash tables
_lm_lms_spin	FALSE	make lms not sleep
_lm_freeze_kill_time	30	timeout for killing unfrozen processes in rcfg/drm freeze step
_lm_no_lh_check	FALSE	skip load and health check at decision points
_lm_drmopt12	56	enable drm scan optimizations in 12
_lm_drm_filters	3	enable drm filters
_lm_drm_duration_limit		set drm object duration limit (secs time/object size)
_lm_drm_duration_limit_type	2	drm object time limit type (time/size)
_lm_fdrm_stats	FALSE	gather full drm statistics
_lm_drm_filter_history_window		drm filter history window
_lm_drm_filter_history_window_type	2	drm object time limit type (time/size)
_lm_lhupd_interval	5	load and health update interval
_lm_high_load_threshold	5	high load threshold parameter
_lm_high_load_sysload_percentage	90	high watermark system load percentage
_lm_low_load_percentage	75	low watermark percentage for load threshold
_lm_drm_hiload_percentage	200	drm high load threshold percentage
_lm_drm_lowload_percentage	200	drm low load threshold percentage
_lm_drm_min_interval	600	minimum interval in secs between two consecutive drms
_lm_drm_batch_time	10	time in seconds to wait to batch drm requests
_lm_inherited_max_requests	100	maximum inherited affinity dissolve requests processed together
_lm_adrm_options	3	active drm options
_lm_adrm_scan_timeout	50	active drm f2a/flush scan timeout in centisecs
_lm_adrm_interval	300	active drm interval in centiseconds
_lm_adrm_time_out	120	active drm timeout in minutes
_lm_enqueue_timeout	360	enqueue suggested min timeout in seconds
_lm_resend_open_convert_timeout	30	timeout in secs before resubmitting the open-convert
_lm_process_lock_q_scan_limit	100	limit on scanning process lock queue instead of resource convert lock queue
_ges_direct_free	FALSE	if TRUE, free each resource directly to the freelist
_ges_resource_memory_opt	4	enable different level of ges res memory optimization
_ges_gather_res_reuse_stats	FALSE	if TRUE, gather resource reuse statistics
_ges_direct_free_res_type		string of resource types(s) to directly free to the freelist
_lm_domain_hash_buckets	64	number of buckets for the domains hash table
_ges_fggl	TRUE	DLM fg grant lock on/off
_ges_freeable_res_chunk_free	FALSE	if TRUE, free dynamic resource chunks which are freeable
_ges_freeable_res_chunk_free_interval	180	time interval for freeing freeable dynamic resource chunks
_lm_share_lock_restype		string of enqueue resource types eligible for S-optimisation
_lm_nonisolated_restype	TOTTUL	string of resource types banned from enqueue isolation
_ges_dump_open_locks	FALSE	if TRUE, dump open locks for the LCK process during shutdown
_lm_exadata_fence_type	TRUE	if FALSE disable Exadata fence type
_rond_test_mode	0	rac one node test mode
instance_mode	READ-WRITE	indicates whether the instance read-only or read-write or read-mostly
_lm_pdb_domains_enable	7	enable pdb domains in DLM
_lm_singleton_pdb_opt	TRUE	RAC PDB singleton optimization
_lm_uid_default_lookup_value	TRUE	returns the default value for uid to id translation
_lm_enable_translation	FALSE	tells if KJURN_PDBID should translate using kpdb calls
_lm_chk_inv_domenq_ops	TRUE	enable checks for invalid enqueue operations on domains
_lm_rm_object_bypass	TRUE	enable read-mostly object bypass for HARIM
_cluster_instances_number	4	number of instances to calculate number of resource buckets
_reconfiguration_opt_level	109	reconfiguration optimization level
_lm_lazy_recovery_member_timeout	300	lazy recovery member detach timeout in seconds
_lm_lazy_domain_timeout	600	lazy domain timeout in seconds
_enqueue_scan_interval	0	enqueue scan interval
_parallel_lmd_reconfig	1	parallel lmd work in reconfiguration for enqueues.
_rac_dbtype_reset	FALSE	RAC database type reset from CRS
_lm_recovery_set	1	enable recovery set checking for accessing invalid domains
_reader_farm_isolation_enable	FALSE	Reader Farm instances isolation enable
_reader_farm_isolation_time_threshold	200	reader farm isolation time threshold
_lm_wait_for_hub_rcv_timeout	300000	read-only insts wait for hub avaliable to recover in millis
_lm_pdb_wait_all_gone	FALSE	pdb domain attach wait until all locks are gone
_lm_rcvinst_sga_threshold	85	recovery buddy SGA threshold
_lm_rcvinst_atp_opt	TRUE	recovery instance optimization for ATP
_adg_distributed_lockmaster	FALSE	standby runs under ADG distributed lockmaster mode
_ges_mseq_demo	0	demo mseq wrap scenarios (dflt is 0)
__maintenance_is_planned	0	Is maintenance scheduled soon?
_defer_while_patching	0	Session should be deferred if patching is secheduled
_lm_dynamic_sga_target		dynamically adjust for changes in SGA size
_lm_better_ddvictim	TRUE	GES better deadlock victim
_kjdd_call_stack_dump_enabled	FALSE	Enables printing of short call stack with the WFG
_kjdd_wfg_dump_cntrl	0	To control the way Wait-For_Graph is dumped
_dd_validate_remote_locks	TRUE	GES deadlock detection validate remote locks
_omni_enqueue_enable	1	Enable Omni Enqueue feature (0 = disable, 1 = enable on ASM (default), 2 = enable)
_lm_omni_ack_timeout	60	Max time to wait for omni acks before triggering netcheck in secs
_dlm_stats_collect	1	DLM statistics collection(0 = disable, 1 = enable (default))
_dlm_stats_collect_mode	6	DLM statistics collection mode
_dlm_stats_collect_slot_interval	60	DLM statistics collection slot interval (in seconds)
_dlm_stats_collect_du_limit	3000	DLM statistics collection disk updates per slot
_dlm_cache_warmup_slaves	2	Number of DLM cache warm up slaves
_lm_msg_batch_size	0	GES batch message size
_lm_tickets	1000	GES messaging tickets
_lm_ticket_min	50	GES messaging tickets per instance minimum
_lm_msg_cleanup_interval	3000	GES message buffer cleanup interval time
_lm_throttle_time_interval	60	GES message throttle interval time in sec
_lm_idle_connection_check	TRUE	GES idle connection check
_lm_idle_connection_load_check	TRUE	GES idle connection load check
_lm_idle_connection_check_interval	140	GES idle connection check interval time
_lm_idle_connection_kill	TRUE	GES idle connection kill
_lm_idle_connection_kill_max_skips	1	GES idle connection max skip kill request
_lm_idle_connection_instance_check_callout	TRUE	GES idle connection instance check callout
_lm_idle_connection_quorum_threshold	50	GES idle connection health quorum threshold
_lm_idle_connection_action	kill	GES idle connection action
_lm_send_mode	auto	GES send mode
_lm_postevent_buffer_size	256	postevent buffer size
_lm_msg_pool_dump_threshold	20000	GES message pool dump threshold in terms of buffer count
_lm_msg_pool_user_callstack_dump	FALSE	GES message pool call stack dump upon exceeding of threshold
_lm_num_msg_pools_per_type	1	number of GES message pools per type
_lm_ticket_check_inject	FALSE	Inject tickets when flow control tkt leak discoverd
_lm_ticket_low_limit_warning	10	lowest number of avail tickets percentage threshold warning
_lm_kill_fg_on_timeout	TRUE	GES kill fg on IPC timeout
_lm_idle_connection_max_ignore_kill_count	2	GES maximum idle connection kill request ignore count
_lm_send_queue_length	5000	GES send queue maximum length
_lm_send_queue_batching	TRUE	GES send queue message batching
_lm_process_batching	TRUE	GES implicit process batching for IPC messages
_lm_sq_batch_factor	2	GES send queue minimum batching factor
_lm_sq_batch_type	auto	GES send queue batching mechanism
_lm_sq_batch_waittick	3	GES send queue batching waittime in tick
_lm_sendproxy_reserve	25	GES percentage of send proxy reserve of send tickets
_lm_checksum_batch_msg	0	GES checksum batch messages
_lm_batch_compression_threshold	0	GES threshold to start compression on batch messages
_lm_compression_scheme	zlib	GES compression scheme
_lm_validate_pbatch	FALSE	GES process batch validation
_lm_watchpoint_maximum	3	GES number of watchpoints
_lm_watchpoint_timeout	3600	GES maximum time in seconds to keep watchpoint
_lm_free_queue_threshold	0	GES free queue threshold
_lm_mp_avail_queue_threshold	0	GES MP avail queue threshold
_lm_mp_bulk_mbuf_free	FALSE	GES MP bulk free message buffer queues
_lm_mp_latch_trigger	4000	GES MP Latch trigger threshold for trace lines
_lm_mp_latch_trigger_soft	40000	GES MP Latch trigger threshold for soft assert
_lm_wait_pending_send_queue	TRUE	GES wait on pending send queue
_lm_hashtable_bkt_low	3	Low element threshold in hash table bucket
_lm_hashtable_bkt_high	5	High element threshold in hash table bucket
_lm_hashtable_bkt_thr	70	Threshold for hash table resizing
_lm_comm_tkts_adaptive	TRUE	Adpative ticketing enabled
_lm_comm_tkts_calc_period_length	1000	Weighted average calculation interval length (us)
_lm_comm_tkts_max_periods	10	Max number of periods used in weighted avearage calculation
_lm_comm_tkts_min_increase_wait	10	Seconds to wait before allowing an allocation increase
_lm_comm_tkts_min_decrease_wait	120	Seconds to wait before allowing an allocation decrease
_lm_comm_tkts_nullreq_threshold	1	Null request threshold
_lm_comm_tkts_mult_factor	1	Ticket allocation multiplication factor
_lm_comm_tkts_sub_factor	10	Ticket allocation subtraction factor
_lm_comm_tkts_max_add	5	Ticket allocation maximum allotments
_lm_comm_msgq_fixed_buffers	FALSE	MSGQ with fixed number of receive buffers
_lm_comm_msgq_copy_buffers	FALSE	MSGQ_DRMQ copy msgs to new buffer
_lm_comm_msgq_bufr_multiple	8	MSGQ_DRMQ multiple for maximum buffers
_lm_comm_channel	msgq	GES communication channel type
_lm_comm_msgq_busywait	0	busy wait time in microsecond for msgq
_lm_comm_reap_count	1	message reap count for receive
_lm_comm_slow_op_stat_dump_threshold	5	GES communication slow operation stat dump threshold in sec
_lm_comm_slow_op_loop_threshold	15	GES communication slow operation loop threshold in ms
_lm_comm_rcv_msg_history_slots	50	GES communication receive message history slots
_lm_comm_sync_seq_on_send_failure	TRUE	GES communication sync seq for failed sends after reconfig
_lm_tkt_leak_check_count	5	Consecutive low NULLACKs to trigger leak check
_lm_tkt_leak_check_seconds	300	Duration of leak check in seconds
_lm_gl_hash_scheme	1	group lock table hashing scheme (0|1|2)
_abort_recovery_on_join	FALSE	if TRUE, abort recovery on join reconfigurations
_send_ast_to_foreground	AUTO	if TRUE, send ast message to foreground
_reliable_block_sends	TRUE	if TRUE, no side channel on reliable interconnect
_blocks_per_cache_server	16	number of consecutive blocks per global cache server
_object_reuse_bast	2	if 1 or higher, handle object reuse
_cluster_flash_cache_slave_file		cluster flash cache slave file for default block size
_cluster_flash_cache_slave_size	0	cluster flash cache slave file size for default block size
__persistent_cl2_slave_size	0	Actual size of slave cluster flash cache for default block size
_gcs_trace_bucket	FALSE	TRUE: use GCS trace bucket and trace LOW by default, FALSE: use default bucket but trace only if enabled
_gcs_trace_bucket_size	LMS:1048576-RMV:1048576-CRV:1048576-DBW:524288	size of the GCS trace bucket in bytes (format: ""LMS:<k>-RMV:<l>-CRV:<m>-DBW:<n>"")
_lms_rollbacks	1000	Maximum number of CR rollbacks per block under LMS
_gcs_enable_private_iterator	TRUE	Enable private iterator for GCS locks
_rf_blocks_per_entity	5	number of blocks per entity
_gcs_cluster_flash_cache_persistency	FALSE	Enable cluster flash cache persistency (FALSE = disable (default), TRUE = enable
_gcs_track_reliable_block_sends	FALSE	if TRUE, track block lost on reliable interconnect
_gcs_freelists_alloc_percent	0	initial allocation of gcs freelists percentage of max usage
_send_close_with_block	TRUE	if TRUE, send close with block even with direct sends
_gcs_fast_reconfig	TRUE	if TRUE, enable fast reconfiguration for gcs locks
_cr_grant_global_role	TRUE	if TRUE, grant lock for CR requests when block is in global role
_cr_grant_local_role	AUTO	turn 3-way CR grants off, make it automatic, or turn it on
_cr_grant_only	FALSE	if TRUE, grant locks when possible and do not send the block
_skip_assume_msg	TRUE	if TRUE, skip assume message for consigns at the master
_gcs_resources	0	number of gcs resources to be allocated
_gcs_latches	128	number of gcs resource hash latches to be allocated per LMS process
_gcs_process_in_recovery	TRUE	if TRUE, process gcs requests during instance recovery
_scatter_gcs_resources	FALSE	if TRUE, gcs resources are scattered uniformly across sub pools
_gcs_res_per_bucket	4	number of gcs resource per hash bucket
_gcs_res_hash_buckets		number of gcs resource hash buckets to be allocated
_gcs_reserved_resources	400	allocate the number of reserved resources in reconfiguration
_gcs_cr_master_ping_remote	TRUE	if TRUE, cr request from master will ping the remote holder
_cr_multiblock_grant_only	FALSE	if TRUE, grant locks for multiblock read when possible and do not send the block
_gcs_partial_open_mode	0	partial open cache fusion service in reconfiguration
_gcs_dynamic_sga	FALSE	if TRUE, enable dynamic cache fusion resources in runtime
_gcs_integrity_checks	1	cache fusion integrity check level
_gcs_shadow_locks	0	number of gcs shadow locks to be allocated
_scatter_gcs_shadows	FALSE	if TRUE, gcs shadows are scattered uniformly across sub pools
_gcs_disable_remote_handles	FALSE	disable remote client/shadow handles
_gcs_disable_skip_close_remastering	FALSE	if TRUE, disable skip close optimization in remastering
_gcs_min_slaves	0	if non zero, it enables the minimum number of gcs slaves
_gcs_min_cr_slaves	0	if non zero, it enables the minimum number of gcs slaves
_gcs_dynamic_slaves	TRUE	if TRUE, it enables dynamic adjustment of the number of gcs slaves
_gcs_reserved_shadows	400	allocate the number of reserved shadows in reconfiguration
_gcs_crslave_longq_cnt	2000	long queue time threshold for cr slave
_gcs_crslave_longq_us	1000	long queue time for cr slave in microseconds
_gcs_crslave_check_time	10	time interval to check for load on cr slaves in seconds
_gcs_recoverable_asserts	1	if non-zero, enable recoverable assert resolution
_gcs_lsr_frequency	60	frequency of invoking lock state resolution in seconds
_gcs_disable_imc_preallocation	FALSE	disable preallocation for imc memory requirement in RAC
_side_channel_batch_size	240	number of messages to batch in a side channel message (DFS)
_side_channel_batch_timeout	6	timeout before shipping out the batched side channelmessages in seconds
_side_channel_batch_timeout_ms	500	timeout before shipping out the batched side channelmessages in milliseconds
_broadcast_scn_wait_timeout	10	broadcast-on-commit scn wait timeout in centiseconds
_broadcast_scn_mode	1	broadcast-on-commit scn mode
_hb_redo_msg_interval	100	BOC HB redo message interval in ms
_master_direct_sends	63	direct sends for messages from master (DFS)
_read_mostly_lock_mitigation	TRUE	Read Mostly Lock mitigation support
_nameservice_consistency_check	TRUE	NameService Consistency check switch
_nameservice_request_batching	TRUE	NameService request batching switch
_cgs_send_timeout	300	CGS send timeout value
_cgs_ticket_sendback	50	CGS ticket active sendback percentage threshold
_cgs_msg_batch_size	4096	CGS message batch size in bytes
_cgs_msg_batching	TRUE	CGS message batching
_cgs_comm_readiness_check	1	CGS communication readiness check
_imr_active	TRUE	Activate Instance Membership Recovery feature
_imr_max_reconfig_delay	75	Maximum Reconfiguration delay (seconds)
_imr_splitbrain_res_wait	0	Maximum wait for split-brain resolution (seconds)
_imr_disk_voting_interval	3	Maximum wait for IMR disk voting (seconds)
_imr_systemload_check	TRUE	Perform the system load check during IMR
_imr_device_type	controlfile	Type of device to be used by IMR
_imr_highload_threshold		IMR system highload threshold
_imr_evicted_member_kill	TRUE	IMR issue evicted member kill after a wait
_imr_evicted_member_kill_wait	20	IMR evicted member kill wait time in seconds
_imr_avoid_double_voting	TRUE	Avoid device voting for CSS reconfig during IMR
_imr_diskvote_implementation	auto	IMR disk voting implementation method
_imr_extra_reconfig_wait	10	Extra reconfiguration wait in seconds
_imr_controlfile_access_wait_time	10	IMR controlfile access wait time in seconds
_imr_rr_holder_kill_time	300	IMR max time instance is allowed to hold RR lock in seconds
_imr_check_css_incarnation_number	TRUE	IMR verify the global consistency of CSS incarnation number
_imr_rim_mount_device	FALSE	Enable rim instances to mount IMR device driver
_imr_largest_hub_membership	TRUE	IMR will derive the largest hub membership from available votes
_imr_non_blocking_device_driver	TRUE	Use the Non Blocking IMR Device Driver Implementation
_imr_dd_slave_wait_time	30	IMR max time LMON will wait for slave response in seconds
_imr_mount_retry_wait_time	20	IMR mount retry wait time (seconds)
_imr_remount_retry_wait_time	60	IMR remount retry wait time in (seconds)
_cluster_library	clss	cluster library selection
_cgs_reconfig_timeout	0	CGS reconfiguration timeout interval
_cgs_node_kill_escalation	TRUE	CGS node kill escalation to CSS
_cgs_node_kill_escalation_wait	0	CGS wait time to escalate node kill to CSS in seconds
_cgs_zombie_member_kill_wait	20	CGS zombie member kill wait time in seconds
_cgs_reconfig_extra_wait	3	CGS reconfiguration extra wait time for CSS in seconds
_cgs_health_check_in_reconfig	FALSE	CGS health check during reconfiguration
_cgs_memberkill_from_rim_instance	FALSE	allow a RIM instance to issue a CSS member kill
_cgs_os_level_connection_check	1	allow OS level connection and interface check
_cgs_os_level_connection_reqno	0	number of ping rqst to process at once, threads created
_cgs_os_level_connection_dynamicthread	TRUE	allow oraping to spawn more threads than the default.
_cgs_combine_css_events	7	CGS registration flags for CSS event combining
_cgs_publish_netinfo_collect_event_haip	TRUE	enable cgs publish collect_netinfo event to event stream for HAIP
_cgs_publish_netinfo_collect_event_chm	rcfg-half-timeout,rcfg-timeout,rcfg-done,idleconn-half-timeout,idleconn-timeout-imr,idleconn-cln	enable cgs publish collect_netinfo event to event stream for CHM
_cgs_tickets	1000	CGS messaging tickets
_cgs_dball_group_registration	local	CGS DBALL group registration type
_cgs_dbgroup_poll_time	600	CGS DB group polling interval in milli-seconds
_cgs_allgroup_poll_time	20000	CGS DBALL group polling interval in milli-seconds
_cgs_big_group_enabled	FALSE	big group membership support
_cgs_support_rim_disc	TRUE	rim instance disconnect and reconnect event support
_ipc_switch_reconfig_needed	FALSE	to trigger a ipc switch reconfiguration
_lm_dynamic_load	TRUE	dynamic load adjustment
_lm_rm_slaves	1	number of remastering slaves
_lm_sp_slaves	0	number of sendproxy slaves
_lm_timed_statistics_level	0	if non zero, it enables timed statistics on lmd and lms
_shutdown_sync_enable	TRUE	if TRUE, shutdown sync is issued before shutdown normal
_lm_lms_no_yield	FALSE	if TRUE, LMS will not yield in spin mode
_lm_max_lms_block_time	5	max blocking time allowed on LMS (sec)
_lm_sndq_flush_int	5	send queue flush time interval (ms)
_lm_watchpoint_kjmddp		list of kjmddp fields for memory watchpoint
_rmv_dynamic_priority	TRUE	enable rmv priority modification
_lm_use_us_timer	FALSE	Use microsecond timer for LM hist
_notify_crs	TRUE	notify cluster ready services of startup and shutdown
_crs_2phase	block	crs 2phase
_kill_diagnostics_timeout	60	timeout delay in seconds before killing enqueue blocker
_ges_diagnostics_asm_dump_level	11	systemstate level on global enqueue diagnostics blocked by ASM
_ges_num_blockers_to_kill	1	number of blockers to be killed for hang resolution
_ges_vbfreelists	0	number of valueblock freelists (will be adjusted to power of 2)
_lm_hb_callstack_collect_time	5	hb diagnostic call stack collection time in seconds
_lm_hb_callstack_collect_time_long	60	extended hb diagnostic call stack collection time in seconds
_lm_hb_disable_check_list	ARC*	list of process names to be disabled in heartbeat check
_lm_hb_enable_acl_check	TRUE	to enable the wait analysis with acceptable condition lists
_lm_hb_acceptable_hang_condition	default	list of acceptable hang conditions in heartbeat check
_lm_hb_maximum_hang_report_count	20	maximum heartbeat hang report count
_lm_hb_exponential_hang_time_factor	2	heartbeat exponential hang time multiplier
_lm_hb_cfio_timeout	70	control file io timeout in seconds
_lm_hb_per_proc_timeout	default	heartbeat timeout
_lm_hb_per_proc_behavior	default	heartbeat behavior
_lm_hb_timeout_extension		heartbeat timeout extension in seconds
_lm_hwc_disabled	FALSE	to disable handle with care behavior
_lmhb_procstate_dump_runtime_limit	60	hb diagnostic runtime limit for process state dump in secs
_lmhb_procstate_dump_cputime_limit	60	hb diagnostic cputime limit for process state dump in secs
_hang_statistics_collection_interval	15	Hang Management statistics collection interval in seconds
_hang_statistics_collection_ma_alpha	30	Hang Management statistics collection moving average alpha
_hang_statistics_high_io_percentage_threshold	25	Hang Management statistics high IO percentage threshold
_gcr_enable_high_cpu_kill	FALSE	if TRUE, GCR may kill foregrounds under high load
_gcr_enable_high_memory_kill	FALSE	if TRUE, GCR may kill foregrounds under high memory load
_gcr_enable_high_cpu_rm	TRUE	if TRUE, GCR may enable a RM plan under high load
_gcr_enable_high_cpu_rt	TRUE	if TRUE, GCR may boost bg priority under high load
_gcr_high_cpu_threshold	10	minimum amount of CPU process must consume to be kill target
_gcr_high_memory_threshold	10	minimum amount of Memory process must consume to be kill target
_gcr_min_free_memory_hard_limit	1073741824	 hard limit for minimum free memory,for high memory systems
_gcr_cpu_min_hard_limit	2560	hard limit for min free CPU to flag high CPU
_gcr_cpu_min_free	10	minimum amount of free CPU to flag an anomaly
_gcr_mem_min_free	10	minimum amount of free memory to flag an anomaly
_gcr_use_css	TRUE	if FALSE, GCR wont register with CSS nor use any CSS feature
_gcr_css_use_2group_lock	TRUE	if FALSE, GCR will not try to lock 2 CSS groups at the same time
_gcr_css_group_try_lock_delay		minimum delay between group locking attempts, secs
_gcr_css_group_query_boost		allowed number of serial multiple queries
_gcr_css_group_update_interval		interval between CSS group updates, secs
_gcr_css_group_update2_interval		interval between CSS group updates when busy, secs
_gcr_css_group_large		size of large CSS group above which query/update disabled
_gcr_tick		duration of time tick used by state machine, centisecs
_gcr_enable_statistical_cpu_check	TRUE	if FALSE, revert to old cpu load metric
_gcr_enable_new_drm_check	FALSE	if FALSE, revert to old drm load metric
_gcr_max_rt_procs		maximum number of RT DLM processes allowed by GCR
_gcr_enable_kill_inst_diags	FALSE	if TRUE, GCR will collect OS diags prior to kill instance
_increase_lms_process	0	modifying this hidden parameter, will modify the numberof lms process by the valueof this parameter
_size_of_log_table	30	modifying this hidden parameter, will modify the sizeof the v$gcr_log table
_size_of_status_table	100	modifying this hidden parameter, will modify the sizeof the v$gcr_status table
_gcr_dump_cpu_consumers	FALSE	if TRUE, enable dumps of CPU consumers
_gcr_cpu_consumer_dump_level	0	level of process dump performed for CPU consumers
_kjac_force_outcome_current_session	FALSE	if TRUE, enable to run force outcome on the current session
_lm_rac_spare_p1	0	rac parameter p1
_lm_rac_spare_p2	0	rac parameter p2
_lm_rac_spare_p3	0	rac parameter p3
_lm_rac_spare_p4	0	rac parameter p4
_lm_rac_spare_p5	0	rac parameter p5
_lm_rac_spare_p6		rac parameter p6
_lm_rac_spare_p7		rac parameter p7
_lm_rac_spare_p8		rac parameter p8
_lm_rac_spare_p9		rac parameter p9
_lm_rac_spare_p10		rac parameter p10
_lm_rac_spare_dp1	0	rac parameter dp1
_lm_rac_spare_dp2	0	rac parameter dp2
_lm_rac_spare_dp3	0	rac parameter dp3
_lm_rac_spare_dp4	0	rac parameter dp4
_lm_rac_spare_dp5	0	rac parameter dp5
_lm_rac_spare_dp6		rac parameter dp6
_lm_rac_spare_dp7		rac parameter dp7
_lm_rac_spare_dp8		rac parameter dp8
_lm_rac_spare_dp9		rac parameter dp9
_lm_rac_spare_dp10		rac parameter dp10
_lm_rac_spare_p11	0	rac parameter p11
_lm_rac_spare_p12	0	rac parameter p12
_lm_rac_spare_p13	0	rac parameter p13
_lm_rac_spare_p14		rac parameter p14
_lm_rac_spare_p15		rac parameter p15
_lm_rac_spare_p16		rac parameter p16
_ka_enabled	FALSE	Enable/disable kernel accelerator
_ka_mode	0	kernel accelerator mode
_ka_locks_per_sector	4	locks per sector in kernel accelerator
_ka_msg_reap_count	40	maximum number of KA messages to receive and process per wait
_ka_compatibility_requirement	all	kernel accelerator compatibility operation requirement
_ka_allow_reenable	FALSE	reenability of kernel accelerator service after disable
_ka_pbatch_messages	TRUE	kernel accelerator perform pbatch messages
_ka_doorbell	0	kernel accelerator doorbell mode
_ka_scn_enabled	FALSE	KA SCN processing enabled
_ka_scn_accel_shrmem	TRUE	KA SCN accelerate shr memory
_ka_scn_use_ka_msgs	TRUE	KA SCN use KA type messages
_ka_grant_policy	AUTO	KA grant policy to favor fusion grant, make it automatic, or favor KA
_ka_msg_wait_count	20	KA maximum number of requests to retrieve per OSD wait
_ka_max_wait_delay	1000	KA maximum amount of time before forcing OSD wait call
_kjlton	FALSE	track DLM latch usage on/off
_kjltmaxgt	1000	record latch requests that takes longer than this many us
_kjltmaxht	1000	record latch reqeust that are held longer than this many us
_ipddb_enable	FALSE	Enable IPD/DB data collection
_gcs_cluster_flash_cache_mode	0	cluster flash cache mode
_gcs_flash_cache_mode	0	flash cache mode
_node_instcnt_average_interval	1800	node inst count average interval in seconds
_node_instcnt_sample_frequency	60	node inst count average sample frequency in seconds
_node_instcnt_update_frequency	300	node inst count average global update frequency in seconds
_high_priority_node_instcnt_cap	FALSE	disable high priority lms when node inst count exceeds cap
sga_target	2415919104	Target size of SGA
__sga_target	2415919104	Actual size of SGA
memory_target	0	Target size of Oracle SGA and PGA memory
memory_max_target	0	Max size for Memory Target
_disable_streams_pool_auto_tuning	FALSE	disable streams pool auto tuning
_sga_shrink_allow	FALSE	Allow SGA shrink operation
_sga_grow_batch_size	2147483648	Dynamic SGA grow batch size
_memory_management_tracing	0	trace memory management activity
_memory_mgmt_immreq_timeout	150	time in seconds to time out immediate mode request
_memory_checkinuse_timeintv	30	check inuse time interval
_memory_mgmt_fail_immreq	FALSE	always fail immediate mode request
_memory_sanity_check	0	partial granule sanity check
_init_granule_interval	10	number of granules to process for deferred cache
_shared_pool_max_size	0	shared pool maximum size when auto SGA enabled
_shared_pool_minsize_on	FALSE	shared pool minimum size when auto SGA enabled
_streams_pool_max_size	0	streams pool maximum size when auto SGA enabled
_simulate_mem_transfer	FALSE	simulate auto memory sga/pga transfers
_memory_nocancel_defsgareq	FALSE	do not cancel deferred sga reqs with auto-memory
_memory_imm_mode_without_autosga	TRUE	Allow immediate mode without sga/memory target
_max_defer_gran_xfer_atonce	10	Maximum deferred granules transferred by MMAN atonce
_asm_allow_small_memory_target	FALSE	Allow a small memory_target for ASM instances
_memory_broker_stat_interval	30	memory broker statistics gathering interval for auto sga
_automemory_broker_interval	3	memory broker statistics gathering interval for auto memory
_memory_broker_shrink_heaps	15	memory broker allow policy to shrink shared pool
_memory_broker_shrink_java_heaps	900	memory broker allow policy to shrink java pool
_memory_broker_shrink_streams_pool	900	memory broker allow policy to shrink streams pool
_memory_broker_shrink_timeout	60000000	memory broker policy to timeout shrink shared/java pool
_memory_broker_log_stat_entries	5	memory broker num stat entries
_memory_initial_sga_split_perc	60	Initial default sga target percentage with memory target
_memory_broker_marginal_utility_sp	7	Marginal Utility threshold pct for sp
_memory_broker_marginal_utility_bc	12	Marginal Utility threshold pct for bc
_memory_broker_sga_shrink_chunked	TRUE	if TRUE, break a large sga shrink request to chunks
_memory_broker_sga_shrink_chunk_size	20	if kmgsbshnkbrk set, sga request resize chunk size in granules.
_memory_broker_sga_grow_split	TRUE	if TRUE, allow sga grow to be split between cache and sp
_memory_broker_sga_grow_splitif_size	20	split sga target grow if atleast this many granules.
_dump_scn_increment_stack		Dumps scn increment stack per session
_big_scn_test_mode	2	testing mode for BigSCN
control_files	+DATA/ORCL/CONTROLFILE/current.261.1022020449	control file names list
_controlfile_enqueue_timeout	900	control file enqueue timeout in seconds
_controlfile_enqueue_holding_time	120	control file enqueue max holding time in seconds
_controlfile_enqueue_holding_time_tracking_size	0	control file enqueue holding time tracking size
_controlfile_update_check	OFF	controlfile update sanity check
_controlfile_enqueue_dump	FALSE	dump the system states after controlfile enqueue timeout
_controlfile_block_size	0	control file block size in bytes
_controlfile_section_init_size		control file initial section size
_controlfile_section_max_expand		control file max expansion rate
db_file_name_convert		datafile name convert patterns and strings for standby/clone db
log_file_name_convert		logfile name convert patterns and strings for standby/clone db
control_file_record_keep_time	7	control file record keep time in days
_kill_controlfile_enqueue_blocker	TRUE	enable killing controlfile enqueue blocker on timeout
_controlfile_backup_copy_check	TRUE	enable check of the copied blocks during controlfile backup copy
_controlfile_cell_flash_caching	3	Flash cache hint for control file accesses
_controlfile_split_brain_check	TRUE	Check for a split-brain in distributed lock manager domain
_controlfile_auto_convert_behaviour	AUTO_CONVERT	controlfile auto convert behavior for a mixed platform dataguard.
_controlfile_verify_on_mount	FALSE	Verify control file blocks on header error during mount
db_block_buffers	0	Number of database blocks cached in memory
_db_block_buffers	76362	Number of database blocks cached in memory: hidden parameter
_db_block_cache_protect	false	protect database blocks (for debugging only)
_db_block_cache_protect_internal	0	protect database blocks (for internal use only)
db_block_checksum	TYPICAL	store checksum in db blocks and check during reads
db_ultra_safe	OFF	Sets defaults for other parameters that control protection levels
db_block_size	8192	Size of database block in bytes
_dbwr_tracing	0	Enable dbwriter tracing
_tsenc_tracing	0	Enable TS encryption tracing
_disable_multiple_block_sizes	FALSE	disable multiple block size support (for debugging)
_db_fast_obj_truncate	TRUE	enable fast object truncate
_db_fast_obj_ckpt	TRUE	enable fast object checkpoint
_enable_obj_queues	TRUE	enable object queues
_db_obj_enable_ksr	TRUE	enable ksr in object checkpoint/reuse
_small_table_threshold	1527	lower threshold level of table size for direct reads
_very_large_object_threshold	500	upper threshold level of object size for direct reads
_dbwr_async_io	TRUE	Enable dbwriter asynchronous writes
_recovery_percentage	50	recovery buffer cache percentage
_db_lost_write_checking	2	Enable scn based lost write detection mechanism
_db_lost_write_tracing	FALSE	Enable _db_lost_write_checking tracing
__db_cache_size	603979776	Actual size of DEFAULT buffer pool for standard block size buffers
db_cache_size	0	Size of DEFAULT buffer pool for standard block size buffers
_db_block_numa	1	Number of NUMA nodes
db_2k_cache_size	0	Size of cache for 2K buffers
db_4k_cache_size	0	Size of cache for 4K buffers
db_8k_cache_size	0	Size of cache for 8K buffers
db_16k_cache_size	0	Size of cache for 16K buffers
db_32k_cache_size	0	Size of cache for 32K buffers
db_keep_cache_size	0	Size of KEEP buffer pool for standard block size buffers
db_recycle_cache_size	0	Size of RECYCLE buffer pool for standard block size buffers
memoptimize_pool_size	0	Size of cache for imoltp buffers
__shared_io_pool_size	83886080	Actual size of shared IO pool
_shared_io_pool_size	83886080	Size of shared IO pool
_db_hot_block_tracking	FALSE	track hot blocks for hash latch contention
_db_block_bad_write_check	FALSE	enable bad write checks
db_big_table_cache_percent_target	0	Big table cache target size in percentage
_db_full_db_cache_diff_pct	5	Cache at least this % larger than DB size for full db caching
_db_cache_xmem_size	0	Size of extended memory data area for buffer cache DEFAULT pool
__db_cache_xmem_size_metadata	0	Size of extended memory metadata of DEFAULT buffer pool for standard block size buffers
_db_keep_cache_xmem_size	0	Size of KEEP buffer pool for standard block size buffers on extended memory
__db_keep_cache_xmem_size_metadata	0	Size of extended cache metadata of KEEP buffer pool for standard block size buffers
_db_recycle_cache_xmem_size	0	Size of Recycle buffer pool for standard block size buffers on extended memory
__db_recycle_cache_xmem_size_metadata	0	Size of extended memory metadata of recycle buffer pool for standard block size buffers
_db_2k_cache_xmem_size	0	Size of 2k buffer pool on extended memory
__db_2k_cache_xmem_size_metadata	0	Size of extended cache metadata for 2k buffer pool
_db_4k_cache_xmem_size	0	Size of 4k buffer pool on extended cache
__db_4k_cache_xmem_size_metadata	0	Size of extended cache metadata for 4k buffer pool
_db_8k_cache_xmem_size	0	Size of 8k buffer pool on extended cache
__db_8k_cache_xmem_size_metadata	0	Size of extended cache metadata for 8k buffer pool
_db_16k_cache_xmem_size	0	Size of 16k buffer pool on extended cache
__db_16k_cache_xmem_size_metadata	0	Size of extended cache metadata for 16k buffer pool
_db_32k_cache_xmem_size	0	Size of 32k buffer pool on extended memory
__db_32k_cache_xmem_size_metadata	0	Size of extended cache metadata for 32k buffer pool
_memoptimize_xmem_pool_size	0	Size of MEMOPTIMIZE buffer pool for standard block size buffers on extended memory
__memoptimize_xmem_pool_size_metadata	0	Size of extended cache metadata of MEMOPTIMIZE buffer pool for standard block size buffers
encrypt_new_tablespaces	CLOUD_ONLY	whether to encrypt newly created tablespaces
_disable_system_tablespaces_enc_enforcement	FALSE	if TRUE, disable system tablespaces encryption enforcement
_cell_object_expiration_hours	24	flashcache object expiration timeout
_db_block_lru_latches	27	number of lru latches
_db_percpu_create_cachesize	2	size of cache created per cpu in deferred cache create
_db_initial_cachesize_create_mb	256	size of cache created at startup
_db_num_evict_waitevents	64	number of evict wait events
_db_todefer_cache_create	TRUE	buffer cache deferred create
_db_minimum_auxsize_percent	10	min percent of aux buffers to be maintained before using aux2
_db_imoltp_hashidx_force_nonctg	0	kcbw imoltp hash index force non contig granules
db_writer_processes	1	number of background database writer  processes to start
_db_block_known_clean_pct	2	Initial Percentage of buffers to maintain known clean
_db_block_max_scan_pct	40	Percentage of buffers to inspect when looking for free
_db_large_dirty_queue	25	Number of buffers which force dirty queue to be written
_db_writer_max_writes	0	Max number of outstanding DB Writer IOs
_db_writer_chunk_writes	0	Number of writes DBWR should wait for
_db_block_med_priority_batch_size	0	Fraction of writes for medium priority reasons
_db_block_hi_priority_batch_size	0	Fraction of writes for high priority reasons
_db_writer_histogram_statistics	FALSE	maintain dbwr histogram statistics in x$kcbbhs
_dbwr_scan_interval	300	dbwriter scan interval
_db_writer_flush_imu	TRUE	If FALSE, DBWR will not downgrade IMU txns for AGING
_db_writer_coalesce_write_limit	131072	Limit on size of coalesced write
_db_writer_coalesce_encrypted_buffers	TRUE	Coalecsing for encrypted buffers
_db_writer_coalesce_area_size	4194304	Size of memory allocated to dbwriter for coalescing writes
_db_writer_nomemcopy_coalesce	FALSE	Enable DBWR no-memcopy coalescing
_selftune_checkpoint_write_pct	3	Percentage of total physical i/os for self-tune ckpt
_db_writer_verify_writes	FALSE	Enable lost write detection mechanism
_dbwr_stall_write_detection_interval	900	dbwriter stall write detection interval
_dbwr_flashlock_shrink_limit	0	limit to shrink le to flash lock per dbwr iteration
_enable_dbwr_auto_tracing	0	enable dbwriter auto-tracing
_dbwr_nowrite_assert_interval	7200	dbwriter assert interval after no write seconds
_dbwr_nwp_assert_interval	1800	dbwriter no write permission assert interval after no write seconds
_remessage_dbwrs	0	DBWR wait and remessage time - in cs
_db_block_prefetch_quota	10	Prefetch quota as a percent of cache size
_db_block_prefetch_wasted_threshold_perc	2	Allowed wasted percent threshold of prefetched size
_db_block_prefetch_limit	0	Prefetch limit in blocks
_db_block_prefetch_override	0	Prefetch force override in blocks
_rbr_ckpt_tracing	0	Enable reuse block range checkpoint tracing
_db_cache_pre_warm	TRUE	Buffer Cache Pre-Warm Enabled : hidden parameter
buffer_pool_keep		Number of database blocks/latches in keep buffer pool
buffer_pool_recycle		Number of database blocks/latches in recycle buffer pool
_db_percent_hot_default	50	Percent of default buffer pool considered hot
_db_percent_hot_keep	0	Percent of keep buffer pool considered hot
_db_percent_hot_recycle	0	Percent of recycle buffer pool considered hot
_db_aging_hot_criteria	2	Touch count which sends a buffer to head of replacement list
_db_xmem_hot_switch_criteria	4	Xmem buffer touch count which makes this buffer candidate of switching to DRAM buffer
_db_aging_stay_count	0	Touch count set when buffer moved to head of replacement list
_db_aging_cool_count	1	Touch count set when buffer cooled
_db_aging_touch_time	3	Touch count which sends a buffer to head of replacement list
_db_aging_freeze_cr	FALSE	Make CR buffers always be too cold to keep in cache
_db_block_hash_buckets	262144	Number of database block hash buckets
_db_block_hash_latches	2048	Number of database block hash latches
_db_blocks_per_hash_latch		Number of blocks per hash latch
_db_handles_cached	10	Buffer handles cached each process
_db_handles	3000	System-wide simultaneous buffer operations
_wait_for_sync	TRUE	wait for sync on commit MUST BE ALWAYS TRUE
_db_block_vlm_check	FALSE	check for mapping leaks (debugging only)
_db_block_vlm_leak_threshold	4	threshold for allowable mapping leaks
_db_block_trace_protect	FALSE	trace buffer protect calls
_db_flash_cache_slow_io_adjustment_interval	3600	Decrement interval
_db_cache_miss_check_les	FALSE	check LEs after cache miss
_db_block_max_cr_dba	6	Maximum Allowed Number of CR buffers per dba
_write_clones	3	write clones flag
_db_cache_silicon_secured_memory	TRUE	enable silicon secured memory
_check_block_after_checksum	TRUE	perform block check after checksum if both are turned on
_trace_pin_time	FALSE	trace how long a current pin is held
_pin_time_statistics	FALSE	if TRUE collect statistics for how long a current pin is held
_db_fast_obj_check	FALSE	enable fast object drop sanity check
_db_block_temp_redo	FALSE	generate redo for temp blocks
_db_block_adjchk_level	0	adjacent cache buffer check level
_db_block_adjcheck	TRUE	adjacent cache buffer checks - low blkchk overwrite parameter
_db_required_percent_fairshare_usage	10	percent of fairshare a processor group should always use
_db_block_check_objtyp	TRUE	check objd and typ on cache disk read
_db_block_do_full_mbreads	FALSE	do full block read even if some blocks are in cache
_shared_iop_max_size	134217728	maximum shared io pool size
_shared_io_pool_buf_size	1048576	Shared IO pool buffer size
_siop_flashback_scandepth	20	Shared IO pool flashback io completion scan depth
_shared_io_pool_debug_trc	0	trace kcbi debug info to tracefile
_shared_io_set_value	FALSE	shared io pool size set internal value - overwrite zero user size
_trace_buffer_wait_timeouts	0	trace buffer busy wait timeouts
_buffer_busy_wait_timeout	100	buffer busy wait time in centiseconds
_influx_scn_wait_timeout	1	active dataguard influx scn wait time in centiseconds
_influx_scn_waits	100000	active dataguard influx scn maximum waits
_db_cache_crx_check	FALSE	check for costly crx examination functions
_db_cache_mman_latch_check	FALSE	check for wait latch get under MMAN ops in kcb
_db_block_cache_history_lru	FALSE	buffer header tracing for lru operations
_db_flash_cache_encryption	FALSE	Set _db_flash_cache_encryption to enable flash cache encryption
_db_xmem_cache_encryption	TRUE	Set _db_xmem_cache_encryption to enable XMEM cache encryption
_db_block_header_guard_level	0	number of extra buffer headers to use as guard pages
_db_block_table_scan_buffer_size	4194304	Size of shared table scan read buffer
_db_cache_process_cr_pin_max	2147483647	maximum number of cr pins a process may have
_db_block_corruption_recovery_threshold	5	threshold number of block recovery attempts
_db_block_chunkify_ncmbr	FALSE	chunkify noncontig multi block reads
_db_cache_wait_debug	0	trace new kslwaits
_db_full_caching	TRUE	enable full db implicit caching
_fastpin_enable	1	enable reference count based fast pins
_bps_sanity_checks	FALSE	enable BPS sanity checks
_db_prefetch_histogram_statistics	FALSE	maintain prefetch histogram statistics in x$kcbprfhs
_flush_undo_after_tx_recovery	TRUE	if TRUE, flush undo buffers after TX recovery
_enable_buffer_header_history	TRUE	if TRUE, records operation history in buffer headers
_db_block_iterations_for_rm	2000	number of blocks to reduce every iteration for RM
_db_block_scandepth_for_rm	20	number of blocks to reduce every iteration for RM
_spare_test_parameter	0	Spare test parameter
db_flash_cache_file		flash cache file for default block size
db_flash_cache_size	0	flash cache size for db_flash_cache_file
_db_2k_flash_cache_file		flash cache file for 2k block size
_db_2k_flash_cache_size	0	flash cache size for _db_2k_flash_cache_file
_db_4k_flash_cache_file		flash cache file for 4k block size
_db_4k_flash_cache_size	0	flash cache size for _db_4k_flash_cache_file
_db_8k_flash_cache_file		flash cache file for 8k block size
_db_8k_flash_cache_size	0	flash cache size for _db_8k_flash_cache_file
_db_16k_flash_cache_file		flash cache file for 16k block size
_db_16k_flash_cache_size	0	flash cache size for _db_16k_flash_cache_file
_db_32k_flash_cache_file		flash cache file for 32k block size
_db_32k_flash_cache_size	0	flash cache size for _db_32k_flash_cache_file
_db_flash_cache_keep_limit	80	Flash cache keep buffer upper limit in percentage
_db_flash_cache_write_limit	1	Flash cache write buffer upper limit in percentage
_db_flash_cache_force_replenish_limit	8	Flash cache force replenish lower limit in buffers
_db_l2_tracing	0	flash cache debug tracing
_db_flash_cache_max_read_retry	3	Flash cache max read retry
_db_flash_cache_max_latency	400	Flash cache maximum latency allowed in 10 milliseconds
_db_flash_cache_max_slow_io	3	Flash cache maximum slow io allowed
_db_flash_cache_max_outstanding_writes	32	Flash cache maximum outstanding writes allowed
_db_flash_cache_disable_write_batchsize	4096	Flash cache disable writes processing batchsize
_db_dump_from_disk_and_efc	0	dump contents from disk and efc
_numa_buffer_cache_stats	0	Configure NUMA buffer cache stats
_switch_current_scan_scn	TRUE	switch current uses scan scn
_cleanout_shrcur_buffers	TRUE	if TRUE, cleanout shrcur buffers
_avoid_scn_growth	1	enable scn growth optimizations
_fast_cr_clone	TRUE	enable fast cr clone feature
_clone_during_split	TRUE	if TRUE, clone buffer during index split
_db_cache_block_read_stack_trace	0	dump short call stack for block reads
_child_read_ahead_dba_check	FALSE	if TRUE, assert child read ahead dba to be continuous of parent
_data_warehousing_scan_buffers	TRUE	if TRUE, enable data warehousing scan buffers
_data_warehousing_scan_flash_buffers	FALSE	if TRUE, enable data warehousing scan flash buffers
_data_warehousing_serial_scan	TRUE	if TRUE, enable data warehousing serial scans
_db_dw_scan_obj_cooling_policy	CACHE_SIZE	DW scan objtect cooling policy
_db_dw_scan_obj_cooling_interval	100	DW Scan object cooling interval in number of scans, seconds, or pct of cache size
_db_dw_scan_obj_cooling_factor	500	DW Scan object cooling factor to cool all temperatures
_db_dw_scan_obj_warming_increment	1000	DW Scan object warming increment when an object is scanned
_db_dw_scan_adaptive_cooling	FALSE	if TRUE, enable adaptive DW scan cooling
_db_dw_scan_max_shadow_count	5	DW Scan adaptive cooling max shadow count
_pq_numa_working_set_affinity	TRUE	if TRUE, enable pq slave NUMA affinity
_db_bt_cache_only_readmostly_obj_on_roi	FALSE	if TRUE, ABTC only caches read mostly objects on ROI
_auto_bmr_noretry_window	1800	Auto BMR NoRetry Window
_sga_clear_dump	FALSE	Allow dumping encrypted blocks in clear for debugging
_clear_buffer_before_reuse	FALSE	Always zero-out buffer before reuse for security
_disable_adp_adj_buf_check	FALSE	No adjacent buffer check for ADP
_db_cache_block_read_stack_trace_where1	0	dump short call stack for block reads just for where1
_db_cache_block_read_stack_trace_where2	0	dump short call stack for block reads just for where2
_db_cache_block_read_stack_trace_where3	0	dump short call stack for block reads just for where3
_override_datafile_encrypt_check	FALSE	if TRUE, override datafile tablespace encryption cross check
_disable_data_block_check_after_decrypt	FALSE	if TRUE, disable data block check after decryption
_assert_encrypted_tablespace_blocks	TRUE	if TRUE, assert encrypted tablespace blocks must be encrypted
_verify_encrypted_tablespace_keys	TRUE	if TRUE, verify encryption key signature for data files
_tablespace_encryption_default_algorithm	AES128	default tablespace encryption block cipher mode
_inject_simulated_error_period	131072	if non-zero, inject IO error once every param_value times
db_cache_advice	ON	Buffer cache sizing advisory
_db_cache_advice_sample_factor	4	cache advisory sampling factor
_db_cache_advice_max_size_factor	2	cache advisory maximum multiple of current size to similate
_db_cache_advice_sanity_check	FALSE	cache simulation sanity check
_db_cache_advice_hash_latch_multiple	16	cache advisory hash latch multiple
_db_mttr_advice	ON	MTTR advisory
_db_mttr_sim_target		MTTR simulation targets
_db_mttr_sample_factor	64	MTTR simulation sampling factor
_db_mttr_partitions	0	number of partitions for MTTR advisory
_db_mttr_sim_trace_size	256	MTTR simulation trace size
_db_mttr_trace_to_alert	FALSE	dump trace entries to alert file
_obj_ckpt_tracing	0	Enable object checkpoint tracing
_immediate_commit_propagation	TRUE	if TRUE, propagate commit SCN immediately
_external_scn_rejection_threshold_hours	24	Lag in hours between max allowed SCN and an external SCN
_c3_external_scn_rejection_threshold_hours	4464	Lag in hours between max allowed SCN and an external SCN
_max_reasonable_scn_rate	32768	Max reasonable SCN rate
_external_scn_logging_threshold_seconds	86400	High delta SCN threshold in seconds
_external_scn_rejection_delta_threshold_minutes	0	external SCN rejection delta threshold in minutes
_low_scn_headroom_warning_threshold_days	90	low SCN headroom warning threshold in days
_high_intrinsic_scn_growth_alert	1440	high intrinsic SCN growth rate alert time in minutes
compatible	19.0.0	Database will be completely compatible with this software version
_redo_compatibility_check	FALSE	general and redo/undo compatibility sanity check
_db_block_check_for_debug	FALSE	Check more and dump block before image for debugging
_db_always_check_system_ts	TRUE	Always perform block check and checksum for System tablespace
_skip_unconverted_change_vector	FALSE	Skip apply of a CV that has no endian conversion function
_log_checkpoint_recovery_check	0	# redo blocks to verify after checkpoint
_two_pass	TRUE	enable two-pass thread recovery
_recovery_verify_writes	FALSE	enable thread recovery write verify
_disable_recovery_read_skip	FALSE	Disable the read optimization during media recovery
_buddy_instance	1	buddy instance control
_buddy_instance_start_rba_timeout	9	Time-out for re-computing Start RBA in Buddy Instance feature
_buddy_instance_num_read_buffers	4	Num of Read Buffers to scan everytime in Buddy Instance feature
_buddy_instance_scan_phase_threshold	3	Threshold (in secs) to let RMS0 construct the recovery set
_instance_recovery_bloom_filter_size	83886080	Bloom filter size (in num of bits) used during claim phase
_instance_recovery_bloom_filter_fprate	0	Allowable false positive percentage [0-100]
_fatalprocess_redo_dump_time_limit	0	time limit, in secs, for diagnostic redo dumps by a fatal process
_nonfatalprocess_redo_dump_time_limit	3600	time limit, in secs, for diagnostic redo dumps by a non-fatal process
_redo_transport_stream_writes	TRUE	Stream network writes?
_redo_transport_stream_test	TRUE	test stream connection?
_redo_transport_vio_size_req	1048576	VIO size requirement
log_archive_dest_1		archival destination #1 text string
log_archive_dest_2		archival destination #2 text string
log_archive_dest_3		archival destination #3 text string
log_archive_dest_4		archival destination #4 text string
log_archive_dest_5		archival destination #5 text string
log_archive_dest_6		archival destination #6 text string
log_archive_dest_7		archival destination #7 text string
log_archive_dest_8		archival destination #8 text string
log_archive_dest_9		archival destination #9 text string
log_archive_dest_10		archival destination #10 text string
log_archive_dest_11		archival destination #11 text string
log_archive_dest_12		archival destination #12 text string
log_archive_dest_13		archival destination #13 text string
log_archive_dest_14		archival destination #14 text string
log_archive_dest_15		archival destination #15 text string
log_archive_dest_16		archival destination #16 text string
log_archive_dest_17		archival destination #17 text string
log_archive_dest_18		archival destination #18 text string
log_archive_dest_19		archival destination #19 text string
log_archive_dest_20		archival destination #20 text string
log_archive_dest_21		archival destination #21 text string
log_archive_dest_22		archival destination #22 text string
log_archive_dest_23		archival destination #23 text string
log_archive_dest_24		archival destination #24 text string
log_archive_dest_25		archival destination #25 text string
log_archive_dest_26		archival destination #26 text string
log_archive_dest_27		archival destination #27 text string
log_archive_dest_28		archival destination #28 text string
log_archive_dest_29		archival destination #29 text string
log_archive_dest_30		archival destination #30 text string
log_archive_dest_31		archival destination #31 text string
log_archive_dest_state_1	enable	archival destination #1 state text string
log_archive_dest_state_2	enable	archival destination #2 state text string
log_archive_dest_state_3	enable	archival destination #3 state text string
log_archive_dest_state_4	enable	archival destination #4 state text string
log_archive_dest_state_5	enable	archival destination #5 state text string
log_archive_dest_state_6	enable	archival destination #6 state text string
log_archive_dest_state_7	enable	archival destination #7 state text string
log_archive_dest_state_8	enable	archival destination #8 state text string
log_archive_dest_state_9	enable	archival destination #9 state text string
log_archive_dest_state_10	enable	archival destination #10 state text string
log_archive_dest_state_11	enable	archival destination #11 state text string
log_archive_dest_state_12	enable	archival destination #12 state text string
log_archive_dest_state_13	enable	archival destination #13 state text string
log_archive_dest_state_14	enable	archival destination #14 state text string
log_archive_dest_state_15	enable	archival destination #15 state text string
log_archive_dest_state_16	enable	archival destination #16 state text string
log_archive_dest_state_17	enable	archival destination #17 state text string
log_archive_dest_state_18	enable	archival destination #18 state text string
log_archive_dest_state_19	enable	archival destination #19 state text string
log_archive_dest_state_20	enable	archival destination #20 state text string
log_archive_dest_state_21	enable	archival destination #21 state text string
log_archive_dest_state_22	enable	archival destination #22 state text string
log_archive_dest_state_23	enable	archival destination #23 state text string
log_archive_dest_state_24	enable	archival destination #24 state text string
log_archive_dest_state_25	enable	archival destination #25 state text string
log_archive_dest_state_26	enable	archival destination #26 state text string
log_archive_dest_state_27	enable	archival destination #27 state text string
log_archive_dest_state_28	enable	archival destination #28 state text string
log_archive_dest_state_29	enable	archival destination #29 state text string
log_archive_dest_state_30	enable	archival destination #30 state text string
log_archive_dest_state_31	enable	archival destination #31 state text string
log_archive_start	FALSE	start archival process on SGA initialization
log_archive_dest		archival destination text string
log_archive_duplex_dest		duplex archival destination text string
log_archive_min_succeed_dest	1	minimum number of archive destinations that must succeed
_arch_sim_mode	0	Change behavior of local archiving
_dg_corrupt_redo_log	0	Corrupt redo log validation during archivals
_local_arc_assert_on_wait	FALSE	Assert whenever local ORL arch waits for space
_defer_eor_orl_arch_for_so	TRUE	defer EOR ORL archival for switchover
fal_client		FAL client
fal_server		FAL server list
_enable_ffw	TRUE	FAL FORWARDING
log_archive_trace	0	Establish archive operation tracing level
_log_archive_trace_pids		log archive trace pids parameter
_redo_transport_sanity_check	0	redo transport sanity check bit mask
_fix_fuzzy_scn	FALSE	fix fuzzy SCN
_dg_cf_check_timer	15	Data Guard controlfile check timer
_bypass_srl_for_so_eor	FALSE	bypass SRL for S/O EOR logs
_redo_transport_redo_log_management		redo log management
_rta_sync_wait_timeout	10	RTA sync wait timeout
_log_archive_prot_auto_demote	FALSE	log archive protection auto demotion
_serialize_lgwr_sync_io	FALSE	Serialize LGWR SYNC local and remote io
data_guard_sync_latency	0	Data Guard SYNC latency
_mgd_rcv_handle_orphan_datafiles	FALSE	Managed recovery handle orphan datafile situation
_standby_auto_flashback	TRUE	Standby automatic flashback when primary flashed back
_real_time_apply_sim	0	Simulation value with real time apply
_defer_rcv_during_sw_to_sby	FALSE	Defer recovery during switchover to standby
_skip_trstamp_check	TRUE	Skip terminal recovery stamp check
_show_mgd_recovery_state	FALSE	Show internal managed recovery state
log_archive_config		log archive config
_log_archive_buffers	10	Number of buffers to allocate for archiving
_redo_transport_compress_all	TRUE	Is ASYNC LNS compression allowed?
_rtc_infeasible_threshold	25	Redo Transport Compression infeasible threshold
log_archive_format	%t_%s_%r.dbf	archival destination format
data_guard_max_io_time	240	maximum I/O time before process considered hung
data_guard_max_longio_time	240	maximum long I/O time before process considered hung
_disable_thread_snapshot	TRUE	Thread snapshot
_redo_log_record_life	168	Life time in hours for redo log table records
_redo_log_debug_config	0	Various configuration flags for debugging redo logs
_redo_log_check_backup	10	time interval in minutes between wakeups to check backup of redo logs
_log_archive_avoid_memcpy	TRUE	log archive avoid memcpy
_async_rta_broadcast	FALSE	asynchronously broadcast RTA boundary
_rtabnd_update_offload	TRUE	RFS process offload RTA boundary update
_redo_transport_async_mode	0	redo transport ASYNC process mode
_log_archive_strong_auth	TRUE	log archive security strong auth
_redo_transport_max_kbytes_sec	0	redo transport maximum KB/s
_redo_transport_min_kbytes_sec	10	redo transport minimum KB/s
_redo_transport_catch_up_bandwidth_percentage	50	redo transport catch up bandwitdth percent
_redo_transport_resource_management	FALSE	Redo transport resource management
redo_transport_user		Data Guard transport user when using password file
_lgwr_ns_nl_min	500	Variable to simulate network latency or buffer threshold
_lgwr_ns_nl_max	1000	Variable to simulate network latency or buffer threshold
_redo_transport_stall_time	360	use parameter DATA_GUARD_MAX_IO_TIME
_redo_transport_stall_time_long	3600	use parameter DATA_GUARD_MAX_LONGIO_TIME
log_archive_max_processes	4	maximum number of active ARCH processes
_max_lns_shutdown_archival_time	30	Maximum time spent by LNS to archive last log during shutdown
_ta_lns_wait_for_arch_log	20	LNS Wait time for archived version of ORL
_lgwr_max_ns_wt	1	Maximum wait time for lgwr to allow NetServer to progress
_ns_max_flush_wt	1	Flush wait time for NetServer to flush oustanding writes
_ns_max_send_delay	15	Data Loss Time Bound for NetServer
_lgwr_ta_sim_err	0	Variable to simulate errors lgwr true async
_lgwr_ns_sim_err	0	Variable to simulate errors lgwrns
_log_archive_network_redo_size	10	Log archive network redo buffer size used by ARCH
_switchover_to_standby_switch_log	FALSE	Switchover to standby switches log for open redo threads
_max_async_wait_for_catch_up	20	Switchover wait time for async LNS to catch up in seconds
_redo_transport_evict_threshold	10	Threshold beyond which a slower ASYNC connection will be evicted
_num_rlslaves	6	number of rl slaves to clear orls
_lgwr_delay_write	FALSE	LGWR write delay for debugging
_enable_redo_global_post	FALSE	LGWR post globally on write
_cache_orl_during_open	ALL	cache online logs
_image_redo_gen_delay	0	Image redo generation delay in centi-seconds (direct write mode)
_simulate_dax_storage	DISABLE	Simulate log on DAX storage
log_buffer	7307264	redo circular buffer size
_log_silicon_secured_memory	TRUE	enable silicon secured memory (log)
_target_log_write_size	0	Do log write if this many redo blocks in buffer (auto=0)
_target_log_write_size_timeout	0	How long LGWR will wait for redo to accumulate (msecs)
_target_log_write_size_spinwait	0	How long LGWR spins to waits for target write size blocks
_target_log_write_size_percent_for_poke	100	Ask LGWR to write if strand has this % of target write size blocks
log_checkpoint_interval	0	# redo blocks checkpoint threshold
log_checkpoint_timeout	1800	Maximum time interval between checkpoints in seconds
_log_switch_timeout	0	Maximum number of seconds redos in the current log could span
archive_lag_target	0	Maximum number of seconds of redos the standby could lose
_log_buffers_debug	FALSE	debug redo buffers (slows things down)
_log_buffers_corrupt	FALSE	corrupt redo buffers before write
_log_simultaneous_copies	6	number of simultaneous copies into redo buffer(# of copy latches)
_use_single_log_writer	ADAPTIVE	Use a single process for redo log writing
_max_outstanding_log_writes	2	Maximum number of outstanding redo log writes
_log_write_worker_task_prefetch	EARLY	Log write worker prefetches tasks
_log_write_worker_task_spinwait	0	How long log write workers spin wait for imminent tasks
_log_write_worker_post_spinwait	0	How long log write workers spin wait before posting FGs
_adaptive_scalable_log_writer_enable_worker_threshold	200	Increase in redo generation rate as a percentage
_adaptive_scalable_log_writer_disable_worker_threshold	50	Percentage of overlap across multiple outstanding writes
_adaptive_scalable_log_writer_sampling_count	128	Evaluate single versus scalable LGWR every N writes
_adaptive_scalable_log_writer_sampling_time	3	Evaluate single versus scalable LGWR every N seconds
_adaptive_scalable_log_writer_enable_worker_aging	999900	Per million of redo gen rate when LGWR workers were last used
_log_parallelism_max	2	Maximum number of log buffer strands
_log_parallelism_dynamic	TRUE	Enable dynamic strands
_max_log_write_parallelism	1	Maximum parallelism within a log write (auto=0)
_lost_write_parallelism_change_tracking	2	Maximum number of lost write change tracking buffers
_serial_log_write_worker_io	FALSE	Serialize log write worker I/O
_parallel_log_write_cleanup	FALSE	Perform (null) log write cleanup in parallel
_log_private_parallelism_mul	10	Active sessions multiplier to deduce number of private strands
_log_private_mul	5	Private strand multiplier for log space preallocation
_lightweight_hdrs	TRUE	Lightweight headers for redo
_redo_read_from_memory	TRUE	Enable reading redo from in-memory log buffer
_desired_readmem_rate	90	The desired percentage of redo reading from memory
_log_read_buffer_size	8	buffer size for reading log files
_validate_readmem_redo	HEADER_ONLY	validate redo blocks read from in-memory log buffer
_mirror_redo_buffers	FALSE	Save buffers for debugging redo corruptions
_fg_log_checksum	TRUE	Checksum redo in foreground process
_verify_fg_log_checksum	FALSE	LGWR verifies redo checksums generated by foreground processes
_disable_logging	FALSE	Disable logging
_simulated_log_write_usecs	0	Simulated latency of log writes (usecs)
_log_buffer_coalesce	FALSE	Coalescing log buffers for log writes
_redo_write_coalesce_all_threshold	0	Redo write coalescing threshold (all strands) in bytes
_redo_write_coalesce_slave_threshold	0	Redo write coalescing threshold (slave strands) in bytes
_redo_write_sync_single_io	TRUE	enable sync I/O for single redo write
_fg_sync_sleep_usecs	0	Log file sync via usleep
_fg_fast_sync_sleep_usecs	0	DAX log file sync sleep time
_fg_fast_sync_spin_usecs	300	DAX log file sync spin time
_fg_fast_sync_slack_usecs	1	DAX log file sync sleep slack time
_fg_fast_sync_sleep_target_pct	50	DAX log file sync sleep target pct
_log_file_sync_timeout	10	Log file sync timeout (centiseconds)
_use_adaptive_log_file_sync	TRUE	Adaptively switch between post/wait and polling
_adaptive_log_file_sync_use_polling_threshold	200	Ratio of redo synch time to expected poll time as a percentage
_adaptive_log_file_sync_use_postwait_threshold	50	Percentage of foreground load from when post/wait was last used
_adaptive_log_file_sync_use_postwait_threshold_aging	1001	Permille of foreground load from when post/wait was last used
_adaptive_log_file_sync_sampling_count	128	Evaluate post/wait versus polling every N writes
_adaptive_log_file_sync_sampling_time	3	Evaluate post/wait versus polling every N seconds
_adaptive_log_file_sync_sched_delay_window	60	Window (in seconds) for measuring average scheduling delay
_adaptive_log_file_sync_poll_aggressiveness	0	Polling interval selection bias (conservative=0, aggressive=100)
_adaptive_log_file_sync_high_switch_freq_threshold	3	Threshold for frequent log file sync mode switches (per minute)
_max_pending_scn_bcasts	9	maximum number of pending SCN broadcasts
_lgwr_posts_for_pending_bcasts	FALSE	LGWR posts commit waiters for pending broadcasts
_long_log_write_warning_threshold	500	threshold for long log write warning messages in ms
_long_bcast_ack_warning_threshold	500	threshold for long bcast ack warning messages in ms
_enable_flash_logging	TRUE	Enable Exadata Smart Flash Logging
_check_pdbid_in_redo	FALSE	Enable checking of pluggable database ID in redo
_log_write_info_size	4096	Size of log write info array
_cache_fusion_pipelined_updates	TRUE	Block ping without wait for log force
_rac_propagate_last_rba	TRUE	Propagate last written log redo address in RAC for log mining
_log_writer_worker_dlm_hearbeat_update_freq	5000	LGWR worker DLM health-monitoring heartbeat update frequency (ms)
_hb_redo_interval	1000	generic heartbeat redo frequency
db_files	200	max allowable # db files
db_file_multiblock_read_count	128	db block to be read each IO
_db_file_exec_read_count	128	multiblock read count for regular clients
_db_file_optimizer_read_count	8	multiblock read count for regular clients
_db_file_noncontig_mblock_read_count	11	number of noncontiguous db blocks to be prefetched
read_only_open_delayed	FALSE	if TRUE delay opening of read only files until first access
cluster_database	FALSE	if TRUE startup in cluster database mode
cluster_database_instances	1	number of instances to use for sizing cluster db SGA structures
db_create_file_dest	+DATA	default database location
db_create_online_log_dest_1		online log/controlfile destination #1
db_create_online_log_dest_2		online log/controlfile destination #2
db_create_online_log_dest_3		online log/controlfile destination #3
db_create_online_log_dest_4		online log/controlfile destination #4
db_create_online_log_dest_5		online log/controlfile  destination #5
db_recovery_file_dest	/u01/fra	default database recovery file location
db_recovery_file_dest_size	21474836480	database recovery files size limit
_db_recovery_temporal_file_dest		default database recovery temporal file location
standby_file_management	MANUAL	if auto then files are created/dropped automatically on standby
_standby_switchover_timeout	120	Number of secords for standby switchover enqueue timeout
_hard_protection	FALSE	if TRUE enable H.A.R.D specific format changes
_datafile_cow	FALSE	Use copy on write snapshot for the renamed file
_max_filestat_tries	10	maximum number of file stat tries
_disable_file_resize_logging	FALSE	disable file resize logging to alert log
_file_set_enqueue_timeout	1200	Timeout to acquire file set enqueue (secs)
_file_offline_sync_timeout	900	Timeout to sync file offline enqueue (secs)
_allow_error_simulation	FALSE	Allow error simulation for testing
_roi_first_open_wait	120	duration of ROI first open wait for RWI open
_db_file_format_io_buffers	4	Block formatting I/O buf count
_disable_read_only_open_dict_check	FALSE	Disable read-only open dictionary check
_standby_flush_mode	SLFLUSH	standby flush mode
_causal_standby_wait_timeout	20	Causal standby wait timeout
_online_file_conversion_batchsize	16	Online datafile move/conversion sync batchsize
_gc_undo_affinity	TRUE	if TRUE, enable undo affinity
_gc_disable_s_lock_brr_ping_check	TRUE	if TRUE, disable S lock BRR ping check for lost write protect
_gc_policy_time	20	how often to make object policy decisions in minutes
_gc_policy_rm_dirty_percent	1	percent of cache which can be dirty for readmostly
_gc_policy_minimum	1500	dynamic object policy minimum activity per minute
_gc_affinity_ratio	50	dynamic object affinity ratio
_gc_transfer_ratio	75	dynamic object read-mostly transfer ratio
_gc_anti_lock_ratio	66	dynamic object anti-lock ratio
_recovery_asserts	FALSE	if TRUE, enable expensive integrity checks
_gc_vector_read	TRUE	if TRUE, vector read current buffers
_gc_element_percent	105	global cache element percent
_gc_latches	32	number of latches per LMS process
_gc_keep_recovery_buffers	TRUE	if TRUE, make recovery buffers current
_gc_keep_undo_recovery_buffers	TRUE	if TRUE, make recovery undo buffers current
_recovery_read_limit	1024	number of recovery reads which can be outstanding
_gc_dump_remote_lock	TRUE	if TRUE, dump remote lock
_gc_drm_windows	8	number of DRM windows
_gc_defer_time	0	how long to defer pings for hot buffers in microseconds
_gc_defer_ping_index_only	TRUE	if TRUE, restrict deferred ping to index blocks only
_gc_delay_ping	TRUE	if TRUE, delay pings to hot blocks
_kcl_debug	TRUE	if TRUE, record le history
_kcl_index_split	TRUE	if TRUE, reject pings on blocks in middle of a split
_fairness_threshold	2	number of times to CR serve before downgrading lock
_gc_interconnect_checksum	FALSE	if TRUE, checksum interconnect blocks
_cr_server_log_flush	TRUE	if TRUE, flush redo log before serving a CR buffer
_gc_log_flush	TRUE	if TRUE, flush redo log before a current block transfer
_async_recovery_reads	TRUE	if TRUE, issue recovery reads asynchronously
_async_recovery_claims	TRUE	if TRUE, issue recovery claims asynchronously
_bwr_for_flushed_pi	TRUE	if TRUE, generate a BWR for a flushed PI
_send_requests_to_pi	TRUE	if TRUE, try to send CR requests to PI buffers
_gc_check_bscn	TRUE	if TRUE, check for stale blocks
_gc_global_lru	AUTO	turn global lru off, make it automatic, or turn it on
_gc_global_lru_touch_count	5	global lru touch count
_gc_global_lru_touch_time	60	global lru touch time in seconds
_gc_statistics	TRUE	global cache statistics level
_gc_coalesce_recovery_reads	TRUE	if TRUE, coalesce recovery reads
_gc_global_checkpoint_scn	TRUE	if TRUE, enable global checkpoint scn
_gc_undo_block_disk_reads	TRUE	if TRUE, enable undo block disk reads
_gc_affinity_locking	TRUE	if TRUE, enable object affinity
_gc_affinity_locks	TRUE	if TRUE, get affinity locks
_gc_read_mostly_locking	TRUE	if TRUE, enable read-mostly locking
_gc_persistent_read_mostly	TRUE	if TRUE, enable persistent read-mostly locking
_gc_bypass_readers	TRUE	if TRUE, modifications bypass readers
_gc_max_downcvt	2048	maximum downconverts to process at one time
_gc_fusion_compression	1024	compress fusion blocks if there is free space
_gc_down_convert_after_keep	TRUE	if TRUE, down-convert lock after recovery
_gc_flush_during_affinity	TRUE	if TRUE, flush during affinity
_gc_cr_server_read_wait	TRUE	if TRUE, cr server waits for a read to complete
_gc_read_mostly_flush_check	FALSE	if TRUE, optimize flushes for read mostly objects
_gc_override_force_cr	TRUE	if TRUE, try to override force-cr requests
_gc_bg_merge	TRUE	if TRUE, merge pi buffers in the background
_gc_fg_merge	TRUE	if TRUE, merge pi buffers in the foreground
_gc_first_dirty_merge	TRUE	if TRUE, merge with a pi after first dirty
_gc_no_fairness_for_clones	TRUE	if TRUE, no fairness if we serve a clone
_gc_sanity_check_cr_buffers	FALSE	if TRUE, sanity check CR buffers
_gc_save_cleanout	TRUE	if TRUE, save cleanout to apply later
_gc_temp_affinity	FALSE	if TRUE, enable global temporary affinity
_gc_fg_spin_time	0	foreground msgq spin time
_gc_object_queue_max_length	0	maximum length for an object queue
_gc_async_send	TRUE	if TRUE, send blocks asynchronously
_gc_async_receive	FALSE	if TRUE, receive blocks asynchronously
_gc_try_to_skip_imc_flush	TRUE	if TRUE, try to skip an imc populate flush
_gc_msgq_buffers	0	set number of MSGQ buffers
_gc_serve_from_flash_cache	FALSE	if TRUE, try to serve a flash cache buffer
_gc_trace_freelist_empty	FALSE	if TRUE, dump a trace when we run out of lock elements
_gc_skip_undo_disk_read	TRUE	if TRUE, skip the disk read for undo blocks
_gc_blocking_pins	FALSE	if TRUE, record a histogram of blocking pins
_gc_trace_blocking_pins	FALSE	if TRUE, trace blocking pins
_gc_enable_cr_bypass	TRUE	if TRUE, enable CR bypass mechanism
_gc_numa_lock_elements	FALSE	if TRUE, numa aware lock element distribution
_gc_buckets_per_latch	0	number of hash buckets per latch
_gc_integrity_checks	1	set the integrity check level
_light_work_rule_debug	FALSE	if TRUE, light work rule debugging is enabled
_gc_fast_index_split_wait	0	fast index split wait usn array size
_gc_max_reg_sz	68719476736	maximum length for memory registration
_gc_partial_cleanout	TRUE	if TRUE, partial cleanout is enabled
_gc_undo_rdma_read	FALSE	if TRUE, rdma read of undo blocks is enabled
_gc_lease_time	10000	lease time for rdma reads
_gc_spin_time	16	rdma spin time
_gc_xmem_rdma	FALSE	if TRUE, xmem blocks rdma read is enabled
_adaptive_direct_read	TRUE	Adaptive Direct Read
_adaptive_direct_write	TRUE	Adaptive Direct Write
_db_block_align_direct_read	TRUE	Align Direct Reads
_db_noarch_disble_optim	FALSE	Image redo logging (NOARCHIVEMODE)
_db_disable_temp_encryption	FALSE	Disable Temp Encryption for Spills
db_unrecoverable_scn_tracking	TRUE	Track nologging SCN in controlfile
_kcbl_assert_reset_slot	TRUE	assert slot state in kcblResetSlot
_direct_io_slots	0	number of slots for direct path I/O
_direct_io_skip_cur_slot_on_error	TRUE	Skip current slot on error
_direct_io_wslots	0	number of write slots for direct path I/O
thread	0	Redo thread to mount
_thread_state_change_timeout_pnp	1800	Thread state change timeout for PnP instance (in sec)
_disable_incremental_checkpoints	FALSE	Disable incremental checkpoints for thread recovery
_disable_thread_internal_disable	FALSE	Disable thread internal disable feature
_disable_selftune_checkpointing	FALSE	Disable self-tune checkpointing
_selftune_checkpointing_lag	300	Self-tune checkpointing lag the tail of the redo log
_target_rba_max_lag_percentage	81	target rba max log lag percentage
_no_recovery_through_resetlogs	FALSE	no recovery through this resetlogs operation
enabled_PDBs_on_standby	*	List of Enabled PDB patterns
_auto_rekey_during_mrcv	TRUE	enable automatic rekey during media recovery
_auto_rcv_pdb_open	1	enable automatic recovery during pdb open
fast_start_io_target	0	Upper bound on recovery reads
fast_start_mttr_target	0	MTTR target in seconds
_log_blocks_during_backup	TRUE	log block images when changed during backup
_allow_resetlogs_corruption	FALSE	allow resetlogs even if it will cause corruption
_allow_terminal_recovery_corruption	FALSE	Finish terminal recovery even if it may cause corruption
_allow_read_only_corruption	FALSE	allow read-only open even if database is corrupt
_allow_file_1_offline_error_1245	FALSE	don't signal ORA-1245 due to file 1 being offline
_recovery_skip_cfseq_check	FALSE	allow media recovery even if controlfile seq check fails
log_checkpoints_to_alert	FALSE	log checkpoint begin/end to alert file
db_lost_write_protect	NONE	enable lost write detection
_db_shadow_lost_write_protect	NOT_SET	alter shadow lost write detection for PDB
_db_lost_write_corrupt_block	FALSE	allow corruption for lost write
_flush_log_buffer_timeout	0	Flush log buffer wait time in seconds
_flush_log_buffer_force	FALSE	Flush log buffer force
_switchover_to_standby_option	OPEN_ALL_IGNORE_SESSIONS	option for graceful switchover to standby
_switchover_timeout	0	Switchover timeout in minutes
_switchover_through_cascade	TRUE	Enable switchover through farsync
_auto_bmr_file_header	TRUE	Enable Auto BMR for file header fix
_fast_psby_conversion	TRUE	Enable fast physical standby conversion
_adg_instance_recovery	TRUE	enable ADG instance recovery
_ac_enable_dscn_in_rac	FALSE	Enable Dependent Commit SCN tracking
_ac_strict_SCN_check	FALSE	enforce strict SCN check for AC replay across DG failover
_allow_convert_to_standby	FALSE	allow convert to standby to go through
_early_flush_delta	0	SCN delta to trigger early log flush
_flush_redo_to_standby	0	Flush redo to standby test parameter
_disable_dict_check_pdb_open	FALSE	disable PDB pseudo open for dictionary check purpose
_clear_preserved_buffers	TRUE	Clear preserved buffers before DB reopen after switchover
_datafile_create_wait_time	0	Wait time for standby during data file creation
_datafile_create_min_wait_time	0	Minimum wait time for standby during data file creation
_skip_pdb_recovery_if_keystore_not_open	FALSE	Skip PDB recovery when the PDB's keystore is not open
recovery_parallelism	0	number of server processes to use for parallel recovery
_serial_recovery	FALSE	force serial recovery or parallel recovery
_coord_message_buffer	0	parallel recovery coordinator side extra message buffer size
_multiple_instance_recovery	FALSE	use multiple instances for media recovery
_backup_compress	FALSE	turn on backup compression always
_backup_kgc_scheme	ZLIB	specifies compression scheme
_backup_kgc_medium_scheme	DEFAULT	specifies medium compression scheme
_backup_kgc_bz2_bufsz	0	specifies buffer size to be used by BZ2 compression
_backup_kgc_bz2_type	0	specifies type used by BZ2 compression
_backup_kgc_bz2_niters	0	specifies number of iterations done by BZ2 compression
_backup_kgc_lzo_bufsz	262144	specifies buffer size to be used by LZO compression
_backup_kgc_zlib_complevel	1	specifies compression (performance) level for ZLIB compression
_backup_kgc_zlib_windowbits	15	specifies window size for ZLIB compression
_backup_kgc_zlib_memlevel	8	specifies memory level for ZLIB compression
_backup_kgc_bzip2_blksiz	9	specifies buffer size to be used by BZIP2 compression
_backup_kgc_zstd_complevel	3	specifies compression (performance) level for ZSTD compression
_backup_kgc_zstd_bufsz	262144	specifies buffer size to be used by ZSTD compression
_backup_ksfq_bufmem_max	268435456	maximum amount of memory (in bytes) used for buffers for backup/restore
_backup_ksfq_bufsz	0	size of buffers used for backup/restore
_backup_ksfq_bufcnt	0	number of buffers used for backup/restore
_backup_disk_bufsz	0	size of buffers used for DISK channels
_backup_disk_bufcnt	0	number of buffers used for DISK channels
_backup_seq_bufsz	0	size of buffers used for non-DISK channels
_backup_seq_bufcnt	0	number of buffers used for non-DISK channels
_backup_file_bufsz	0	size of buffers used for file access
_backup_file_bufcnt	0	number of buffers used for file access
_restore_maxopenfiles	8	restore assumption for maxopenfiles
_backup_max_gap_size	4294967294	largest gap in an incremental/optimized backup buffer, in bytes
_backup_min_ct_unused_optim	2097152	mimimun size in bytes of change tracking to apply unused space optimuzation
_unused_block_compression	TRUE	enable unused block compression
_restore_spfile		restore spfile to this location
_dummy_instance	FALSE	dummy instance started by RMAN
_rman_io_priority	3	priority at which rman backup i/o's are done
_backup_encrypt_opt_mode	4294967294	specifies encryption block optimization mode
_disable_initial_block_compression	FALSE	disable initial block compression
_undo_block_compression	TRUE	enable undo block compression
_update_datafile_headers_with_space_information	FALSE	user requested update of datafile headers of locally managed datafiles with space information
_disable_cell_optimized_backups	FALSE	disable cell optimized backups
_backup_align_write_io	TRUE	align backup write I/Os
_backup_dynamic_buffers	TRUE	dynamically compute backup/restore buffer sizes
_backup_automatic_retry	10	automatic retry on backup write errors
_krb_trace_buffer_size	131072	size of per-process I/O trace buffer
_sparse_backing_file	AVM	specifies sparse backing file
_catalog_foreign_restore	FALSE	catalog foreign file restore
_restore_create_directory	TRUE	automatically create directory during restore
_backup_max_wallet_session	50	specifies maximum wallet session for backup
_backup_block0	default	backup block0
_restore_block0	on	restore block0
_backup_int_spare1	4294967294	backup int spare1
_backup_int_spare2	4294967294	backup int spare2
_backup_int_spare3	4294967294	backup int spare3
_backup_int_spare4	4294967294	backup int spare4
_backup_text_spare1		backup text spare1
_backup_text_spare2		backup text spare2
_backup_text_spare3		backup text spare3
_backup_text_spare4		backup text spare4
_backup_bool_spare1	FALSE	backup bool spare1
_backup_bool_spare2	FALSE	backup bool spare2
_backup_bool_spare3	FALSE	backup bool spare3
_backup_bool_spare4	FALSE	backup bool spare4
_krb_check_osd_block_endianess	TRUE	Check OSD Block Endianess
_controlfile_autobackup_delay	300	time delay (in seconds) for performing controlfile autobackups
_deferred_log_dest_is_valid	TRUE	consider deferred log dest as valid for log deletion (TRUE/FALSE)
_log_deletion_policy	mandatory	archivelog deletion policy for mandatory/all destination
_prefered_standby		standby db_unique_name prefered for krb operations
_auto_bmr	enabled	enable/disable Auto BMR
_auto_bmr_req_timeout	60	Auto BMR Requester Timeout
_auto_bmr_sess_threshold	30	Auto BMR Request Session Threshold
_auto_bmr_pub_timeout	10	Auto BMR Publish Timeout
_auto_bmr_fc_time	60	Auto BMR Flood Control Time
_auto_bmr_bg_time	3600	Auto BMR Process Run Time
_auto_bmr_sys_threshold	100	Auto BMR Request System Threshold
_auto_bmr_max_rowno	1024	x$krbabrstat Max number of rows
_krbabr_trace_buffer_size	131072	size of I/O trace buffer
_preplugin_backup	enabled	enable/disable pre-plugin backup feature
_auto_export_preplugin_backup	TRUE	auto export pre-plugin backup
_backup_appliance_enabled	FALSE	Backup Appliance Enabled
_ba_container_filesystem_ausize	4194304	allocation unit size for Backup Appliance containers
_ba_max_groups	0	maximum number of Backup Appliance container groups
_ba_max_containers	0	maximum number of Backup Appliance containers
_ba_max_seg_bytes	4000	maximum number of bytes per array segment
_ba_cf_trace_buffer_size	131072	size of per-process I/O KBC trace buffer
_ba_timeouts_enabled	TRUE	enable timeouts
enable_goldengate_replication	FALSE	goldengate replication enabled
_tts_allow_charset_mismatch	FALSE	allow plugging in a tablespace with an incompatible character set
_xtts_allow_pre10	FALSE	allow cross platform for pre10 compatible tablespace
_xtts_set_platform_info	FALSE	set cross platform info during file header read
_bypass_xplatform_error	FALSE	bypass datafile header cross-platform-compliance errors
_aux_dfc_keep_time	1440	auxiliary datafile copy keep time in minutes
_forced_endian_type	UNKNOWN	Forced endian type of data dictionary
_allow_cross_endian_dictionary	FALSE	Allow cross-endian data dictionary
_query_on_physical	TRUE	query on physical
_recoverable_recovery_batch_percent	50	Recoverable recovery batch size (percentage of buffer cache)
_undo_tbs_slave_percent	0	Percentage of redo slaves for undo tablespace
_recoverable_recovery_max_influx_buffers	100000	Recoverable recovery number of influx buffers limit
_disable_incremental_recovery_ckpt	FALSE	Disable incremental recovery checkpoint mechanism
_clone_one_pdb_recovery	FALSE	Recover ROOT and only one PDB in clone database
_incremental_recovery_ckpt_min_batch	500	minimum number of writes for incremental recovery ckpt every second
_time_based_rcv_ckpt_target	180	time-based incremental recovery checkpoint target in sec
_time_based_rcv_hdr_update_interval	180	time-based incremental recovery file header update interval in sec
_multi_instance_pmr	TRUE	enable multi instance redo apply
_disable_active_influx_move	FALSE	disable active influx move during parallel media recovery
_abort_on_mrp_crash	FALSE	abort database instance when MRP crashes
_keep_19907_during_recovery	FALSE	keep until scn within recovery target check in recovery
_defer_log_boundary_ckpt	TRUE	defer media recovery checkpoint at log boundary
_defer_log_count	100	Number of log boundaries media recovery checkpoint lags behind
_transient_logical_clear_hold_mrp_bit	FALSE	clear KCCDI2HMRP flag during standby recovery
_log_max_optimize_threads	128	maximum number of threads to which log scan optimization is applied
_reduce_sby_log_scan	TRUE	enable standby log scan optimization
_sync_primary_wait_time	5	wait time for alter session sync with primary
_standby_implicit_rcv_timeout	1	minutes to wait for redo during standby implicit recovery
_readable_standby_sync_timeout	10	readable standby query scn sync timeout
_readable_standby_sync_interval	0	readable standby recovery global sync interval
_adg_parselock_timeout	0	timeout for parselock get on ADG in centiseconds
_adg_influx_qscn_gap	0	maximium time gap between influx scn and qscn update in seconds
_adg_parselock_timeout_sleep	100	sleep duration after a parselock timeout on ADG in milliseconds
_adg_objectlock_timeout	0	timeout for objectlock get on ADG in centiseconds
_adg_objectlock_attempts	2	Maximum attemps for objectlock get on ADG
_adg_objectlock_maxnum	1000	The maximum limit of the objectlock number on ADG
_adg_count_beyond_limit	0	Count the total number of objects if beyond redo marker length.
_adg_defer_segstat	TRUE	Defer the segment statistics update on standby.
inmemory_adg_enabled	TRUE	Enable IMC support on ADG
_adg_adt_redirect_catchup_wait_time	12000	Maximum centi-secends for standby to catch up
_adg_adt_redirect_apply_lag_threshold	12000	Maximum centi-secends of apply lag threshold
_read_only_violation_max_count	500	read-only violation array max count
_read_only_violation_max_count_per_module	100	read-only violation array per module max count
_read_only_violation_dump_to_trace	FALSE	read-only violation dump to trace files
_adg_redirect_upd_to_primary_max_retries	500	max retries for ADT redirect to Primary from ADG
_media_recovery_read_batch	32	media recovery block read batch
_standby_causal_heartbeat_timeout	2	readable standby causal heartbeat timeout
_use_pdb_parselock	TRUE	use PDB level parselock on ADG
_snapshot_recovery_enabled	TRUE	enable/disable snapshot recovery
_adg_auto_close_pdb	TRUE	ADG recovery auto close PDB upon PDB drop/unplug/rename marker
_bct_public_dba_buffer_size	0	total size of all public change tracking dba buffers, in bytes
_bct_initial_private_dba_buffer_size	0	initial number of entries in the private change tracking dba buffers
_bct_bitmaps_per_file	8	number of bitmaps to store for each datafile
_bct_file_block_size	0	block size of change tracking file, in bytes
_bct_file_extent_size	0	extent size of change tracking file, in bytes
_bct_chunk_size	0	change tracking datafile chunk size, in bytes
_bct_crash_reserve_size	262144	change tracking reserved crash recovery SGA space, in bytes
_bct_buffer_allocation_size	2097152	size of one change tracking buffer allocation, in bytes
_bct_buffer_allocation_max	104857600	maximum size of all change tracking buffer allocations, in bytes
_bct_buffer_allocation_min_extents	1	mininum number of extents to allocate per buffer allocation
_bct_fixtab_file		change tracking file for fixed tables
_disable_primary_bitmap_switch	FALSE	disable primary bitmap switch
_bct_health_check_interval	60	CTWR health check interval (seconds), zero to disable
_bct_public_dba_buffer_dynresize	2	allow dynamic resizing of public dba buffers, zero to disable
_bct_public_dba_buffer_maxsize	0	max buffer size permitted for public dba buffers, in bytes
_bct_mrp_timeout	600	CTWR MRP wait timeout (seconds), zero to wait forever
_krc_trace_buffer_size	131072	size of I/O trace buffer
_kra_trace_buffer_size	131072	size of I/O trace buffer
_kra_cfile_compaction	TRUE	controlfile record compation
db_flashback_retention_target	1440	Maximum Flashback Database log retention time in minutes.
_validate_flashback_database	FALSE	Scan database to validate result of flashback database
_flashback_allow_noarchivelog	FALSE	Allow enabling flashback on noarchivelog database
_verify_flashback_redo	TRUE	Verify that the redo logs needed for flashback are available
_flashback_verbose_info	FALSE	Print verbose information about flashback database
_flashback_dynamic_enable_failure	0	Simulate failures during dynamic enable
_flashback_dynamic_enable	TRUE	enable flashback enable code path
_allow_drop_snapshot_standby_grsp	FALSE	Allow dropping snapshot standby guaranteed restore point
_flashback_marker_cache_size	328	Size of flashback database marker cache
_flashback_marker_cache_enabled	TRUE	Enable flashback database marker cache
_flashback_database_test_only	FALSE	Run Flashback Database in test mode
_allow_drop_ts_with_grp	FALSE	Allow drop Tablespace with guaranteed restore points
_df_hist_offl_override	FALSE	Allow update of keep offline bit in datafile history record
_propogate_restore_point	TRUE	Allow shipping of restore point from primary to standby
_flashback_logfile_enqueue_timeout	600	flashback logfile enqueue timeout for opens
_flashback_barrier_interval	1800	Flashback barrier interval in seconds
_flashback_standby_barrier_interval	1	Flashback standby barrier interval in seconds
_flashback_stby_support_mira	TRUE	Flashback database on standby supports MIRA
_flashback_standby_check_barrier_MIRA	20	Flashback standby check barrier generation in seconds
_flashback_standby_check_minpfh_MIRA	15	Flashback standby check minimum high fuzzy scn in seconds
_flashback_max_standby_sync_span	300	Maximum time span between standby recovery sync for flashback
_flashback_fuzzy_barrier	TRUE	Use flashback fuzzy barrier
_disable_kcb_flashback_blocknew_opt	FALSE	Disable KCB flashback block new optimization
_disable_kcbl_flashback_blocknew_opt	FALSE	Disable KCBL flashback block new optimization
_disable_flashback_wait_callback	FALSE	Disable flashback wait callback
_check_block_new_invariant_for_flashback	FALSE	check block new invariant for flashback
_allow_compatibility_adv_w_grp	FALSE	allow advancing DB compatibility with guaranteed restore points
_minimum_db_flashback_retention	60	Minimum flashback retention
_flashback_delete_chunk_MB	128	Amount of flashback log (in MB) to delete in one attempt
_flashback_11_1_block_new_opt	FALSE	use 11.1 flashback block new optimization scheme
_flashback_marker_for_every_grp	FALSE	generate a new flashback marker for every GRP
_flashback_log_size	1000	Flashback log size
_flashback_log_min_size	100	Minimum flashback log size
_db_flashback_log_min_size	16777216	Minimum flashback database log size in bytes
_db_flashback_log_min_total_space	0	Minimum flashback database log total space in bytes
_flashback_copy_latches	10	Number of flashback copy latches
_flashback_n_log_per_thread	128	Desired number of flashback logs per flashback thread
_flashback_max_n_log_per_thread	2048	Maximum number of flashback logs per flashback thread
_flashback_generation_buffer_size	14614528	flashback generation buffer size
_allocate_flashback_buffer	FALSE	Allocate flashback buffer at mount time even if flashback is off
_flashback_max_log_size	0	Maximum flashback log size in bytes (OS limit)
_flashback_log_io_error_behavior	0	Specify Flashback log I/O error behavior
_flashback_prepare_log	TRUE	Prepare Flashback logs in the background
_flashback_size_based_on_redo	TRUE	Size new flashback logs based on average redo log size
_flashback_validate_controlfile	FALSE	validate flashback pointers in controlfile for 11.2.0.2 database
_flashback_format_chunk_mb	4	Chunk mega-bytes for formatting flashback logs using sync write
_flashback_format_chunk_mb_dwrite	16	Chunk mega-bytes for formatting flashback logs using delayed write
_flashback_log_rac_balance_factor	10	flashback log rac balance factor
_flashback_write_max_loop_limit	10	Flashback writer loop limit before it returns
_flashback_hint_barrier_percent	20	Flashback hint barrier percent
_drop_flashback_logical_operations_enq	FALSE	Drop logical operations enqueue immediately during flashback marker generation
_percent_flashback_buf_partial_full	50	Percent of flashback buffer filled to be considered partial full
_flashback_reclaim_monitor_window	7	Proactive flashback logs reclaimation window
_flashback_reclaim_speed_up	FALSE	Proactive flashback logs reclaimation speed up
_tdb_debug_mode	16	set debug mode for testing transportable database
_log_read_buffers	8	Number of log read buffers for media recovery
_change_vector_buffers	1	Number of change vector buffers for media recovery
_change_vector_read_sample_ratio	0	Sample ratio of change vector read timestamp on ADG
_kcfis_spawn_debugger	FALSE	Decides whether to spawn the debugger at kcfis initialize
_kcfis_trace_bucket_size	131072	KCFIS tracing bucket size in bytes
_kcfis_fault_control	0	Fault Injection Control
_kcfis_caching_enabled	TRUE	enable kcfis intra-scan session caching
_kcfis_large_payload_enabled	FALSE	enable large payload to be passed to cellsrv
_kcfis_automem_level	1	Set auto memory management control for kcfis memory allocation
_kcfis_cell_passthru_enabled	FALSE	Do not perform smart IO filtering on the cell
_kcfis_cell_passthru_dataonly	TRUE	Allow dataonly passthru for smart scan
_kcfis_dump_corrupt_block	TRUE	Dump any corrupt blocks found during smart IO
_kcfis_kept_in_cellfc_enabled	TRUE	Enable usage of cellsrv flash cache for kept objects
_kcfis_nonkept_in_cellfc_enabled	FALSE	Enable use of cellsrv flash cache for non-kept objects
_kcfis_rdbms_blockio_enabled	FALSE	Use block IO instead of smart IO in the smart IO module on RDBMS
_kcfis_fast_response_enabled	TRUE	Enable smart scan optimization for fast response (first rows)
_kcfis_fast_response_threshold	1048576	Fast response - the number of IOs after which smartIO is used
_kcfis_fast_response_initiosize	2	Fast response - The size of the first IO in logical blocks
_kcfis_fast_response_iosizemult	4	Fast response - (next IO size = current IO size * this parameter)
_kcfis_max_out_translations	5000	Sets the maximum number of outstanding translations in kcfis
_kcfis_max_cached_sessions	10	Sets the maximum number of kcfis sessions cached
_kcfis_storageidx_disabled	FALSE	Don't use storage index optimization on the storage cell
_kcfis_disable_platform_decryption	FALSE	Don't use platform-specific decryption on the storage cell
_kcfis_storageidx_diag_mode	0	Debug mode for storage index on the cell
_kcfis_storageidx_set_membership_disabled	FALSE	Don't use set membership optimization on the storage cell
_kcfis_byteswap_opt_disabled	FALSE	Don't use byte swapping optimization on the storage cell
_kcfis_cellcache_disabled	FALSE	Don't use cellcache rewrite optimization on the storage cell
_kcfis_test_control1	0	kcfis tst control1
_kcfis_stats_level	0	sets kcfis stats level
_kcfis_io_prefetch_size	8	Smart IO prefetch size for a cell
_kcfis_block_dump_level	0	Smart IO block dump level
_kcfis_ioreqs_throttle_enabled	TRUE	Enable Smart IO requests throttling
_kcfis_qm_prioritize_sys_plan	TRUE	Prioritize Quaranitine Manager system plan
_kcfis_qm_user_plan_name		Quaranitine Manager user plan name
_kcfis_control1	0	Kcfis control1
_kcfis_control2	0	Kcfis control2
_kcfis_control3	0	Kcfis control3
_kcfis_control4	0	Kcfis control4
_kcfis_control5	0	Kcfis control5
_kcfis_control6	0	Kcfis control6
_kcfis_oss_io_size	0	KCFIS OSS I/O size
_kcfis_read_buffer_limit	0	KCFIS Read Buffer (per session) memory limit in bytes
_cell_file_format_chunk_size	0	Cell file format chunk size in MB
_cell_offload_capabilities_enabled	1	specifies capability table to load
_kcfis_cell_passthru_fromcpu_enabled	TRUE	Enable automatic passthru mode when cell CPU util is too high
_kcfis_celloflsrv_usage_enabled	TRUE	Enable offload server usage for offload operations
_kcfis_celloflsrv_passthru_enabled	FALSE	Enable offload server usage for passthru operations
_kcfis_fastfileinit_disabled	FALSE	Don't use ffi during file creation
_kcfis_xtgran_prefetch_count	1	External Table Smart Scan granule prefetch count
_kcfis_storageidx_xtss_disabled	FALSE	Don't use storage index optimization on the storage cell for XTSS
_kcfis_pmem_enabled	TRUE	RDMA Persistent Memory support enabled
_db_block_prefetch_skip_reading_enabled	TRUE	Batched IO enable skip reading buffers
_db_block_prefetch_fast_longjumps_enabled	TRUE	Batched IO enable fast longjumps
_db_block_prefetch_private_cache_enabled	TRUE	Batched IO enable private cache
_datafile_write_errors_crash_instance	TRUE	datafile write errors crash instance
_datafile_open_errors_crash_instance	TRUE	datafile open errors crash instance
_siop_perc_of_bc_x100	625	percentange * 100 of cache to transfer to shared io pool
_siop_init_mem_gradually	TRUE	will cause shared io pool in small chunks
_db_flashback_iobuf_size	1	Flashback IO Buffer Size
_db_flashback_num_iobuf	64	Flashback Number of IO buffers
_flashback_enable_ra	TRUE	Flashback enable read ahead
_nologging_sendbuf_ratio	90	Nologging standby: outstanding send buffer ratio
_nologging_slots	20	Nologging standby: initial buffer count
_nologging_load_slotsz	1048576	Nologging standby: direct load buffer size
_nologging_block_cleanout_delay	300	Nologging standby: block cleanout delay (seconds)
_force_logging_in_upgrade	TRUE	force logging during upgrade mode
_nologging_mode_override	0	Override the database logging mode; 1=Force, 2=NoForce, 3=LP, 4=DA
_nologging_txn_history_to_sessions_percent	100	Ratio, as a percentage, of sessions to set X$KCNT max. size
_nologging_fetch_slv_wt	600	Nologging standby fetch slave wait time
_nologging_progress_keep_alive	10	Nologging standby progress keep alive time
_nologging_kcnbuf_hash_buckets	1024	Number of nologging buffer hash buckets
_nologging_kcnbuf_hash_latches	256	Number of nologging buffer hash latches
_nologging_standby_hot_buffer_timeout	500	Centi-seconds recovery will wait for a buffer being sent by a direct load client in Nologging Standby Data Availabilty mode
_nologging_standby_cold_buffer_timeout	500	Centi-seconds recovery will wait for a buffer that is not being sent by a direct load client in Nologging Standby Data Availability mode
_nbr_recovery_timeout	60	seconds recovery will wait for any invalid block range to arrive
_nbr_recovery_max_request_size	8	the maximum size in MBs of a request for data blocks
_nbr_recovery_target_bufs	0	the target number of oustanding buffers to maintain
_nologging_apply_stall_time	1000	milli-seconds recovery waits after DTC full before changing RCVID
_nologging_standby_fetch_disable	FALSE	controls whether invalid block ranges are fecthed during recovery
_nologging_standby_refetch_disable	FALSE	controls fetching of pre-existing invalid block ranges during standby recovery
_nologging_standby_dtc_expire	600	The number of seconds a Data Transfer Cache buffer may remain unclaimed
_nologging_sdcl_append_wait	200	Nologging standby append sdcl wait time
_nologging_txn_cmt_wait	1500	Nologging standby transaction commit wait time
_max_data_transfer_cache_size	536870912	Maximum size of data transfer cache
_data_transfer_cache_bc_perc_x100	500	Percentange * 100 of buffer cache to transfer to data transfer cache
data_transfer_cache_size	0	Size of data transfer cache
__data_transfer_cache_size	0	Actual size of data transfer cache
_nologging_fetch_retry_interval_hot	60	Interval before fetch request for recently created invalid block            range
_nologging_fetch_retry_interval_cold	1800	Interval before fetch request for older invalid block range
_nologging_fetch_demote_count	10	Nologging standby fetch demote count
_nologging_fetch_initial_interval	2	seconds recovery waits between issuing fetches for old ranges
_max_kcnibr_ranges	1048576	Max number of nonlogged data block ranges
_mira_mark_archivelog_timeout	60	mira mark archive log as applied timeout
enable_imc_with_mira	FALSE	enable IMC with  multi instance redo apply
_mira_num_receive_buffers	25	Number of receive buffers for multi instance media recovery
_mira_num_local_buffers	25	Number of  local buffers for multi instance media recovery
_mira_sender_process	2	Number of sender processes
_mira_rcv_max_buffers	500	Maximum number of outstanding buffers
_krpm_trace_buffer_size	262144	size of per-process mira trace buffer
_mira_rcv_catchup_buffers	5	Number of buffers to allocate before catch up
_mira_free_unused_buffers	TRUE	free unused buffers when idle
_dbcomp_msg_ver	1	database block compare message version
_dbcomp_maxdump	100	Maximum # of dumped blocks per datafile
_shadow_lost_write_found	118	Specify shadow lost write error handling
_shadow_lost_write_tracing	0	Enable new lost write tracing
adg_account_info_tracking	LOCAL	ADG user account info tracked in standby(LOCAL) or in Primary(GLOBAL)
adg_redirect_dml	FALSE	Enable DML Redirection from ADG
_alter_adg_redirect_behavior	none	Alter ADG's Redirection behavior
dml_locks	2084	dml locks - one for each table modified in a transaction
_row_locking	always	row-locking
_serializable	FALSE	serializable
_scn_wait_interface_max_timeout_secs	2147483647	max timeout for scn wait interface in kta
_scn_wait_interface_max_backoff_time_secs	600	max exponential backoff time for scn wait interface in kta
replication_dependency_tracking	TRUE	tracking dependency for Replication parallel propagation
_ktb_debug_flags	8	ktb-layer debug flags
_log_committime_block_cleanout	FALSE	Log commit-time block cleanout
_ktc_latches	0	number of ktc latches
_prescomm	FALSE	presume commit of IMU transactions
_recursive_imu_transactions	FALSE	recursive transactions may be IMU
_ktc_debug	0	for ktc debug
_enable_minscn_cr	TRUE	enable/disable minscn optimization for CR
_txn_control_trace_buf_size	4096	size the in-memory buffer size of txn control
transactions	521	max. number of concurrent active transactions
transactions_per_rollback_segment	5	number of active transactions per rollback segment
_ktu_latches	0	number of KTU latches
_transaction_auditing	TRUE	transaction auditing records generated in the redo log
_smu_error_simulation_site	0	site ID of error simulation in KTU code
_smu_error_simulation_type	0	error type for error simulation in KTU code
_imtxn_table_enable	TRUE	is In-Memory Txn Table cache enabled
_imtxn_table_max_undo_segs	1024	In-Memory Txn Table Max Undo Segments in Cache
_imtxn_table_max_slts_per_seg	34	In-Memory Txn Table Slots per Undo Segment
_imtxn_table_max_inc_per_slt	1	In-Memory Txn Table number of incarnations per slot
_imtxn_table_flags	3	In-Memory Txn Table cache flags
_temp_undo_disable_adg	FALSE	is temp undo disabled on ADG
temp_undo_enabled	FALSE	is temporary undo enabled
_temp_undo_optimal_extents	0	optimal number of extents for temp undo
_rollback_stopat	0	stop at -position to step rollback
_discrete_transactions_enabled	FALSE	enable OLTP mode
_in_memory_undo	TRUE	Make in memory undo for top level transactions
_imu_pools	3	in memory undo pools
_branch_tagging	TRUE	enable branch tagging for distributed transaction
_row_cr	TRUE	enable row cr for all sql
_enable_block_level_transaction_recovery	TRUE	enable block level recovery
_cleanup_rollback_entries	100	no. of undo entries to apply per transaction cleanup
rollback_segments		undo segment list
_rollback_segment_initial	1	starting undo segment number
undo_management	AUTO	instance runs in SMU mode if TRUE, else in RBU mode
_offline_rollback_segments		offline undo segment list
_corrupted_rollback_segments		corrupted undo segment list
_rollback_segment_count	0	number of undo segments
undo_tablespace	UNDOTBS1	use/switch undo tablespace
_smu_timeouts		comma-separated *AND double-quoted* list of AUM timeouts: mql, tur, sess_exprn, qry_exprn, slot_intvl
_smu_debug_mode	0	<debug-flag> - set debug event for testing SMU operations
_undo_debug_mode	0	debug flag for undo related operations
_tablespaces_per_transaction	10	estimated number of tablespaces manipulated by each transaction
_verify_undo_quota	FALSE	TRUE - verify consistency of undo quota statistics
_in_memory_tbs_search	TRUE	FALSE - disable fast path for alter tablespace read only
_highthreshold_undoretention	4294967294	high threshold undo_retention in seconds
_undo_autotune	TRUE	enable auto tuning of undo_retention
undo_retention	900	undo retention in seconds
_collect_undo_stats	TRUE	Collect Statistics v$undostat
_collect_tempundo_stats	TRUE	Collect Statistics v$tempundostat
_indoubt_pdb_transactions_force_outcome	COMMIT	commit force or rollback force during undo mode switch
_min_undosegs_for_parallel_fptr	100	minimum undo segments for parallel first-pass recovery
_number_of_undo_blocks_to_prefetch	8	number of undo blocks to prefetch
_imtxnrma_table_enable	FALSE	is In-Memory RMA Txn Table cache enabled
_transaction_recovery_servers	0	max number of parallel recovery slaves that may be used
fast_start_parallel_rollback	LOW	max number of parallel recovery slaves that may be used
_parallel_recovery_stopat	32767	stop at -position- to step through SMON
resumable_timeout	0	set resumable_timeout
_resumable_critical_alert	0	raise critical alert for resumable failure
_cr_trc_buf_size	8192	size of cr trace buffer
_max_cr_rollbacks	1000	Maximum number of CR  rollbacks per block (LMS)
_disable_txn_alert	0	disable txn layer alert
_undo_debug_usage	0	invoke undo usage functions for testing
_db_change_notification_enable	TRUE	enable db change notification
_minact_timeout	180	Configurable interval for minact-scn
_disable_flashback_archiver	0	disable flashback archiver 
_disable_fba_qrw	0	disable flashback archiver query rewrite
_disable_fba_wpr	0	disable flashback archiver wait for prepared transactions
_flashback_archiver_partition_size	0	flashback archiver table partition size
_fbda_busy_percentage	0	flashback archiver busy percentage
_fbda_inline_percentage	0	flashback archiver inline percentage
_fbda_debug_mode	0	flashback archiver debug event for testing
_fbda_debug_assert	0	flashback archiver debug assert for testing
_fbda_global_bscn_lag	0	flashback archiver global barrier scn lag
_fbda_rac_inactive_limit	0	flashback archiver rac inactive limit
_fbda_tcrv_cleanup_lag	3600	flashback archiver tcrv cleanup lag in secs
_securefile_log_num_latches	0	Maximum number of open descriptors for securefile log
_securefile_log_shared_pool_size	0	Size of securefile log buffer pool from SGA
_cli_cachebktalloc	100	Percentage of memory to allocate
_ilm_mem_limit	10	percentage of the max shared pool heat-map can use - internal
_ktilmsc_exp	600	expiration time of ktilm segment cache (in second)
_ktilm_uga_off	FALSE	Disable KTILM UGA cache activity tracking
_inmemory_check_prot_meta	FALSE	If true, marks SMU area read only to prevent stray writes
_inmemory_private_journal_quota	100	quota for transaction in-memory private journals
_inmemory_txnpjrnl_debug	0	txn priv jrnl debugging parameter
_inmemory_private_journal_sharedpool_quota	20	quota for transaction in-memory objects
_inmemory_private_journal_numbkts	512	Number of priv jrnl ht bkts
_inmemory_private_journal_numgran	255	Number of granules per HT node
_inmemory_private_journal_maxexts	5000000	Max number of extents per PJ
_inmemory_journal_scan	0	inmemory journal scan enable
_inmemory_journal_format	1	inmemory journal format options
_inmemory_journal_scan_format	TRUE	If true, the set journal format will be used for scan
_inmemory_journal_cla_stride	4	inmemory journal format cla stride
_inmemory_partrowlock_threshold	10	Number of committed rows that stay not cleaned out
_inmemory_pin_hist_mode	16	settings for IM pinned buffer history
_inmemory_txn_checksum	0	checksum for SMUs and private journals
_inmemory_buffer_waittime	100	wait interval for one SMU or IMCU to be freed
_inmemory_retention_time	120	maximum retention time of imcu after repopulation
_inmemory_cudrop_timeout	1000	maximum wait time for IMCU to be freed during drop
_inmemory_exclto_timeout	100	maximum wait time to pin SMU for cleanout
_inmemory_num_hash_latches	256	Maximum number of latches for IM buffers
_inmemory_strdlxid_timeout	0	max time to determine straddling transactions
_inmemory_incremental_repopulation	TRUE	If true, incremental repopulation of IMCU will be attempted
_inmemory_repopulate_optimize	TRUE	If true, itl transfer will be attempted during repopulation of IMCU
_inmemory_transaction_options	2806	in-memory transaction performance options
_inmemory_waitinvis_count	8	in-memory waitinvisible retry count
_inmemory_lock_for_smucreate	FALSE	take object lock during smu creation
_inmemory_relimcusz_thresh	25	in-memory relative imcusz thresh for direct reads
_inmemory_shared_journal_maxexts	1024	Max number of extents per SJ
_inmemory_shared_journal_minexts_repop	256	min number of extents per SJ to trigger repop
_inmemory_direct_reads	1	direct-reads for SMUs population repopulation
_inmemory_grpcolinv_buffer_size	131072	In-memory grpcolinv buffer size
_inmemory_grpcolinv_granularity	1	In-memory grpcolinv blks per colmap
_inmemory_crclone_buffer_size	131072	In-memory CR Clone buffer size
_inmemory_crclone_threshold_rows	100	In-memory CR Clone threshold rows
_inmemory_crclone_min_clones	6	In-memory CR Clone minimum number of clones
_inmemory_crclone_min_space_percent	50	In-memory CR Clone minimum space percentage
_inmemory_patch_threshold_blocks	25	In-memory SMU patch threshold blocks
_inmemory_patch_background_blocks	200	In-memory SMU patch threshold blocks to start background tasks
_inmemory_patch_commit_path	FALSE	If true, enable the SMU patching from DML path
_inmemory_smu_patch_options	7	Inmemory SMU patching options
_inmemory_adg_quiesce_timeout	2	timeout for getting ZQ enq
_inmemory_adg_periodic_sort	FALSE	If true, periodic sort is performed
_inmemory_adg_batched_flush	TRUE	If true, batched flush is performed
_inmemory_adg_parallel_flush	TRUE	If true, parallel flush is performed
_inmemory_adg_journal_quota	FALSE	If true, throttled mining is performed under space pressure
_ktst_rss_min	100	minimum temp extents to be released across instance
_ktst_rss_max	1000	maximum temp extents to be released across instance
_ktst_rss_retry	5	maximum retries of sort segment release
_force_temp_space_cleanup	TRUE	Force temp space cleanup after PDB close
_partition_large_extents	TRUE	Enables large extent allocation for partitioned tables
_index_partition_large_extents	FALSE	Enables large extent allocation for partitioned indices
_force_local_temp	FALSE	For testing only   Forces temporary tablespaces to be LOCAL
_prefer_local_temp	FALSE	Use Local Temp as preferred default tablespace
instance_number	0	instance number
_allocate_creation_order	FALSE	should files be examined in creation order during allocation
_log_space_errors	TRUE	should we report space errors to alert log
_assm_low_gsp_threshold	10000	Number of blocks rejected before collecting stats
_assm_high_gsp_threshold	11024	Number of blocks rejected before growing segment
_simulate_io_wait	0	Simulate I/O wait to test segment advisor
_bump_highwater_mark_count	0	how many blocks should we allocate per free list on advancing HWM
_assm_segment_extension_percent	100	Percent of full blocks after which segment is extended
_old_extent_scheme	FALSE	Revert to old extent allocation
_trace_temp	FALSE	Trace Tempspace Management
_concurrency_chosen	10	what is the chosen value of concurrency
_no_small_file	FALSE	Not to apply new extent scheme for small file temp spaces
_assm_default	TRUE	ASSM default
_enable_hwm_sync	TRUE	enable HWM synchronization
_hwm_sync_threshold	10	HWM synchronization threshold in percentage
_enable_check_truncate	TRUE	enable checking of corruption caused by canceled truncate
_enable_tablespace_alerts	TRUE	enable tablespace alerts
_disable_temp_tablespace_alerts	FALSE	disable tablespace alerts for TEMPORARY tablespaces
_disable_undo_tablespace_alerts	FALSE	disable tablespace alerts for UNDO tablespaces
_disable_lostwrite_tablespace_alerts	FALSE	disable tablespace alerts for LOSTWRITE tablespaces
_last_allocation_period	5	period over which an instance can retain an active level1 bitmap
_securefiles_forceflush	FALSE	securefiles force flush before allocation
_securefiles_concurrency_estimate	12	securefiles concurrency estimate
_securefiles_increase_hbb	FALSE	securefiles increase hbb
_securefiles_memory_percentofSGA	8	securefiles memory as percent of SGA
_inst_locking_period	5	period an instance can retain a newly acquired level1 bitmap
_allocation_update_interval	3	interval at which successful search in L1 should be updated
_minimum_blocks_to_shrink	0	minimum number freeable blocks for shrink to be present
_minimum_extents_to_shrink	1	minimum number freeable extents for shrink to be present
_index_partition_shrink_opt	TRUE	enable alter index modify partition shrink optimization
_use_best_fit	FALSE	use best fit to allocate space
_step_down_limit_in_pct	20	step down limit in percentage
_assm_test_force_rej	0	assm min number of blocks to cbk-reject
_assm_test_force_rej2	0	assm min number of blocks to kdt-reject
_assm_test_reentrant_gsp	FALSE	assm test reentrant gsp
_enable_space_preallocation	3	enable space pre-allocation
_ktspsrch_maxsc	1024	maximum segments supported by space search cache
_ktspsrch_scexp	60	expiration time of space search cache
_ktspsrch_scchk	60	cleanout check time of space search cache
_ktspsrch_maxskip	5	space search cache rejection skip upper limit
_max_sys_next_extent	0	Dictionary managed SYSTEM tablespace maximum next extent size in MB (allowed range [16-4095], 0 if unlimited)
_assm_force_fetchmeta	FALSE	enable metadata block fetching in ASSM segment scan
_max_fsu_segments	1024	Maximum segments to track for fast space usage
_max_fsu_sgapcent	10	Percentage of shared pool for Fast Space Usage
_max_fsu_exptime	7200	Fast Space Usage: Entry expiration time in seconds
_max_fsu_stale_time	600	Allowed space usage staleness in seconds
_disable_flashback_recyclebin_opt	TRUE	Don't use the Flashback Recyclebin optimization
_max_shrink_obj_stats	0	number of segments for which shrink stats will be maintained
_check_ts_threshold	0	check tablespace thresholds
_async_ts_threshold	1	check tablespace thresholds asynchronously
_enable_securefile_flashback_opt	FALSE	Enable securefile flashback optimization
_disable_def_seg_update	0	Disable deferred seg$ update
_use_cached_asm_free_space	FALSE	Should x$kttets use cached ASM free space info
_ena_storage_lmt	DEFAULT	Enable storage clause for LMT
_kttext_warning	5	tablespace pre-extension warning threshold in percentage
_ktt_tsid_reuse_threshold	60000	tablespace id reuse threshold
_enable_verbose_gdr	FALSE	GDR: Enable verbose 
_enable_sysaux_gdr	FALSE	GDR: Enable on SYSAUX 
_gdr_clear_inactive_only	FALSE	GDR: Clear inactive ranges only
_gdr_clear_active_only	FALSE	GDR: Clear active ranges only
_drop_tablespace_objects	0	GDR: drop all tablespace objects
_smon_internal_errlimit	100	limit of SMON internal errors
_smon_undo_seg_rescan_limit	10	limit of SMON continous undo segments re-scan
_enable_12g_bft	TRUE	enable 12g bigfile tablespace
_space_align_size	1048576	space align size
_undotbs_stepdown_pcent	75	Undo Tablespace small allocation step down percentage
_undotbs_regular_tables	FALSE	Create regular tables in undo tablespace
_enable_spacebg	TRUE	enable space management background task
_max_spacebg_slaves	1024	maximum space management background slaves
_minmax_spacebg_slaves	8	min-max space management background slaves
_min_spacebg_slaves	2	minimum space management background slaves
_max_spacebg_tasks	8192	maximum space management background tasks
_max_spacebg_msgs_percentage	50	maximum space management interrupt message throttling
_ktslj_segext_warning	10	segment pre-extension warning threshold in percentage
_ktslj_segext_warning_mb	0	segment pre-extension warning threshold in MB
_ktslj_segext_max_mb	0	segment pre-extension max size in MB (0: unlimited)
_ktslj_segext_retry	5	segment pre-extension retry
_securefiles_fg_retry	100	segment retry before foreground waits
_securefiles_breakreten_retry	5	segment retry before dishonoring retention
_securefiles_bulkclnout	TRUE	securefiles segment bulk clnout optization
_securefiles_bulkinsert	FALSE	securefiles segment insert only optization
_securefiles_bgtimeout	0	securefiles segment background invocation timeout
_securefiles_spcutl	FALSE	securefiles segment utl optimization
_spacebg_sync_segblocks	TRUE	to enable/disable segmon driver
_trace_ktfs	FALSE	Trace ILM Stats Tracking
_trace_ktfs_mem	FALSE	Debug memleak
heat_map	OFF	ILM Heatmap Tracking
_enable_ilm_flush_stats	TRUE	Enable ILM Stats Flush
_enable_ilm_testflush_stats	FALSE	Enable Test ILM Stats Flush
_disable_12cbigfile	FALSE	DIsable Storing ILM Statistics in 12cBigFiles
_enable_heatmap_internal	FALSE	heatmap related - to be used by oracle dev only
_heatmap_format_1block	FALSE	heatmap related - to be used by oracle dev only
_test_hm_extent_map	FALSE	heatmap related - to be used by oracle dev only
_ilmset_stat_limit	0	ILM set statistics limit - Internal testing only
_ilmflush_stat_limit	0	ILM flush statistics limit - Internal testing only
_heatmap_min_maxsize	0	Internal testing only
_ilmstat_memlimit	5	Percentage of shared pool for use by ILM Statistics
_flush_ilm_stats	0	flush ilm stats
_create_stat_segment	0	create ilm statistics segment
_drop_stat_segment	0	drop ilm statistics segment
_print_stat_segment	0	print ilm statistics segment
_print_inmem_heatmap	0	print inmem ilm heatmap
_blockhm_flush_period	3600	Block heat map background flush period
_inmemory_auto_distribute	TRUE	If true, enable auto distribute
_inmemory_autodist_2safe	FALSE	If true, enable auto distribute with 2safe
_inmemory_distribute_timeout	300	If true, enable auto distribute with 2safe
_inmemory_distribute_ondemand_timeout	300	On demand timeout for redistribute
_inmemory_granule_size	134217728	In-memory granule size
inmemory_size	838860800	size in bytes of in-memory area
inmemory_xmem_size	0	size in bytes of in-memory xmem area
_inmemory_64k_percent	30	percentage of in-memory area for 64k pools
_inmemory_expressions_area_percent	10	percentage of in-memory area for IMEUs
_inmemory_min_ima_defersize	0	Defer in-memory area allocation beyond this size
_inmemory_memprot	TRUE	enable or disable memory protection for in-memory
__inmemory_ext_rwarea	0	Actual size in bytes of inmemory rw extension area
_inmemory_ext_rwarea	0	size in bytes of inmemory rw extension area
__inmemory_ext_roarea	0	Actual size in bytes of inmemory ro extension area
_inmemory_ext_roarea	0	size in bytes of inmemory rw extension area
inmemory_prefer_xmem_memcompress		Prefer to store tables with given memcompress levels in xmem
inmemory_prefer_xmem_priority		Prefer to store tables with given priority levels in xmem
_inmemory_xmem_size	0	size in bytes of in-memory xmem area
_inmemory_prefer_xmem_memcompress		Prefer to store tables with given memcompress levels in xmem
_inmemory_prefer_xmem_priority		Prefer to store tables with given priority levels in xmem
_inmemory_drcancel_cu_percent	80	IMCU percentage threshold to switch from DR to BC
_trace_ktds	FALSE	Trace block reuse
_track_space_reuse	FALSE	SpaceReuse Tracking
_track_space_reuse_rac	FALSE	SpaceReuse Tracking Enable in RAC
_spacereuse_track_memlimit	10	Percentage of shared pool for use by spacereuse tracking
_print_inmem_srmap	0	print inmem spacereuse map
_enable_rejection_cache	TRUE	Enable ASSM rejection cache
_assm_space_cache_hb_expire	3	Seconds after which higher order bitmaps expire from space cache
_assm_l1cleanout_throttle_time	3	L1 bitmap block cleanout throttle time in seconds
_assm_examination_time_threshold	60	ASSM get space examination time threshold in seconds
_assm_examination_blocks_threshold	8196	ASSM get space number of fuzzy blocks to examine
_assm_examination_enable_sla	FALSE	ASSM get space enable examination limits
_assm_space_cache_max_segments	1024	ASSM Maximum Segments to Track
_assm_segment_repair_fg	0	ASSM Segment repair: fg
_assm_segment_repair_bg	TRUE	ASSM Segment repair: bg enable
_assm_segment_repair_maxblks	4294967294	ASSM Segment repair: Max blocks per slave
_assm_latency_sampling_frequency	0	ASSM Latency sampling frequency in seconds
_assm_segment_repair_timelimit	60	ASSM Segment repair: Max time in seconds per slave
_atp_block_size_default	TRUE	ATP setting block size to 8K
allow_rowid_column_type	FALSE	Allow creation of rowid column
_db_row_overlap_checking	TRUE	row overlap checking override parameter for data/index blocks
_db_index_block_checking	TRUE	index block checking override parameter
_kdi_avoid_block_checking	FALSE	avoid index block checking on sensitive opcodes
db_block_checking	FALSE	header checking and data and index block checking
_disable_block_checking	FALSE	disable block checking at the session level
_kd_symtab_chk	TRUE	enable or disable symbol table integrity block check
_sage_block_checking	FALSE	enable block checking of blocks returned by smartscan
_kd_rows_chk	TRUE	enable or disable row block check
recyclebin	on	recyclebin processing
_suppress_identifiers_on_dupkey	FALSE	supress owner index name err msg
_compression_compatibility	19.0.0	Compression compatibility
_check_column_length	TRUE	check column length
_oltp_compression	TRUE	oltp compression enabled
_inplace_update_retry	TRUE	inplace update retry for ora1551
_widetab_comp_enabled	TRUE	wide table compression enabled
_partial_comp_enabled	TRUE	partial table compression enabled
_limit_itls	20	limit the number of ITLs in OLTP Compressed Tables
_force_hsc_compress	FALSE	compress all newly created tables
_force_oltp_compress	FALSE	OLTP Compress all newly created compressed tables
_force_partial_compress	FALSE	Force using OLTP Partial Compression
_force_sys_compress	TRUE	Sys compress
_force_oltp_update_opt	TRUE	OLTP Compressed row optimization on update
_force_arch_compress	0	Archive Compress all newly created compressed tables
_compression_advisor	0	Compression advisor
_compression_chain	90	percentage of chained rows allowed for Compression
_compression_above_cache	0	number of recompression above cache for sanity check
_oltp_compress_dbg	0	oltp compression debug
_oltp_compression_gain	10	oltp compression gain
_arch_compression	TRUE	archive compression enabled
_arch_comp_dbg_scan	0	archive compression scan debug
_oltp_comp_dbg_scan	0	oltp compression scan debug
_dbg_scan	0	generic scan debug
_arch_comp_dec_block_check_dump	1	decompress archive compression blocks for checking and dumping
_alternate_iot_leaf_block_split_points	TRUE	enable alternate index-organized table leaf-block split-points
_kdu_array_depth	16	array update retry recursion depth limits
_cell_offload_hybridcolumnar	TRUE	Query offloading of hybrid columnar compressed tables to exadata
_disable_implicit_row_movement	FALSE	disable implicit row movement
_cu_row_locking	0	CU row level locking
_oltp_spill	FALSE	spill rows for oltp compression if loader pga limit is exceeded
_delete_ghost_data	FALSE	Test delete ghost data
_kd_dbg_control	0	kernel data generic control
_block_dump_assert	FALSE	Encrypted block dump assert
_release_insert_threshold	5	maximum number of unusable blocks to unlink from freelist
_walk_insert_threshold	0	maximum number of unusable blocks to walk across freelist
_enable_hash_overflow	FALSE	TRUE - enable hash cluster overflow based on SIZE
_kdtgsp_retries	1024	max number of retries in kdtgsp if space returns same block
_rowlen_for_chaining_threshold	1000	maximum rowlen above which rows may be chained across blocks
_minfree_plus	0	max percentage of block space + minfree before we mark block full
_disable_hcc_array_insert	FALSE	TRUE - enable conventional inserts into HCC CUs
_extra_lmn_enabled	TRUE	suppl logging for extra record enabled
_use_seq_process_cache	TRUE	whether to use process local seq cache
_pdb_use_sequence_cache	TRUE	Use sequence cache in PDB mode
_sequence_scale_noextend	FALSE	Force sequence creation with scale noextend
_sequence_scale_extend	FALSE	Force sequence creation with scale extend
_dynamic_sequence_cache	TRUE	Enable/disable sequence dynamic cache sizing
_dynamic_sequence_cache_scale	10	Max scale factor for dynamic sequence cache size
_dynamic_sequence_cache_max	1000000	Sequence dynamic cache maximum size
_analyze_comprehensive	FALSE	Analyze comprehensive mode
_disable_index_block_prefetching	FALSE	disable index block prefetching
_index_scan_check_skip_corrupt	FALSE	check and skip corrupt blocks during index scans
_index_scan_check_stopkey	FALSE	check stopkey during index range scans
_index_max_inc_trans_pct	20	max itl expand percentage soft limit during index insert
_index_split_chk_cancel	5	index insert split check cancel
_advanced_index_compression_trace	0	advanced index compression trace
_gdr_control_flags	0	gdr control flags
db_index_compression_inheritance	NONE	options for table or tablespace level compression inheritance
_index_alert_key_not_found	FALSE	dumps 8102 error to alert log file
_reuse_index_loop	5	number of blocks being examine for index block reuse
_kdis_reject_limit	5	#block rejections in space reclamation before segment extension
_kdis_reject_level	24	b+tree level to enable rejection limit
_kdis_reject_ops	FALSE	enable rejection heuristic for branch splits
_kdis_split_xid_prune	TRUE	prune xids during an index split
_kdbl_enable_post_allocation	FALSE	allocate dbas after populating data buffers
_ldr_io_size	1048576	size of write IOs used during a load operation
_ldr_pga_lim	0	pga limit, beyond which new partition loads are delayed
_ldr_tempseg_threshold	8388608	amount to buffer prior to allocating temp segment (extent sizing)
_reclaim_lob_index_scan_limit	0	limit lob index scanning during lob space-reclaim
_dbfs_symlink_path_prefix	TRUE	disallow symbolic link creation in dbfs outside path_prefix
_lmn_invalidlkr_enabled	TRUE	suppl logging for invalid lkr enabled
_ignore_desc_in_index	FALSE	ignore DESC in indexes, sort those columns ascending anyhow
_kdic_segarr_sz	0	size threshold for segmented arrays for seg_info_kdicctx
_keep_remote_column_size	FALSE	remote column size does not get modified
_kdli_trace	0	inode trace level
_kdli_sort_dbas	FALSE	sort dbas during chunkification
_kdli_safe_callbacks	TRUE	invoke inode read/write callbacks safely
_kdli_inode_preference	data	inline inode evolution preference (data, headless, lhb)
_kdli_reshape	FALSE	reshape an inode to inline or headless on length truncation
_kdli_cache_inode	TRUE	cache inode state across calls
_kdli_cache_verify	FALSE	verify cached inode via deserialization
_kdli_cache_size	8	maximum #entries in inode cache
_kdli_memory_protect	FALSE	trace accesses to inode memory outside kdli API functions
_kdli_rci_lobmap_entries	255	#entries in RCI lobmap before migration to lhb
_kdli_readahead_strategy	contig	shared/cached IO readahead strategy
_kdli_readahead_limit	0	shared/cached IO readahead limit
_kdli_sio_on	TRUE	enable shared IO pool operations
_kdli_sio_min_read	0	shared IO pool read threshold
_kdli_sio_min_write	0	shared IO pool write threshold
_kdli_sio_async	TRUE	asynchronous shared IO
_kdli_sio_fgio	TRUE	reap asynchronous IO in the foreground
_kdli_sio_nbufs	8	maximum #IO buffers to allocate per session
_kdli_sio_niods	8	maximum #IO descriptors to allocate per session
_kdli_sio_strategy	extent	shared IO strategy: block vs. extent
_kdli_sio_fileopen	none	shared IO fileopen mode: datasync vs nodatasync vs async
_kdli_sio_flush	FALSE	enable shared IO pool operations
_kdli_sio_bps	0	maximum blocks per IO slot
_kdli_sio_pga	FALSE	use PGA allocations for direct IO
_kdli_sio_pga_top	FALSE	PGA allocations come from toplevel PGA heap
_kdli_sio_dop	2	degree-of-parallelism in the SIO keep pool
_kdli_sio_free	TRUE	free IO buffers when not in active use
_kdli_sio_backoff	FALSE	use exponential backoff when attempting SIOP allocations
_kdli_inline_xfm	TRUE	allow inline transformed lobs
_kdli_timer_trc	FALSE	trace inode timers to uts/tracefile
_kdli_timer_dmp	FALSE	dump inode timers on session termination
_kdli_cacheable_length	0	minimum lob length for inode cacheability
_kdli_small_cache_limit	32	size limit of small inode cache
_kdli_inject_assert	0	inject asserts into the inode
_kdli_inject_crash	0	inject crashes into the inode
_kdli_space_cache_limit	2048	maximum #blocks in per-segment space cache
_kdli_force_cr	TRUE	force CR when reading data blocks of direct-write lobs
_kdli_force_cr_meta	TRUE	force CR when reading metadata blocks of direct-write lobs
_kdli_recent_scn	FALSE	use recent (not dependent) scns for block format/allocation
_kdli_itree_entries	0	#entries in lhb/itree blocks (for testing only)
_kdli_cache_read_threshold	0	minimum lob size for cache->nocache read (0 disables heuristic)
_kdli_cache_write_threshold	0	minimum lob size for cache->nocache write (0 disables heuristic)
_kdli_full_readahead_threshold	0	maximum lob size for full readahead
_kdli_force_storage	none	force storage settings for all lobs
_kdli_allow_corrupt	TRUE	allow corrupt filesystem_logging data blocks during read/write
_kdli_squeeze	TRUE	compact lobmap extents with contiguous dbas
_kdli_buffer_inject	TRUE	use buffer injection for CACHE [NO]LOGGING lobs
_kdli_inject_batch	0	buffer injection batch size [1, KCBNEWMAX]
_kdli_flush_injections	TRUE	flush injected buffers of CACHE NOLOGGING lobs before commit
_kdli_flush_cache_reads	FALSE	flush cache-reads data blocks after load
_kdli_checkpoint_flush	FALSE	do not invalidate cache buffers after write
_kdli_delay_flushes	TRUE	delay flushing cache writes to direct-write lobs
_kdli_dbc	none	override db_block_checking setting for securefiles
_kdli_preallocation_pct	0	percentage preallocation [0 .. inf) for lob growth
_kdli_preallocation_mode	length	preallocation mode for lob growth
_kdli_inplace_overwrite	0	maximum inplace overwrite size (> chunksize)
_kdli_sio_write_pct	100	percentage of buffer used for direct writes
_kdli_sio_fbwrite_pct	35	percentage of buffer used for direct writes in flashback-db
_kdli_vll_direct	TRUE	use skip-navigation and direct-positioning in vll-domain
_kdli_descn_adj	FALSE	coalesce extents with deallocation scn adjustment
_kdli_oneblk	FALSE	allocate chunks as single blocks
_kdli_mts_so	TRUE	use state objects in shared server for asyncIO pipelines
_kdli_ralc_length	10485760	lob length threshold to trigger rounded allocations
_kdli_ralc_rounding	1048576	rounding granularity for rounded allocations
_kdli_space_cache_segments	16	#segments in space cache
_kdli_icache_entries	3	size of itree cache
_kdli_full_vll	FALSE	materialize full vll lobmap for reads
_kdli_small_append_redo	TRUE	detect and use redo optimizations for small appends
_kdli_STOP_tsn	0	undocumented parameter for internal use only
_kdli_STOP_dba	0	undocumented parameter for internal use only
_kdli_STOP_fsz	0	undocumented parameter for internal use only
_kdli_STOP_bsz	0	undocumented parameter for internal use only
_kdli_STOP_nio	0	undocumented parameter for internal use only
_kdlw_enable_write_gathering	TRUE	enable lob write gathering for sql txns
_kdlw_enable_ksi_locking	FALSE	enable ksi locking for lobs
_kdlwp_flush_threshold	4194304	WGC flush threshold in bytes
_kdlxp_cmp_subunit_size	262144	size of compression sub-unit in bytes
_kdlxp_minxfm_size	32768	minimum transformation size in bytes
_kdlxp_lobcompress	FALSE	enable lob compression - only on SecureFiles
_kdlxp_lobcmplevel	2	Default securefile compression
_kdlxp_lobcmprciver	1	Default securefile compression map version
_kdlxp_lobencrypt	FALSE	enable lob encryption - only on SecureFiles
_kdlxp_xfmcache	TRUE	enable xfm cache - only on SecureFiles
_kdlxp_lobcmpadp	FALSE	enable adaptive compression - only on SecureFiles
_kdlxp_uncmp	FALSE	lob data uncompressed - only on SecureFiles
_kdlxp_mincmplen	200	minimum loblen to compress - only on SecureFiles
_kdlxp_mincmp	20	minimum comp ratio in pct - only on SecureFiles
_sf_default_enabled	TRUE	enable 12g securefile default
db_securefile	PREFERRED	permit securefile storage during lob creation
_kdlf_read_flag	0	kdlf read flag
_kdlxp_lobdeduplicate	FALSE	enable lob deduplication - only on SecureFiles
_kdlxp_lobdedupvalidate	TRUE	enable deduplicate validate - only on SecureFiles
_kdlxp_dedup_hash_algo	SHA1	secure hash algorithm for deduplication - only on SecureFiles
_kdlxp_dedup_flush_threshold	8388608	deduplication flush threshold in bytes
_kdlxp_dedup_prefix_threshold	1048576	deduplication prefix hash threshold in bytes
_kdlxp_dedup_inl_pctfree	5	deduplication pct size increase by which inlining avoided
_kdlxp_dedup_wapp_len	0	deduplication length to allow write-append
_kdlxp_spare1	0	deduplication spare 1
_kdlxp_no_dedup_on_insert	FALSE	disable deduplication for new inserts of deduplicated lobs
_securefile_timers	FALSE	collect kdlu timers and accumulate per layers
_kdlu_trace_system	0	UTS system dump
_kdlu_trace_layer	0	UTS kdlu per-layer trace level
_kdlu_max_bucket_size	4194304	UTS kdlu bucket size
_kdlu_max_bucket_size_mts	131072	UTS kdlu bucket size for mts
_kdz_hcc_track_upd_rids	FALSE	Enable rowid tracking during updates
_kdz_hcc_flags	0	Miscellaneous HCC flags
_kdz_pcode_flags	0	pcode flags
_enable_columnar_cache	1	Enable Columnar Flash Cache Rewrite
_kdz_proj_nrows	1024	Number of rows to project at a time in kdzt
_kdz_pred_nrows	32767	Number of rows to predicate at a time in kdzt
_kdzk_enable_init_trace	FALSE	Enable kdzk initialization tracing
_kdzk_load_specialized_library	3	Flags for loading HPK specialized library
_kdzk_specialized_library_name		HPK specialized library name
_kdzk_trace_level	0	HPK trace level
_hpk_project_cost_weighting	20	hpk project cost weighting
_hpk_throughput_range	5	hpk throughput range
_hpk_compression_range	5	hpk compression range
_inmemory_analyzer_optimize_for	0	inmemory analyzer optimize for
_kdz_clear_analysis_percent	60	percentage to clear dictionary analysis
_dbfs_modify_implicit_fetch	TRUE	DBFS Link allows implicit fetch on modify - only on SecureFiles
_ILM_FILTER_TIME	0	Upper filter time for ILM block compression
_ILM_FILTER_TIME_LOWER	0	Lower filter time for ILM block compression
_ILM_POLICY_NAME	FALSE	User specified ILM policy name
_inmemory_default_flags	8459	Default flags based on inmemory_clause_default
_inmemory_default_new	FALSE	Force in-memory on new tables
inmemory_clause_default		Default in-memory clause for new tables
inmemory_force	DEFAULT	Force tables to be in-memory or not
inmemory_query	ENABLE	Specifies whether in-memory queries are allowed
_inmemory_default_svc	0	Default In-Memory distribute service type for new tables
_inmemory_default_svcname		Default In-Memory distribute service name for new tables
inmemory_expressions_usage	ENABLE	Controls which In-Memory Expressions are populated in-memory
inmemory_virtual_columns	MANUAL	Controls which user-defined virtual columns are stored in-memory
_inmemory_disable_selective_vircols	FALSE	disable selective columns for VCs/IMEs
_inmemory_expression_count	20	IME number of expressions to lookup from the ESS
_inmemory_max_expressions_table	50	IME maximum number of SYS_IME VCs in a table
_inmemory_expressions_mark_unused	FALSE	Mark cold IME expressions unused instead of no inmemory
_inmemory_ime_increpop_threshold	1	Invalidation threshold for IME incremental repopulation
_inmemory_query_scan	TRUE	In-memory scan enabled
_inmemory_scan_override	FALSE	In-memory scan override
_inmemory_small_segment_threshold	65536	In-memory small segment threshold (must be larger for in-memory)
_inmemory_query_fetch_by_rowid	FALSE	In-memory fetch-by-rowid enabled
_inmemory_pruning	ON	In-memory pruning
_inmemory_subcusize	512	In-memory subCU size
_inmemory_subcu_histsize	0	In-memory subCU Histogram size
_inmemory_enable_sys	FALSE	enable in-memory on system tablespace with sys user
_inmemory_populate_fg	FALSE	populate in foreground
_inmemory_pga_per_server	536870912	minimum pga needed per inmemory populate server
inmemory_max_populate_servers	2	maximum inmemory populate servers
_inmemory_servers_throttle_pgalim_percent	55	In-memory populate servers throttling pga limit percentage
inmemory_trickle_repopulate_servers_percent	1	inmemory trickle repopulate servers percent
_inmemory_populate_wait	FALSE	wait for population to complete
_inmemory_populate_wait_max	600	maximum wait time in seconds for segment populate
_inmemory_imco_cycle	120	IMCO cycle in seconds (sleep period)
_inmemory_disable_alter_imco_cycle	FALSE	in-memory disable alter imco cycle
_inmemory_enable_population_verify	1	verify in-memory population
_inmemory_log_level	0	in-memory log level
_inmemory_fs_verify	FALSE	in-memory faststart verify
_inmemory_force_fs	FALSE	in-memory faststart force
_inmemory_force_fs_tbs	SYSAUX	in-memory faststart force tablespace
_inmemory_force_fs_tbs_size	1073741824	in-memory faststart force tablespace size
_inmemory_fs_raise_error	FALSE	in-memory faststart raise error
_inmemory_fs_nodml	FALSE	in-memory faststart assumes no dmls while populating
_inmemory_fs_enable	TRUE	in-memory faststart enable
_inmemory_fsdw_enable	TRUE	in-memory faststart deferwrite enable
_inmemory_fsdw_populate_threshold_multiplier	10	in-memory faststart deferwrite populate threshold multiplier
_inmemory_faststart_control_flags	0	in-memory faststart control flags
_inmemory_fsdw_on_populate	TRUE	in-memory faststart deferwrite on populate
_inmemory_fsdw_penalty_threshold	20	in-memory faststart deferwrite penalty threshold
_inmemory_fsdw_inline	FALSE	in-memory faststart deferwrite inline
_inmemory_fs_enable_blk_lvl_inv	TRUE	in-memory faststart enable block level invalidation
_inmemory_fsdw_cnt	2147483647	in-memory faststart defer writes per cycle
_inmemory_fsdw_maxcnt	10	in-memory faststart max defer writes per cycle
_inmemory_fsdw_maxmem	104755200	in-memory faststart max defer writes memory cap
_inmemory_fsdw_threshold	300	In-memory faststart defer write minimum interval (millisec)
_inmemory_fsdw_priority_population_percent	100	In-memory faststart defer write percent priority for population
_inmemory_fsdw_priority_repopulation_percent	90	In-memory faststart defer write percent priority for repopulation
_inmemory_fsdw_priority_penalty_percent	10	In-memory faststart defer write percent priority for penalized
_inmemory_fsdw_schedlrtm	1	in-memory faststart defer write scheduler cycle (sec)
_inmemory_fsdw_scheduler_dedicated	FALSE	in-memory faststart defer write dedicated scheduler
_inmemory_fs_blk_inv_blkcnt		in-memory faststart CU invalidation threshold(blocks)
_inmemory_fs_blk_inv_blk_percent	50	in-memory faststart CU invalidation threshold(blocks)
_inmemory_fs_prune_pct	10	in-memory faststart out of mem prune percent
_inmemory_fs_dmlverify_read_ahead_cnt	10	in-memory faststart dmlverify read ahead count
_inmemory_fsdw_task_timeout	20	in-memory faststart defer writes task timeout (sec)
_inmemory_fs_tbsmaxsz		in-memory faststart tablespace maximum size
_inmemory_enable_stat_alert	FALSE	dump in-memory stats in alert log file
_inmemory_imcu_align	TRUE	Enforce 8M IMCU alignment
_inmemory_max_populate_retry	3	IM populate maximum number of retry
_inmemory_imcu_target_rows	0	IMCU target number of rows
_inmemory_imcu_target_bytes	0	IMCU target size in bytes
_inmemory_imcu_source_extents	0	number of source extents per IMCU
_inmemory_imcu_source_blocks	0	number of source blocks per IMCU
_inmemory_imcu_source_minbytes	1048576	number of minimum source bytes per IMCU
_inmemory_imcu_populate_minbytes	5242880	minimum free space in IMA for populating IMCU
_inmemory_imcu_source_analyze_bytes	134217728	number of source analyze bytes per IMCU
_inmemory_imcu_target_maxrows	8388608	IMCU maximum target number of rows
_inmemory_imcu_source_maxbytes	536870912	IMCU maximum source size in bytes
_inmemory_max_queued_tasks	800	Maximum queued populating tasks on the auxiliary queue
_inmemory_repopulate_threshold_rows		In-memory repopulate threshold number of modified rows
_inmemory_repopulate_threshold_blocks		In-memory repopulate threshold number of modified blocks
_inmemory_pct_inv_rows_invalidate_imcu	50	In-memory percentage invalid rows for IMCU invalidation
_inmemory_pct_inv_blocks_invalidate_imcu	100	In-memory percentage invalid blocks for IMCU invalidation
_inmemory_repopulate_threshold_mintime_factor	5	In-memory repopulate minimum interval (N*timetorepop)
_inmemory_repopulate_threshold_mintime	0	In-memory repopulate minimum interval (millisec)
_inmemory_repopulate_threshold_scans	0	In-memory repopulate threshold number of scans
_inmemory_repopulate_priority_scale_factor	100	In-memory repopulate priority threshold scale factor
_inmemory_repopulate_invalidate_rate_percent	0	In-memory repopulate invalidate rate percent
_inmemory_repopulate_priority_threshold_row	160	In-memory repopulate priority threshold row
_inmemory_repopulate_priority_threshold_block	320	In-memory repopulate priority threshold block
_inmemory_repopulate_threshold_rows_percent	5	In-memory repopulate threshold rows invalid percentage
_inmemory_repopulate_threshold_blocks_percent	10	In-memory repopulate threshold blocks invalid percentage
_inmemory_repopulate_disable	2	disable In-memory repopulate
_inmemory_checksum	FALSE	If true, checksums in-memory area to detect stray writes
_inmemory_cu_checksum	FALSE	If true, checksums CU to detect stray writes
_inmemory_validate_fetch	FALSE	If true, validate single-row fetch between in-memory and disk
_inmemory_journal_row_logging	FALSE	If true, log the entire row into the in-memory journal
inmemory_optimized_arithmetic	DISABLE	Controls whether or not DSBs are stored in-memory
_inmemory_prefix_encode_dsbs	FALSE	Prefix-encode the DSB-dictionary
_inmemory_vector_encode_override	FALSE	Populate and use DSBs for Vector Encode columns
_inmemory_journal_check	0	Depending on value does one of the DML verifications
_inmemory_rows_check_interrupt	1000	Number of rows buffered before interrupt check
_inmemory_enable_readonly	TRUE	Enable Inmemory on read only DB instance
_inmemory_repopulate_flags	2	In-memory repopulate decision flags
_inmemory_hwm_expansion	0	If 0, the highwatermark CU is dropped when expanded
_inmemory_dbg_scan	0	In-memory scan debugging
_inmemory_query_check	0	In-memory query checking
_inmemory_test_verification	0	In-memory verification testing
_inmemory_invalidate_cursors	TRUE	In-memory populate enable cursor invalidations
_inmemory_prepopulate_fg	0	Force prepopulate of in-memory segment in foreground
_inmemory_format_compatible	19.0.0	In-memory format compatibility parameter
_inmemory_prepopulate	TRUE	Enable inmemory populate by IMCO
_inmemory_trickle_repopulate	TRUE	Enable inmemory trickle repopulate
_inmemory_trickle_repopulate_threshold_dirty_ratio	0	IMCO Trickle Repopulate threshold dirty ratio
_inmemory_trickle_repopulate_min_interval	300	IMCO Trickle Repopulate Interval
_inmemory_trickle_repopulate_fg	0	Trickle Repopulate in the Foreground
_inmemory_max_delta	5	Inmemory max number of deltas per CU
_inmemory_delta_population	0	Control Delta IMCU population
_inmemory_min_delta_blocks	50	Inmemory minimum blocks per delta
_inmemory_min_delta_rows	255	Inmemory minimum rows per delta
_inmemory_scan_invalid_percent	30	Inmemory scan invalid percentage
_inmemory_external_table	TRUE	Enable inmemory extern table
_inmemory_parallel_load_ext	TRUE	Parallel load inmemory extern table
_inmemory_dynamic_scans	AUTO	Enable IM Dynamic Scans
_inmemory_dynamic_scans_batch_size	500	Number of steady state outstanding tasks
_inmemory_dynamic_scans_analyze_batch_size	5	Inmemory dynamic scan analyze batch size
_inmemory_dynamic_scan_disable_threshold	10	Inmemory dynamic scan disable threshold
_inmemory_dynamic_scans_dbg	0	Inmemory dynamic scans debug
_inmemory_suppress_vsga_ima	FALSE	Suppress inmemory area in v$sga
_inmemory_force_non_engineered	FALSE	force non-engineered systems in-memory behavior on RAC
_inmemory_hwm_expand_percent	20	max blks percent can exceed in hwmimcu
_globaldict_enable	2	Enable segment dictionary
_globaldict_chunk_minalloc	FALSE	Force minimum chunk allocation size
_globaldict_use_ndv	TRUE	Use NDV for sizing global dictionary, if available
_globaldict_dbg	0	Global dictionary debug modes
_globaldict_reprobe_limit	1	Reprobe limit for global dictionary
_globaldict_chain_limit	32	Chain limit for global dictionary
_globaldict_check	0	Dictionary checking
_globaldict_analyzer_pct	100	Maximum percentage of unique values in analyzer phase for GD
_globaldict_max_gdsize	1073741824	Maximum number of entries in a Global dictionary
inmemory_automatic_level	OFF	Enable Automatic In-Memory management
_imado_diagtasks_log_period	5	IM-ADO diagnostic tasks logging period (in seconds)
_imado_diagtasks_purge_period	30	IM diagnostic tasks purge older than X days
_imado_sysaux_usage_limit	90	SYSAUX usage percent limit for storing AIM diagnostics
_imado_disable_bg	FALSE	Disable AIM background task for testing
_imado_mem_threshold	98	Memory threshold percent for AIM action
_imado_optim_algo	GREEDY	Optimization algorithm for AIM
_imado_optimize_period	0	IM-store optimize period for AIM (in minutes)
_imado_verification	0	AIM verification state
_imado_evict_sf	2	AIM evict safety factor
_cellcache_default_flags	2	Default flags based on cellcache_clause_default
_cellcache_default_new	FALSE	Force cellcache on new tables
_cellcache_clause_default		Default cellcache clause for new tables
_index_load_buf_oltp_sacrifice_pct	10	index load buf oltp sacrifice pct
_index_load_buf_oltp_under_pct	85	index load buf and comp oltp under-estimation pct
_index_load_buf_oltp_over_retry	0	index load buf and comp oltp over-estimation retry
_index_load_last_leaf_comp	85	index load write last leaf compression threshold
_index_load_min_key_count	10	index load min key count for first compression
_index_load_analysis_frequency	4	index load compression analysis frequency
_kdizoltp_uncompsentinal_freq	16	kdizoltp uncomp sentinal frequency
_kdfs_trace	1	dbfs trace level
_kdfs_trace_size	131072	size of the uts buffer for generic traces
_kdfs_timer_dmp	FALSE	dbfs timers
_kdfs_fix_control	0	dbfs fix_control
_worker_threads	0	Number of worker threads
_advanced_index_compression_umem_options	2147483647	advanced index compression umem options
_advanced_index_compression_options	0	advanced index compression options
_advanced_index_compression_cmp_options	0	advanced index compression cmp options
_advanced_index_compression_tst_options	0	advanced index compression tst options
_advanced_index_compression_opt_options	0	advanced index compression opt options
_advanced_index_compression_options_value	0	advanced index compression options2
_advanced_index_compression_recmp_cusz	90	advanced index compression limit recomp cu
_advanced_index_compression_recmp_crsz	10	advanced index compression limit recomp cr
_advanced_index_compression_recmp_nprg	10	advanced index compression limit recomp pu
_column_level_stats	OFF	Turn column statistics collection on or off
_column_stats_mem_limit	10	percentage of the max shared pool column-level statistics can use - internal
_column_stats_flush_interval	60	column-level statistics flush to disk interval
_column_stats_max_entries_per_stat	5	column-level statistics max entries saved per stat type
_kdkv_trace	FALSE	kdkv tracing on-off
_kdkv_force_fastpath	FALSE	kdkv fast path on-off
_kdkv_index_lossy	TRUE	hashindex lossiness on-off
_kdkv_index_relocate	FALSE	hashindex relocation on-off
_kdkv_fg_populate	FALSE	hashindex foreground populate
_kdkv_fg_no_memopt	FALSE	hashindex foreground cleanup
_kdkv_fg_drop_memopt	TRUE	hashindex foreground drop
_kdkv_fg_repopulate	FALSE	hashindex foreground repopulate
_kdkv_indexinvalid	FALSE	objd and rdba based index invalidation
_kdkv_force_samehash	FALSE	kdkv hash to same bucket on-off
_kdfip_flush_nrows	2147483647	memopt w flush num rows
_kdfip_flush_rowsz	1048576	memopt w flush row size
_kdfip_flush_rowtm	60	memopt w flush time
_kdfip_cmap_nbkt	16	memopt w chunk map buckets
_kdfip_iga_bufsz	1048576	memopt w write buffer size
_kdfip_iga_maxsz	2147483648	memopt w max global area size
_kdfip_iga_minsz	268435456	memopt w min global area size
_kdfip_par_flush	TRUE	memopt w parallel flush
_kdfip_trace	FALSE	memopt w tracing on-off
_kdfip_debug	0	memopt w debug
_kdfip_elem_nclatch	64	memopt w chunkmap elem child latches
_kdfip_bufl_nbkt	128	memopt w buffers list buckets
_kdfip_drain_sleeps	60	memopt w drain coord sleep count
_kqr_optimistic_reads	TRUE	optimistic reading of row cache objects
_kqr_enable_conservative_logging	TRUE	log kgl/kqr objects conservativly in redo
_max_row_cache_dumps	1000	Maximum number of dumps allowed
_row_cache_dump_interval	0	Interval (in seconds) between each dump
_row_cache_dump_cooling_period	10	Period to wait (in minutes) before resetting dump count
_row_cache_cursors	20	number of cached cursors for row cache management
_kqdsn_instance_digits	2	number of instance digits in scalable sequence
_kqdsn_cpu_digits	3	number of cpu digits in scalable sequence
_kgl_cluster_lock	TRUE	Library cache support for cluster lock
_kgl_cluster_pin	TRUE	Library cache support for cluster pins
_kgl_cluster_lock_read_mostly	FALSE	Library cache support for cluster lock read mostly optimization
_kgl_latch_count	0	number of library cache latches
_kgl_heap_size	4096	extent size for library cache heap 0
_kgl_fixed_extents	TRUE	fixed extent size for library cache memory allocations
_kgl_bucket_count	9	Library cache hash table bucket count (2^_kgl_bucket_count * 256)
_library_cache_advice	TRUE	whether KGL advice should be turned on
_kglsim_maxmem_percent	5	max percentage of shared pool size to be used for KGL advice
_kgl_hash_collision	FALSE	Library cache name hash collision possible
_kgl_time_to_wait_for_locks	15	time to wait for locks and pins before timing out
_kgl_large_heap_warning_threshold	52428800	maximum heap size before KGL writes warnings to the alert log
_kgl_large_heap_assert_threshold	524288000	maximum heap size before KGL raises an internal error
_synonym_repoint_tracing	FALSE	whether to trace metadata comparisons for synonym repointing
_ignore_fg_deps		ignore fine-grain dependencies during invalidation
_trace_kqlidp	FALSE	trace kqlidp0 operation
_force_standard_compile	FALSE	force compilation of STANDARD
_disable_fast_validate	FALSE	disable PL/SQL fast validation
_kgl_message_locks	0	RAC message lock count
_kql_clientlocks_enabled	15	clients allocating DLM memory
_kgl_debug		Library cache debugging
_mutex_wait_time	1	Mutex wait time
_mutex_spin_count	255	Mutex spin count
_mutex_wait_scheme	2	Mutex wait scheme
_kgl_min_cached_so_count	1	Minimum cached SO count. If > 1 can help find SO corruptions
_kgl_hot_object_copies	0	Number of copies for the hot object
_kgl_kqr_cap_so_stacks	0	capture stacks for library and row cache state objects
_invalidate_upon_revoke	TRUE	Invalidate all dependent objects upon revoke
_pseudo_bootstrap	FALSE	Indicate that pseudo boostrap be done
_kgl_iterator_action	SKIP	Action to take if we dereference in-flux state in kgl iterator
_max_library_cache_dumps	1000	Maximum number of dumps allowed
_library_cache_dump_interval	0	Interval (in seconds) between each dump
_library_cache_dump_cooling_period	10	Period to wait (in minutes) before resetting dump count
_enable_kqf_purge	TRUE	Enable KQF fixed runtime table purge
create_stored_outlines		create stored outlines for DML statements
_object_number_cache_size	5	Object number cache size
_enable_Front_End_View_Optimization	1	enable front end view optimization
_max_remote_tool_requests	10	Maximum number of remote tool requests
serial_reuse	disable	reuse the frame segments
_cursor_features_enabled	2	Shared cursor features enabled bits.
_session_page_extent	2048	Session Page Extent Size
_cursor_runtimeheap_memlimit	5242880	Shared cursor runtime heap memory limit
_kgx_latches	1024	# of mutex latches if CAS is not supported.
_cursor_stats_enabled	TRUE	Enable cursor stats
_enable_editions_for_users	FALSE	enable editions for all users
_disable_actualization_for_grant	FALSE	disable actualization of editioned objects on grant
_ignore_edition_enabled_for_EV_creation	FALSE	ignore schema's edition-enabled status during EV creation
_cvw_examine_tables_in_from_list_subqry	TRUE	examine tables in from list subqueries
ldap_directory_access	NONE	RDBMS's LDAP access option
_ldap_password_oneway_auth	FALSE	Use oneway auth for password based LDAP directory bind
ldap_directory_sysauth	no	OID usage parameter
os_roles	FALSE	retrieve roles from the operating system
rdbms_server_dn		RDBMS's Distinguished Name
_lock_dc_users_time	120	max time to attempt to lock dc_users
_enable_secure_sub_role	FALSE	Disallow enabling of secure sub roles
remote_os_authent	FALSE	allow non-secure remote clients to use auto-logon accounts
remote_os_roles	FALSE	allow non-secure remote clients to use os roles
_case_sensitive_logon	TRUE	case sensitive logon enabled
sec_case_sensitive_logon	TRUE	case sensitive password enabled for logon
_VIEW_DICTIONARY_ACCESSIBILITY	FALSE	View Dictionary Accessibility Support
_restrict_become_user	TRUE	become user functionality restricted
_enable_http_digest_generation	TRUE	generation of the HTTP Digest verifier is enabled
_nls_binary	TRUE	force binary collation
_passwordfile_enqueue_timeout	900	password file enqueue timeout in seconds
remote_login_passwordfile	EXCLUSIVE	password file usage parameter
license_max_users	0	maximum number of named users that can be created in the database
_iat_frequency_short	FALSE	Use short interval (5 minutes) for inactive account time job
_dynamic_rls_policies	TRUE	rls policies are dynamic
_virtual_column_access_control	TRUE	require VPD/RAS protection for virtual columns derived from protected columns
_allow_insert_with_update_check	FALSE	Allow INSERT as statement_types when update_check is FALSE
_session_context_size	10000	session app context size
audit_sys_operations	TRUE	enable sys auditing
_default_encrypt_alg	0	default encryption algorithm
_tsenc_obfuscate_key	BOTH	Encryption key obfuscation in memory
_db_discard_lost_masterkey	FALSE	discard lost masterkey handles
_db_generate_dummy_masterkey	FALSE	if TRUE, use old havior and generate dummy master key
_use_fips_mode	FALSE	Enable use of crypographic libraries in FIPS mode
DBFIPS_140	FALSE	Enable use of crypographic libraries in FIPS mode, public
one_step_plugin_for_pdb_with_tde	FALSE	Facilitate one-step plugin for PDB with TDE encrypted data
external_keystore_credential_location		external keystore credential location
_heartbeat_period_multiplier	0	Multiplier for the period of the TDE heartbeat
_heartbeat_config	NONE	TDE heartbeat configuration parameter
_redo_log_key_reuse_count	0	Determines the number of redo logs sharing the same redo log key
_stats_encryption_enabled	FALSE	Enable statistics encryption on sensitive data
_REMOVE_INACTIVE_STANDBY_TDE_MASTER_KEY	FALSE	Remove Inactive Standby TDE Master Key
_standby_newkey_keystore_location		Location of keystore on standby having new key
_REMOVE_STDBY_OLD_KEY_AFTER_CHECKPOINT_SCN	TRUE	Remove standby old key after checkpoint SCN
_ols_cleanup_task	TRUE	Clean up unnecessary entries in OLS sessinfo table
_sys_logon_delay	1	The failed logon delay for the database instance
_pbkdf2_sder_count	3	The PBKDF2 count to use for session key derivation
_resource_includes_unlimited_tablespace	FALSE	Whether RESOURCE role includes UNLIMITED TABLESPACE privilege
_priv_for_set_current_schema	FALSE	ALTER SESSION privilege required for SET CURRENT_SCHEMA
_xs_cleanup_task	TRUE	Triton Session Cleanup
_xs_logon_grant	FALSE	Create session privilege is required for RAS direct logon user to login to database
_xds_max_child_cursors	100	Maximum number of XDS user-specific child cursors
_fusion_security	TRUE	Fusion Security
_radm_enabled	TRUE	Data Redaction
_strict_redaction_semantics	TRUE	Strict Data Redaction semantics
_xs_dispatcher_only	FALSE	XS dispatcher only mode
_unified_audit_policy_disabled	FALSE	Disable Default Unified Audit Policies on DB Create
unified_audit_sga_queue_size	1048576	Size of Unified audit SGA Queue
_unified_audit_flush_threshold	85	Unified Audit SGA Queue Flush Threshold
_unified_audit_flush_interval	3	Unified Audit SGA Queue Flush Interval
_asm_audit_sp_param		ASM audit spare parameter
_disable_asm_audit_feat	0	disable ASM audit features
_ldap_config_ssl_for_sasl_md5	TRUE	LDAP configure SSL for SASL-DIGEST-MD5
_ldap_config_force_sync_up	FALSE	LDAP configure force sync up
_ldap_reset_user_account_flc	TRUE	LDAP reset user account lockout counter
_ldap_no_nested_group_search	FALSE	LDAP no nested group search
_ldap_adaptive_to_no_nested_group_search	TRUE	LDAP adaptive to no nested group search
wallet_root		wallet root instance initialization parameter
tde_configuration		Per-PDB configuration for Transparent Data Encryption
_purge_idcs_access_token	FALSE	Purge IDCS Access Token
db_domain		directory part of global database name stored with CREATE DATABASE
global_names	FALSE	enforce that database links have same name as remote database
distributed_lock_timeout	60	number of seconds a distributed transaction waits for a lock
_distributed_recovery_connection_hold_time	200	number of seconds RECO holds outbound connections open
_reco_sessions_max_percentage	50	allowed RECO sessions as a percentage of total sessions allowed
commit_point_strength	1	Bias this node has toward not preparing in a two-phase commit
_k2q_latches	0	number of k2q latches
_clusterwide_global_transactions	TRUE	enable/disable clusterwide global transactions
global_txn_processes	1	number of background global transaction processes to start
_autotune_gtx_threshold	60	auto-tune threshold for degree of global transaction concurrency
_forwarded_2pc_threshold	10	auto-tune threshold for two-phase commit rate across RAC instances
_disable_autotune_gtx	FALSE	disable autotune global transaction background processes
_autotune_gtx_interval	5	interval to autotune global transaction background processes
_autotune_gtx_idle_time	600	idle time to trigger auto-shutdown a gtx background process
_enable_separable_transactions	FALSE	enable/disable separable transactions
_xa_internal_retries	600	number of internal retries for xa transactions
_restrict_db_link_user_entries	10000	Maximum number of entries per db link user
_db_link_sources_tracking	TRUE	enable/disable database link source tracking
_external_scn_activity_tracking	TRUE	enable/disable external scn activity tracking
instance_name	orcl	instance name supported by the instance
dispatchers	(PROTOCOL=TCP) (SERVICE=orclXDB)	specifications of dispatchers
shared_servers	1	number of shared servers to start up
max_shared_servers		max number of shared servers
max_dispatchers		max number of dispatchers
circuits		max number of circuits
shared_server_sessions		max number of shared server sessions
_pmon_load_constants	300,192,64,3,10,10,0,0	server load balancing constants (S,P,D,I,L,C,M)
_dispatcher_rate_ttl		time-to-live for rate statistic (100ths of a second)
_dispatcher_rate_scale		scale to display rate statistic (100ths of a second)
_enable_shared_server_vector_io	FALSE	Enable shared server vector I/O
_shared_server_load_balance	0	shared server load balance
_enable_shared_server_sizing	TRUE	Enable sizing manager for shared servers
_enable_shared_server_sizing_slope	FALSE	Enable utility slope in sizing manager for shared servers
_shared_server_sizing_coeff	1000	Shared server sizing coefficient
_shared_servers_performance	0	Tradeoff shared servers resource usage for performance
_dispatcher_listen_on_vip	FALSE	Determines if dispatcher listens on VIP if no HOST is supplied
_shared_server_num_queues	2	number of shared server common queues
_kernel_message_network_driver	FALSE	kernel message network driver
_dedicated_server_poll_count	10	dedicated server poll count
_dedicated_server_post_wait_call	FALSE	dedicated server post/wait call
_dedicated_server_post_wait	FALSE	dedicated server post/wait
use_dedicated_broker	FALSE	Use dedicated connection broker
_mpmt_fg_enabled	FALSE	MPMT mode foreground enabled
_bequeath_via_broker	FALSE	Bequeath connections via broker
connection_brokers	((TYPE=DEDICATED)(BROKERS=1)), ((TYPE=EMON)(BROKERS=1))	connection brokers specification
_cp_num_hash_latches	1	connection pool number of hash latches
_connection_broker_host	localhost	connection broker host for listen address
_connection_broker_handout_accept	FALSE	connection broker accepts prior to handout
local_listener	LISTENER_ORCL	local listener
forward_listener		forward listener
remote_listener		remote listener
listener_networks		listener registration networks
__reload_lsnr	0	reload listener
_disable_duplicate_service_warning	FALSE	disable listener warning for duplicate service
_pdb_service_on_root_listener	FALSE	pdb services on CDB ROOT listeners
_fast_cursor_reexecute	FALSE	use more memory in order to get faster execution
cursor_space_for_time	FALSE	use more memory in order to get faster execution
session_cached_cursors	50	Number of cursors to cache in a session.
_cursor_obsolete_threshold	8192	Number of cursors per parent before obsoletion.
_disable_cursor_sharing	FALSE	disable cursor sharing
_cursor_reload_failure_threshold	0	Number of failed reloads before marking cursor unusable
_cursor_diagnostic_node_agedout_count	100	Number of cursor-sharing diagnostic nodes to retain before reuse
_max_sql_stmt_length	0	Maximum allowed sql statement length
_monitor_sql_stmt_length	FALSE	Monitor sql statement length
_kks_cached_parse_errors	0	KKS cached parse errors
_kks_obsolete_dump_threshold	1	Number of parent cursor obsoletions before dumping cursor
_kks_parse_error_warning	100	Parse error warning
_dump_qbc_tree	0	dump top level query parse tree to trace
_sql_alias_scope	TRUE	Use only SQL name resolution for a column whose alias matches that of some table
remote_dependencies_mode	TIMESTAMP	remote-procedure-call dependencies mode parameter
smtp_out_server		utl_smtp server and port configuration parameter
_plsql_dump_buffer_events		conditions upon which the PL/SQL circular buffer is dumped
plsql_v2_compatibility	FALSE	PL/SQL version 2.x compatibility flag
_ncomp_shared_objects_dir		native compilation shared objects dir
plsql_warnings	DISABLE:ALL	PL/SQL compiler warnings settings
plsql_code_type	INTERPRETED	PL/SQL code-type
_plsql_anon_block_code_type	INTERPRETED	PL/SQL anonymous block code-type
plsql_debug	FALSE	PL/SQL debug
plsql_optimize_level	2	PL/SQL optimize level
plsql_ccflags		PL/SQL ccflags
_inline_sql_in_plsql	FALSE	inline SQL in PL/SQL
plscope_settings	identifiers:all	plscope_settings controls the compile time collection, cross reference, and storage of PL/SQL source code identifier and SQL statement data
_plsql_native_frame_threshold	4294967294	Allocate PL/SQL native frames on the heap if size exceeds this value
_plsql_nvl_optimize	FALSE	PL/SQL NVL optimize
_plsql_icd_arg_dump	FALSE	Dump arguments to ICD
_plsql_max_stack_size	0	PL/SQL maximum stack size
permit_92_wrap_format	TRUE	allow 9.2 or older wrap format in PL/SQL
_EnableShadowTypes	FALSE	enable shadow types
java_jit_enabled	TRUE	Java VM JIT enabled
java_restrict	none	Restrict Java VM Access
job_queue_processes	5	maximum number of job queue slave processes
_job_queue_interval	5	Wakeup interval in seconds for job queue co-ordinator
scheduler_follow_pdbtz	FALSE	Make scheduler objects follow PDB TZ
_redef_on_statement	FALSE	Use on-statement refresh in online redefinition
_duplicated_table_complete_refresh_percent	50	percent threshold for duplicated table to do complete refresh
_dbms_sql_security_level	1	Security level in DBMS_SQL
parallel_min_percent	0	minimum percent of threads required for parallel query
_parallel_default_max_instances	1	default maximum number of instances for parallel query
_system_trig_enabled	TRUE	are system triggers enabled
_AllowMultInsteadofDDLTrigger	0	Oracle internal parameter to allow multiple instead of DDL triggers
_kktAllowInsteadOfDDLTriggeronDDL	0	Oracle internal parameter to allow instead of DDL triggers on specified DDLs
_EnableDDLTtriggerTracing	FALSE	enable ddl trigger tracing
create_bitmap_area_size	8388608	size of create bitmap buffer for bitmap index
bitmap_merge_area_size	1048576	maximum memory allow for BITMAP MERGE
_kkfi_trace	FALSE	trace expression substitution
_lock_ref_constraint_count	50	number of nowait attempts to lock referential constraint
_lock_next_constraint_count	3	max number of attempts to lock _NEXT_CONSTRAINT
cursor_sharing	EXACT	cursor sharing mode
_adjust_literal_replacement	FALSE	If TRUE, we will adjust the SQL/PLUS output
_kolfuseslf	FALSE	allow kolf to use slffopen
_lock_ref_descendants_count	50	number of nowait attempts to lock ref-partitioning descendants
_kkpogpi_nocpy	1	attempt to avoid partition metadata copy in kkpogpi
_system_partition_with_default	FALSE	allow default partition for system partitioned tables
_autotbs_management_enabled	FALSE	allow automatic tablespace management
_create_idx_from_constraint	FALSE	allow trigger to create index from constraint
_kkpo_ctb_allow_vpd	FALSE	allow VPD predicates in recursive SQL under CREATE TABLE
result_cache_mode	MANUAL	result cache operator usage mode
_result_cache_auto_size_threshold	100	result cache auto max size allowed
_result_cache_auto_time_threshold	1000	result cache auto time threshold 
_result_cache_auto_execution_threshold	1	result cache auto execution threshold
_result_cache_deterministic_plsql	FALSE	result cache deterministic PLSQL functions
_max_string_size_bypass	0	controls error checking for the max_string_size parameter
_qkslvc_extended_bind_sz	1	controls error checking for the max_string_size parameter
_qkslvc_47510_test	0	enable project 47510 for testing
_qkslvc_47510_sys	1	enable project 47510 for internal users
_utl32k_mv_query	FALSE	utl32k.sql is compiling a materialized view query
_STFTranslateDynamicSQL	FALSE	if TRUE translation profile will translate dynamic SQL statements
_bigdata_external_table	TRUE	enables use of ORACLE_HIVE and ORACLE_HDFS access drivers
_external_table_hive_partition_restricted	TRUE	restrict external tabel hive partition methods to Hive supported
_qksfgi_disable_action_mask	0	disable fine-grained cursor invalidation actions
_qksfgi_disable_oct_mask	0	disable fine-grained cursor invalidation for certain oct
_qksfgi_dynamic_partitions		enable partition bind SQLIDs for 
_qksfgi_feature_level	0	controls the feature level for fine-grained cursor invalidation
_qksfgi_dix_val	FALSE	controls action of fine-grained cursor invalidation for DROP INDEX
_session_cached_instantiations	60	Number of pl/sql instantiations to cache in a session.
_protect_frame_heaps	FALSE	Protect cursor frame heaps
_frame_cache_time	0	number of seconds a cached frame page stay in cache.
_cursor_cache_time	900	number of seconds a session cached cursor stay in cache.
_aged_out_cursor_cache_time	300	number of seconds an aged out session cached cursor stay in cache
_kxscio_cap_stacks	FALSE	capture location when kxscio is set to null
_plsql_share_instantiation	TRUE	PL/SQL share kgscc for same SQL executed at multiple locations
_px_trace	none	px trace parameter
_xt_trace	none	external tables trace parameter
_xt_coverage	none	external tables code coverage parameter
_ku_trace	none	datapump trace parameter
_optimizer_trace	none	optimizer trace parameter
parallel_min_servers	6	minimum parallel query servers per instance
parallel_max_servers	60	maximum parallel query servers per instance
_parallel_server_idle_time	30000	idle time before parallel query server dies (in 1/100 sec)
_parallel_server_sleep_time	1	sleep time between dequeue timeouts (in 1/100ths)
_px_send_timeout	300	IPC message  send timeout value in seconds
_dynamic_stats_threshold	30	delay threshold (in seconds) between sending statistics messages
parallel_instance_group		instance group to use for all parallel operations
_px_execution_services_enabled	TRUE	enable service-based constraint of px slave allocation
_parallel_fake_class_pct	0	fake db-scheduler percent used for testing
_px_load_publish_interval	200	interval at which LMON will check whether to publish PX load
_px_proactive_slave_alloc_threshold	6	parallel proactive slave allocation threshold/unit
_px_load_balancing_policy	UNIFORM	parallel load balancing policy
_px_dp_array_size	32767	Max number of pq processes supported
_px_parallel_spawn_min_count	2	PQ parallel spawn min threshold count
_px_increase_join_frag_size	TRUE	increase join message fragment size
parallel_execution_message_size	16384	message buffer size for parallel execution
_parallel_execution_message_align	FALSE	Alignment of PX buffers to OS page boundary
_PX_use_large_pool	FALSE	Use Large Pool as source of PX buffers
_parallel_min_message_pool	491520	minimum size of shared pool memory to reserve for pq servers
_px_buffer_ttl	30	ttl for px mesg buffers in seconds
_tq_dump_period	0	time period for duping of TQ statistics (s)
_affinity_on	TRUE	enable/disable affinity at run time
_enable_default_affinity	0	enable default implementation of hard affinity osds
_px_max_map_val	32	Maximum value of rehash mapping for PX
_dss_cache_flush	FALSE	enable full cache flush for parallel execution
_dss_cache_flush_threshold	1	threshold when thread ckpt considered over obj ckpt
_hash_join_enabled	TRUE	enable/disable hash join
hash_area_size	131072	size of in-memory hash work area
_hash_multiblock_io_count	0	number of blocks hash join will read/write at once
_cursor_db_buffers_pinned	252	additional number of buffers a cursor can pin at once
_old_connect_by_enabled	FALSE	enable/disable old connect by
_table_lookup_prefetch_size	40	table lookup prefetch vector size
_multi_join_key_table_lookup	TRUE	TRUE iff multi-join-key table lookup prefetch is enabled
_table_lookup_prefetch_thresh	2	table lookup prefetch threshold
_adaptive_fetch_enabled	TRUE	enable/disable adaptive fetch in parallel group by
_query_execution_cache_max_size	131072	max size of query execution cache
_fast_dual_enabled	TRUE	enable/disable fast dual
_newsort_enabled	TRUE	controls whether new sorts can be used as system sort
_newsort_type	0	specifies options for the new sort algorithm
_newsort_ordered_pct	63	controls when new sort avoids sorting ordered input
_recursive_with_max_recursion_level	0	check for maximum level of recursion instead of checking for cycles
_sort_spill_threshold	0	force sort to spill to disk each time this many rows are received
_queue_buffer_max_dump_len	65536	max number of bytes to dump to trace file for queue buffer dump
_force_hash_join_spill	FALSE	force hash join to spill to disk
_nlj_batching_ae_flag	2	FAE flag type set after restoring to IO batching buffer
_sort_sync_min_spillsize	262144	controls the size of mininum run size for synchronized spill (in kb)
_sort_sync_min_spill_threshold	90	controls the mininum spill size for synchronized spill (in percent)
_sqlexec_cache_aware_hash_join_enabled	TRUE	enable/disable cache aware hash join
_sqlexec_encoding_aware_hj_enabled	TRUE	enable/disable encoding aware hash join
_sqlexec_sort_uses_xmem	TRUE	enable/disable xmem PGA for sort areas
_sqlexec_hash_join_uses_xmem	FALSE	enable/disable xmem PGA for hash join areas
_sqlexec_encoding_aware_hj_min_compression_ratio	8	minimum compression ratio to leverage encoding for HJ probe
_sqlexec_join_group_aware_hj_enabled	TRUE	enable/disable join group aware hash join
_sqlexec_join_group_aware_hj_unencoded_rowsets_tolerated	50	minimum number of unencoded rowsets processed before adaptation
_sqlexec_cache_aware_hash_aggr_enabled	TRUE	enable/disable cache aware hash aggregation
_sqlexec_bitmap_options	0	settings for bitmap count distinct optimizations
_sqlexec_bitmap_sparse_size	100	maximum number of sparse bitmap values
_sysdate_at_dbtimezone	FALSE	return SYSDATE at database timezone
_in_memory_cdt	LIMITED	In Memory CDT
_in_memory_ts_only	OFF	In Memory CDT use temp segment only
_in_memory_memory_threshold	40	In Memory CDT memory threshold
_in_memory_cdt_maxpx	4	Max Parallelizers allowed for IMCDT
_ptt_max_num	16	Maximum number of PTTs per session
private_temp_table_prefix	ORA$PTT_	Private temporary table prefix
_in_memory_cleanup_wait_timeout	10000	Tiemout for IMCDT cleanup waiting for end of scan
_fix_control		bug fix control parameter
_sdiag_crash	NONE	sql diag crash
result_cache_max_size	12091392	maximum amount of memory to be used by the cache
result_cache_max_result	5	maximum result size as percent of cache size
result_cache_remote_expiration	0	maximum life time (min) for any result using a remote object
_result_cache_block_size	1024	result cache block size
_result_cache_copy_block_count	1	blocks to copy instead of pinning the result
_result_cache_global	TRUE	Are results available globally across RAC?
_result_cache_per_pdb	TRUE	Is service result cache per pdb
_result_cache_timeout	10	maximum time (sec) a session waits for a result
_result_cache_white_list		users allowed to use result cache
_result_cache_black_list		cache_id's not allowed to use the result cache
_result_cache_latch_free_reads	ADMIN	latch free reads
_result_cache_auto_time_distance	300	result cache auto time distance
_result_cache_auto_dml_monitoring_slots	4	result cache auto dml monitoring slot
_result_cache_auto_dml_monitoring_duration	15	result cache auto dml monitoring duration
_result_cache_auto_dml_threshold	16	result cache auto dml threshold
_result_cache_auto_dml_trend_threshold	20	result cache auto dml trend threshold
_parallel_queuing_max_waitingtime		parallel statement queuing: max waiting time in queue
_cell_offload_expressions	TRUE	enable offload of expressions to cells
_cell_materialize_virtual_columns	TRUE	enable offload of expressions underlying virtual columns to cells
_cell_materialize_all_expressions	FALSE	Force materialization of all offloadable expressions on the cells
_cell_offload_sys_context	TRUE	enable offload of SYS_CONTEXT evaluation to cells
_gby_vector_aggregation_enabled	TRUE	enable group-by and aggregation using vector scheme
_key_vector_max_size	0	maximum key vector size (in KB)
_key_vector_predicate_enabled	TRUE	enables or disables key vector filter predicate pushdown
_key_vector_predicate_threshold	0	selectivity pct for key vector filter predicate pushdown
_key_vector_offload	predicate	controls key vector offload to cells
_vector_operations_control	0	control different uses/algorithms related to vector transform
_vector_serialize_temp_threshold	1000	threshold for serializing vector transform temp table writes
_always_vector_transformation	FALSE	always favor use of vector transformation
_vector_aggregation_max_size	0	max size of vector aggregation space
_vector_dense_accum_max	100	vector group by dense accumulator space max
_key_vector_create_pushdown_threshold	20000	minimum grouping keys for key vector create pushdown
_key_vector_alternate_dictionary	TRUE	enables or disables key vector alternate dictionary generation
_key_vector_force_alternate_dictionary	FALSE	stops key vector alternate dictionary from being disabled
_key_vector_shared_dgk_ht	TRUE	allows shared DGK hash table
_key_vector_double_enabled	TRUE	enables or disables key vector support for binary_double
_key_vector_timestamp_enabled	TRUE	enables or disables key vector support for timestamp
_cell_offload_vector_groupby_withnojoin	TRUE	allow offload of vector group by without joins
_key_vector_join_pushdown_enabled	TRUE	enables or disables key vector join push down support
_cell_offload_grand_total	TRUE	allow offload of grand total aggregations
_ptf_max_rows	1024	number of rows per row-buffer
_qesma_mvob_lru_sz	25	size of MVOB LRU list for QESMA session cache
_qesma_bo_lru_sz	25	size of base object LRU list for QESMA session cache
_qesmasc_trc	0	tracing for QESMA session cache
_ptf_enable_objects	FALSE	enable object types in PTF
_oss_skgxp_udp_dynamic_credit_mgmt		OSSLIB set dynamic credit for SKGXP-UDP
shadow_core_dump	partial	Core Size for Shadow Processes
background_core_dump	partial	Core Size for Background Processes
background_dump_dest	/u01/db/rdbms/log	Detached process dump directory
user_dump_dest	/u01/db/rdbms/log	User process dump directory
core_dump_dest	/u01/app/oracle/diag/rdbms/orcl/orcl/cdump	Core dump directory
_oradbg_pathname		path of oradbg script
_shmprotect	0	allow mprotect use for shared memory
_crash_domain_on_exception	0	allow domain to exit for exceptions in any thread
_online_patch_disable_stack_check	FALSE	disable check for function on stack for online patches
_vendor_lib_loc		Vendor library search root directory
_disable_sun_rsm	TRUE	Disable IPC OSD support for Sun RSMAPI
_ipc_test_failover	0	Test transparent cluster network failover
_ipc_test_mult_nets	0	simulate multiple cluster networks
_ipc_fail_network	0	Simulate cluster network failer
audit_file_dest	/u01/app/oracle/admin/orcl/adump	Directory in which auditing files are to reside
audit_syslog_level		Syslog facility and level
unified_audit_systemlog		Syslog facility and level for Unified Audit
unified_audit_common_systemlog		Syslog facility and level for only common unified audit records
_enable_event_ports	TRUE	Enable/Disable event ports
_event_port_opts		Options for event ports
_enable_thr_kill	TRUE	Enable/Disable thread directed signalling
_sem_per_semid		the exact number of semaphores per semaphore set to allocate
_ops_per_semop		the exact number of operations per semop system call
_use_futex_ipc	FALSE	use futex ipc
_posix_spawn_enabled	TRUE	posix_spawn enabled
_datapump_inherit_svcname	TRUE	Inherit and propagate service name throughout job
_disable_streams_diagnostics	0	streams diagnostics
resource_manage_goldengate	FALSE	goldengate resource manager enabled
_max_aq_persistent_queue_memory	10	max aq persistent queue memory
object_cache_optimal_size	10240000	optimal size of the user session's object cache in bytes
object_cache_max_size_percent	10	percentage of maximum size over optimal of the user session's object cache
_no_objects	FALSE	no object features are used
lob_signature_enable	FALSE	enable lob signature
_kokli_cache_size	128	Size limit of ADT Table Lookup Cache
_kokln_current_read	FALSE	Make all LOB reads for this session 'current' reads
session_max_open_files	10	maximum number of open files allowed per session
_domain_index_batch_size	2000	maximum number of rows from one call to domain index fetch routine
_domain_index_dml_batch_size	200	maximum number of rows for one call to domain index dml routines
_odci_aggregate_save_space	FALSE	trade speed for space in user-defined aggregation
_odci_index_pmo_rebuild	FALSE	domain index running pmo rebuild
_nchar_imp_conv	TRUE	should implicit conversion bewteen clob and nclob be allowed
_insert_enable_hwm_brokered	TRUE	during parallel inserts high water marks are brokered
_pgactx_cap_stacks	FALSE	capture stacks for setting pgactx
open_links	4	max # open links per session
open_links_per_instance	4	max # open links per instance
_all_shared_dblinks		treat all dblinks as shared
_disttxn_for_queries	TRUE	remote queries start distributed transaction
_close_cached_open_cursors	FALSE	close cursors cached by PL/SQL at each commit
_disable_savepoint_reset	FALSE	disable the fix for bug 1402161
commit_write		transaction commit log write behaviour
commit_wait		transaction commit log wait behaviour
commit_logging		transaction commit log write behaviour
_init_sql_file	?/rdbms/admin/sql.bsq	File containing SQL statements to execute upon database creation
optimizer_features_enable	19.1.0	optimizer plan compatibility parameter
fixed_date		fixed SYSDATE value
audit_trail	DB	enable system auditing
sort_area_size	65536	size of in-memory sort work area
sort_area_retained_size	0	size of in-memory sort work area retained between fetch calls
_sort_multiblock_read_count	2	multi-block read count for sort
_shrunk_aggs_enabled	TRUE	enable use of variable sized buffers for non-distinct aggregates
_sql_ncg_mode	OFF	Optimization mode for SQL NCG
_cell_storidx_mode	EVA	Cell Storage Index mode
_cell_storidx_minmax_enabled	TRUE	enable Storage Index Min/Max optimization on the cells
_deferred_constant_folding_mode	DEFAULT	Deferred constant folding mode
_rdbms_internal_fplib_raise_errors	FALSE	enable reraising of any exceptions in CELL FPLIB
_rdbms_internal_fplib_enabled	FALSE	enable CELL FPLIB filtering within rdbms
_cell_index_scan_enabled	TRUE	enable CELL processing of index FFS
_cell_range_scan_enabled	TRUE	enable CELL processing of index range scans
_cell_offload_virtual_columns	TRUE	enable offload of predicates on virtual columns to cells
_cell_offload_predicate_reordering_enabled	FALSE	enable out-of-order SQL processing offload to cells
_cell_offload_timezone	TRUE	enable timezone related SQL processing offload to cells
_direct_read_decision_statistics_driven	TRUE	enable direct read decision based on optimizer statistics
cell_offload_processing	TRUE	enable SQL processing offload to cells
_cell_offload_hybrid_processing	TRUE	enable hybrid SQL processing offload to cells
_cell_offload_complex_processing	TRUE	enable complex SQL processing offload to cells
cell_offload_decryption	TRUE	enable SQL processing offload of encrypted data to cells
cell_offload_parameters		Additional cell offload parameters
cell_offload_compaction	ADAPTIVE	Cell packet compaction strategy
cell_offload_plan_display	AUTO	Cell offload explain plan display
_cell_offload_vector_groupby	TRUE	enable SQL processing offload of vector group by
_cell_offload_vector_groupby_force	FALSE	force offload of vector group by
_shrunk_aggs_disable_threshold	60	percentage of exceptions at which to switch to full length aggs
_gby_onekey_enabled	TRUE	enable use of one comparison of all group by keys
db_name	orcl	database name specified in CREATE DATABASE
db_unique_name	orcl	Database Unique Name
open_cursors	300	max # cursors per session
ifile		include file in init.ora
sql_trace	FALSE	enable SQL trace
os_authent_prefix	ops$	prefix for auto-logon accounts
_sql_connect_capability_table		SQL Connect Capability Table (testing only)
optimizer_mode	ALL_ROWS	optimizer mode
_optimizer_mode_force	TRUE	force setting of optimizer mode for user recursive SQL also
_explain_rewrite_mode	FALSE	allow additional messages to be generated during explain rewrite
_query_rewrite_or_error	FALSE	allow query rewrite, if referenced tables are not dataless
_sort_elimination_cost_ratio	0	cost ratio for sort eimination under first_rows mode
sql92_security	TRUE	require select privilege for searched update/delete
_grant_secure_role	FALSE	Disallow granting of SR to other SR or NSR
_sql_connect_capability_override	0	SQL Connect Capability Table Override
blank_trimming	FALSE	blank trimming semantics parameter
_always_anti_join	CHOOSE	always use this method for anti-join when possible
_optimizer_null_aware_antijoin	TRUE	null-aware antijoin parameter
_optimizer_partial_join_eval	TRUE	partial join evaluation parameter
_partition_view_enabled	TRUE	enable/disable partitioned views
_always_star_transformation	FALSE	always favor use of star transformation
_b_tree_bitmap_plans	TRUE	enable the use of bitmap plans for tables w. only B-tree indexes
star_transformation_enabled	FALSE	enable the use of star transformation
_column_elimination_off	FALSE	turn off predicate-only column elimination
_cpu_to_io	0	divisor for converting CPU cost to I/O cost
_optimizer_extended_cursor_sharing	UDO	optimizer extended cursor sharing
_optimizer_extended_cursor_sharing_rel	SIMPLE	optimizer extended cursor sharing for relational operators
_optimizer_adaptive_cursor_sharing	TRUE	optimizer adaptive cursor sharing
_optimizer_cost_model	CHOOSE	optimizer cost model
_optimizer_undo_cost_change	19.1.0	optimizer undo cost change
_optimizer_system_stats_usage	TRUE	system statistics usage
_optimizer_cache_stats	FALSE	cost with cache statistics
_new_sort_cost_estimate	TRUE	enables the use of new cost estimate for sort
_complex_view_merging	TRUE	enable complex view merging
_simple_view_merging	TRUE	control simple view merging performed by the optimizer
_unnest_subquery	TRUE	enables unnesting of complex subqueries
_optimizer_unnest_all_subqueries	TRUE	enables unnesting of every type of subquery
_optimizer_unnest_scalar_sq	TRUE	enables unnesting of of scalar subquery
_eliminate_common_subexpr	TRUE	enables elimination of common sub-expressions
_pred_move_around	TRUE	enables predicate move-around
_convert_set_to_join	FALSE	enables conversion of set operator to join
_px_bind_peek_sharing	TRUE	enables sharing of px cursors that were built using bind peeking
_px_ual_serial_input	TRUE	enables new pq for UNION operators
_px_minus_intersect	TRUE	enables pq for minus/interect operators
_remove_aggr_subquery	TRUE	enables removal of subsumed aggregated subquery
_distinct_view_unnesting	FALSE	enables unnesting of in subquery into distinct view
_optimizer_push_down_distinct	0	push down distinct from query block to table
_optimizer_cost_based_transformation	LINEAR	enables cost-based query transformation
_optimizer_squ_bottomup	TRUE	enables unnesting of subquery in a bottom-up manner
_optimizer_cbqt_factor	50	cost factor for cost-based query transformation
_push_join_predicate	TRUE	enable pushing join predicate inside a view
_push_join_union_view	TRUE	enable pushing join predicate inside a union all view
_push_join_union_view2	TRUE	enable pushing join predicate inside a union view
_fast_full_scan_enabled	TRUE	enable/disable index fast full scan
_optimizer_skip_scan_enabled	TRUE	enable/disable index skip scan
_optimizer_join_sel_sanity_check	TRUE	enable/disable sanity check for multi-column join selectivity
_optim_enhance_nnull_detection	TRUE	TRUE to enable index [fast] full scan more often
_enable_cscn_caching	FALSE	enable commit SCN caching for all transactions
_parallel_broadcast_enabled	TRUE	enable broadcasting of small inputs to hash and sort merge joins
_px_broadcast_fudge_factor	100	set the tq broadcasting fudge factor percentage
_px_kxib_tracing	0	turn on kxib tracing
_px_granule_size	1000000	default size of a rowid range granule (in KB)
_px_chunk_size	1000000	default size of a chunk for row id granules (in KB)
_px_xtgranule_size	10000	default size of a external table granule (in KB)
_xtbigdata_max_buffersize	10240	maximum size of IO Buffers for exadoop external tables (in KB)
_xtbuffer_size	0	buffer size in KB needed for populate/query operation
parallel_degree_policy	MANUAL	policy used to compute the degree of parallelism (MANUAL/LIMITED/AUTO/ADAPTIVE)
_px_min_granules_per_slave	13	minimum number of rowid range granules to generate per slave
_px_split_batches_per_slave	7	number of split granules per slave for exadoop
_px_split_use_single_list	TRUE	use single list for split granules
_px_split_multi_msg	TRUE	use multiple messages to send batch of split granules
_px_max_granules_per_slave	100	maximum number of rowid range granules to generate per slave
_px_no_stealing	FALSE	prevent parallel granule stealing in shared nothing environment
_px_no_granule_sort	FALSE	prevent parallel partition granules to be sorted on size
_px_proc_constrain	TRUE	reduce parallel_max_servers if greater than (processes - fudge)
_px_freelist_latch_divisor	2	Divide the computed number of freelists by this power of 2
parallel_adaptive_multi_user	FALSE	enable adaptive setting of degree for multiple user streams
parallel_threads_per_cpu	1	number of parallel execution threads per CPU
_parallel_adaptive_max_users	4	maximum number of users running with default DOP
_parallel_cluster_cache_policy	ADAPTIVE	policy used for parallel execution on cluster(ADAPTIVE/CACHED)
_parallel_load_balancing	TRUE	parallel execution load balanced slave allocation
_parallel_load_bal_unit	0	number of threads to allocate per instance
_parallel_slave_acquisition_wait	1	time(in seconds) to wait before retrying slave acquisition
_px_io_system_bandwidth	0	total IO system bandwidth in MB/sec for computing DOP
_px_io_process_bandwidth	200	IO process bandwidth in MB/sec for computing DOP
_pdml_slaves_diff_part	TRUE	slaves start on different partition when doing index maint
_pdml_gim_sampling	5000	control separation of global index maintenance for PDML
_pdml_gim_staggered	FALSE	slaves start on different index when doing index maint
_px_dynamic_opt	TRUE	turn off/on restartable qerpx dynamic optimization
_px_dynamic_sample_size	50	num of samples for restartable qerpx dynamic optimization
_px_rownum_pd	TRUE	turn off/on parallel rownum pushdown optimization
_predicate_elimination_enabled	TRUE	allow predicate elimination if set to TRUE
_groupby_nopushdown_cut_ratio	3	groupby nopushdown cut ratio
_groupby_orderby_combine	5000	groupby/orderby don't combine threshold
_temp_tran_block_threshold	100	number of blocks for a dimension before we temp transform
_temp_tran_cache	TRUE	determines if temp table is created with cache option
_ordered_semijoin	TRUE	enable ordered semi-join subquery
_always_semi_join	CHOOSE	always use this method for semi-join when possible
_ordered_nested_loop	TRUE	enable ordered nested loop costing
_nested_loop_fudge	100	nested loop fudge
_project_view_columns	TRUE	enable projecting out unreferenced columns of a view
_no_or_expansion	FALSE	OR expansion during optimization disabled
_optimizer_max_permutations	2000	optimizer maximum join permutations per query block
optimizer_index_cost_adj	100	optimizer index cost adjustment
optimizer_index_caching	0	optimizer percent index caching
_system_index_caching	0	optimizer percent system index caching
_serial_direct_read	auto	enable direct read in serial
_disable_datalayer_sampling	FALSE	disable datalayer sampling
_disable_sample_io_optim	FALSE	disable row sampling IO optimization
_sample_rows_per_block	4	number of rows per block used for sampling IO optimization
_ncmb_readahead_enabled	0	enable multi-block readahead for an index scan
_ncmb_readahead_tracing	0	turn on multi-block readahead tracing
_nlj_batching_enabled	1	enable batching of the RHS IO in NLJ
_nlj_batching_misses_enabled	1	enable exceptions for buffer cache misses
_ioq_fanin_multiplier	2	IOQ miss count before a miss exception
_index_prefetch_factor	100	index prefetching factor
query_rewrite_enabled	TRUE	allow rewrite of queries using materialized views if enabled
query_rewrite_integrity	enforced	perform rewrite using materialized views with desired integrity
_query_cost_rewrite	TRUE	perform the cost based rewrite with materialized views
_query_rewrite_2	TRUE	perform query rewrite before&after or only after view merging
_query_rewrite_1	TRUE	perform query rewrite before&after or only before view merging
_query_rewrite_fudge	90	cost based query rewrite with MVs fudge factor
_query_rewrite_expression	TRUE	rewrite with cannonical form for expressions
_query_rewrite_jgmigrate	TRUE	mv rewrite with jg migration
_query_rewrite_fpc	TRUE	mv rewrite fresh partition containment
_query_rewrite_drj	FALSE	mv rewrite and drop redundant joins
_query_rewrite_maxdisjunct	257	query rewrite max disjuncts
_query_rewrite_vop_cleanup	TRUE	prune frocol chain before rewrite after view-merging
_mmv_query_rewrite_enabled	TRUE	allow rewrites with multiple MVs and/or base tables
_bt_mmv_query_rewrite_enabled	TRUE	allow rewrites with multiple MVs and base tables
_add_stale_mv_to_dependency_list	TRUE	add stale mv to dependency list
_max_rwgs_groupings	8192	maximum no of groupings on materialized views
_full_pwise_join_enabled	TRUE	enable full partition-wise join when TRUE
_partial_pwise_join_enabled	TRUE	enable partial partition-wise join when TRUE
_slave_mapping_enabled	TRUE	enable slave mapping when TRUE
_slave_mapping_group_size	0	force the number of slave group in a slave mapper
_local_communication_costing_enabled	TRUE	enable local communication costing when TRUE
_local_communication_ratio	50	set the ratio between global and local communication (0..100)
_parallelism_cost_fudge_factor	350	set the parallelism cost fudge factor
_left_nested_loops_random	TRUE	enable random distribution method for left of nestedloops
_improved_row_length_enabled	TRUE	enable the improvements for computing the average row length
_px_object_sampling	200	parallel query sampling for base objects (100000 = 100%)
_px_object_sampling_multiplier	2	number of samples to send to QC per slave is DOP * prmixsm 
_index_join_enabled	TRUE	enable the use of index joins
_use_nosegment_indexes	FALSE	use nosegment indexes in explain plan
_enable_type_dep_selectivity	TRUE	enable type dependent selectivity estimates
_improved_outerjoin_card	TRUE	improved outer-join cardinality calculation
_optimizer_adjust_for_nulls	TRUE	adjust selectivity for null values
_optimizer_degree	0	force the optimizer to use the same degree of parallelism
_use_column_stats_for_function	TRUE	enable the use of column statistics for DDP functions
_subquery_pruning_cost_factor	20	subquery pruning cost factor
_subquery_pruning_reduction	50	subquery pruning reduction factor
_subquery_pruning_enabled	TRUE	enable the use of subquery predicates to perform pruning
_subquery_pruning_mv_enabled	FALSE	enable the use of subquery predicates with MVs to perform pruning
_parallel_txn_global	FALSE	enable parallel_txn hint with updates and deletes
_or_expand_nvl_predicate	TRUE	enable OR expanded plan for NVL/DECODE predicate
_like_with_bind_as_equality	FALSE	treat LIKE predicate with bind as an equality predicate
_table_scan_cost_plus_one	TRUE	bump estimated full table scan and index ffs cost by one
_cost_equality_semi_join	TRUE	enables costing of equality semi-join
_default_non_equality_sel_check	TRUE	sanity check on default selectivity for like/range predicate
_new_initial_join_orders	TRUE	enable initial join orders based on new ordering heuristics
_oneside_colstat_for_equijoins	TRUE	sanity check on default selectivity for like/range predicate
_column_tracking_level	53	column usage tracking
_optim_peek_user_binds	TRUE	enable peeking of user binds
_mv_refresh_selections	TRUE	create materialized views with selections and fast refresh
_cursor_plan_enabled	TRUE	enable collection and display of cursor plans
_minimal_stats_aggregation	TRUE	prohibit stats aggregation at compile/partition maintenance time
_mv_complete_refresh_conventional	FALSE	use conventional INSERTs for MV complete refresh
_mv_refresh_eut	TRUE	refresh materialized views using EUT(partition)-based algorithm
_mav_refresh_consistent_read	TRUE	refresh materialized views using consistent read snapshot
_mav_refresh_opt	0	optimizations during refresh of materialized views
_mav_refresh_unionall_tables	3	# tables for union all expansion during materialized view refresh
_mv_refresh_delta_fraction	10	delta mv as fractional percentage of size of mv
_mv_expression_extend_size	4096	MV expression extend size
_force_temptables_for_gsets	FALSE	executes concatenation of rollups using temp tables
pga_aggregate_target	805306368	Target size for the aggregate PGA memory consumed by the instance
__pga_aggregate_target	805306368	Current target size for the aggregate PGA memory consumed
_pga_max_size	209715200	Maximum size of the PGA memory for one process
workarea_size_policy	AUTO	policy used to size SQL working areas (MANUAL/AUTO)
_smm_auto_min_io_size	56	Minimum IO size (in KB) used by sort/hash-join in auto mode
_smm_auto_max_io_size	248	Maximum IO size (in KB) used by sort/hash-join in auto mode
_smm_auto_cost_enabled	TRUE	if TRUE, use the AUTO size policy cost functions
_smm_control	0	provides controls on the memory manager
_smm_trace	0	Turn on/off tracing for SQL memory manager
_smm_min_size	786	minimum work area size in auto mode
_smm_max_size_static	102400	static maximum work area size in auto mode (serial)
_smm_px_max_size_static	393216	static maximum work area size in auto mode (global)
_smm_max_size	102400	maximum work area size in auto mode (serial)
_smm_px_max_size	393216	maximum work area size in auto mode (global)
_smm_retain_size	0	work area retain size in SGA for shared server sessions (0 for AUTO)
_smm_bound	0	overwrites memory manager automatically computed bound
_smm_advice_log_size	0	overwrites default size of the PGA advice workarea history log
_smm_advice_enabled	TRUE	if TRUE, enable v$pga_advice
_gs_anti_semi_join_allowed	TRUE	enable anti/semi join for the GS query
_mv_refresh_use_stats	FALSE	pass cardinality hints to refresh queries
_mv_refresh_use_no_merge	TRUE	use no_merge hint in queries
_mv_refresh_use_hash_sj	TRUE	use hash_sj hint in queries
_no_stale_joinback_rewrite	FALSE	No joinbacks if mv is stale
_mv_refresh_no_idx_rebuild	FALSE	avoid index rebuild  as part of the MV refresh
_mv_deferred_no_log_age_val	TRUE	avoid build deferred MV log age validate
_mv_add_log_placeholder	TRUE	add log placeholder
_optim_new_default_join_sel	TRUE	improves the way default equijoin selectivity are computed
_optimizer_dyn_smp_blks	32	number of blocks for optimizer dynamic sampling
optimizer_dynamic_sampling	2	optimizer dynamic sampling
_pre_rewrite_push_pred	TRUE	push predicates into views before rewrite
_optimizer_new_join_card_computation	TRUE	compute join cardinality using non-rounded input values
_mav_refresh_double_count_prevented	FALSE	materialized view MAV refreshes avoid double counting
_pct_refresh_double_count_prevented	TRUE	materialized view PCT refreshes avoid double counting
_mv_refresh_new_setup_disabled	FALSE	materialized view MV refresh new setup disabling
_load_without_compile	NONE	Load PL/SQL or Database objects without compilation
_precompute_gid_values	TRUE	precompute gid values and copy them before returning a row
_union_rewrite_for_gs	YES_GSET_MVS	expand queries with GSets into UNIONs for rewrite
_nested_mv_fast_oncommit_enabled	TRUE	nested MV refresh fast on commit allowed
_generalized_pruning_enabled	TRUE	controls extensions to partition pruning for general predicates
_rowsource_execution_statistics	FALSE	if TRUE, Oracle will collect rowsource statistics
_rowsource_profiling_statistics	TRUE	if TRUE, Oracle will capture active row sources in v$active_session_history
_rowsource_statistics_sampfreq	128	frequency of rowsource statistic sampling (must be a power of 2)
_bitmap_or_improvement_enabled	TRUE	controls extensions to partition pruning for general predicates
_intrapart_pdml_enabled	TRUE	Enable intra-partition updates/deletes
_force_tmp_segment_loads	FALSE	Force tmp segment loads
_force_slave_mapping_intra_part_loads	FALSE	Force slave mapping for intra partition loads
_intrapart_pdml_randomlocal_enabled	TRUE	Enable intra-partition updates/deletes with random local dist
_optim_adjust_for_part_skews	TRUE	adjust stats for skews across partitions
_optimizer_compute_index_stats	TRUE	force index stats collection on index creation/rebuild
_optimizer_autostats_job	TRUE	enable/disable auto stats collection job
_optimizer_push_pred_cost_based	TRUE	use cost-based query transformation for push pred optimization
_optimizer_extend_jppd_view_types	TRUE	join pred pushdown on group-by, distinct, semi-/anti-joined view
_optimizer_filter_pred_pullup	TRUE	use cost-based flter predicate pull up transformation
_optimizer_connect_by_cost_based	TRUE	use cost-based transformation for connect by
_optimizer_connect_by_combine_sw	TRUE	combine no filtering connect by and start with
_optimizer_connect_by_elim_dups	TRUE	allow connect by to eliminate duplicates from input
_connect_by_use_union_all	TRUE	use union all for connect by
_force_datefold_trunc	FALSE	force use of trunc for datefolding rewrite
statistics_level	TYPICAL	statistics level
_array_update_vector_read_enabled	FALSE	Enable array update vector read
_two_pass_reverse_polish_enabled	TRUE	uses two-pass reverse polish alg. to generate canonical forms
_expand_aggregates	TRUE	expand aggregates
_dump_common_subexpressions	FALSE	dump common subexpressions
_spr_use_AW_AS	TRUE	enable AW for hash table in spreadsheet
_dump_connect_by_loop_data	FALSE	dump connect by loop error message into trc file
_column_compression_factor	0	Column compression ratio
_dml_monitoring_enabled	TRUE	enable modification monitoring
_fic_algorithm_set	automatic	Set Frequent Itemset Counting Algorithm
_fic_area_size	131072	size of Frequent Itemset Counting work area
_fic_min_bmsize	1024	Frequent Itemset Counting Minimum BITMAP Size
_dtree_area_size	131072	size of Decision Tree Classification work area
_dtree_pruning_enabled	TRUE	Decision Tree Pruning Enabled
_dtree_binning_enabled	TRUE	Decision Tree Binning Enabled
_dtree_max_surrogates	1	maximum number of surrogates
_right_outer_hash_enable	TRUE	Right Outer/Semi/Anti Hash Enabled
_optimizer_mjc_enabled	TRUE	enable merge join cartesian
_optimizer_sortmerge_join_enabled	TRUE	enable/disable sort-merge join method
_cursor_bind_capture_area_size	400	maximum size of the cursor bind capture area
cursor_bind_capture_destination	memory+disk	Allowed destination for captured bind variables
_flush_plan_in_awr_sql	0	Plan is being flushed from an AWR flush SQL
_cursor_bind_capture_interval	900	interval (in seconds) between two bind capture for a cursor
_dump_cursor_heap_sizes	FALSE	dump comp/exec heap sizes to tryace file
_projection_pushdown	TRUE	projection pushdown
_projection_pushdown_debug	0	level for projection pushdown debugging
_px_compilation_debug	0	debug level for parallel compilation
_px_compilation_trace	0	tracing level for parallel compilation
_trace_virtual_columns	FALSE	trace virtual columns exprs
_replace_virtual_columns	TRUE	replace expressions with virtual columns
_virtual_column_overload_allowed	TRUE	overload virtual columns expression
_kdt_buffering	TRUE	control kdt buffering for conventional inserts
_disable_parallel_conventional_load	FALSE	Disable parallel conventional loads
_ltc_trace	0	tracing level for load table conventional
_print_refresh_schedule	false	enable dbms_output of materialized view refresh schedule
_optimizer_undo_changes	FALSE	undo changes to query optimizer
_optimizer_percent_parallel	101	optimizer percent parallel
_optimizer_search_limit	5	optimizer search limit
skip_unusable_indexes	TRUE	skip unusable indexes if set to TRUE
_mv_refresh_costing	rule	refresh decision based on cost or on rules
_mv_refresh_ana	0	what percent to analyze after complete/PCT refresh
_cache_stats_monitor	FALSE	if TRUE, enable cache stats monitoring
_sta_control	0	SQL Tuning Advisory control parameter
_enable_automatic_sqltune	TRUE	Automatic SQL Tuning Advisory enabled parameter
_sql_analyze_enable_auto_txn	FALSE	SQL Analyze Autonomous Transaction control parameter
_ds_enable_auto_txn	FALSE	Dynamic Sampling Service Autonomous Transaction control parameter
_sql_analyze_parse_model	2	SQL Analyze Parse Model control parameter
_ds_parse_model	2	Dynamic Sampling Service Parse Model control parameter
_kes_parse_model	2	SQL Tune/SPA KES Layer Parse Model control parameter
_ds_iocount_iosize	6553664	Dynamic Sampling Service defaults: #IOs and IO Size
_ds_xt_split_count	1	Dynamic Sampling Service: split count for external tables
_ds_progressive_no_matches_min_sample_size	50	Minimum sample size at which progressive sampling report no match
_ds_progressive_initial_samples	2	Number of initial samples used for progressive sampling
_ds_sampling_method	PROGRESSIVE	Dynamic sampling method used
_ds_enable_view_sampling	TRUE	Use sampling for views in Dynamic Sampling
_mv_refsched_timeincr	300000	proportionality constant for dop vs. time in MV refresh
_spr_push_pred_refspr	TRUE	push predicates through reference spreadsheet
_optimizer_block_size	8192	standard block size used by optimizer
_spr_max_rules	10000	maximum number of rules in sql spreadsheet
_idxrb_rowincr	100000000	proportionality constant for dop vs. rows in index rebuild
_hj_bit_filter_threshold	50	hash-join bit filtering threshold (0 always enabled)
_optimizer_save_stats	TRUE	enable/disable saving old versions of optimizer stats
_optimizer_cost_filter_pred	FALSE	enables  costing of filter predicates in IO cost model
_optimizer_correct_sq_selectivity	TRUE	force correct computation of subquery selectivity
_allow_commutativity	TRUE	allow for commutativity of +, * when comparing expressions
_mv_refresh_rebuild_percentage	10	minimum percentage change required in MV to force an indexrebuild
_qa_control	0	Oracle internal parameter to control QA
_qa_lrg_type	0	Oracle internal parameter to specify QA lrg type
_mv_refresh_force_parallel_query	0	force materialized view refreshes to use parallel query
_enable_fast_ref_after_mv_tbs	FALSE	enable fast refresh after move tablespace
_optim_dict_stats_at_db_cr_upg	TRUE	enable/disable dictionary stats gathering at db create/upgrade
_utlmmig_table_stats_gathering	TRUE	enable/disable utlmmig table stats gathering at upgrade
_remove_exf_component	TRUE	enable/disable removing of components EXF and RUL during upgrade
_optimizer_dim_subq_join_sel	TRUE	use join selectivity in choosing star transformation dimensions
_optimizer_disable_strans_sanity_checks	0	disable star transformation sanity checks
_allow_level_without_connect_by	FALSE	allow level without connect by
optimizer_ignore_hints	FALSE	enables the embedded hints to be ignored
_optimizer_random_plan	0	optimizer seed value for random plans
_optimizer_ceil_cost	TRUE	CEIL cost in CBO
_delay_index_maintain	TRUE	delays index maintenance until after MV is refreshed
_query_rewrite_setopgrw_enable	TRUE	perform general rewrite using set operator summaries
_cursor_plan_hash_version	1	version of cursor plan hash value
_disable_function_based_index	FALSE	disable function-based index matching
_optimizer_invalidation_period	18000	time window for invalidation of cursors of analyzed objects
_px_net_msg_cost	10000	CPU cost to send a PX message over the internconnect
_px_loc_msg_cost	1000	CPU cost to send a PX message via shared memory
_smm_freeable_retain	5120	value in KB of the instance freeable PGA memory to retain
_cursor_plan_unparse_enabled	TRUE	enables/disables using unparse to build projection/predicates
_kill_java_threads_on_eoc	FALSE	Kill Java threads and do sessionspace migration at end of call
_optimizer_join_order_control	3	controls the optimizer join order search algorithm
_px_nss_planb	TRUE	enables or disables NSS Plan B reparse with outline
_bloom_filter_enabled	TRUE	enables or disables bloom filter
_bloom_filter_debug	0	debug level for bloom filtering
_bloom_filter_size	0	bloom filter vector size (in KB)
_bloom_predicate_enabled	TRUE	enables or disables bloom filter predicate pushdown
_bloom_predicate_offload	TRUE	enables or disables bloom filter predicate offload to cells
_bloom_folding_enabled	TRUE	Enable folding of bloom filter
_bloom_folding_density	16	bloom filter folding density lower bound
_bloom_folding_min	0	bloom filter folding size lower bound (in KB)
_bloom_pushing_max	512	bloom filter pushing size upper bound (in KB)
_bloom_max_size	262144	maximum bloom filter size (in KB)
_bloom_pushing_total_max	262144	bloom filter combined pushing size upper bound (in KB)
_bloom_minmax_enabled	TRUE	enable or disable bloom min max filtering
_bloom_rm_filter	FALSE	remove bloom predicate in favor of zonemap join pruning predicate
_bloom_sm_enabled	TRUE	enable bloom filter optimization using slave mapping
_bloom_serial_filter	ON	enable serial bloom filter on exadata
_enable_refresh_schedule	TRUE	enable or disable MV refresh scheduling (revert to 9.2 behavior)
_optimizer_cartesian_enabled	TRUE	optimizer cartesian join enabled
_optimizer_starplan_enabled	TRUE	optimizer star plan enabled
_optimizer_join_elimination_enabled	TRUE	optimizer join elimination enabled
_gby_hash_aggregation_enabled	TRUE	enable group-by and aggregation using hash scheme
_extended_pruning_enabled	TRUE	do runtime pruning in iterator if set to TRUE
_globalindex_pnum_filter_enabled	TRUE	enables filter for global index with partition extended syntax
_sql_model_unfold_forloops	RUN_TIME	specifies compile-time unfolding of sql model forloops
_enable_dml_lock_escalation	TRUE	enable dml lock escalation against partitioned tables if TRUE
_plsql_cache_enable	TRUE	PL/SQL Function Cache Enabled
_disable_fast_aggregation	FALSE	fast aggregation
_disable_adaptive_shrunk_aggregation	FALSE	adaptive shrunk aggregation
_plsql_minimum_cache_hit_percent	20	plsql minimum cache hit percentage required to keep caching active
_plan_outline_data	TRUE	explain plan outline data enabled
_outline_bitmap_tree	TRUE	BITMAP_TREE hint enabled in outline
_drop_table_optimization_enabled	TRUE	reduce SGA memory use during drop of a partitioned table
_drop_table_granule	256	drop_table_granule
_xpl_trace	0	Explain Plan tracing parameter
_dm_max_shared_pool_pct	1	max percentage of the shared pool to use for a mining model
_optimizer_multiple_cenv		generate and run plans using several compilation environments
_kql_subheap_trace	0	tracing level for library cache subheap level pins
_optimizer_cost_hjsmj_multimatch	TRUE	add cost of generating result set when #rows per key > 1
_optimizer_transitivity_retain	TRUE	retain equi-join pred upon transitive equality pred generation
optimizer_secure_view_merging	TRUE	optimizer secure view merging and predicate pushdown/movearound
_px_pwg_enabled	TRUE	parallel partition wise group by enabled
_sql_hash_debug	0	Hash value of the SQL statement to debug
_mv_rolling_inv	FALSE	create/alter mv uses rolling cursor invalidation instead of immediate 
_smm_isort_cap	102400	maximum work area for insertion sort(v1)
_optimizer_cbqt_no_size_restriction	TRUE	disable cost based transformation query size restriction
_windowfunc_optimization_settings	0	settings for window function optimizations
_truncate_optimization_enabled	TRUE	do truncate optimization if set to TRUE
_optimizer_enhanced_filter_push	TRUE	push filters before trying cost-based query transformation
_compilation_call_heap_extent_size	16384	Size of the compilation call heaps extents
_xpl_peeked_binds_log_size	8192	maximum bytes for logging peeked bind values for V$SQL_PLAN (0 = OFF)
_rowsrc_trace_level	0	Row source tree tracing level
_optimizer_rownum_pred_based_fkr	TRUE	enable the use of first K rows due to rownum predicate
_optimizer_better_inlist_costing	ALL	enable improved costing of index access using in-list(s)
_optimizer_self_induced_cache_cost	FALSE	account for self-induced caching
_optimizer_min_cache_blocks	10	set minimum cached blocks
_enable_exchange_validation_using_check	TRUE	use check constraints on the table for validation
_optimizer_or_expansion	DEPTH	control or expansion approach used
_optimizer_outer_to_anti_enabled	TRUE	Enable transformation of outer-join to anti-join if possible
_optimizer_order_by_elimination_enabled	TRUE	Eliminates order bys from views before query transformation
_optimizer_star_tran_in_with_clause	TRUE	enable/disable star transformation in with clause queries
_optimizer_sortmerge_join_inequality	TRUE	enable/disable sort-merge join using inequality predicates
_selfjoin_mv_duplicates	TRUE	control rewrite self-join algorithm
_dimension_skip_null	TRUE	control dimension skip when null feature
_force_rewrite_enable	FALSE	control new query rewrite features
_optimizer_complex_pred_selectivity	TRUE	enable selectivity estimation for builtin functions
_build_deferred_mv_skipping_mvlog_update	TRUE	DEFERRED MV creation skipping MV log setup update
_bloom_pruning_enabled	TRUE	Enable partition pruning using bloom filtering
_query_mmvrewrite_maxpreds	10	query mmv rewrite maximum number of predicates per disjunct
_query_mmvrewrite_maxintervals	5	query mmv rewrite maximum number of intervals per disjunct
_query_mmvrewrite_maxinlists	5	query mmv rewrite maximum number of in-lists per disjunct
_query_mmvrewrite_maxdmaps	10	query mmv rewrite maximum number of dmaps per query disjunct
_query_mmvrewrite_maxcmaps	20	query mmv rewrite maximum number of cmaps per dmap in query disjunct
_query_mmvrewrite_maxregperm	512	query mmv rewrite maximum number of region permutations
_row_shipping_threshold	100	row shipping column selection threshold
_row_shipping_explain	FALSE	enable row shipping explain plan support
_query_mmvrewrite_maxqryinlistvals	500	query mmv rewrite maximum number of query in-list values
_first_k_rows_dynamic_proration	TRUE	enable the use of dynamic proration of join cardinalities
_optimizer_aw_stats_enabled	TRUE	Enables statistcs on AW olap_table table function
_enable_row_shipping	TRUE	use the row shipping optimization for wide table selects
_optimizer_skip_scan_guess	FALSE	consider index skip scan for predicates with guessed selectivity
_optimizer_distinct_elimination	TRUE	Eliminates redundant SELECT DISTNCT's
_add_col_optim_enabled	TRUE	Allows new add column optimization
_optimizer_multi_level_push_pred	TRUE	consider join-predicate pushdown that requires multi-level pushdown to base table
ddl_lock_timeout	0	timeout to restrict the time that ddls wait for dml lock
_enable_ddl_wait_lock	TRUE	use this to turn off ddls with wait semantics
deferred_segment_creation	TRUE	defer segment creation to first insert
_optimizer_group_by_placement	TRUE	consider group-by placement optimization
_optimizer_distinct_placement	TRUE	consider distinct placement optimization
_optimizer_coalesce_subqueries	TRUE	consider coalescing of subqueries optimization
_optimizer_enable_density_improvements	TRUE	use improved density computation for selectivity estimation
_optimizer_rownum_bind_default	10	Default value to use for rownum bind
_enable_query_rewrite_on_remote_objs	TRUE	mv rewrite on remote table/view
_enable_scn_wait_interface	TRUE	use this to turn off scn wait interface in kta
optimizer_use_pending_statistics	FALSE	Control whether to use optimizer pending statistics
_optimizer_improve_selectivity	TRUE	improve table and partial overlap join selectivity computation
_optimizer_aw_join_push_enabled	TRUE	Enables AW Join Push optimization
_cvw_enable_weak_checking	TRUE	enable weak view checking
optimizer_capture_sql_plan_baselines	FALSE	automatic capture of SQL plan baselines for repeatable statements
optimizer_use_sql_plan_baselines	TRUE	use of SQL plan baselines for captured sql statements
_enable_online_index_without_s_locking	TRUE	Allow online index creation algorithm without S DML lock
_dbop_enabled	1	Any positive number enables automatic DBOP monitoring. 0 is disabled
_sqlmon_threshold	5	CPU/IO time threshold before a statement is monitored. 0 is disabled
_sqlmon_max_plan	60	Maximum number of plans entry that can be monitored. Defaults to 20 per CPU
_sqlmon_max_planlines	300	Number of plan lines beyond which a plan cannot be monitored
_sqlmon_recycle_time	5	Minimum time (in s) to wait before a plan entry can be recycled
_sqlmon_binds_xml_format	default	format of column binds_xml in [G]V$SQL_MONITOR
_optimizer_native_full_outer_join	FORCE	execute full outer join using native implementaion
_optimizer_ansi_join_lateral_enhance	TRUE	optimization of left/full ansi-joins and lateral views
_optimizer_multi_table_outerjoin	TRUE	allows multiple tables on the left of outerjoin
_optimizer_null_accepting_semijoin	TRUE	enables null-accepting semijoin
_optimizer_ansi_rearchitecture	TRUE	re-architecture of ANSI left, right, and full outer joins
_optimizer_aggr_groupby_elim	TRUE	group-by and aggregation elimination
_optimizer_enable_extended_stats	TRUE	use extended statistics for selectivity estimation
_direct_path_insert_features	0	disable direct path insert features
_optimizer_free_transformation_heap	TRUE	free transformation subheap after each transformation
_pivot_implementation_method	CHOOSE	pivot implementation method
_optimizer_use_subheap	TRUE	Enables physical optimizer subheap
_optimizer_or_expansion_subheap	TRUE	Use subheap for optimizer or-expansion
_optimizer_star_trans_min_cost	0	optimizer star transformation minimum cost
_optimizer_star_trans_min_ratio	0	optimizer star transformation minimum ratio
_with_subquery	OPTIMIZER	WITH subquery transformation
_optimizer_reuse_cost_annotations	TRUE	reuse cost annotations during cost-based query transformation
_optimizer_interleave_jppd	TRUE	interleave join predicate pushdown during CBQT
_optimizer_fkr_index_cost_bias	10	Optimizer index bias over FTS/IFFS under first K rows mode
_px_dump_12805_source	TRUE	enables or disables tracing of 12805 signal source
parallel_min_time_threshold	AUTO	threshold above which a plan is a candidate for parallelization (in seconds)
_parallel_time_unit	10	unit of work used to derive the degree of parallelism (in seconds)
parallel_degree_limit	CPU	limit placed on degree of parallelism
parallel_force_local	FALSE	force single instance execution
_parallel_scalability	50	Parallel scalability criterion for parallel execution
_parallel_syspls_obey_force	TRUE	TRUE to obey force parallel query/dml/ddl under System PL/SQL
_optimizer_nested_rollup_for_gset	100	number of groups above which we use nested rollup exec for gset
_plan_verify_improvement_margin	150	Performance improvement criterion for evolving plan baselines
_statistics_based_srf_enabled	TRUE	enable/disable the use of statistics for storage reduction factor
_selectivity_for_srf_enabled	FALSE	enable/disable selectivity for storage reduction factor
optimizer_use_invisible_indexes	FALSE	Usage of invisible indexes (TRUE/FALSE)
_optimizer_extended_stats_usage_control	192	controls the optimizer usage of extended stats
_sql_plan_management_control	0	controls various internal SQL Plan Management algorithms
_optimizer_fast_pred_transitivity	TRUE	use fast algorithm to generate transitive predicates
_optimizer_fast_access_pred_analysis	TRUE	use fast algorithm to traverse predicates for physical optimizer
_optimizer_multiple_cenv_report	result	control what to report in trace file when run in multi-plan mode
_optimizer_multiple_cenv_stmt	query	control the types of statements that are run in multi-plan mode
_parallel_cluster_cache_pct	80	max percentage of the global buffer cache to use for affinity
_px_granule_batch_size	26	maximum size of a batch of granules
_optimizer_instance_count	0	force the optimizer to use the specified number of instances
_block_sample_readahead_prob_threshold	10	controls readahead value during block sampling
_mv_generalized_oj_refresh_opt	TRUE	enable/disable new algorithm for MJV with generalized outer joins
_parallel_optimization_phase_for_local	FALSE	parallel optimization phase when all slaves are local
_enable_schema_synonyms	FALSE	enable DDL operations (e.g. creation) involving schema synonyms
_enable_rename_user	FALSE	enable RENAME-clause using ALTER USER statement
_mv_refresh_enhanced_dml_detection	ON_RC	enable enhanced detection of DML types from MV log
_mv_refresh_pkfk_relationship_opt	TRUE	control MV refresh based on the use of PK-FK relationships
_mv_refresh_pkfk_data_units_opt	auto	control MV refresh based on the assumption of PK-FK data units
_optimizer_unnest_disjunctive_subq	TRUE	Unnesting of disjunctive subqueries (TRUE/FALSE)
_optimizer_unnest_corr_set_subq	TRUE	Unnesting of correlated set subqueries (TRUE/FALSE)
_optimizer_distinct_agg_transform	TRUE	Transforms Distinct Aggregates to non-distinct aggregates
_aggregation_optimization_settings	0	settings for aggregation optimizations
_arch_compress_checksums	FALSE	enable/disable row checksums for archive compressed blocks
_optimizer_eliminate_filtering_join	TRUE	optimizer filtering join elimination enabled
dst_upgrade_insert_conv	TRUE	Enables/Disables internal conversions during DST upgrade
_create_table_in_any_cluster	FALSE	allow creation of table in a cluster not owned by the user
_dsc_feature_level	0	controls the feature level for deferred segment creation
_parallel_statement_queuing	FALSE	parallel statement queuing enabled
_parallel_conservative_queuing	FALSE	conservative parallel statement queuing
parallel_servers_target	60	instance target in terms of number of parallel servers
_px_load_factor	300	weighted autodop load factor
_dml_frequency_tracking	FALSE	Control DML frequency tracking
_dml_frequency_tracking_advance	TRUE	Control automatic advance and broadcast of DML frequencies
_dml_frequency_tracking_slots	4	Number of slots to use for DML frequency tracking
_dml_frequency_tracking_slot_time	15	Time length of each slot for DML frequency tracking
_px_gim_factor	100	weighted autodop global index maintenance factor
_add_trim_for_nlssort	TRUE	add trimming for fixed char semantics
_optimizer_connect_by_cb_whr_only	FALSE	use cost-based transformation for whr clause in connect by
_optimizer_join_factorization	TRUE	use join factorization transformation
_optimizer_force_CBQT		force CBQT transformation regardless of cost
_optimizer_use_cbqt_star_transformation	TRUE	use rewritten star transformation using cbqt framework
_rep_base_path		base path for EM reports in database
_optimizer_table_expansion	TRUE	consider table expansion transformation
_and_pruning_enabled	TRUE	allow partition pruning based on multiple mechanisms
_dml_batch_error_limit	0	number or error handles allocated for DML in batch mode
_noseg_for_unusable_index_enabled	TRUE	no segments for unusable indexes if set to TRUE
_slave_mapping_skew_ratio	2	maximum skew before slave mapping is disabled
_px_index_sampling_objsize	TRUE	parallel query sampling for index create based on object size
_sql_compatibility	0	sql compatability bit vector
_optimizer_use_feedback	TRUE	optimizer use feedback
_optimizer_gather_feedback	TRUE	optimizer gather feedback
_optimizer_feedback_control		controls the optimizer feedback framework
_optimizer_try_st_before_jppd	TRUE	try Star Transformation before Join Predicate Push Down
_parallel_blackbox_size	16384	parallel execution blackbox bucket size
_parallel_blackbox_enabled	TRUE	parallel execution blackbox enabled
_parallel_load_publish_threshold	10	diffrence in percentage controlling px load propagation 
_px_partition_scan_enabled	TRUE	enables or disables parallel partition-based scan 
_px_partition_scan_threshold	64	least number of partitions per slave to start partition-based scan 
_parallel_heartbeat_snapshot_interval	2	interval of snapshot to track px msging between instances
_parallel_heartbeat_snapshot_max	128	maximum number of historical snapshots archived
_optimizer_false_filter_pred_pullup	TRUE	optimizer false predicate pull up transformation
_px_granule_randomize	TRUE	enables or disables randomization of parallel scans rowid granules
_optimizer_purge_stats_iteration_row_count	10000	number of rows to be deleted at each iteration of the stats                   purging process
_mv_refresh_update_analysis	TRUE	materialized view refresh using update analysis
_mv_cleanup_orphaned_metadata	TRUE	cleanup orphaned materialized view metadata
_mv_refresh_insert_no_append	TRUE	materialized view refresh using insert no append
_part_redef_global_index_update	TRUE	online partition redefinition update global indexes
_ptn_cache_threshold	1	flags and threshold to control partition metadata caching
_optimizer_enable_table_lookup_by_nl	TRUE	consider table lookup by nl transformation
_px_max_message_pool_pct	40	percentage of shared pool for px msg buffers range [5,90]
_px_chunklist_count_ratio	32	ratio of the number of chunk lists to the default DOP per instance
_px_hold_time	0	hold px at execution time (unit: second)
_optimizer_generate_transitive_pred	TRUE	optimizer generate transitive predicates
_optimizer_cube_join_enabled	TRUE	enable cube join
_optimizer_filter_pushdown	TRUE	enable/disable filter predicate pushdown
max_string_size	STANDARD	controls maximum size of VARCHAR2, NVARCHAR2, and RAW types in SQL
_dm_enable_legacy_dmf_output_types	FALSE	revert dmf output types to pre-12.1.0.1
_dm_dmf_details_compatibility	12.1.0	set dm dmf details compatibility version
_cdc_subscription_owner		Change Data Capture subscription_owner
_optimizer_outer_join_to_inner	TRUE	enable/disable outer to inner join conversion
_optimizer_hybrid_fpwj_enabled	TRUE	enable hybrid full partition-wise join when TRUE
_px_message_compression	TRUE	enable compression of control messages for parallel query
_px_object_sampling_enabled	TRUE	use base object sampling when possible for range distribution
_px_concurrent	TRUE	enables pq with concurrent execution of serial inputs
_px_back_to_parallel	OFF	allow going back to parallel after a serial operation
_scalar_type_lob_storage_threshold	4000	threshold for VARCHAR2, NVARCHAR2, and RAW storage as BLOB
_px_replication_enabled	TRUE	enables or disables replication of small table scans
_px_round_robin_rowcnt	1000	round robin row count to enq to next slave
_zonemap_use_enabled	TRUE	enable the use of zonemaps for IO pruning
_zonemap_staleness_tracking	1	control the staleness tracking of zonemaps via trigger
_zonemap_control	0	control different uses/algorithms related to zonemaps
_zonemap_usage_tracking	TRUE	Control the capture of zonemap usage statistics
_sql_plan_directive_mgmt_control	67	controls internal SQL Plan Directive management activities
_optimizer_full_outer_join_to_outer	TRUE	enable/disable full outer to left outer join conversion
_px_filter_parallelized	TRUE	enables or disables correlated filter parallelization 
_px_filter_skew_handling	TRUE	enable correlated filter parallelization to handle skew
_px_groupby_pushdown	FORCE	perform group-by pushdown for parallel query
_partition_advisor_srs_active	true	enables sampling based partitioning validation
_px_parallelize_expression	TRUE	enables or disables expression evaluation parallelization 
_fast_index_maintenance	TRUE	fast global index maintenance during PMOPs
_optimizer_gather_stats_on_load	TRUE	enable/disable online statistics gathering
_multi_transaction_optimization_enabled	TRUE	reduce SGA memory use during create of a partitioned table
_optimizer_batch_table_access_by_rowid	TRUE	enable table access by ROWID IO batching
optimizer_adaptive_reporting_only	FALSE	use reporting-only mode for adaptive optimizations
_optimizer_ads_max_table_count	0	maximum number of tables in a join under ADS
_optimizer_ads_time_limit	0	maximum time limit (seconds) under ADS
_optimizer_ads_use_result_cache	TRUE	use result cache for ADS queries
_optimizer_ads_result_cache_life	3600	result cache shelf life for ADS queries
_optimizer_ads_use_spd_cache	TRUE	use Sql Plan Directives for caching ADS queries
_optimizer_ads_spd_cache_owner_limit	64	Maximum number of directives under an owner in SPD cache
_px_wif_dfo_declumping	CHOOSE	NDV-aware DFO clumping of multiple window sorts
_px_wif_extend_distribution_keys	TRUE	extend TQ data redistribution keys for window functions
_px_wif_min_ndv_per_slave	2	mininum NDV of TQ keys needed per slave for scalable WiF PX
_px_join_skew_handling	TRUE	enables skew handling for parallel joins
_px_join_skew_ratio	10	sets skew ratio for parallel joins
_px_join_skew_minfreq	30	sets minimum frequency(%) for skewed value for parallel joins
_px_join_skew_use_histogram	TRUE	Enables retrieval of skewed values from histogram when possible
_px_join_skew_sampling_time_limit	50	Sets execution time limit for skew handling sampling queries
_px_join_skew_sampling_percent	0	Sets sampling percentage for skew handling sampling queries
_px_adaptive_dist_method	CHOOSE	determines the behavior of adaptive distribution methods
_px_adaptive_dist_method_threshold	0	Buffering / decision threshold for adaptive distribution methods
_px_adaptive_dist_bypass_enabled	TRUE	enable the bypass table queue for adaptive distribution methods
_px_adaptive_dist_bypass_optimization	1	sets optimizations for bypass table queue for ADM
_parallel_fault_tolerance_enabled	FALSE	enables or disables fault-tolerance for parallel statement
_parallel_fault_tolerance_threshold	3	total number of faults fault-tolerance will handle
_px_partial_rollup_pushdown	ADAPTIVE	perform partial rollup pushdown for parallel execution
_sql_diag_repo_retain		retain sql diag repository to cursor or not
_sql_diag_repo_origin	all	duarations where sql diag repository are retained
_optimizer_dsdir_usage_control	0	controls optimizer usage of dynamic sampling directives
_px_cpu_autodop_enabled	TRUE	enables or disables auto dop cpu computation
_px_cpu_process_bandwidth	200	CPU process bandwidth in MB/sec for DOP computation
_px_cpu_operator_bandwidth		CPU operator bandwidth in MB/sec for DOP computation
_px_single_server_enabled	TRUE	allow single-slave dfo in parallel query
_optimizer_use_gtt_session_stats	TRUE	use GTT session private statistics
optimizer_adaptive_plans	TRUE	controls all types of adaptive plans
_optimizer_adaptive_plan_control	0	internal controls for adaptive plans
_optimizer_adaptive_random_seed	0	random seed for adaptive plans
_optimizer_strans_adaptive_pruning	TRUE	allow adaptive pruning of star transformation bitmap trees
_optimizer_proc_rate_level	BASIC	control the level of processing rates
_px_hybrid_TSM_HWMB_load	TRUE	Enable Hybrid Temp Segment Merge/High Water Mark Brokered load method
_optimizer_use_histograms	TRUE	enable/disable the usage of histograms by the optimizer
_disable_directory_link_check	FALSE	Disable directory link checking
_add_nullable_column_with_default_optim	TRUE	Allows add of a nullable column with default optimization
_emx_max_sessions	128	Maximum number of sessions in the EM Express cache
_emx_session_timeout	3600	Session timeout (sec) in the EM Express cache
_emx_control	0	EM Express control (internal use only)
_parallel_blackbox_sga	TRUE	true if blackbox will be allocated in SGA, false if PGA
_rowsets_enabled	TRUE	enable/disable rowsets
_rowsets_target_maxsize	524288	target size in bytes for space reserved in the frame for a rowset
_rowsets_max_rows	256	maximum number of rows in a rowset
_rowsets_use_encoding	TRUE	allow/disallow use of encoding with rowsets
_rowsets_max_enc_rows	64	maximum number of encoded rows in a rowset
_px_load_monitor_threshold	10000	threshold for pushing information to load slave workload monitor
_px_numa_support_enabled	FALSE	enable/disable PQ NUMA support
_px_numa_stealing_enabled	TRUE	enable/disable PQ granule stealing across NUMA nodes
_px_adaptive_offload_threshold	10	threshold (GB/s) for PQ adaptive offloading of granules
_px_adaptive_offload_percentage	30	percentage for PQ adaptive offloading of granules
_modify_column_index_unusable	FALSE	allow ALTER TABLE MODIFY(column) to violate index key length limit
_adaptive_window_consolidator_enabled	TRUE	enable/disable adaptive window consolidator PX plan
_sql_hvshare_threshold	0	threshold to control hash value sharing across operators
_px_tq_rowhvs	TRUE	turn on intra-row hash valueing sharing in TQ
_sql_hvshare_debug	1	control hash value sharing debug level
_sql_show_expreval	FALSE	show expression evalution as shared hash producer in plan 
_parallel_ctas_enabled	TRUE	enable/disable parallel CTAS operation
_optimizer_performance_feedback	OFF	controls the performance feedback
_optimizer_proc_rate_source	DEFAULT	control the source of processing rates
_hashops_prefetch_size	4	maximum no of rows whose relevant memory locations are prefetched
_stat_aggs_one_pass_algorithm	FALSE	enable one pass algorithm for variance-related functions
_px_onepass_slave_acquisition	TRUE	enable/disable one pass slave acquisition for parallel execution
_part_access_version_by_number	TRUE	use version numbers to access versioned objects for partitioning
_online_ctas_diag	0	controls dumping diagnostic information for online ctas
_upddel_dba_hash_mask_bits	0	controls masking of lower order bits in DBA
_px_pwmr_enabled	TRUE	parallel partition wise match recognize enabled
_px_cdb_view_enabled	TRUE	parallel cdb view evaluation enabled
_optimizer_cluster_by_rowid	TRUE	enable/disable the cluster by rowid feature
_optimizer_cluster_by_rowid_control	129	internal control for cluster by rowid feature mode
_partition_cdb_view_enabled	TRUE	partitioned cdb view evaluation enabled
_common_data_view_enabled	TRUE	common objects returned through dictionary views
_optimizer_cbqt_or_expansion	ON	enables cost based OR expansion
_pred_push_cdb_view_enabled	TRUE	predicate pushdown enabled for CDB views
_rowsets_cdb_view_enabled	TRUE	rowsets enabled for CDB views
_distinct_agg_optimization_gsets	CHOOSE	Use Distinct Aggregate Optimization for Grouping Sets
_array_cdb_view_enabled	TRUE	array mode enabled for CDB views
_mv_refresh_pipe_timeout	600	timeout that MV refresh coordinator waits for a job pipe
_mv_refresh_truncate_log	FALSE	materialized view refresh truncate MV log
_rc_sys_obj_enabled	TRUE	result cache enabled for Sys Objects
_px_scalable_invdist	TRUE	enable/disable px scalable plan for inverse distribution functions
_indexable_con_id	TRUE	indexing of CON_ID column enabled for X$ tables
_optimizer_reduce_groupby_key	TRUE	group-by key reduction
_optimizer_cluster_by_rowid_batched	TRUE	enable/disable the cluster by rowid batching feature
_optimizer_cluster_by_rowid_batch_size	100	Sorting batch size for cluster by rowid feature
_object_link_fixed_enabled	TRUE	object linked views evaluated using fixed table
_optimizer_synopsis_min_size	2	minimal synopsis size (kb)
_merge_monitor_threshold	10000	threshold for pushing information to MERGE monitoring
optimizer_inmemory_aware	TRUE	optimizer in-memory columnar awareness
_optimizer_inmemory_table_expansion	TRUE	optimizer in-memory awareness for table expansion
_optimizer_inmemory_gen_pushable_preds	TRUE	optimizer generate pushable predicates for in-memory
_optimizer_inmemory_autodop	TRUE	optimizer autoDOP costing for in-memory
_optimizer_inmemory_access_path	TRUE	optimizer access path costing for in-memory
_optimizer_inmemory_quotient	0	in-memory quotient (% of rows in in-memory format)
_optimizer_inmemory_pruning_ratio_rows	100	in-memory pruning ratio for # rows (% of rows remaining after pruning)
_parallel_inmemory_min_time_threshold	AUTO	threshold above which a plan is a candidate for parallelization for in-memory tables (in seconds)
_parallel_inmemory_time_unit	1	unit of work used to derive the degree of parallelism for in-memory tables (in seconds)
_px_external_table_default_stats	TRUE	the external table default stats collection enable/disable 
_optimizer_nlj_hj_adaptive_join	TRUE	allow adaptive NL Hash joins
_px_autodop_pq_overhead	TRUE	adjust auto dop calculation using pq overhead
_px_overhead_init_slavealloc	1000	pq overhead on allocating per slave during initialization (in microseconds)
_px_overhead_init_endpoints	4	pq overhead on setting up one end point during initialization (in microseconds)
_px_overhead_exec_ctrlmesg	4	pq overhead on sending one control message during execution (in microseconds)
_px_overhead_teardown	600	pq overhead on setting up one end point during initialization (in microseconds)
_grant_read_instead_of_select	FALSE	grant read privilege instead of select wherever applicable
_optimizer_inmemory_bloom_filter	TRUE	controls serial bloom filter for in-memory tables
_optimizer_inmemory_cluster_aware_dop	TRUE	Affinitize DOP for inmemory objects
_optimizer_inmemory_minmax_pruning	TRUE	controls use of min/max pruning for costing in-memory tables
_cdb_cross_container	65535	Debug flag for cross container operations
_cdb_view_parallel_degree	65535	Parallel degree for a CDB view query
_optimizer_hll_entry	4096	number of entries in hll hash table
_cross_con_row_count	FALSE	use actual row count for cross container views
_cdb_view_prefetch_batch_size	200	Batch Size for Prefetch for a CDB view query
_cdb_view_rc_shelflife	30	Result Cache Shelflife for a CDB view query
_approx_cnt_distinct_gby_pushdown	choose	perform group-by pushdown for approximate distinct count query
_approx_cnt_distinct_optimization	0	settings for approx_count_distinct optimizations
_px_cdb_view_join_enabled	TRUE	disable parallelism cap on CDB view
_external_table_smart_scan	HADOOP_ONLY	External Table Smart Scan
_optimizer_db_blocks_buffers	0	optimizer value for _db_blocks_buffers
_composite_interval_partition_creation_opt_enabled	TRUE	when creating interval/auto list partitions, defer subpartition segment creation until a row for the subpartition is inserted
_optimizer_bushy_join	off	enables bushy join
_optimizer_bushy_fact_dim_ratio	20	bushy join dimension to fact ratio
_optimizer_bushy_fact_min_size	100000	minimumm fact size for bushy join
_optimizer_bushy_cost_factor	100	cost factor for bushy join
_query_rewrite_use_on_query_computation	TRUE	query rewrite use on query computation
_mv_access_compute_fresh_data	ON	mv access compute fresh data
_px_min_ndv_per_slave_perc_func	2	mininum NDV of TQ keys needed per slave for parallel percentile
_px_scalable_invdist_mcol	TRUE	enable/disable px plan for percentile functions on multiple columns
_rmt_for_table_redef_enabled	TRUE	Use Rowid Mapping Table for table redef
_query_execution_time_limit	0	Query execution time limit in seconds
_optimizer_ads_use_partial_results	TRUE	Use partial results of ADS queries
_optimizer_eliminate_subquery	TRUE	consider elimination of subquery optimization
cursor_invalidation	IMMEDIATE	default for DDL cursor invalidation semantics
_sqlexec_hash_based_distagg_enabled	FALSE	enable hash based distinct aggregation for gby queries
_sqlexec_disable_hash_based_distagg_tiv	FALSE	disable hash based distinct aggregation in TIV for gby queries
_sqlexec_hash_based_distagg_ssf_enabled	TRUE	enable hash based distinct aggregation for single set gby queries
_sqlexec_distagg_optimization_settings	0	settings for distinct aggregation optimizations
approx_for_aggregation	FALSE	Replace exact aggregation with approximate aggregation
approx_for_count_distinct	FALSE	Replace count distinct with approx_count_distinct
_optimizer_union_all_gsets	TRUE	Use Union All Optimization for Grouping Sets
_optimizer_enhanced_join_elimination	TRUE	Enhanced(12.2) join elimination
_optimizer_multicol_join_elimination	TRUE	eliminate multi-column key based joins
_optimizer_enable_plsql_stats	TRUE	Use statistics of plsql functions
_recursive_with_parallel	TRUE	Enable/disable parallelization of Recursive With
_recursive_with_using_temp_table	FALSE	Enable the use of CDT for serial execution of Recursive With
_recursive_with_branch_iterations	7	Expected number of iterations of the recurive branch of RW/CBY
_recursive_with_control	0	control different uses/algorithms related to recursive with
_partition_read_only	TRUE	bypass all read only check for partition
_px_dist_agg_partial_rollup_pushdown	ADAPTIVE	perform distinct agg partial rollup pushdown for px execution
_mv_refresh_shrink_log	TRUE	materialized view refresh shrink MV log
_pwise_distinct_enabled	TRUE	enable partition wise distinct
_approx_perc_sampling_err_rate	2	error rate percentage of approximate percentile using sampling
_vector_encoding_mode	MANUAL	enable vector encoding(OFF/MANUAL/AUTO)
_optimizer_use_table_scanrate	HADOOP_ONLY	Use Table Specific Scan Rate
_optimizer_use_xt_rowid	TRUE	Use external table rowid
_xt_sampling_scan_granules	ON	Granule Sampling for Block Sampling of External Tables
_xt_sampling_scan_granules_min_granules	1	Minimum number of granules to scan for granule sampling
_xt_def_compression_ratio	4	Default compression ratio for external table data files
_xt_legacy_debug_flags	0	Debug flags for ORACLE_LOADER and ORACLE_DATAPUMP
_xt_enable_columnar_fetch	TRUE	Enable external table columnar fetch
_sqlexec_use_rwo_aware_expr_analysis	TRUE	enable/disable the usage of row vector aware expression analysis
_monitor_workload_interval	24	workload monitoring interval in hours
_optimizer_band_join_aware	TRUE	enable the detection of band join by the optimizer
_optimizer_vector_transformation	TRUE	perform vector transform
_optimizer_vector_fact_dim_ratio	10	cost based vector transform dimension to fact ratio
_optimizer_vector_min_fact_rows	10000000	min number of rows required for vector aggregation transform
_optimizer_key_vector_aggr_factor	75	the required aggregation between IJK and DGK
_optimizer_vector_cost_adj	100	cost adjustment for vector aggregation processing estimates
_optimizer_key_vector_pruning_enabled	TRUE	enables or disables key vector partition pruning
_optimizer_vector_base_dim_fact_factor	200	cost based vector transform base dimension to base fact ratio
approx_for_percentile	none	Replace percentile_* with approx_percentile
_approx_percentile_optimization	0	settings for approx_percentile optimization
_optimizer_adaptive_plans_continuous	FALSE	enable continuously adaptive plans
_optimizer_adaptive_plans_iterative	FALSE	enable iterative adaptive plans
_optimizer_generate_ptf_implied_preds	TRUE	Generate implied predicates for PTF
_optimizer_inmemory_capture_stored_stats	TRUE	optimizer capture and store statistics for in-memory tables
_optimizer_inmemory_use_stored_stats	AUTO	optimizer use stored statistics for in-memory tables
_shard_sql_use_chunk_ids	0	Shard SQL use chunk ids
_expression_tracking_latch_count	16	Number of latches for tracking expression usage statistics
_expression_tracking_elem_per_bucket	30	Number of expression usage statistics elements per hash bucket
_bloom_filter_ratio	35	bloom filter filtering ratio
_optimizer_control_shard_qry_processing	65528	control shard query processing
_optimizer_interleave_or_expansion	TRUE	interleave OR Expansion during CBQT
_px_partition_load_dist_threshold	64	# of load slave to # of partition ratio to switch distribution 
optimizer_adaptive_statistics	FALSE	controls all types of adaptive statistics
_optimizer_use_feedback_for_join	FALSE	optimizer use feedback for join
_optimizer_ads_for_pq	FALSE	use ADS for parallel queries
_px_slave_parse_first_with_outline_hints	TRUE	Enable/Disable trying outlined plan first
_px_join_skewed_values_count	0	force join skew handling with specified skewed values count
_bloom_max_wait_time	50	bloom filter wait time upper bound (in ms)
_bloom_wait_on_rac	FALSE	enables bloom filter (with hash hash distribution) wait on RAC
_bloom_extent_size	0	bloom filter extent size in bytes 
_read_optimized_table_lookup	TRUE	enables read-optimized table lookup
_optimizer_key_vector_payload	TRUE	enables or disables dimension payloads in vector transform
_optimizer_vector_fact_payload_ratio	20	cost based vector transform payload dimension to fact ratio
_bloom_pruning_setops_enabled	TRUE	Allow bloom pruning to be pushed through set operations
_bloom_filter_setops_enabled	TRUE	Allow bloom filter to be pushed through set operations
_px_pwise_wif_enabled	TRUE	enable parallel partition wise window function
_sqlexec_reorder_wif_enabled	TRUE	enable re-ordering of window functions
_px_partition_skew_threshold	80	percentage of table size considered as threshold for skew determination
_sqlexec_pwiseops_with_sqlfuncs_enabled	TRUE	enables partition wise operations even in the presence of functions over table partition keys
_sqlexec_pwiseops_with_binds_enabled	TRUE	enable partition wise execution in the presence of bind variables in inlist equality operator in where clause
optimizer_ignore_parallel_hints	FALSE	enables embedded parallel hints to be ignored
_px_shared_hash_join	FALSE	enable/disable shared hash join
_px_reuse_server_groups	MULTI	enable/disable reusing of server groups that are already acquired
_px_join_skew_null_handling	TRUE	enables null skew handling improvement for parallel outer joins
_px_tq_memcpy_threshold	100	threshold for PQ TQ to use memcpy for packing columns
_bloom_use_shared_pool	FALSE	use shared pool for bloom filter
_enable_parallel_dml	FALSE	enables or disables parallel dml
_px_nlj_bcast_rr_threshold	10	threshold to use broadcast left random right distribution for NLJ
parallel_min_degree	1	controls the minimum DOP computed by Auto DOP
_sqlexec_use_kgghash3	TRUE	use CRC-based hash function
_optimizer_gather_stats_on_load_all	FALSE	enable/disable online statistics gathering for nonempty segments
_optimizer_gather_stats_on_load_hist	FALSE	enable/disable online histogram gathering for loads
_px_granule_alignment	1024	default size of a rowid range granule (in KB)
_optimizer_allow_all_access_paths	TRUE	allow all access paths
_lob_use_locator_varying_width	FALSE	use varying width flag in lob locator
_optimizer_answering_query_using_stats	FALSE	enable statistics-based query transformation
_cell_offload_vector_groupby_fact_key	TRUE	enable cell offload of vector group by with fact grouping keys
_px_scalable_gby_invdist	TRUE	scalable PX plan for GBY w/ inverse distribution functions
_xt_preproc_timeout	100	external table preprocessor timeout
_px_dynamic_granules	TRUE	enable dynamic granule generation
_px_dynamic_granules_adjust	10	adjust dynamic granule regeneration
_px_hybrid_partition_execution_enabled	TRUE	enable parallel hybrid partition execution
_px_hybrid_partition_skew_threshold	10	partitions bigger than threshold times average size are skewed
_optimizer_key_vector_use_max_size	1048576	maximum key vector use size (in KB)
_optimizer_non_blocking_hard_parse	TRUE	enable non-blocking hard parse
_optimizer_track_hint_usage	TRUE	enable tracking of optimizer hint usage
_optimizer_compare_plans_control	0	compare plans controls for testing
_group_partition_data_for_impdp_ok	FALSE	data pump import allows DATA_OPTIONS=GROUP_PARTITION_DATA
_optimizer_key_vector_payload_dim_aggs	FALSE	enables or disables dimension payloading of aggregates in VT
_optimizer_quarantine_sql	TRUE	enable use of sql quarantine
_optimizer_use_auto_indexes	AUTO	Use Auto Index
_optimizer_gather_stats_on_load_index	TRUE	enable/disable online index stats gathering for loads
_optimizer_stats_on_conventional_dml_sample_rate	100	sampling rate for online stats gathering on conventional DML
_optimizer_gather_stats_on_conventional_dml	TRUE	optimizer online stats gathering for conventional DML
_optimizer_use_stats_on_conventional_dml	TRUE	use optimizer statistics gathered for conventional DML
_optimizer_use_stats_on_conventional_config	0	settings for optimizer usage of online stats on conventional DML
_optimizer_gather_stats_on_conventional_config	0	settings for optimizer online stats gathering on conventional DML
_dmm_ipp_cutoff	0	Intra-Partition Parallel size cutoff
_dmm_nobin_threshold	200	No Binning Row Count Threshold
_dmm_force_treetop_merge	0	Force Treetop Merge
_dmm_cnt_arr_size_threshold	500000	Counts Array Size Threshold
_dmm_sample_lower_threshold	10000	Minimum Sample Size
_dmm_sample_upper_threshold	500000	Maximum Sample Size
_dmm_auto_max_features	500	Auto Max Features
_dmm_max_memory_size	1000000	Maximum Memory Size
_dmm_memory_size	64000000	Memory Size
_dmsqr_qr_chunk_rows	10000	QR maximum chunk rows
_dm_max_chunk_size	2000	Data Mining Max Chunk Size
_dm_inmemory_threshold	1000000	In-memory cardinality threshold
_bigram_dependency_percentage	5	Bigram dependency percentage
_dmm_inc_cholesky_rows	50000	Incomplete Cholesky number of rows
_dmm_kmean_dense_threshold	500	Kmean densify threshold
_dmm_blas_library		Control which BLAS/LAPACK dynamic library to load
_dmm_ts_lapack	1	Enable usage of BLAS/LAPACK for Tall Skinny SVD
_dmm_reduction_rate	4	Reduction rate in reduction tree
_dmm_pga_load_threshold	3	Model size less than threshold are loaded into PGA
_dmm_details_filter_weight	1	Filter details based on weight
_alter_upgrade_signature_only	FALSE	alter table upgrade only sets signature
sec_protocol_error_trace_action	TRACE	TTC protocol error action
sec_protocol_error_further_action	(DROP,3)	TTC protocol error continue action
_spadr	YES	_SPADR
sec_max_failed_login_attempts	3	maximum number of failed login attempts on a connection
sec_return_server_release_banner	FALSE	whether the server retruns the complete version information
_sec_enable_test_rpcs	FALSE	Whether to enable the test RPCs
_use_zero_copy_io	TRUE	Should network vector IO interface be used for data transfer
enable_ddl_logging	TRUE	enable ddl logging
_tstz_localtime_bypass	FALSE	Should TTC not convert to LocalTime to preserve Timestamp with Timezone values
_client_tstz_error_check	TRUE	Should Client give error for suspect Timestamp with Timezone operations
client_result_cache_size	0	client result cache max size in bytes
client_result_cache_lag	3000	client result cache maximum lag in milliseconds
_client_result_cache_bypass	FALSE	bypass the client result cache
_client_result_cache_ramthreshold		client_result_cache_ramthreshold
_client_result_set_threshold		client_result_set_threshold
_emon_regular_ntfn_slaves	4	number of EMON slaves doing regular database notifications
_emon_outbound_connect_timeout	7200000	timeout for completing connection set up to clients
_emon_send_timeout	7200000	send timeout after which the client is unregistered
_emon_max_active_connections	256	maximum open connections to clients per emon
_client_ntfn_pingtimeout	30000	timeout to connect to unreachable notification clients
_client_ntfn_pinginterval	75	time between pings to unreachable notification clients
_client_ntfn_pingretries	6	number of times to ping unreachable notification clients
_client_enable_auto_unregister	FALSE	enable automatic unregister after a send fails with timeout
_srvntfn_q_msgcount	50	srvntfn q msg count for job exit
_srvntfn_q_msgcount_inc	100	srvntfn q msg count increase for job submit
_srvntfn_jobsubmit_interval	3	srvntfn job submit interval
_srvntfn_max_concurrent_jobs	20	srvntfn max concurrent jobs
_srvntfn_job_deq_timeout	60	srvntfn job deq timeout
_client_ntfn_cleanup_interval	2400	interval after which dead client registration cleanup task repeats
_max_clients_per_emon	8	maximum number of clients per emon
_emon_pool_inc	4	increment in EMON slaves per pool type
_emon_pool_min	4	minimum number of EMON slaves per pool type
_emon_pool_max	16	maximum number of EMON slaves per pool type
_tsm_connect_string		TSM test connect string
_sscr_dir		Session State Capture and Restore DIRectory object
_sscr_osdir		Session State Capture and Restore OS DIRectory
_tsm_disable_auto_cleanup	1	Disable TSM auto cleanup actions
_enable_nativenet_tcpip	FALSE	Enable skgxp driver usage for native net
_client_features_tracking_enable	TRUE	track client feature uage
outbound_dblink_protocols	ALL	Outbound DBLINK Protocols allowed
allow_global_dblinks	FALSE	LDAP lookup for DBLINKS
_async_scn_sync	OFF	Asynchronous SCN Sync Setting
_share_drcp_proxy_sessions	TRUE	Enable Disable Proxy Session Sharing DRCP
_request_boundaries	3	request boundaries mode
_spfoc	OFF	SPFOC
_spfdc	OFF	SPFDC
_spfei		SPFEI
client_statistics_level	TYPICAL	Client Statistics Level
_close_deq_by_cond_curs	FALSE	Close Dequeue By Condition Cursors
_deq_maxwait_time	0	Change wait times between dequeue calls
_deq_max_fetch_count	10	deq max fetch count
_deq_execute_reset_time	30	deq execute reset time
_aq_streaming_threshold	10485760	large payload threshold size
_aq_dly_bkt	2	Delay Bucket Size
_aq_retry_timeouts	0	retry timeouts
_aq_scrambled_deqlog	1	scrambled deqlog
_aq_dqblocks_in_cache	0	deq blocks in cache
_aq_uncached_stats	0	Uncached Stats
_aq_free_list_pools	10	state object and transaction memory pools
aq_tm_processes	1	number of AQ Time Managers to start
_aq_tm_statistics_duration	0	statistics collection window duration
_orph_cln_interval	1200	qmon periodic interval for removed subscriber messages cleanup
_aq_max_scan_delay	1500	Maximum allowable scan delay for AQ indexes and IOTs
_aq_tm_scanlimit	0	scan limit for Time Managers to clean up IOT
_aq_tm_deqcountinterval	0	dequeue count interval for Time Managers to cleanup DEQ IOT BLOCKS
_disable_gvaq_cache	FALSE	Disable cache
_rule_max_dnfp_cnt	1024	Rules max dnf piece count
_re_fast_sql_operator	all	enables fast boxable sql operator
_re_result_cache_keysiz	20	defines max number key for result cache hash table
_re_result_cache_size	20	defines max number of cached elements for result cache
_re_independent_expression_cache_size	20	defines max number of compiled cached expressions for iee
_enable_iee_stats	TRUE	enables IEE stats gathering
_re_num_complex_operator	1000	defines max number of compiled complex operator per ruleset-iee
_re_num_rowcache_load	2	defines max number of complex operators loaded with row cache
_prop_old_enabled	FALSE	Shift to pre 11g propagation behaviour
_bufq_stop_flow_control	FALSE	Stop enforcing flow control for buffered queues
_capture_publisher_flow_control_threshold	0	Flow control threshold for capture publishers
_buffered_publisher_flow_control_threshold	0	Flow control threshold for buffered publishers except capture
_buffered_message_spill_age	300	Buffered message spill age
_deq_log_array_size	10000	deq log array size
_deq_ht_max_elements	100000	deq ht max elements
_deq_ht_child_latches	8	deq ht child latches
_deq_large_txn_size	25000	deq large txn size
_aqsharded_cache_limit	0	Limit for cached enqueue/dequeue operations
_aq_Txn_ht_sz	1024	Message cache Txn Hash table size
_aq_shard_bitmap_child_latches	32	Bitmap child latches
_aq_shard_retry_child_latches	32	Retry child latches
_aq_shard_txn_child_latches	128	Txn child latches
_aq_shard_sub_child_latches	512	Subscriber child latches
_aq_shard_sub_child_Elem_latches	1024	Subscriber Element child latches
_aq_shard_child_latches	512	Shard child latches
_aq_shard_prty_latches	16	Shard priority child latches
_aq_init_shards	5	Minimum enqueue shards per queue at an instance
_aq_x_mode	1	AQ - cross mode
_aq_latency_relative_threshold	100	Relative threshold of average latency
_aq_latency_absolute_threshold	300	Absolute threshold greater than average latency
_aq_max_pdb_close_msg	1	Max Number of AQ Recovery Messages when pdb is closed
_aq_lb_subht_bkt_ltch	32	AQ LB subscriber ht bucket latches
_aq_lb_subht_elm_ltch	128	AQ LB subscriber ht element latches
_aq_lb_garbage_col_interval	600	AQ LB garbage collect interval
_aq_x_msg_size	32768	AQ cross single message buffer size
_aq_stop_backgrounds	FALSE	Stop all AQ background processes
_aq_lb_cycle	120	Time(seconds) between consecutive AQ load balancing efforts
_aq_lb_stats_collect_cycle	45	Time(seconds) between consecutive AQ load statistics collection
_aq_pt_processes	10	Partition background processes
_aq_subshard_Size	20000	Sub Shard Size
_aq_subshards_per_qpartition	1	SubShards Per Q Partition
_aq_subshards_per_dqpartition	1	SubShards Per Deq Partition
_aq_lookback_size	60	AQ PT Look Back Size
_aq_qt_prefetch_Size	5	AQ PT QT prefech Size
_aq_dq_prefetch_Siz	5	AQ PT DQ prefech Size
_aq_pt_statistics_window	60	PT statistics sample window Size
_aq_pt_shrink_frequency	1450	PT shrink window Size
_aq_addpt_batch_size	1	Add PT batch Size
_aq_truncpt_batch_size	1	Trunc PT batch Size
_aq_droppt_batch_size	5	Drop PT batch Size
_shrd_que_tm_processes	1	number of sharded queue Time Managers to start
_shrd_que_tm_statistics_duration	0	Shaded queue statistics collection window duration
_aq_ipc_max_slave	10	maximum number of slaves for knlpipcm
_aq_opt_stat_window	21600	AQ: OPT Subscriber Statistics Window Size
_aq_opt_stop_stat	FALSE	AQ: OPT Stop Collection of Subscriber Statistics
_aq_opt_enabled	TRUE	AQ: OPT Operations enabled
_aq_opt_background_enabled	TRUE	AQ: OPT Operations Background enabled
_aq_opt_fudge_factor	500	AQ: OPT Fudge Factor for pre-fretching
_aq_opt_prefetch_horizon	60	AQ: OPT horizon for pre-fretching
_aq_opt_min_evict_memory	0	AQ: OPT LWM memory for eviction to stop
_aq_opt_prefetch_dop	3	AQ: OPT Background: Prefetch Degree Of Parallelism
_aq_opt_preevict_dop	3	AQ: OPT Background: PreEvict Degree Of Parallelism
hs_autoregister	TRUE	enable automatic server DD updates in HS agent self-registration
_ctx_doc_policy_stems	FALSE	enable ctx_doc.policy_stems api
_nonce_history_buffer_size	0	Size of Nonce History Buffer
xml_db_events	enable	are XML DB events enabled
dg_broker_start	FALSE	start Data Guard broker (DMON process)
dg_broker_config_file1	/u01/db/dbs/dr1orcl.dat	data guard broker configuration file #1
dg_broker_config_file2	/u01/db/dbs/dr2orcl.dat	data guard broker configuration file #2
_dg_broker_trace_level		data guard broker trace level
_olapi_history_retention	FALSE	enable olapi history retention
_olapi_session_history	300	enable olapi session history collection
_olapi_session_history_retention	FALSE	enable olapi session history retention
_olapi_iface_object_history	1000	enable olapi interface object history collection
_olapi_iface_object_history_retention	FALSE	enable olapi interface object history retention
_olapi_interface_operation_history	1000	enable olapi interface operation history collection
_olapi_iface_operation_history_retention	FALSE	enable olapi interface operation history retention
_olapi_memory_operation_history	1000	enable olapi memory alloc/free history collection
_olapi_memory_operation_history_retention	FALSE	enable olapi memory operation history retention
_olapi_memory_operation_history_pause_at_seqno	0	enable olapi memory alloc/free history collection pausing
olap_page_pool_size	0	size of the olap page pool in bytes
_olap_continuous_trace_file	false	OLAP logging definition
_olap_table_function_statistics	FALSE	Specify TRUE to output OLAP table function timed statistics trace
_olap_parallel_update_threshold	1000	OLAP parallel update threshold in pages
_olap_parallel_update_small_threshold	1000	OLAP parallel update threshold for number of small pagespaces
_olap_parallel_update_server_num	0	OLAP parallel update server count
_olap_aggregate_buffer_size	1048576	OLAP Aggregate max buffer size
_olap_aggregate_min_buffer_size	1024	OLAP Aggregate min buffer size
_olap_aggregate_work_per_thread	1024	OLAP Aggregate max work parents
_olap_aggregate_min_thread_status	64	OLAP Aggregate minimum cardinality of dimensions for thread
_olap_aggregate_statlen_thresh	1024	OLAP Aggregate status array usage threshold
_olap_aggregate_worklist_max	5000	OLAP Aggregate max worklists generated at once
_olap_aggregate_max_thread_tuples	5000	OLAP Aggregate max thread tuples creation
_olap_aggregate_function_cache_enabled	TRUE	OLAP Aggregate function cache enabled
_olap_aggregate_multipath_hier	FALSE	OLAP Aggregate Multi-path Hierarhies enabled
_olap_aggregate_flags	0	OLAP Aggregate debug flags
_olap_allocate_errorlog_header	Dim      Source   Basis
%-8d %-8s %-8b Description
-------- -------- -------- -----------	OLAP Allocate Errorlog Header format
_olap_allocate_errorlog_format	%8p %8y %8z %e (%n)	OLAP Allocate Errorlog Format
_olap_dbgoutfile_echo_to_eventlog	FALSE	OLAP DbgOutfile copy output to event log (tracefile)
_olap_eif_export_lob_size	2147483647	OLAP EIF Export BLOB size
_olap_sort_buffer_size	262144	OLAP Sort Buffer Size
_olap_sort_buffer_pct	10	OLAP Sort Buffer Size Percentage
_olap_sesscache_enabled	TRUE	OLAP Session Cache knob
_olap_object_hash_class	3	OLAP Object Hash Table Class
_olap_dimension_corehash_size	30	OLAP Dimension In-Core Hash Table Maximum Memory Use
_olap_dimension_corehash_pressure	90	OLAP Dimension In-Core Hash Table Pressure Threshold
_olap_dimension_corehash_large	50000	OLAP Dimension In-Core Hash Table Large Threshold
_olap_dimension_corehash_force	FALSE	OLAP Dimension In-Core Hash Table Force
_olap_page_pool_low	262144	OLAP Page Pool Low Watermark
_olap_page_pool_hi	50	OLAP Page Pool High Watermark
_olap_page_pool_expand_rate	20	OLAP Page Pool Expand Rate
_olap_page_pool_shrink_rate	50	OLAP Page Pool Shrink Rate
_olap_page_pool_hit_target	100	OLAP Page Pool Hit Target
_olap_page_pool_pressure	90	OLAP Page Pool Pressure Threshold
_olap_statbool_threshold	8100	OLAP Status Boolean CBM threshold
_olap_statbool_corebits	20000000	OLAP Status Boolean max incore bits
_olap_lmgen_dim_size	100	Limitmap generator dimension column size
_olap_lmgen_meas_size	1000	Limitmap generator measure column size
_olap_wrap_errors	FALSE	Wrap error messages to OLAP outfile
_olap_analyze_max	10000	OLAP DML ANALYZE command max cells to analyze
_olap_adv_comp_stats_max_rows	100000	do additional predicate stats analysis for AW rowsource
_olap_adv_comp_stats_cc_precomp	20	do additional predicate stats analysis for AW rowsource
_olap_row_load_time_precision	DEFAULT	OLAP Row Load Time Precision
_olap_disable_loop_optimized	FALSE	Disable LOOP OPTIMIZED directive in OLAP_TABLE
_xsolapi_fetch_type	PARTIAL	OLAP API fetch type
_xsolapi_dimension_group_creation	OVERFETCH	OLAP API symmetric overfetch
_xsolapi_sql_auto_measure_hints	TRUE	OLAP API enable automatic measure hints
_xsolapi_sql_auto_dimension_hints	FALSE	OLAP API enable automatic dimension hints
_xsolapi_sql_hints		OLAP API generic hints
_xsolapi_sql_measure_hints		OLAP API measure hints
_xsolapi_sql_dimension_hints		OLAP API dimension hints
_xsolapi_sql_top_measure_hints		OLAP API top measure hints
_xsolapi_sql_top_dimension_hints		OLAP API top dimension hints
_xsolapi_sql_all_non_base_hints		OLAP API non-base hints
_xsolapi_sql_all_multi_join_non_base_hints		OLAP API multi-join non-base hints
_xsolapi_densify_cubes	TABULAR	OLAP API cube densification
_xsolapi_sql_optimize	TRUE	OLAP API enable optimization
_xsolapi_sql_remove_columns	TRUE	OLAP API enable remove unused columns optimizations
_xsolapi_sql_symmetric_predicate	TRUE	OLAP API enable symmetric predicate for dimension groups
_xsolapi_sql_use_bind_variables	TRUE	OLAP API enable bind variables optimization
_xsolapi_sql_prepare_stmt_cache_size	16	OLAP API prepare statement cache size
_xsolapi_sql_result_set_cache_size	32	OLAP API result set cache size
_xsolapi_sql_minus_threshold	1000	OLAP API SQL MINUS threshold
_xsolapi_debug_output	SUPPRESS	OLAP API debug output disposition
_xsolapi_materialize_sources	TRUE	OLAP API Enable source materialization
_xsolapi_load_at_process_start	NEVER	When to load OLAP API library at server process start
_xsolapi_fix_vptrs	TRUE	OLAP API Enable vptr fixing logic in shared server mode
_xsolapi_auto_materialization_type	PRED_AND_RC	OLAP API behavior for auto materialization
_xsolapi_auto_materialization_bound	20	OLAP API lower bound for auto materialization.
_xsolapi_materialization_rowcache_min_rows_for_use	1	OLAP API min number of rows required to use rowcache in query materialization
_xsolapi_source_trace	FALSE	OLAP API output Source definitions to trace file 
_xsolapi_dml_trace		OLAP API output dml commands and expressions to trace file 
_xsolapi_build_trace	FALSE	OLAP API output build info to trace file 
_xsolapi_metadata_reader_mode	DEFAULT	OLAP API metadata reader mode
_xsolapi_odbo_mode	FALSE	OLAP API uses ODBO mode?
_xsolapi_set_nls	TRUE	OLAP API sets NLS?
_xsolapi_stringify_order_levels	FALSE	OLAP API stringifies order levels?
_xsolapi_suppression_chunk_size	4000	OLAP API suppression chunk size
_xsolapi_suppression_aw_mask_threshold	1000	OLAP API suppression AW mask threshold
_xsolapi_share_executors	TRUE	OLAP API share executors?
_xsolapi_hierarchy_value_type	unique	OLAP API hierarchy value type
_xsolapi_use_models	TRUE	OLAP API uses models?
_xsolapi_use_olap_dml	TRUE	OLAP API uses OLAP DML?
_xsolapi_use_olap_dml_for_rank	TRUE	OLAP API uses OLAP DML for rank?
_xsolapi_remove_columns_for_materialization	TRUE	OLAP API removes columns for materialization?
_xsolapi_precompute_subquery	TRUE	OLAP API precomputes subqueries?
_xsolapi_optimize_suppression	TRUE	OLAP API optimizes suppressions?
_xsolapi_generate_with_clause	FALSE	OLAP API generates WITH clause?
_xsolapi_sql_enable_aw_join	TRUE	OLAP API enables AW join?
_xsolapi_sql_enable_aw_qdr_merge	TRUE	OLAP API enables AW QDR merge?
_xsolapi_opt_aw_position	TRUE	OLAP API enables AW position and count optimization?
_xsolapi_support_mtm	FALSE	OLAP API MTM mapping classes supported?
_asm_runtime_capability_volume_support	FALSE	runtime capability for volume support returns supported
_asm_disable_multiple_instance_check	FALSE	Disable checking for multiple ASM instances on a given node
_asm_disable_amdu_dump	FALSE	Disable AMDU dump
_asmsid	asm	ASM instance id
_asm_global_dump_level	267	System state dump level for ASM asserts
_remote_asm		remote ASM configuration
_ios_root_directory	IOS	IOS default root directory
_apx_root_directory	APX	APX default root directory
_asm_node_site_guid		ASM site GUID of node
_asm_reloc_cic	FALSE	Allow relocation during rolling migration
_asm_oda_type		ODA Type
_asm_access	auto	ASM File access mechanism
_asm_allow_system_alias_rename	FALSE	if system alias renaming is allowed
_asm_instlock_quota	0	ASM Instance Lock Quota
_asm_relocation_trace	FALSE	enable extent relocation tracing
asm_diskstring		disk set locations for discovery
_asm_disk_repair_time	14400	seconds to wait before dropping a failing disk
asm_preferred_read_failure_groups		preferred read failure groups
_asm_disable_profilediscovery	FALSE	disable profile query for discovery
_asm_relocation_ignore_hard_failure	0	ignore HARD for relocation
_asm_max_parallelios	256	Maximum simultaneous outstanding IOs
_asm_auto_online_interval		auto online interval
_asm_imbalance_tolerance	3	hundredths of a percentage of inter-disk imbalance to tolerate
_asm_shadow_cycle	3	Inverse shadow cycle requirement
_asm_primary_load_cycles	TRUE	True if primary load is in cycles, false if extent counts
_asm_primary_load	1	Number of cycles/extents to load for non-mirrored files
_asm_secondary_load_cycles	FALSE	True if secondary load is in cycles, false if extent counts
_asm_secondary_load	10000	Number of cycles/extents to load for mirrored files
_kffmop_chunks	42	number of chunks of kffmop's
_kffmap_hash_size	1024	size of kffmap_hash table
_kffmop_hash_size	2048	size of kffmop_hash table
_kffmlk_hash_size	512	size of kffmlk_hash table
_kffmspw_hash_size	128	size of kffmspw_hash table
_asm_diskgroups2		disk groups to mount automatically set 2
_asm_diskgroups3		disk groups to mount automatically set 3
_asm_diskgroups4		disk groups to mount automatically set 4
_asm_zero_power_limit		allow setting zero power limit
_disable_rebalance_space_check	FALSE	disable space usage checks for storage reconfiguration
_asm_log_scale_rebalance	FALSE	Rebalance power uses logarithmic scale
_asm_sync_rebalance	FALSE	Rebalance uses sync I/O
_diag_arb_before_kill	FALSE	dump diagnostics before killing unresponsive ARBs
_asm_ausize	1048576	allocation unit size
_asm_blksize	4096	metadata block size
_asm_acd_chunks	1	initial ACD chunks created
_asm_partner_target_disk_part	8	target maximum number of disk partners for repartnering
_asm_partner_target_fg_rel	4	target maximum number of failure group relationships for repartnering
_asm_automatic_rezone	TRUE	automatically rebalance free space across zones
_asm_rebalance_plan_size	120	maximum rebalance work unit
_asm_rebalance_space_errors	1000	number of out of space errors allowed before aborting rebalance
_asm_relocation_scheme	alloc_p2 alloc_s3 reb_p2 reb_s1 bal_p2 bal_s3 prep_p2 prep_s3	ASM allocation / relocation scheme
_asm_disable_dangerous_failgroup_checking	FALSE	Disable checking for dubious failgroup configurations
_asm_rebalance_estimates_process	TRUE	Perform rebalance estimates in ARB-A process
_asm_disable_failgroup_size_checking	FALSE	Disable checking for failure group size
_asm_disable_failgroup_count_checking	FALSE	Disable checking for failure group count
_asm_allow_foreign_siteguids		Disable checking for foreign siteguid on a given node
_asm_allow_dgname_special_chars	FALSE	Enable the use of special characters in diskgroup names
_asm_libraries	ufs	library search order for discovery
_asm_maxio	1048576	Maximum size of individual I/O request
_asm_allow_only_raw_disks	TRUE	Discovery only raw devices
_asm_disable_vtoc_check	FALSE	Disable vtoc/sector 0 check
_asm_fob_tac_frequency	9	Timeout frequency for FOB cleanup
_asm_emulate_nfs_disk	FALSE	Emulate NFS disk test event
_asm_allow_lvm_resilvering	TRUE	Enable disk resilvering for external redundancy
_asm_lsod_bucket_size	67	ASM lsod bucket size
_asm_iostat_latch_count	31	ASM I/O statistics latch count
_asm_diskerr_traces	2	Number of read/write errors per disk a process can trace
_asm_procs_trace_diskerr	5	Number of processes allowed to trace a disk failure
_asm_trace_limit_timeout	30000	Time-out in milliseconds to reset the number of traces per disk and the number of processes allowed to trace
_asm_fd_cln_on_fg	TRUE	ASM stale FD cleanup on foregrounds
_asm_fd_cln_idle_sess_twait	60000000	Idle session time wait to run ASM FD cleanup
_asm_skip_dbfile_ios	FALSE	Skip I/Os to database files (do only ASM metadata I/O)
_asm_offload_all	FALSE	Offload all write operations to Exadata cells, when supported
_asm_read_cancel	AUTO	Read cancel timeout in milliseconds
_asm_read_cancel_back_out	5000	Time period in milliseconds when no reads are issued to a disk after a read is cancelled
_asm_write_cancel	AUTO	Write timeout in milliseconds
_asm_cancel_delta	75000	Delta timeout for blocking big writes in milliseconds
_asm_cancel_alert_time	600	Wait time for I/O cancel alert message (in seconds)
_asm_enable_kfks	FALSE	Enable KFKS module
_kfm_disable_set_fence	FALSE	disable set fence calls and revert to default (process fence)
_asm_disable_smr_creation	FALSE	Do Not create smr
_afd_disable_fence	FALSE	Disable AFD fencing 
_asm_network_timeout	1	Keepalive timeout for ASM network connections
_asm_wait_time	18	Max/imum time to wait before asmb exits
_asm_skip_diskval_check	FALSE	skip client side discovery for disk revalidate
_asm_skip_resize_check	FALSE	skip the checking of the clients for s/w compatibility for resize
_asm_skip_rename_check	FALSE	skip the checking of the clients for s/w compatibility for rename
_asm_direct_con_expire_time	120	Expire time for idle direct connection to ASM instance
_asm_check_for_misbehaving_cf_clients	FALSE	check for misbehaving CF-holding clients
_asm_diag_dead_clients	FALSE	diagnostics for dead clients
_asm_disable_ufg_dump	FALSE	disable terminated umbilicus diagnostic
_asm_reserve_slaves	TRUE	reserve ASM slaves for CF txns
_asm_kill_unresponsive_clients	TRUE	kill unresponsive ASM clients
_asm_disable_async_msgs	FALSE	disable async intra-instance messaging
_asm_remote_client_timeout	300	timeout before killing disconnected remote clients
_asm_allow_unsafe_reconnect	TRUE	attempt unsafe reconnect to ASM
_asm_disable_ufgmemberkill	FALSE	disable ufg member kill
_asm_disable_proact_client_cleanup	FALSE	disable proactive client cleanup
_asm_nodekill_escalate_time	180	secs until escalating to nodekill if fence incomplete
_asm_healthcheck_timeout	180	seconds until health check takes action
_asm_cclient_cleanup_timeout	300	timeout before cleaning up remote cluster clients
_asm_allow_older_clients	FALSE	Allow older clients to connect to the ASM server
_asm_enable_multiple_asmb	TRUE	Allow the ASM client to have multiple ASMB background processes
_asm_disable_vxn_map_messages	FALSE	disable using vxn map messages
_asm_asmb_rcvto	10	Receive timeout for ASMB in seconds
_asm_asmb_max_wait_timeout	6	timeout before processes are signaled with network interrupt
_asm_tcp_user_timeout	1	TCP_USER_TIMEOUT in minutes
_asm_ufg_nw_wait_timeout	10	seconds to start health check on unresponsive clients
_asm_resyncCkpt	1024	number of extents to resync before flushing checkpoint
_asm_relocation_async_lock_count	128	limit of asynchronous map locks during relocation
_asm_stripewidth	8	ASM file stripe width
_asm_stripesize	131072	ASM file stripe size
_disable_fastopen	FALSE	Do Not Use Fastopen
_asm_random_zone	FALSE	Random zones for new files
_asm_serialize_volume_rebalance	FALSE	Serialize volume rebalance
_asm_force_quiesce	FALSE	Force diskgroup quiescing
_asm_dba_threshold	0	ASM Disk Based Allocation Threshold
_asm_dba_batch	500000	ASM Disk Based Allocation Max Batch Size
_asm_force_paritycheck_rebalance	FALSE	Force parity extent integrity check during rebalance
_asm_dba_spcchk_thld	100000	ASM Disk Based Allocation Space Check Threshold
_asm_usd_batch	64	ASM USD Update Max Batch Size
_asm_fail_random_rx	FALSE	Randomly fail some RX enqueue gets
_relocation_commit_batch_size	8	ASM relocation commit batch size
_asm_max_redo_buffer_size	2097152	asm maximum redo buffer size
_asm_max_cod_strides	10	maximum number of COD strides
_asm_max_aux_cods	5	maximum number of auxiliary cods in sparse disk groups
_asm_evenread	2	ASM Even Read level
_asm_evenread_alpha	0	ASM Even Read Alpha
_asm_evenread_alpha2	0	ASM Even Read Second Alpha
_asm_evenread_faststart	0	ASM Even Read Fast Start Threshold
_asm_noevenread_diskgroups		List of disk groups having even read disabled
_asm_disable_request_tracer	TRUE	Disable kfioRqTracer
_asm_force_parity_extent_check	FALSE	Force parity extent integrity check
_asm_enable_kfios	FALSE	Enable KFIOS module
_asm_networks		ASM network subnet addresses
_asm_access_assume_local	FALSE	Assume IOS client is in the same cluster as IOS
_asm_iosconnect_timeout	0	Time (in 3secs multiples) before db gives up on connecting to IOS
_asm_br_listener_port	51521	Bitrotter listener port for testing purpose
_asm_ios_network_domains	0	number of domains in ASM IOSERVER instance
_asm_ios_network_processes	0	number network processes per domain in ASM IOSERVER instance
_asm_netp_factor	0	number of network processes per net
_asm_idn_processes	0	number of global open processes
_asm_iowp_max_async	0	maximum async IOs per IO worker process
_asm_max_clients	1000	maximum number of clients this IOS instance can service
_asm_netp_iosize	0	maximum io size
_asm_brfuzz_ios_lsnrport	0	IOS listener port for fuzzing with Bitrotter
_asm_dbmsdg_nohdrchk	FALSE	dbms_diskgroup.checkfile does not check block headers
_asm_root_directory	ASM	ASM default root directory
_asm_odapremchk	TRUE	Check premature storage for ODA
_asm_pstonpartners	TRUE	Select ideal PST disks following partnership
_asm_allowdegeneratemounts	FALSE	Allow force-mounts of DGs w/o proper quorum
_asm_hbeatiowait	120	number of secs to wait for PST Async Hbeat IO return
_asm_hbeatwaitquantum	2	quantum used to compute time-to-wait for a PST Hbeat check
_asm_repairquantum	60	quantum (in 3s) used to compute elapsed time for disk drop
_asm_emulmax	10000	max number of concurrent disks to emulate I  /O errors
_asm_emultimeout	0	timeout before emulation begins (in 3s ticks)
_asm_kfdpevent	0	KFDP event
_asm_storagemaysplit	FALSE	PST Split Possible
_asm_avoid_pst_scans	TRUE	Avoid PST Scans
_disable_storage_type	FALSE	Disable storage type checks
_asm_min_compatibility	11.2.0.2	default mininum ASM compatibility level
_asm_compatibility	11.2.0.2	default ASM compatibility level
_rdbms_compatibility	10.1	default RDBMS compatibility level
_kfi_version_patchmap		pairs of version:patchmap for testing
_kfi_software_patchmap		value of patchmap for software
_asm_disable_patch_compat	FALSE	disable DG patch compatibility checks
_asm_proxy_startwait	60	Maximum time to wait for ASM proxy connection
_asm_allow_dangerous_unprotected_volumes	FALSE	Disable checking for unprotected volumes in mirrored disk groups
_asm_proxy_online_restart	0	Allow patching while ADVM volumes are online
_allow_cell_smart_scan_attr	TRUE	Allow checking smart_scan_capable Attr
_asm_admin_with_sysdba	FALSE	Does the sysdba role have administrative privileges on ASM?
_asm_allow_appliance_dropdisk_noforce	FALSE	Allow DROP DISK/FAILUREGROUP NOFORCE on ASM Appliances
_disable_appliance_check	FALSE	Disable appliance-specific code
_disable_appliance_partnering	FALSE	Disable appliance partnering algorithms
_asm_appliance_config_file		Appliance configuration file name
_asm_appliance_ignore_oak	FALSE	Ignore OAK appliance library
_dirty_appliance_mode	FALSE	Enable appliance mode even on non-appliance
_asm_appliance_slot_from_path	FALSE	Get appliance disk slot from disk path
_asm_appliance_disable_fg_check	FALSE	Disable failure group check
_asm_write_badfdata_in_contentcheck	FALSE	Write BADFDA7A in content check
_asm_scrub_disable_cod	FALSE	Disable scrubbing COD
_asm_scrub_strict	FALSE	Enable strict scrubbing mode
_asm_scrub_async	TRUE	Enable asynchronous scrubbing
_asm_scrub_limit	AUTO	ASM disk scrubbing power
_asm_scrub_unmatched_dba	1024	Scrub maximum number of blocks with unmatched DBA
_asm_enable_parity_scrub	FALSE	Allow scrubbing parity files
_asm_async_scrub_reap_wait	100000	Async scrubbing reaping IO wait in microseconds
_asm_enable_batch_scrub	FALSE	Allow scrubbing verification to run in batch mode
_asm_enable_lostwrite_scrub	FALSE	Allow lost write detection in scrubbing
_asm_enable_repair_lostwrite_scrub	FALSE	Allow repairing lost write in scrubbing
_memory_max_tgt_inc_cnt	0	counts the times checker increments memory target
_asm_enable_xrov	FALSE	Enable XROV capability
_asm_xrov_single	FALSE	Enable single issues of IOs
_asm_xrov_rsnmod	2	Specify 'reason' mode
_asm_xrov_nvios	24	Specify number of VIO processes
_asm_xrov_nstats	0	Specify number of IOs before stats
_skip_acfs_checks	FALSE	Override checking if on an ACFS file system
_asm_force_vam	FALSE	force VAM for external redundancy
_usd_recent_read	TRUE	Allow to scan recent USD blocks
_usd_preload_blks	4	USD preload block count for prefetch
_asm_dependency_under_cfenqueue	TRUE	Send dependency request if holding CF enqueue
_asm_max_connected_clients	3	The high water mark value for connected clients
__asm_max_connected_clients	3	The high water mark value for connected clients
_asm_enable_parityfile_creation	TRUE	Enable parity files creation
_asm_enable_parity_datafile_creation	FALSE	Enable parity datafiles creation
_enable_multiple_fgprepares	FALSE	Allow concurrent PREPAREs on the same database
_enable_single_dgprepare	FALSE	Disable concurrent PREPAREs in same disk group
_asm_allow_prepare_split	TRUE	Allow database prepare and split in non-appliance mode
_enable_ios_spm	FALSE	Allow Split Mirror operations via IOServer
control_management_pack_access	DIAGNOSTIC+TUNING	declares which manageability packs are enabled
_alert_expiration	604800	seconds before an alert message is moved to exception queue
_alert_message_cleanup	1	Enable Alert Message Cleanup
_alert_message_purge	1	Enable Alert Message Purge
_alert_post_background	1	Enable Background Alert Posting
_swrf_test_action	0	test action parameter for SWRF
_sysaux_test_param	1	test parameter for SYSAUX
_swrf_mmon_flush	TRUE	Enable/disable SWRF MMON FLushing
_remote_awr_enabled	FALSE	Enable/disable Remote AWR Mode
_awr_corrupt_mode	FALSE	AWR Corrupt Mode
_awr_restrict_mode	FALSE	AWR Restrict Mode
_swrf_mmon_metrics	TRUE	Enable/disable SWRF MMON Metrics Collection
_swrf_metric_frequent_mode	FALSE	Enable/disable SWRF Metric Frequent Mode Collection
_awr_flush_threshold_metrics	TRUE	Enable/Disable Flushing AWR Threshold Metrics
_awr_flush_workload_metrics	FALSE	Enable/Disable Flushing AWR Workload Metrics
_awr_disabled_flush_tables		Disable flushing of specified AWR tables
_awr_disabled_purge_tables		Disable purging of specified AWR tables
_awr_snapshot_level	BESTFIT	Set Default AWR snapshot level
_swrf_on_disk_enabled	TRUE	Parameter to enable/disable SWRF
_awr_pdb_registration_enabled	FALSE	Parameter to enable/disable AWR PDB Registration
_swrf_mmon_dbfus	TRUE	Enable/disable SWRF MMON DB Feature Usage
_awr_mmon_cpuusage	TRUE	Enable/disable AWR MMON CPU Usage Tracking
_swrf_test_dbfus	FALSE	Enable/disable DB Feature Usage Testing
_adr_migrate_runonce	TRUE	Enable/disable ADR Migrate Runonce action
_awr_sql_child_limit	200	Setting for AWR SQL Child Limit
_awr_enable_pdb_snapshots	TRUE	Enable/Disable AWR PDB level snapshots
awr_pdb_autoflush_enabled	FALSE	Enable/Disable AWR automatic PDB flushing
awr_pdb_max_parallel_slaves	10	maximum concurrent AWR PDB MMON slaves per instance
_awr_incremental_flush_enabled	TRUE	Enable/Disable AWR automatic incremental flushing
_awr_warehouse_enabled	FALSE	Enable/Disable AWR warehouse functionality
awr_snapshot_time_offset	0	Setting for AWR Snapshot Time Offset
_awr_mmon_deep_purge_interval	7	Set interval for deep purge of AWR contents
_awr_mmon_deep_purge_extent	7	Set extent of rows to check each deep purge run
_awr_mmon_deep_purge_numrows	5000	Set max number of rows per table to delete each deep purge run
_awr_mmon_deep_purge_all_expired	FALSE	Allows deep purge to purge AWR data for all expired snapshots
_awr_cdbperf_threshold	21	Setting for AWR CDBPERF Threshold
_awr_partition_interval	0	Setting for AWR Partition Interval
_incremental_purge_size	200	Setting for AWR Incremental Purge Size
_awr_metrics_use_mmnl	FALSE	Use MMNL or other background process for AWR metrics
sqltune_category	DEFAULT	Category qualifier for applying hintsets
_sqltune_category_parsed	DEFAULT	Parsed category qualifier for applying hintsets
_ash_sampling_interval	1000	Time interval between two successive Active Session samples in millisecs
_ash_size	1048618	To set the size of the in-memory Active Session History buffers
_ash_enable	TRUE	To enable or disable Active Session sampling and flushing
_ash_disk_write_enable	TRUE	To enable or disable Active Session History flushing
_ash_disk_filter_ratio	10	Ratio of the number of in-memory samples to the number of samples actually written to disk
_ash_eflush_trigger	66	The percentage above which if the in-memory ASH is full the emergency flusher will be triggered
_ash_sample_all	FALSE	To enable or disable sampling every connected session including ones waiting for idle waits
_ash_dummy_test_param	0	Oracle internal dummy ASH parameter used ONLY for testing!
_ash_min_mmnl_dump	90	Minimum Time interval passed to consider MMNL Dump
_ash_compression_enable	TRUE	To enable or disable string compression in ASH
_ash_progressive_flush_interval	300	ASH Progressive Flush interval in secs
_kebm_nstrikes	3	kebm # strikes to auto suspend an action
_kebm_suspension_time	104400	kebm auto suspension time in seconds
_kebm_sanity_check_enabled	FALSE	Enable/disable MMON Action Sanity Check
_kebm_max_parallel_autotasks	AUTO	maximum parallel autotask executions per instance
_kebm_autotask_nstrikes	3	kebm # strikes to auto suspend an autotask
_timemodel_collection	TRUE	enable timemodel collection
_disable_metrics_group	0	Disable Metrics Group (or all Metrics Groups)
_kewm_simulate_oer4031	0	Simulate OER(4031) for one or more Metric Groups
_enable_metrics_allpdb	TRUE	Enable/Disable Metrics for Root and all PDBs if applicable
_enable_metrics_pdb	FALSE	Enable/Disable Metrics for this Non-Root PDB
_validate_metric_groups	FALSE	Enable/disable SGA Metric Structure validation
_track_metrics_memory	TRUE	Enable/disable Metrics Memory Tracking
_kewm_trace_sga	FALSE	Enable/Disable Metrics SGA Allocation Tracing
_threshold_alerts_enable	1	if 1, issue threshold-based alerts
_enable_default_undo_threshold	TRUE	Enable Default Tablespace Utilization Threshold for TEMPORARY Tablespaces
_enable_default_temp_threshold	TRUE	Enable Default Tablespace Utilization Threshold for UNDO Tablespaces
_addm_auto_enable	TRUE	governs whether ADDM gets run automatically after every AWR snapshot
_addm_version_check	TRUE	governs whether ADDM checks the input AWR snapshot version
_addm_skiprules		comma-separated list of ADDM nodes to skip
_addm_auto_actions_enabled	TRUE	determines if ADDM can automatically implement its recommendations
_automatic_maintenance_test	0	Enable AUTOTASK Test Mode
_autotask_min_window	15	Minimum Maintenance Window Length in minutes
_autotask_max_window	480	Maximum Logical Maintenance Window Length in minutes
_enable_automatic_maintenance	1	if 1, Automated Maintenance Is Enabled
_autotask_test_name	N/A	Name of current Autotask Test (or test step)
autotask_max_active_pdbs	2	Setting for Autotask Maximum Maintenance PDBs
enable_automatic_maintenance_pdb	TRUE	Enable/Disable Automated Maintenance for Non-Root PDB
_autotask_test_action	0	test action parameter for AUTOTASK
_bsln_adaptive_thresholds_enabled	TRUE	Adaptive Thresholds Enabled
_wcr_control	0	Oracle internal test WCR parameter used ONLY for testing!
_dbreplay_feature_control		Database Replay Feature Control
_capture_buffer_size	65536	To set the size of the PGA I/O recording buffers
_wcr_seq_cache_size	65535	Oracle internal: Set the replay cache size for WRR$_REPLAY_SEQ_DATA.
_wcr_grv_cache_size	65535	Oracle internal: Set the replay cache size for WRR$_REPLAY_DATA.
_wcr_test_action	0	Oracle internal test WCR parameter used for test actions
_max_queued_report_requests	300	Maximum number of report requests that can be queued in a list
_report_capture_cycle_time	60	Time (in sec) between two cycles of report capture daemon
_report_capture_dbtime_percent_cutoff	50	100X Percent of system db time daemon is allowed over 10 cycles
_report_capture_timeband_length	1	Length of time band (in hours) in the reports time bands table
_report_capture_recharge_window	10	No of report capture cycles after which db time is recharged
_max_report_flushes_percycle	5	Max no of report requests that can be flushed per cycle
_report_request_ageout_minutes	60	Time (in min) after which a report request is deleted from queue
_kecap_cache_size	10240	Workload Replay INTERNAL parameter used to set memory usage in  Application Replay
_rtaddm_trigger_enabled	TRUE	To enable or disable Real-Time ADDM automatic trigger
_rtaddm_trigger_args		comma-separated list of numeric arguments for RT addm trigger
_mwin_schedule	TRUE	Enable/disable Maintenance Window Schedules
_umf_remote_target_dblink		UMF Remote Target DBLink for Flushing
_umf_remote_enabled	FALSE	Enable remote UMF operations
_dbmsumf$$nn		UMF Configuration
_dbmsumf$$p		UMF Configuration
_dbmsumf$$1x		UMF Configuration
_dbmsumf$$2x		UMF Configuration
_dbmsumf$$3x		UMF Configuration
_umf_test_action	0	test action parameter for UMF
_iut_enable	TRUE	Control Index usage tracking
_iut_max_entries	30000	Maximum Index entries to be tracked
_iut_stat_collection_type	SAMPLED	Specify Index usage stat collection type
_sqlset_hash_max_size	100000	Max size of hash table used when loading into a SQL set
_component_timing		Oracle parameter used for component tracking and timing
spatial_vector_acceleration	FALSE	enable spatial vector acceleration
_diag_verbose_error_on_init	0	Allow verbose error tracing on diag init
_diag_hm_rc_enabled	TRUE	Parameter to enable/disable Diag HM Reactive Checks
_diag_hm_tc_enabled	FALSE	Parameter to enable/disable Diag HM Test(dummy) Checks
diagnostic_dest	/u01/app/oracle	diagnostic base directory
_diag_adr_enabled	TRUE	Parameter to enable/disable Diag ADR
_diag_adr_auto_purge	TRUE	Enable/disable ADR MMON Auto Purging
_diag_backward_compat	TRUE	Backward Compatibility for Diagnosability
_diag_adr_test_param	0	Test parameter for Diagnosability
_diag_adr_trace_dest	/u01/app/oracle/diag/rdbms/orcl/orcl/trace	diagnosability trace directory path
_diag_pdb_purge_threshold	97	Controls threshold for ADR PDB Auto Purge Operation
_diag_pdb_purge_target	90	Controls target percentage for ADR PDB Auto Purge Operation
_diag_pdb_control	0	DIAG PDB Space Management Control Parameter
_dra_enable_offline_dictionary	FALSE	Enable the periodic creation of the offline dictionary for DRA
_dra_bmr_number_threshold	1000	Maximum number of BMRs that can be done to a file
_dra_bmr_percent_threshold	10	Maximum percentage of blocks in a file that can be BMR-ed
_diag_conf_cap_enabled	TRUE	Parameter to enable/disable Diag Configuration Capture
_diag_patch_cap_enabled	TRUE	Parameter to enable/disable Diag Patch Configuration Capture
_log_segment_dump_parameter	TRUE	Dump KSP on Log Segmentation
_log_segment_dump_patch	TRUE	Dump Patchinfo on Log Segmentation
_diag_adl_dyn_alloc	TRUE	Enable Diag Alert Dynamic Allocation
_diag_cdb_logging	short	Format for CDB Annotation
_diag_alert_root_annotate	FALSE	Enable annotation for alert log entries from root
_dde_flood_control_init	TRUE	Initialize Flood Control at database open
_diag_dde_fc_enabled	TRUE	Parameter to enable/disable Diag Flood Control
_diag_dde_fc_implicit_time	0	Override Implicit Error Flood Control time parameter
_diag_dde_fc_macro_time	0	Override Macro Error Flood Control time parameter
_diag_cc_enabled	TRUE	Parameter to enable/disable Diag Call Context
_diag_dde_inc_proc_delay	1	The minimum delay between two MMON incident sweeps (minutes)
_diag_dde_async_msgs	50	diag dde async actions: number of preallocated message buffers
_diag_dde_async_msg_capacity	1024	diag dde async actions: message buffer capacity
_diag_dde_async_slaves	5	diag dde async actions: max number of concurrent slave processes
_diag_dde_async_mode	1	diag dde async actions: dispatch mode
_diag_dde_async_age_limit	300	diag dde async actions: message age limit (in seconds)
_diag_dde_async_process_rate	5	diag dde async actions: message processing rate - per loop
_diag_dde_async_runtime_limit	900	diag dde async actions: action runtime limit (in seconds)
_diag_dde_async_cputime_limit	300	diag dde async actions: action cputime limit (in seconds)
_diag_dde_enabled	TRUE	enable DDE handling of critical errors
tracefile_identifier		trace file custom identifier
_trace_files_public	FALSE	Create publicly accessible trace files
max_dump_file_size	unlimited	Maximum size (in bytes) of dump file
_max_incident_file_size		Maximum size (in KB, MB, GB, Blocks) of incident dump file
_uts_trace_segment_size	0	Maximum size (in bytes) of a trace segment
_uts_trace_segments	5	Maximum number of trace segments
_uts_first_segment_size	0	Maximum size (in bytes) of first segments
_uts_first_segment_retain	TRUE	Should we retain the first trace segment
_diag_uts_control	0	UTS control parameter
_uts_trace_disk_threshold	0	Trace disk threshold parameter
_diag_test_seg_reinc_mode	FALSE	Sets trace segmentation to be in reincarnation mode
_uts_trace_files_nopurge	FALSE	Sets trace files to not get purged
_uts_trace_buffer_size	0	Trace disk buffer size
_uts_inc_inmem_trace	0	Controls UTS in-memory tracing during an active incident
_uts_enable_alltrc_stats	FALSE	Enables accounting of trace data in incident and cdmp trace files
_trace_pool_size		trace pool size in bytes
trace_enabled	TRUE	enable in memory tracing
_evt_system_event_propagation	TRUE	disable system event propagation
_diag_enable_startup_events	FALSE	enable events in instance startup notifiers
_diag_attn_log_format_standard		Attention Log Standard Entry format
_diag_attn_log_format_error		Attention Log Error Entry format
_auto_manage_exadata_disks	TRUE	Automate Exadata disk management
_auto_manage_ioctl_bufsz	8192	oss_ioctl buffer size, to read and respond to cell notifications
_auto_manage_num_tries	2	Num. tries before giving up on a automation operation
_auto_manage_enable_offline_check	TRUE	perodically check for OFFLINE disks and attempt to ONLINE
_auto_manage_max_online_tries	3	Max. attempts to auto ONLINE an ASM disk
_auto_manage_online_tries_expire_time	86400	Allow Max. attempts to auto ONLINE an ASM disk after lapsing this time (unit in seconds)
_auto_manage_num_pipe_msgs	1000	Max. number of out-standing msgs in the KXDAM pipe
_auto_manage_enable_smart_rebalance	TRUE	OFFLINE instead of DROP disk(s) when free space is not enough for rebalance
_auto_manage_smart_rebalance_grace_period_in_min	0	Number of minutes waited after ASM diskgroup free space increases and becomes sufficient for rebalance before dropping an ASM disk offlined due to insufficient free space
_auto_manage_smart_rebalance_space_threshold	0	Percentage of ASM diskgroup free space required for rebalance
_auto_manage_infreq_tout	0	TEST: Set infrequent timeout action to run at this interval, unit is seconds
cell_offloadgroup_name		Set the offload group name
_kxdbio_ctx_init_count	32	initial count of KXDBIO state object
_kxdbio_offena_timeout	7200000	kxdbio re-enable offloaded write timeout
_kxdbio_disable_offload_opcode	0	KXDBIO Disable offload for the set opcodes.  Value is a Bitmap of    0x00000001 - disable cell to cell data copy offload    0x00000002 - disable disk scrubbing offload to cell    0x00000004 - disable offloaded writes to cell
_kxdbio_enable_ds_opcode	0	KXDBIO Enable Dumb storage simulation for the set opcodes.
_enable_offloaded_writes	FALSE	Enable offloaded writes for Unit Test
_block_level_offload_high_lat_thresh	40000	High Latency Threshold for Block Level Offload operations
_kxdbio_hca_loadavg_thresh	74	HCA loadavg threshold at which writes need to get offloaded
_kxdbio_ut_ctl	0	kxdbio unit test controls
_cell_offload_backup_compression	TRUE	enable offload of backup compression to cells
_enable_pluggable_database	FALSE	Enable Pluggable Database
enable_pluggable_database	TRUE	Enable Pluggable Database
_oracle_script	FALSE	Running an Oracle-supplied script
_pdb_first_script	FALSE	Running a script that is PDB-first/ROOT-last
_discard_cmn_ddl_in_pdb_err	FALSE	Discard error when Common DDL is attempted in PDB
pdb_os_credential		pluggable database OS credential to bind
pdb_file_name_convert		PDB file name convert patterns and strings for create cdb/pdb
_pluggable_database_debug	0	Debug flag for pluggable database related operations
_pdb_failure_testing	0	Testing failure in pluggable database related operations
noncdb_compatible	FALSE	Non-CDB Compatible
_cdb_compatible	TRUE	CDB Compatible
_deferred_seg_in_seed	TRUE	Enable Deferred Segment Creation in Seed
common_user_prefix	C##	Enforce restriction on a prefix of a Common User/Role/Profile name
_common_user_prefix	C##	Enforce restriction on a prefix of a Common User/Role/Profile name
_relocate_pdb	FALSE	Relocate PDB to another RAC instance after it is closed in the current instance
_set_container_service	DEFAULT	set container service
_multiple_char_set_cdb	TRUE	Multiple character sets enabled in CDB
_cdb_spfile_inherit	FALSE	Inherit CDB Spfile enabled/disabled in a PDB
_enable_pdb_close_abort	TRUE	Enable PDB shutdown abort (close abort)
_enable_pdb_close_noarchivelog	FALSE	Enable PDB close abort with no archive logging
target_pdbs	4	Parameter is a hint to adjust certain attributes of the CDB
max_pdbs	254	max number of pdbs allowed in CDB or Application ROOT
_pdb_cluster_database	TRUE	This parameter can be turned-off when cluster_database is TRUE
_enable_pdb_isolation	FALSE	Enables Pluggable Database isolation inside a CDB
_auto_dismount_on_pdb_close	FALSE	Enable implicit PDB dismount on PDB close
_pdb_mask_cdb_info	FALSE	Enable masking CDB information within a PDB
_split_file_copy	TRUE	Enable block-level parallelism for file copy in Create PDB
_test_offload_pdb_sga_init	FALSE	Test offload of PDB SGA creation
cdb_cluster	FALSE	if TRUE startup in CDB Cluster mode
cdb_cluster_name		CDB Cluster name
_save_afns_on_subset_pdb_creation	FALSE	Use one reserved AFN for skipped tablespaces on pdb subset            creation with lower compat
_multiple_name_convert_patterns	FALSE	apply multiple patterns on a name during file_name_convert             in PDB
standby_pdb_source_file_directory		standby source file directory location
standby_pdb_source_file_dblink		database link to standby source files
_pdb_hash_table_size	255	number of buckets in PDB hash table
_pdb_hash_table_latches	16	number of PDB hash table latches
_pdb_lrg_auto_undots_create	FALSE	enable automatic creation of undo tablespace in local undo mode
_pdb_auto_undots_create_off	FALSE	disable automatic creation of undo tablespace in local undo mode
remote_recovery_file_dest		default remote database recovery file location for refresh/relocate
disable_pdb_feature	0	Disable features
_proxy_connect_after_set_container	TRUE	Enable proxy connection after set container
_pdb_seed_mcsc	FALSE	Allow PDB SEED to have different character set than the CDB.
_pdb_strict_plugin_compat	FALSE	Pluggable database strict plugin compatibility
_enable_pdb_process_limit	TRUE	Enable process limit as the number of sessions in the PDB.
_pdb_inherit_cfd	FALSE	Automatically enable CREATE_FILE_DEST clause in the PDB
_auto_start_pdb_services	FALSE	Automatically start all PDB services on PDB Open
_seed_root_undo_ratio	30	Ratio of PDB$SEED to ROOT undo size, expressed as a percentage
_cdb_disable_pdb_limit	FALSE	CDB Compatible
_slow_kill_on_pdb_close_immediate	FALSE	Kill sessions periodically on pdb close immediate
_edition_enable_oracle_users		Edition enable Oracle supplied users
_pdb_name_case_sensitive	FALSE	Keeps PDB name case sensitive
_restrict_local_user_dml	TRUE	Restrict Local user's ability to update sensitive tables
_pdb_max_diag_size	0	Default value for MAX_DIAG_SIZE property in new PDB creation
_pdb_max_audit_size	0	Default value for MAX_AUDIT_SIZE property in new PDB creation
_reuse_dropped_pdbid_time	180	Time in seconds to wait before reusing a dropped PDB ID
_pdb_auto_save_state	FALSE	Save pdb state automatically on state change on a given instance
_next_pdbid	3	Hint for the next PDBID to use when creating a new PDB entry
_cloud_service_type		cloud service type
_pdb_ignore_table_clauses	TRUE	Ignore subset of clauses in CREATE TABLE and ALTER TABLE
_no_catalog		options whose schemas should not be created
_pdb_max_size_discount	10	Discount percentable on PDB Max space usage
_non_app_ignore_errors	TRUE	ignore errors during containers() on non-application object
_app_ignore_errors	TRUE	ignore errors during containers() on application object
_app_default_containers	FALSE	containers_default and container_map enabled by default on MDL application object
_exclude_seed_cdb_view	TRUE	exclude PDB$SEED from CDB View Result
_disable_cdb_view_rc_invalidation	FALSE	disable Result Cache invalidation for CDB View results
_object_linked_remote	FALSE	Enable remote transformation of Object Linked table
_cdb_rac_affinity	TRUE	rac affinity for parallel cdb operations
_cdb_view_recursive_px_enabled	TRUE	enable parallelism of recursive SQL under CONTAINERS()
_cdb_view_no_skip_migrate	FALSE	do not skip OPEN MIGRATE PDBs from results of CONTAINERS()
_cdb_special_old_xplan	TRUE	display old-style plan for CDB special fixed table
containers_parallel_degree	65535	Parallel degree for a CONTAINERS() query
_disable_con_recurse_queuing	TRUE	disable parallel statement queuing for containers() recursive SQL
_disable_dblink_optim	TRUE	disable intra CDB dblink optimizations
_cdb_view_no_skip_restricted	FALSE	do not skip RESTRICTED mode PDBs from results of CONTAINERS()
_intra_cdb_dblink	FALSE	enable intra CDB implicit dblink
_partition_by_con_name	FALSE	enable partitioning by con$name
_error_row_predicate_evaluation	AUTO	skip predicate evaluation for error rows
_cross_con_collection	FALSE	enable cross container collection
_predicate_validity_execution	FALSE	enable execution-time check for predicate validation
_containers_multiple_ptn_key	TRUE	enable multiple partition keys for container views
_enable_view_pdb	TRUE	Enable Proxy PDB support
_enable_guid_endpoint_service	TRUE	Enable service functionality for GUID service
_enable_proxy_distr_txn	TRUE	Enable Distributed Transaction in Proxy PDB
_federation_max_root_clones	5	Maximum number of Federation Root Clones per Application
_application_purge_enabled	TRUE	Is an application purge allowed
_federation_script	FALSE	Running a Federation script
_application_script	FALSE	Running an application script
default_sharing	METADATA	Default sharing clause
_enable_partial_sync	FALSE	Is partial sync of a Federation allowed
_enable_drop_clone	FALSE	Is drop of a Root Clone allowed
_disable_destructive_patch_operation	TRUE	Is destructive operation allowed in a patch
_upgrade_optim	TRUE	Upgrade optimization enabled
_upgrade_capture_noops	TRUE	do not skip capturing noops during upgrade
_app_replay_silent_errors	FALSE	silently ignore all errors during application sync
_capture_pgadep	0	capture statements at this pgadep
_sync_app_pdb_first_open	FALSE	sync application PDB automatically on first open
_disable_ptl_replay	FALSE	Is PTL replay disabled during Application Sync
_enable_module_match	TRUE	Is match of module name enforced
_lrgdbcz6_ignore_restrictions	FALSE	Temp parameter to ignore app script restrictions for lrgdbcz6
_enable_system_app	2	Enable System app for CDB-wide common users
_modify_other_app_object	FALSE	Parameter to allow modification of another application's object
_enable_cdb_upgrade_capture	FALSE	Enable capture of CDB upgrade
_skip_app_object_check	FALSE	Skip application object checks
_session_aware_replay	TRUE	Enable session aware replay
_strict_dml_data_link	FALSE	Enable strict semantics for DML into [Extended] Data Link
_skip_app_unconverted_check	FALSE	Skip application unconverted check
_enable_auto_upgrade	FALSE	Enable automatic PDB upgrade
_app_container_debug	0	Enable Debug tracing in Application container
_enable_pmo_outside_begin_end	TRUE	Enable PMO outside begin-end block
_record_module_name	TRUE	Record module name in BEGIN action
_no_snapshot_root_clone	FALSE	No snapshot clone during Application Root Clone creation
_root_clone_state_from_root	TRUE	Application Root Clone's state comes from Application Root
_apppdb_multi_slave_sync	FALSE	Multiple slaves used during Application sync
_enable_replay_upgrade_diag	FALSE	Enable diagnostics for Replay Upgrade
_max_stmt_tries_sync	2	Maximum number of tries of a statement during Application Sync
_suppress_migration_errors	TRUE	Suppress migration errors during Application Sync
pdb_lockdown		pluggable database lockdown profile
_pdb_ldp_cascade	0	pluggable database lockdown profile cascade param
_pdb_lockdown_bypass_sr	0	special run lockdown parameter
_default_pct_free	0	Default value of PCT_FREE enforced by DWCS lockdown
_pdb_lockdown_ddl_clauses	0	pluggable database lockdown clauses for statements
_enable_containers_subquery	TRUE	enable transformation to containers() sub query
_force_containers_subquery	FALSE	force transformation to containers() sub query
_cdb_fleet_sync_timeout	10	Time in minutes to wait for sync of stub entry in CDB Fleet
pdb_template		PDB template
_cdb_port	0	Port number for CDB
_pdb_isolation_class	NONE	PDB isolation level: NONE, HIGH or MAX
_con_map_sql_enforcement	TRUE	disable container map SQL enforcement
_uniq_cons_sql_enforcement	TRUE	disable extended data unique constraint SQL enforcement
_ref_cons_sql_enforcement	TRUE	disable extended/data ref constraint SQL enforcement
_xt_http_wscl	FALSE	Use KGWSCL for HTTP requests
_disable_sensitive_internal	FALSE	disable internal SQL from showing sensitive information
_restrict_pdb_gv	FALSE	restrict GV$ in a PDB
_enable_sensitive_trace	FALSE	enable traces to contain sensitive information
_sensitive_common_as_local	FALSE	treat common user as local user for sensitive data handling
_sensitive_common_users		list of common users to be treated as local
_link_ts_name		Name of linked tablespace
_gsm		GSM descriptions
shrd_dupl_table_refresh_rate	60	duplicated table refresh rate (in seconds)
_gsm_region_list		List of GSM Regions
_cloud_name		gsm cloud name
_dbpool_name		gsm database pool name
_region_name		gsm region name
_db_num_gsm	0	database number in gsm dbpool
_gsm_config_vers	0	version of gsm config
_gsm_max_instances_per_db	8	maximum number of instances per database in gsm cloud
_gsm_max_num_regions	10	maximum number of regions in gsm cloud
_gsm_drv_interval	30	metric derived values interval
_gsm_srlat_thresh	20	Single block read latency threshold
_gsm_cpu_thresh	75	CPU busy threshold
_gsm_thresh_zone	10	threshold zone
_gsm_thresh_respct	50	threshold resource percentage
_gsm_svcrgnmax	100	Maximum Service x Region statistics
_gds_chunk_num	0	number of chunks in sharding environment
_gds_max_chunk_num	0	max chunk_num used in sharding environment
_gds_allow_nullkey	0	allow the use of nullable shard key columns
_skip_pset_col_chk	0	skip validation of partition set keys in DML
_gds_lddlid	0	the id of the last executed DDL query
_shardgroup_name		gsm shardgroup name
_gwm_db_unique_name		gsm db_unique_name name
_gds_shardgroup_id	0	shardgroup database is in
_shardspace_name		gsm shardspace name
_shd_reptype	0	replication type of the databse and pool
_gws_deployed	0	the shardb/catalog has been deployed for sharding.
_gws_sharding_method	0	Sharding method used (system-managed/user-defined/composite)
_gws_cache_version	0	the shard/catalog cache version.
_gwm_database_flags		GWM Database Flags
_user_defined_sharding	0	enable user-defined sharding
_dupt_noupdate	0	disable duplicated table updates
_shd_atomic_move	0	Use atomic move
multishard_query_data_consistency	strong	consistency setting for multishard queries
multishard_query_partial_results	not allowed	enable partial results for multishard queries
_gwm_int_dbnum	0	GWM internal db id
_gwm_autoons_ha_subscription		AutoONS HA notification subscription string
_gwm_autoons_rlb_subscription		AutoONS RLB notification subscription string
_oracle_special_license_1_granted		gsm spare 1
_gwm_spare2	0	gsm spare 2
_gwm_spare3	0	gsm spare 3
_rq_shm_max_size	1024	maximum size of an RQuery shared memory segement (in KB)
_hcs_enable_all_distinct	FALSE	use distinct instead of rownum=1
_hcs_disable_exists_distinct	FALSE	no exists distinct
_hcs_disable_filter_hierarchies	FALSE	filter hierarchies in hcs queries
_hcs_disable_hier_join_map_nonnull	FALSE	no hier join map non null
_hcs_disable_level_ord	FALSE	prune away MAX(MAX(...)) around level order columns
_hcs_disable_level_prune	FALSE	perform all level pruning
_hcs_disable_level_prune_gby	FALSE	perform level pruning in group by
_hcs_disable_level_prune_hier_join	FALSE	perform level pruning from hierarchy joins
_hcs_disable_level_prune_hier_qry	FALSE	perform level pruning from hierarchy queries
_hcs_disable_level_prune_hierarchize	FALSE	level prune hierarchize
_hcs_disable_level_prune_in_qry	FALSE	perform level pruning from level IN conditions
_hcs_disable_level_prune_mbr_lookup	FALSE	perform level pruning in member lookup queries
_hcs_disable_level_prune_vis_lvs	FALSE	perform level pruning from visible leaves
_hcs_disable_level_prune_calc_data_joins	FALSE	perform level pruning for joins across calc data
_hcs_logging	SUMMARY	analytic view logging
_hcs_disable_materialize	FALSE	add materialize to result cache hint
_hcs_disable_opt_estimate	FALSE	generate opt estimate hints
_hcs_enable_parallel_hint	FALSE	include parallel hint in cell query
_hcs_disable_result_cache_hint	FALSE	generate hcs query result cache hints
_hcs_disable_smooth_descendants	FALSE	perform smooth descendants
_hcs_disable_smooth_drill_all	FALSE	perform smooth drill all
_hcs_disable_smooth_hierarchize	FALSE	perform hierarchize smoothing
_hcs_disable_smooth_remove_all	FALSE	smooth and remove ALL member
_hcs_disable_pushed_preds_in_gen_sql	FALSE	push sql query predicates into hierarchy targets
_hcs_disable_vis_totals	FALSE	generate visual totals
_hcs_enable_unsupported_calcs	FALSE	enable unsupported calcs
_hcs_query_hint		query hint
_hcs_disable_bd_agg_opt	FALSE	optimize base data aggregation
_hcs_disable_sp_jback_opt	FALSE	optimize single parent joinback
_hcs_disable_av_jback_opt	FALSE	optimize analytic view query joinback
_hcs_disable_all_prune	FALSE	prune hierarchies pinned to ALL level
_hcs_enable_dynamic_cache	FALSE	enable/disable av cache DYNAMIC definition
_hcs_disable_hord_in_oby_prune	FALSE	prune levels if HIER_ORDER referenced only in ORDER BY
_hcs_disable_jback_opt_for_hord_in_oby	FALSE	optimize analytic view joinback for HIER_ORDER
_hcs_disable_mv_rewrite_check	FALSE	skip MV rewrite check when generating for ANALYTIC VIEW cache
_hcs_disable_cell_qry_tmpls	FALSE	no cell query templates for optimization
_hcs_disable_opt_cell_qry	FALSE	optimize cell query
_hcs_disable_cell_qry_meas_prune_opt	FALSE	apply measure prune optimization to cell query
_hcs_disable_cell_qry_lvl_prune_opt	FALSE	apply level prune optimization to cell query
_hcs_disable_cell_qry_no_calc_nav_opt	FALSE	apply no calc navigation optimization to cell query
_hcs_disable_cell_qry_mv_cache_opt	FALSE	apply mv cache optimization to cell query
_hcs_disable_latest_compat_check	FALSE	skip compatibility check for latest compatible version
_hcs_disable_col_prune_optz	FALSE	skip column pruning optimization on generated SQL
_hcs_disable_rm_unused_withs_optz	FALSE	skip unused WITH element removal optimization on generated SQL
_hcs_disable_rm_like_withs_optz	FALSE	skip like WITH element removal optimization on generated SQL
_hcs_enable_auto_av_cache	FALSE	use dynamic across all levels cache
_hcs_enable_parse_auto_av_cache	FALSE	allow parsing of dynamic across all levels cache
_hcs_disable_mdx_cache_hint	FALSE	generate hcs query mdx cache hints
_hcs_enable_mdx_cache_name_col	FALSE	add column for mdx cache name
_hcs_enable_multi_parent_gen	FALSE	generate hcs query using multi-parent aggregation
_hcs_enable_mdx_sleep_after_pin	FALSE	sleep after pinning MDX caches
_hcs_stats_max_card	2000000	maximum value for stats cardinality
_hcs_disable_cell_qry_no_out_data_opt	FALSE	apply no output data optimization to cell query
_hcs_disable_inline_tmpl_opt	FALSE	apply inline single ref top blocks optimization to cell query
_hcs_disable_rmv_unref_top_opt	FALSE	apply remove unref top blocks optimization to cell query
_hcs_disable_cell_qry_atr_prune_opt	FALSE	apply attribute prune optimization to cell query
_hcs_disable_calc_dtm_to_out_opt	FALSE	apply move calc determined hier to output hier optimization
_hcs_disable_fltr_hier_star_opt	FALSE	apply filtered hierarchy star optimization
_hcs_disable_fltr_fact_opt	FALSE	apply filtered fact optimization
_hcs_enable_aggr_opt_estimate	FALSE	apply OPT_ESTIMATE hint to aggregation queries
_hcs_disable_tgt_depths_opt	FALSE	apply target depths optimization
_hcs_disable_dup_src_tbl_opt	FALSE	apply duplicate src table optimization
_hcs_enable_in_mem_cdt_hint	FALSE	add hint opt_param('_in_memory_cdt', 'off')
_hcs_enable_expose_with_expr	FALSE	expose internal with_expression
_hcs_enable_pred_push	TRUE	enable optimizer AV predicate pushing via reparse
_hcs_disable_dup_nav_calc_opt	FALSE	duplicate navigation calc optimize
_hcs_disable_calc_opt	FALSE	calc optimize
_hcs_disable_obj_cache_name	FALSE	Do not include the object number in an aggregate or level cache
_hcs_disable_fltr_below_fltr_star_opt	FALSE	apply filter below filtered star optimization
_hcs_disable_vector_transform	FALSE	disable vector transform hint
_hcs_enable_no_expand	FALSE	enable no expand hint
_hcs_disable_unnest	FALSE	disable unnest hint
_hcs_enable_mdx_mv_gen	FALSE	enable mdx mv cache SQL generation
_hcs_enable_mem_trck	FALSE	enable memory tracking
_hcs_disable_view_merge	FALSE	disable view merge
_reg_cache_status	FALSE	Enables or disabled caching

*/
