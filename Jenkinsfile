pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation babs_oxi_polymerase container'

            }
        }
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    app = docker.build("thefranciscrickinstitute/babs_oxi_polymerase-image")
                    app.inside {
                        sh 'echo Hello test container'

                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Deploy To Staging Environment') {
            when {
                branch 'main'
            }
            steps {

                withCredentials([usernamePassword(credentialsId: 'dockerdeploy', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dockerip \"docker pull thefranciscrickinstitute/babs_oxi_polymerase-image:${env.BUILD_NUMBER}\""
                        try {
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dockerip \"docker stop babs_oxi_polymerase\""
                            sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dockerip \"docker rm babs_oxi_polymerase\""
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dockerip \"docker run --restart always --name babs_oxi_polymerase -p 80:8080 -d thefranciscrickinstitute/babs_oxi_polymerase-image:${env.BUILD_NUMBER}\""
                    }
                }
            }
        }
    }
}
