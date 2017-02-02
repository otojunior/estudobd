-- Random Cap
CREATE or replace FUNCTION rstringcap(minlen NUMERIC, maxlen NUMERIC)
RETURNS VARCHAR(1000) AS
$$
DECLARE
  rv VARCHAR(1000) := '';
  i  INTEGER := 0;
  len INTEGER := 0;
BEGIN
  IF maxlen < 1 OR minlen < 1 OR maxlen < minlen THEN
    RETURN rv;
  END IF;

  len := floor(random()*(maxlen-minlen)) + minlen;

  FOR i IN 1..floor(len) LOOP
    rv := rv || chr(97+CAST(random() * 25 AS INTEGER));
  END LOOP;
  RETURN initcap(rv);
END;
$$ LANGUAGE plpgsql;

-- Random Integer
create or replace function rint(min integer, max integer)
returns integer as
$$
	select (random()*1e7)::integer % (max - min) + min;
$$ language sql;

-- Random Date
create or replace function rtime(min varchar, max varchar)
returns timestamp as
$$
	select min::timestamp +
       random() * (max::timestamp -
                   min::timestamp);
$$ language sql;