-- insensível a tempo verbal :: verbo comer: comeu, comeria, comerá
-- insensível a flexão de gênero e número: rato: rata, ratos
-- ignora artigos que não mudam o significado da sentença de pesquisa

SELECT 
	to_tsquery('comeu & rato') @@ 
	to_tsvector('Um gato comeu muitos ratos');

SELECT 
	to_tsquery('um & comeria & rato') @@ 
	to_tsvector('Um gato comeu muitos ratos');
	
SELECT 
	to_tsquery('o & comerá & rata') @@ 
	to_tsvector('Um gato comeu muitos ratos');

-- ratazana já muda o significado.

SELECT 
	to_tsquery('comerá & ratazana') @@ 
	to_tsvector('Um gato comeu muitos ratos');

-- termos um seguido do outro:

SELECT to_tsquery('fatal <1> error') @@ to_tsvector('fatal error');
SELECT to_tsquery('gato <2> rato') @@ to_tsvector('gatos comem ratos');


-- pesquisas com negação:

SELECT 
	to_tsquery('o & comerá & rata & !cachorro') @@ 
	to_tsvector('Um gato comeria muitos ratos, mas o cachorro não deixou');

SELECT 
	to_tsquery('o & comerá & rata & !cachorro') @@ 
	to_tsvector('Um gato comeria muitos ratos, mas o coelho não deixou');


-- **********************************************************

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


--Link: https://www.infoq.com/br/articles/postgresql-fts