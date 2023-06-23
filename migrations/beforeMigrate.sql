DO
$$
DECLARE 
	extensions_available bool = TRUE;
BEGIN
	WITH current_extensions(name,version) AS (
		VALUES 
			('pg_stat_statements','1.10'),
			('timescaledb','2.9')
	),
	installed_extensions(name,version) AS (
		SELECT name, VERSION 
		FROM pg_catalog.pg_available_extension_versions
	)
	SELECT INTO extensions_available NOT EXISTS(SELECT * FROM current_extensions ce
		LEFT JOIN installed_extensions ie USING(name,VERSION)
	WHERE ie.VERSION IS NULL);

	IF NOT extensions_available THEN
		RAISE EXCEPTION 'At least one required extension/version is not available';
	END IF;
END
$$
