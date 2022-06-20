# docker-spark-deltalake

Fork of metabase docker-spark that adds support for DeltaLake

## Usage

1. docker-compose up --build
2. Connect using [your favorite](https://snapcraft.io/datagrip) JDBC client

```sql
CREATE TABLE parquet.people
USING DELTA
LOCATION '/data/people'
```

## References
[SQL Syntax](https://books.japila.pl/delta-lake-internals/sql/)
[Why wget DeltaLake JAR](https://stackoverflow.com/questions/69862388/how-to-run-spark-sql-thrift-server-in-local-mode-and-connect-to-delta-using-jdbc)
[Resolves this issue](https://github.com/delta-io/delta/issues/919)
[Version mapping](https://docs.delta.io/latest/releases.html)
[Additional Spark Parameters](https://docs.delta.io/latest/quick-start.html)
[Creating tables](https://docs.databricks.com/delta/quick-start.html#language-sql)
