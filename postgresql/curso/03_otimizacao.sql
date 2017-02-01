-- Criação de índices para o like

create index idx_nome_like on empregados (nome varchar_pattern_ops);

-- usa índice

select * from empregados where nome like 'Ot%';

-- não usa índice

select * from empregados where nome like '%Ot';

-- Busca por valores calculados

select * from empregados where id = 120 + 3		-- OK

select * from empregados where id - 3 = 120		-- Seq. Scan