# Model-based Explorative Testing for ZooKeeper-3.8.0

This project is about distributed system explorative testing driven by models. 

**Model-based explorative Testing (MET)** is an effective approach for understanding target distributed system design and detecting distributed system bugs. It combines the advantages of both model checking and testing.

At the design level, by modelling the target distributed system using lightweight formal languages such as TLA+ and the programming language, developers can make a deep comprehensive understanding upon the target system. Besides, test cases can be generated using the model checker easily. Since the model contains experts' domain knowledge, some subtle and deep bugs can be found during the model checking phase.

At the implementation level, above test cases generated by the model checker can be injected into the real system. By manipulating target system ( here, we manipulate Java-implemented systems using the RMI framework and aspect-oriented instrumentation techniques like AspectJ ), these generated test cases can be precisely replayed and verified in the running system, which clears the doubt that model-based generated trace is only responsible for the model and cannot be reproduced at the code level. 



Currently we have conducted some testing work on ZooKeeper, a popular system that provides coordination service for other distributed systems. Applying this method to ZooKeeper-3.8.0 (the latest version till 2022), we have triggered some subtle deep bugs. We have also reproduced some deep and subtle bugs in the former versions of ZooKeeper, such as [ZOOKEEPER-3911](https://issues.apache.org/jira/browse/ZOOKEEPER-3911),  [ZOOKEEPER-2845](https://issues.apache.org/jira/browse/ZOOKEEPER-2845), etc. More bugs and property violations are expected to be found applying this approach!

Note: some modules of this project are developed based on the implementation [here](https://gitlab.mpi-sws.org/rupak/hitmc) , which appeared in the work [Trace Aware Random Testing for Distributed Systems](https://dl.acm.org/doi/pdf/10.1145/3360606). 



The directories of the project mainly includes the following contents.

* *zk-test* : the test engine for ZooKeeper
  * *api* : the RMI remote interface and state type definition for both RMI server and clients of the test engine (in this testing framework, the RMI clients are the instrumented ZooKeeper nodes).
  * *server* : the RMI server of the test engine, including the modules of scheduler, executor, checker and interceptor, etc. The server also implements the RMI remote interface, creates and exports a remote object that provides the service.
  * *zookeeper-ensemble* : the main entry of the testing engine, as well as the configuration and process control of the ZooKeeper ensembles.
  * *zookeeper-wrapper* : AspectJ-instrumented codes for ZooKeeper. With the instrumented codes, each ZooKeeper node will take the role as an RMI client, register the remote object with a Java RMI registry, and invoke the remote methods at specific program points. In this way, test engine server can intercept target system at the appropriate moments for later scheduling work in the testing. 
  * *test* : scripts for running tests. Also the directory for test output.
    * *buildAndTest.sh* : build the project and run the test.
    * *test.sh* : run the test without building the project from scrach.
    * *stop.sh* : stop the existing running ZooKeeper nodes.
    * *zookeeper.properties* :  configuration file for testing. 
    * *zk_log.properties* : configuration files of logging. 
    * *traces* : trace files (.json) generated by external models.
* *apache-zookeeper-3.8.0* : the source code of the target system for testing. This is needed when building the project from the ground up.



## Build Instructions

The test can be built and run using the script below. Java (at lease version 8) and [Apache Maven](http://maven.apache.org/) (at least version 3.5) is required.

```bash
./zk-test/test/buildAndTest.sh
```

Or, run the test without building it:

```bash
./zk-test/test/test.sh
```
