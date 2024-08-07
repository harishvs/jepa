# Prereqs

export SSH_KEY_NAME=<your key name>
intall jq 
`sudo apt-get install jq`

# Install pcluster

https://docs.aws.amazon.com/parallelcluster/latest/ug/install-v3-virtual-environment.html

Note: Use pip to install pcluster and follow the directions above, If you use conda , you cannot install parallel cluster  

# set common varaibles in common_env.sh

## create new PCluster AMI from DLAMI 
./jepa-plcluster-build-ami.sh


## Create the cluster config
./create-cluster-config.sh

## Create the cluster
./create_cluster.sh



## login to cluster
pcluster ssh --cluster-name <cluster name> -i <your_ssh.pem> --region <region>


## Create the Hello World Application

```
cat > mpi_hello_world.c << EOF
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <unistd.h>

int main(int argc, char **argv){
  int step, node, hostlen;
  char hostname[256];
  hostlen = 255;

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &node);
  MPI_Get_processor_name(hostname, &hostlen);

  for (step = 1; step < 5; step++) {
    printf("Hello World from Step %d on Node %d, (%s)\n", step, node, hostname);
    sleep(2);
  }

 MPI_Finalize();
}
EOF

module load intelmpi
mpicc mpi_hello_world.c -o mpi_hello_world


## run the hello world

`mpirun -n 4 ./mpi_hello_world`

## create a submission script (you need to be logged in to the ssh node)
```
cat > submission_script.sbatch << EOF
#!/bin/bash
#SBATCH --job-name=hello-world-job
#SBATCH --ntasks=4
#SBATCH --output=%x_%j.out

mpirun ./mpi_hello_world
EOF
```


## Submit your First Job
sbatch submission_script.sbatch

## Check status 
squeue
when the queue is empty, your job is done.

After sometime you should see hello-world-job_1.out
the logs will be in this file

At this point your cluster is setup

## verify that your compute nodes are set up and configured

`sinfo`
show there are two queues in your cluster


