#Set the path for the R libraries you would like to use.
#You may need to modify this if you have custom R libraries.
.libPaths(c(.libPaths(), '/usr/lib/spark/R/lib'))

#Set the SPARK_HOME environment variable to the location on EMR
Sys.setenv(SPARK_HOME = '/usr/lib/spark')

#Load the SparkR library into R
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

#Initiate a Spark context and identify where the master node is located.
#local is used here because the RStudio server
#was installed on the master node

sc <- sparkR.session(master = "local[*]", sparkEnvir = list(spark.driver.memory="2g"))
sqlContext <- sparkR.session(sc)
