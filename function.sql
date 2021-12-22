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