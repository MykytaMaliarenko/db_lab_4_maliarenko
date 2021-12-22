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