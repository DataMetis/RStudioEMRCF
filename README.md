# CloudFormation YAML template to install R Studio on EMR
Let's face it. Although Data guys like me love Spark SQL and everything just fine, but what we really crave is "R" for their daily work. Spark Notebooks are fine but nothing compares to the viseral joy of the R command line REPL. Now we understand that you can only fit so much data on your local R box,  so going to the big rig is inevitable.

Woudln't be great if we could combine the coolness of R with the robustness and pure data crunching power of SPARK? Well, that's what we have tried to do here.

There are two identical CloudFormation templates here:
  1) CloudFormation.tempalte file is in JSON, while
  2) AWS_EMR_CF.YAML file is the same identical file in YAML
  
You can take either of the two files and run it through CloudFormation (either via the console or CLI) to get a nice 3 node EMR cluster (1 master + 2 core). No parameters needed. Just enter a stack name and the template does the rest. I have chosen to have Spark, HUE and Zeppelin installed along with core hadoop libraries (feel free to modify the template to suit your needs).

So far it is pretty ordinary boiler-plate stuff. The cool stuff happens in the bootstrap script "install-r-server.sh" file, which downloads the latest nightly R-studio build from S3 and sets up a few paraameters (user id / password etc, along with the Spark version).

It takes about 10 minutes for the cluster to come up. Before you can launch R Studio on the master node (http://your_master_node_DNS:8787) you must first SSH into the master node to establish port-forwarding (as I data guy, I do not claim to understand why and how it works, but works it does).

Now launch R Studio on the master node and log in with these credentials (datametis / metis100$). Try a few R commands to make sure your R installation works as expected. You still aren't connected to Spark R yet. For that, you need to run the attached "rstudio_spark_r.init" file from your R command prompt. Assuming everything goes well at this point, you shoudl be all set with Spark R on the cluster and with vanilla R on your master node.
















