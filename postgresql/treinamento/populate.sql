﻿drop table if exists departamento;

create table departamento (
	id INTEGER primary key,
	nome VARCHAR(20),
	criacao timestamp
);

-- --------------------------------------------------------------

insert into departamento
select 	generate_series as id,
	'Dpto ' || random_string(random_int_range(5,15))::varchar(20) as nome,
	random_date('2017-01-01 00:00:00', '2017-12-31 23:59:59') as criacao
from generate_series(1,1e3)

-- ---------------------------------------------------------------

drop table if exists empregado;

create table empregado (
	id INTEGER primary key,
	nome VARCHAR(50),
	nasc timestamp,
	dpto_id integer,
	foreign key (dpto_id) references departamento (id)
);

-- ---------------------------------------------------------------

insert into empregado
select generate_series as id,
	'Emp ' || random_string(random_int_range(5,15))::varchar(20) as nome,
	random_date('1920-01-01 00:00:00', '2016-12-31 23:59:59') as nasc,
	random_int_range(1, 1e3::INTEGER) as dept_id
from generate_series(1, 1e5);