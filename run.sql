-- FUNCTION
CREATE OR REPLACE FUNCTION distributors_top_revenue(distributor_name varchar(150)) RETURNS int AS
$$
    DECLARE
        revenue integer;
    BEGIN
        SELECT max(trm.total_revenue) INTO revenue
        FROM top_revenue_distributor
        left join top_revenue_movie trm on top_revenue_distributor.id = trm.distributor_id
        WHERE top_revenue_distributor.name = distributor_name;
        RETURN revenue;
    END;
$$ LANGUAGE 'plpgsql';

SELECT distributors_top_revenue('20th Century Fox');


-- PROCEDURE
CREATE OR REPLACE PROCEDURE filter_movies_by_genre(genre_name varchar(150))
LANGUAGE 'plpgsql'
AS $$
BEGIN
	DROP TABLE IF EXISTS filtered_movies;
	CREATE TABLE filtered_movies
	AS
	(
	    select top_revenue_movie.id, top_revenue_movie.name from top_revenue_movie
	    left join top_revenue_genre trg on trg.id = top_revenue_movie.genre_id
	    where trg.name = genre_name
	);
END;
$$;

CALL filter_movies_by_genre('Musical');


-- TRIGGER
CREATE OR REPLACE FUNCTION inject_year()
RETURNS trigger AS
$$
	BEGIN
	    IF NEW.year is null THEN
            NEW.year = 2021;
        END IF;
	    RETURN NEW;
	END;
$$ LANGUAGE 'plpgsql';
DROP TRIGGER IF EXISTS validate_top_revenue_movie on top_revenue_movie;

CREATE TRIGGER validate_top_revenue_movie
BEFORE UPDATE OR INSERT ON top_revenue_movie
FOR EACH ROW
EXECUTE FUNCTION inject_year();

SELECT * FROM top_revenue_movie where year = 2021;
INSERT INTO top_revenue_movie(name, rating, total_revenue, year, distributor_id, genre_id)
values ('Black Panther','PG-13',703901821,null,10,7);
SELECT * FROM top_revenue_movie where year = 2021;