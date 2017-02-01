-- Criação da tabela de empregados

drop table if exists empregados;

create table if not exists empregados as 
select generate_series as id,
	rstringcap(10,20)::varchar(20) as nome,
	rstringcap(10,30)::varchar(30) as sobrenome,
	rtime('1950-01-01','2017-01-01')::date as dtnasc,
	rint(6000,7000) as ramal,
	(case when rint(0,2) = 0 then 'M' else 'F' end)::char(1) as genero,
	'junk'::char(1000) as junk,
	rint(1,31) as dpto_id
from generate_series(1,1000);

alter table empregados 
add constraint empregados_pk
primary key (id);

-- Atualização da tabelas para testes

UPDATE empregados 
SET nome = 'Oto', sobrenome = 'Junior'
WHERE id=123;

-- ****************************************************

select count(*) from empregados;
