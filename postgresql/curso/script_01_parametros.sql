-- Cache Hit Ratio

SELECT trunc(sum(blks_hit) /
sum(blks_read + blks_hit) * 100, 2)
AS cache_hit_ratio
FROM pg_stat_database;

-- Mostrar parâmetro shared_buffers

show shared_buffers;
