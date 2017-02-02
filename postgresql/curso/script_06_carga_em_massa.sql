-- exportando com COPY

copy municipios to 'd:\temp\backup.txt';

-- importando com COPY

drop table if exists cidades;

create table if not exists cidades as 
select * 
from municipios 
where false;

copy cidades from 'd:\temp\backup.txt';

-- depois de importados, podemos criar as restrições e os índices.

alter table cidades
add constraint cidades_pkey
primary key (id);

ALTER TABLE cidades
ADD CONSTRAINT cidades_estado_fk FOREIGN KEY (uf)
REFERENCES estados (id);

CREATE INDEX cidades_gidx
ON cidades
USING gin (busca);

-- ******************************************************************

-- Alguns outros exemplos variando um pouco a sintaxe:

copy municipios to 'd:\temp\backup.bin'
with (
	freeze true,
	FORMAT binary
);

copy municipios to 'd:\temp\backup.txt'
with (
	freeze true,
	FORMAT text
);

copy municipios to 'd:\temp\backup.csv'
with (
	freeze true,
	FORMAT csv,
	delimiter '|'
);