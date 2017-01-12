create or replace function random_string(length integer) 
returns text as $$
	declare
		chars text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
		result text := '';
		i integer := 0;
	begin
		if length < 0 then
			raise exception 'Given length cannot be less than 0';
		end if;
		for i in 1..length loop
			result := result || chars[1+random()*(array_length(chars, 1)-1)];
		end loop;
		return result;
	end;
$$ language plpgsql;

-- --------------------------------------------------------------

create or replace function random_string(minlength integer, maxlength INTEGER, words INTEGER) 
returns text as $$
	declare
		result text := '';
	begin
		for i in 1..words loop
			result := result || random_string(random_int_range(minlength, maxlength)) || ' ';  
		end loop;
		return TRIM(result);
	end;
$$ language plpgsql;

-- --------------------------------------------------------------

create or replace function random_date(begining varchar(20), ending varchar(20))
returns timestamp as $$
	select cast(begining as timestamp) + random() * 
		(cast(ending as timestamp) - cast(begining as timestamp))
$$ language sql;

-- --------------------------------------------------------------

create or replace function random_int_range(begining integer, ending integer) 
returns integer as $$
	select (cast((random()*1e6) as integer) % ((ending+1)-begining)) + begining
$$ language sql;
