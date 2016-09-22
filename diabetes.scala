val df = sqlContext.read
    .format("com.databricks.spark.csv")
    .option("header", "true") // Use first line of all files as header
    .option("inferSchema", "true") // Automatically infer data types
    .load("s3://diabetestnewcases/diabetes_prevalance.csv")


df.printSchema()

df.show()

df.createOrReplaceTempView("diabetes")

sqlContext.sql("Select State,county,number_2013 as new_cases from diabetes order by 1").show()

sqlContext.sql("Select State,sum(number_2013) as new_cases from diabetes group by 1 order by 1").show()

val dfbystate = sqlContext.sql("Select State,sum(number_2013) as new_cases from diabetes group by 1 order by 1")

dfbystate.cache()