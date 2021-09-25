pipeline {
    options {
        disableConcurrentBuilds()
    }

    agent any

    stages {
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
                configFileProvider([configFile(fileId: 'deploy-env-prod', targetLocation: './.env.production')]) {
                    sh 'cat ./.env.production'
                }
                withCredentials([sshUserPrivateKey(
                        credentialsId: 'deploy',
                        keyFileVariable: 'keyfile',
                        passphraseVariable: 'passphrase',
                        usernameVariable: 'userName'
                )]) {
                    sh 'echo BEFORE_COPY'
                    sh 'cat ./.env.production'
                    sh 'echo ${passphrase} >> pass'
                    sh 'sshpass -Ppassphrase -f ./pass scp -i ${keyfile} -P ${DEPLOY_PORT} ./partners-deploy.tar.gz ./env.production ./prepare.sh ${userName}@${DEPLOY_HOST}:~'
                    sh 'sshpass -Ppassphrase -f ./pass ssh -i ${keyfile} -p ${DEPLOY_PORT} ${userName}@${DEPLOY_HOST} chmod +x \\~/prepare.sh \\&\\& \\~/prepare.sh'
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