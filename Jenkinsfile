pipeline {
    options {
        disableConcurrentBuilds()
    }

    agent any

    stages {
        stage('Prepare configs') {
            steps {
                configFileProvider([configFile(fileId: 'deploy-env-app-prop', targetLocation: './partners-deploy/application.properties')]) {}
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
                DEPLOY_PASS = credentials('deploy-pass')
            }
            steps {
                sh 'echo ${DEPLOY_PASS} >> pass'
                sh 'sshpass -Ppassphrase -f ./pass rsync -v ./partners-deploy.tar.gz ./prepare.sh ${DEPLOY_HOST}:~'
                sh 'sshpass -Ppassphrase -f ./pass ssh ${DEPLOY_HOST} chmod +x \\~/prepare.sh \\&\\& \\~/prepare.sh'
                sh 'rm ./pass'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}