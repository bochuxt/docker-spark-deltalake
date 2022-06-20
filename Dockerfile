FROM eclipse-temurin:11-jre-alpine

MAINTAINER Cam Saul <cam@metabase.com>

WORKDIR /spark

ENV SPARK_VERSION 3.2.1
ENV HADOOP_VERSION 3.2
ENV DELTA_VERSION 1.2.1
ENV SCALA_VERSION 2.12

# Spark
ENV SPARK_ARCHIVE spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN wget "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_ARCHIVE}" && \
    tar -xf $SPARK_ARCHIVE && \
    rm $SPARK_ARCHIVE
ENV SPARK_DIR "/spark/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"

# DeltaLake
ENV DELTA_ARCHIVE delta-core_$SCALA_VERSION-$DELTA_VERSION.jar
RUN wget https://repo1.maven.org/maven2/io/delta/delta-core_$SCALA_VERSION/$DELTA_VERSION/$DELTA_ARCHIVE && \
    ls -lh $SPARK_DIR && \
    mv $DELTA_ARCHIVE $SPARK_DIR/jars/ && \
    ls -lh $SPARK_DIR/jars

EXPOSE 10000

ENTRYPOINT java \
 -Duser.timezone=Etc/UTC \
 -Xmx512m \
 -cp "${SPARK_DIR}/conf:${SPARK_DIR}/jars/*" \
 org.apache.spark.deploy.SparkSubmit \
 --master local[8] \
 --packages io.delta:delta-core_$SCALA_VERSION:$DELTA_VERSION \
 --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" \
 --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" \
 --conf spark.executor.extraJavaOptions=-Duser.timezone=Etc/UTC \
 --conf spark.eventLog.enabled=false \
 --class org.apache.spark.sql.hive.thriftserver.HiveThriftServer2 \
 --name "Thrift JDBC/ODBC Server" \
 --executor-memory 512m \
 spark-internal
