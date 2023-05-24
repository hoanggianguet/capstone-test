pipeline {

    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {

        stage("Lint HTML Static files") {
            steps {
                sh 'tidy -q -e ./blue-app/*.html'
                sh 'tidy -q -e ./green-app/*.html'
            }
        }
        stage("Made the file executable") {
            steps {
                sh ''
                '
                chmod + x. / create_cluster.sh
                chmod + x. / remove_cluster.sh
                chmod + x. / create_k8s - config.sh
                chmod + x. /
                    switch -to - green - app.sh ''
                '
                sh ''
                '
                cd. / blue - app
                chmod + x. / build_docker.sh
                chmod + x. / upload_docker.sh
                chmod + x. / remove_docker.sh
                chmod + x. / blue - app.yaml
                chmod + x. / blue - service.yaml ''
                '
                sh ''
                '
                cd. / green - app
                chmod + x. / build_docker.sh
                chmod + x. / upload_docker.sh
                chmod + x. / remove_docker.sh
                chmod + x. / green - app.yaml
                chmod + x. / green - service.yaml ''
                '
            }
        }
        stage("Build Docker Images Stage") {
            parallel {
                stage("Build Blue App Image") {
                    steps {
                        sh ''
                        '
                        echo $BUILD_ID
                        cd. / blue - app
                            . / build_docker.sh ''
                        '						
                    }
                }
                stage("Build Green App Image") {
                    steps {
                        sh ''
                        '
                        echo $BUILD_ID
                        cd. / green - app
                            . / build_docker.sh ''
                        '
                    }
                }
            }
            stage("List Images after Building") {
                steps {
                    sh 'echo " ---- Display List Dockers Images was build--- "'
                    sh 'docker images'
                }
            }
        }

        stage("Push Docker Images") {
            parallel {
                stage("Push Blue Image") {
                    steps {
                        sh 'echo " ---- Pushing Docker Image to the Repository --- "'
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        sh ''
                        '
                        cd. / blue - app
                            . / upload_docker.sh ''
                        '
                    }
                }
                stage("Push Green Image") {
                    steps {
                        sh 'echo " ---- Pushing Docker Image to the Repository --- "'
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        sh ''
                        '
                        cd. / green - app
                            . / upload_docker.sh ''
                        '
                    }
                }
            }
            stage("List Images after Pushing to Registry") {
                steps {
                    sh 'echo " ---- Listing Dockers Images --- "'
                    sh 'docker images'
                }
            }
        }

        stage("Remove Docker Images") {
            parallel {
                stage("Remove Blue Image") {
                    steps {
                        sh 'echo " ---- Removing Blue Image --- "'
                        sh ''
                        '
                        cd. / blue - app
                            . / remove_docker.sh ''
                        '
                    }
                }
                stage("Remove Green Image") {
                    steps {
                        sh 'echo " ---- Removing Green Image --- "'
                        sh ''
                        '
                        cd. / green - app
                            . / remove_docker.sh ''
                        '
                    }
                }
                stage("Confirm Docker Images are removed") {
                    steps {
                        sh 'echo " ---- Listing Dockers Images --- "'
                        sh 'docker images'
                    }
                }

            }
        }

        stage("Create Kubernetes Cluster in AWS EKS") {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                    sh 'echo " ---- Creating Kubernetes Cluster in AWS --- "'
                    sh 'eksctl create cluster --name cloud-devops-capstone --version 1.26 --region us-east-1 --nodegroup-name project-capstone --node-type t3.micro --nodes 4 --nodes-min 2 --nodes-max 4 --managed'
                }
            }
        }
        stage("Update K8s Cluster Context") {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                    sh 'echo " ---- Updating Kubernetes Cluster Config --- "'
                    sh 'aws eks --region us-east-1 update-kubeconfig --name cloud-devops-capstone'
                }
            }
        }
        stage("Deploy Application Containers") {
            parallel {
                stage("Deploy Blue Application Container") {
                    steps {
                        withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                            sh 'echo " ---- Deploying Green Application Container --- "'
                            sh ''
                            '
                            cd. / blue - app
                            kubectl apply - f blue - app.yaml ''
                            '
                        }
                    }
                }
                stage("Deploy Green Application Container") {
                    steps {
                        withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                            sh 'echo " ---- Deploying Blue Application Container --- "'
                            sh ''
                            '
                            cd. / green - app
                            kubectl apply - f green - app.yaml ''
                            '
                        }
                    }
                }
            }
        }
        stage("Run Blue Application") {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                    sh 'echo " ---- Running Blue Application --- "'
                    sh ''
                    '
                    cd. / blue - app
                    kubectl apply - f blue - service.yaml ''
                    '
                }
            }
        }
        stage("K8s: Verify Blue Application") {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                    sh 'echo " --- Very Blue application is running --- "'
                    sleep time: 1, unit: 'MINUTES'
                    sh 'kubectl get nodes,deploy,svc,pod'
                    sh 'kubectl get service -o wide'
                    sh 'echo " --- Copy URL and test the application in the browser --- "'
                    sleep time: 1, unit: 'MINUTES'
                }
            }
        }
        stage("Switch to Green Application") {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                    sh 'echo " ---- Switching Application from Blue to Green --- "'
                    sh 'kubectl apply -f green-app/green-service.yaml'
                }
            }
        }
        stage("K8s: Verify Green Application") {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-jenkins') {
                    sh 'echo " --- Very Green application is running --- "'
                    sleep time: 1, unit: 'MINUTES'
                    sh 'kubectl get nodes,deploy,svc,pod'
                    sh 'kubectl get service -o wide'
                    sh 'echo " --- Copy URL and test the application in the browser --- "'
                }
            }
        }
    }
}