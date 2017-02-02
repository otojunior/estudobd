-- criar coluna de busca:

ALTER TABLE municipios ADD busca tsvector;

-- popular coluna de busca:

UPDATE municipios SET busca = to_tsvector(nome);

-- efetuar busca usando FTS:

SELECT nome, uf
FROM municipios
WHERE busca @@ plainto_tsquery('água');

-- buscas com ranking:

SELECT nome, uf, 
	ts_rank_cd(
		busca, 
		to_tsquery('são & (carlos | pedro)'), 10) as rank
FROM municipios
WHERE busca @@ to_tsquery('são & (carlos | pedro)')
ORDER BY rank DESC, nome, uf
LIMIT 10;

-- depuração dos parsers:

SELECT ts_debug('15 contas no http://gmail.com');

-- estatísticas do vetor de buscas:

SELECT * 
FROM ts_stat('SELECT busca FROM municipios')
ORDER BY nentry DESC, ndoc DESC, word
LIMIT 100;

-- criar índice invertido:

CREATE INDEX municipios_gidx ON municipios USING gin(busca);

-- ***************************************

-- Mantendo o índice atualizado:

-- criar função de trigger:

CREATE or replace FUNCTION municipios_trigger()
RETURNS trigger AS $$
	begin
		new.busca := to_tsvector(new.nome);
		return new;
	end
$$ LANGUAGE plpgsql;

-- criar trigger de atualização:

CREATE TRIGGER municipios_tsupdate
BEFORE INSERT OR UPDATE ON municipios
FOR EACH ROW EXECUTE PROCEDURE municipios_trigger();
