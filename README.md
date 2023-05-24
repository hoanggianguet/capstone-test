# Udacity Capstone Project 

## Project Overview

Capstone project for Udacity's "Cloud DevOps Engineer" Nanodegree Program.

<hr>

## Objectives

- Working in AWS
- Using Jenkins to implement Continuous Integration and Continuous Deployment
- Building pipelines
- Working eksclt to deploy clusters
- Building Kubernetes clusters
- Building Docker containers in pipelines

<hr>

## Tools Used

- Git & GitHub
- AWS & AWS-CLI
- Jenkins
- Kubernetes CLI (kubectl)
- eksclt

## Project Steps

1. [Development]
2. [Jenkins]
3. [Setup Kubernetes Cluster]
4. [CI/CD Pipeline]
5. [Cost of Greatness]

### Jenkins

- **Create security-group for jenkins:**

![1-jenkins-sg.png](screenshots/1-jenkins-sg.png)

- **Create jenkins EC2:**

![2-jenkins-ec2.png](screenshots/2-jenkins-ec2.png)

- **Connect to jenkins ec2:**

    ```
    ssh -i udacity-capstone.pem ubuntu@ec2-18-220-188-146.us-east-2.compute.amazonaws.com
    ```

- **Setup Jenkins Server:** 

    - Install java:

        ```
        $ sudo apt update && sudo apt install default-jdk;
        ```

    - Install Jenkins.

    - Install pip3 and venv:
        ```
        $ sudo apt install python3-pip
        ```
        ```
        $ sudo apt-get install python3-venv
        ```

    - Install "Blue-Ocean-Aggregator" Plug-In.

    ![3-jenkins-blueocean.png](screenshots/3-jenkins-blueocean.png)
