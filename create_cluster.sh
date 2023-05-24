#!/bin/bash

eksctl create cluster --name udacity-capstone --version 1.26 --region us-east-1 --nodegroup-name project --node-type t3.micro --nodes 4 --nodes-min 2 --nodes-max 4 --managed