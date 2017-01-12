/*
	Populate :: Exemplo 02
	Autor:
		Oto Soares Coelho Junior
		(otojunior@gmail.com)
		17/01/2017
	Entidades:
		[cliente]1---*[pedido]*---*[item]*---1[categoria]
*/


drop table if exists cliente cascade;

create table cliente (
	id INTEGER primary key,
	nome VARCHAR(60),
	nasc timestamp
	/* idade pode ser campo calulado via function */
);

-- ---------------------------------------------------------------

insert into cliente
select generate_series as id,
	initcap(random_string(5, 15, random_int_range(3, 4))::varchar(60)) as nome,
	random_date('1920-01-01 00:00:00', '2016-12-31 23:59:59') as nasc
from generate_series(1, 1e5);

-- ---------------------------------------------------------------

drop table if exists categoria cascade;

create table categoria (
	id INTEGER primary key,
	nome VARCHAR(20),
	descricao VARCHAR(100)
);

-- ---------------------------------------------------------------

insert into categoria
select generate_series as id,
	'Cat ' || initcap(random_string(random_int_range(5,15))::varchar(20)) as nome,
	'Desc ' || initcap(random_string(10, 22, random_int_range(3, 4))::varchar(100)) as descricao
from generate_series(1, 1e3);

-- ---------------------------------------------------------------

drop table if exists pedido cascade;

create table pedido (
	id INTEGER primary key,
	dt_pedido TIMESTAMP,
	cliente_id INTEGER,
	FOREIGN KEY (cliente_id) references cliente (id)
);

-- ---------------------------------------------------------------

insert into pedido
select generate_series as id,
	random_date('2008-01-01 00:00:00', '2017-01-10 23:59:59') as dt_pedido,
	random_int_range(1, 1e5::INTEGER) as cliente_id
from generate_series(1, 1e4);

-- ---------------------------------------------------------------

drop table if exists item cascade;

create table item (
	id INTEGER primary key,
	nome VARCHAR(20),
	descricao VARCHAR(100),
	preco NUMERIC(5,2),
	cat_id INTEGER,
	FOREIGN KEY (cat_id) references categoria (id)
);

-- ---------------------------------------------------------------

insert into item
select generate_series as id,
	'Item ' || initcap(random_string(random_int_range(5,15))::varchar(20)) as nome,
	'Desc ' || initcap(random_string(10, 22, random_int_range(3, 4))::varchar(100)) as descricao,
	round(cast(random()*1e3 as numeric), 2),
	random_int_range(1, 1e3::INTEGER) as cat_id
from generate_series(1, 1e5);

-- ---------------------------------------------------------------

drop table if exists pedido_item cascade;

create table pedido_item (
	pedido_id INTEGER,
	item_id INTEGER,
	PRIMARY KEY (pedido_id, item_id),
	FOREIGN KEY (pedido_id) references pedido (id),
	FOREIGN KEY (item_id) references item (id)
);

-- ---------------------------------------------------------------

insert into pedido_item
select
	generate_series as pedido_id,
	random_int_range(1, 1e5::INTEGER) as item_id
from generate_series(1, 1e4);
