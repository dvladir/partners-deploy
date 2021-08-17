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
                withCredentials([sshUserPrivateKey(
                        credentialsId: 'deploy',
                        keyFileVariable: 'keyfile',
                        passphraseVariable: 'passphrase',
                        usernameVariable: 'userName'
                )]) {
                    sh 'echo ${passphrase} >> pass'
                    sh 'sshpass -Ppassphrase -f ./pass scp -o StrictHostKeyChecking=no -i ${keyfile} -P ${DEPLOY_PORT} ./partners-deploy.tar.gz ./prepare.sh ${userName}@${DEPLOY_HOST}:~'
                    sh 'sshpass -Ppassphrase -f ./pass ssh -o StrictHostKeyChecking=no -i ${keyfile} -p ${DEPLOY_PORT} ${userName}@${DEPLOY_HOST} chmod +x \\~/prepare.sh \\&\\& \\~/prepare.sh'
                }
            }
        }
    }
}