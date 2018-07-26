CREATE KEYSPACE IF NOT EXISTS port_info WITH REPLICATION = { 'class' : 'org.apache.cassandra.locator.NetworkTopologyStrategy', 'dseawsd': '3' } AND DURABLE_WRITES = true;

CREATE TABLE IF NOT EXISTS port_info.ports (
    brand_code text,
    port_code text,
    port_type text,
    port_name text,
    PRIMARY KEY (brand_code, port_code, port_type)
) WITH read_repair_chance = 0.0
   AND dclocal_read_repair_chance = 0.1
   AND gc_grace_seconds = 864000
   AND bloom_filter_fp_chance = 0.01
   AND caching = { 'keys' : 'ALL', 'rows_per_partition' : 'NONE' }
   AND comment = ''
   AND compaction = { 'class' : 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy', 'max_threshold' : 32, 'min_threshold' : 4 }
   AND compression = { 'chunk_length_in_kb' : 64, 'class' : 'org.apache.cassandra.io.compress.LZ4Compressor' }
   AND default_time_to_live = 0
   AND speculative_retry = '99PERCENTILE'
   AND min_index_interval = 128
   AND max_index_interval = 2048
   AND crc_check_chance = 1.0
   AND cdc = false;


