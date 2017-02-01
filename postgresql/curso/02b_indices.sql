-- Verificar a seletividade das colunas:

select count(distinct id)::numeric/count(*) from empregados
select count(distinct nome)::numeric/count(*) from empregados
select count(distinct dtnasc)::numeric/count(*) from empregados
select count(distinct ramal)::numeric/count(*) from empregados
select count(distinct genero)::numeric/count(*) from empregados
select count(distinct dpto_id)::numeric/count(*) from empregados

-- Verificar a utilização de índices

SELECT relname, indexrelname, idx_scan,
	idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes;

SELECT relname, indexrelname,
	idx_blks_read, idx_blks_hit
FROM pg_statio_user_indexes;

SELECT relname, seq_scan, seq_tup_read
FROM pg_stat_all_tables;

-- Cluster

cluster verbose empregados using empregados_pk;

-- Índices baseado em funções

select * from empregados where UPPER(nome) = 'OTO';

create index idx_nome on empregados (nome);
create index idx_unome on empregados (UPPER(nome));
