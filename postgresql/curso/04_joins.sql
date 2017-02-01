-- Empregados

drop table if exists empregados0;

create table if not exists empregados0 as 
select generate_series as id,
	rstringcap(10,20)::varchar(20) as nome,
	rstringcap(10,30)::varchar(30) as sobrenome,
	rtime('1950-01-01','2017-01-01')::date as dtnasc,
	rint(6000,7000) as ramal,
	(case when rint(0,2) = 0 then 'M' else 'F' end)::char(1) as genero,
	'junk'::char(1000) as junk,
	rint(1,31) as dpto_id
from generate_series(1,1000);

alter table empregados0 
add constraint empregados0_pk
primary key (id);

create index idx_dptoid 
on empregados0 (dpto_id);

-- Departamentos

drop table if exists departamentos0;

create table if not exists departamentos0 as 
select generate_series as id,
	rstringcap(10,15)::varchar(15) as nome,
	rstringcap(10,40)::varchar(40) as descricao,
	rtime('1950-01-01','2017-01-01')::date as criacao,
	rint(6000,7000) as ramal,
	'junk'::char(1000) as junk
from generate_series(1,30);

alter table departamentos0 
add constraint departamentos0_pk
primary key (id);

analyze;

/*
	Testando o join:
	Sem filtro: Hash Join.
	Com filtro: Nested Loop (menos dados)
*/	

SELECT *
FROM empregados0 e
JOIN departamentos0 d on d.id = e.dpto_id
WHERE d.id = 10

-- Nested Loop: custo 346.0

/*
A tabela da direita é varrida totalmente para 
cada linha encontrada na tabela da esquerda.
*/

set enable_nestloop = true;
set enable_mergejoin = false;
set enable_hashjoin = false;

SELECT *
FROM empregados0 e
JOIN departamentos0 d on d.id = e.dpto_id;

-- Merge Join: custo 224.01

/*
Cada tabela é ordenada antes da junção, depois cada tabela é varrida
paralelamente e combinadas pela chave de junção.
*/

set enable_nestloop = false;
set enable_mergejoin = true;
set enable_hashjoin = false;

SELECT *
FROM empregados0 e
JOIN departamentos0 d on d.id = e.dpto_id;

-- Hash Join: custo 172.43

/*
A tabela da direita é varrida primeiro e colocada numa tabela hash,
usando como chave do hash a coluna de junção. Depois a tabela da esquerda é
varrida e o valor apropriado de cada linha encontrada é usada como
chave de hash para localizar as linhas correspondentes na tabela.
*/

set enable_nestloop = false;
set enable_mergejoin = false;
set enable_hashjoin = true;

SELECT *
FROM empregados0 e
JOIN departamentos0 d on d.id = e.dpto_id;

set enable_nestloop = true;
set enable_mergejoin = true;
set enable_hashjoin = true;