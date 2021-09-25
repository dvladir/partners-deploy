pipeline {
    options {
        disableConcurrentBuilds()
    }

    agent any

    stages {
        stage('Prepare configs') {
            steps {
                configFileProvider([configFile(fileId: 'deploy-env-prod', targetLocation: './partners-deploy/.env.production')]) {}
                configFileProvider([configFile(fileId: 'deploy-env-pg', targetLocation: './partners-deploy/pg-main.env')]) {}
                configFileProvider([configFile(fileId: 'deploy-env-flyway', targetLocation: './partners-deploy/flyway.config')]) {}
            }
        }
        stage('Archive') {
            steps {
                sh "tar -czf ./partners-deploy.tar.gz ./partners-deploy/"
            }
        }
        stage('Deploy') {
            environment {
                DEPLOY_HOST = credentials('deploy-host')
                DEPLOY_PORT = credentials('deploy-port')
            }
            steps {
                withCredentials([sshUserPrivateKey(
                        credentialsId: 'deploy',
                        keyFileVariable: 'keyfile',
                        passphraseVariable: 'passphrase',
                        usernameVariable: 'userName'
                )]) {
                    sh 'echo ${passphrase} >> pass'
                    sh 'sshpass -Ppassphrase -f ./pass scp ./partners-deploy.tar.gz ./prepare.sh ${DEPLOY_HOST}:~'
                    //sh 'sshpass -Ppasshphrase -f ./pass rsync -v ./partners-deploy.tar.gz ./prepare.sh ${DEPLOY_HOST}:~'
                    sh 'sshpass -Ppassphrase -f ./pass ssh ${DEPLOY_HOST} chmod +x \\~/prepare.sh \\&\\& \\~/prepare.sh'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}