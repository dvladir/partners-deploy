pipeline {
    options {
        disableConcurrentBuilds()
    }

    agent any

    environment {
        BRANCH="${BRANCH_NAME.replaceAll('feat/', '').toLowerCase()}"
        FOLDER="partners-${BRANCH}"
    }

    stages {
        stage('Show environment') {
            steps {
                sh "echo BRANCH $BRANCH"
                sh "echo FOLDER $FOLDER"
            }
        }
        stage('Prepare configs') {
            steps {
                configFileProvider([
                    configFile(fileId: "app_prop_$BRANCH", targetLocation: './partners-deploy/application.properties'),
                    configFile(fileId: "flyway_conf_$BRANCH", targetLocation: './flyway/flyway.config')
                ]) {}
            }
        }
        stage('Prepare DB') {
            steps {
                dir('./flyway') {
                    sh 'echo "BRANCH=${BRANCH}" >> .env'
                    sh 'docker-compose run migrate'
                    sh 'docker-compose run validate'
                    sh 'docker-compose run info'
                    sh 'docker container prune --force'
                }
            }
        }
        stage('Deploy') {
            environment {
                DEPLOY_HOST = credentials('deploy-host')
                DEPLOY_PASS = credentials('deploy-pass')
            }
            steps {
                dir('./partners-deploy') {
                    sh 'echo "BRANCH=${BRANCH}" >> .env'
                }
                sh 'echo ${DEPLOY_PASS} >> pass'
                sh 'sshpass -Ppassphrase -f ./pass rsync -rv ./partners-deploy/ ${DEPLOY_HOST}:~/${FOLDER}'
                sh 'sshpass -Ppassphrase -f ./pass ssh ${DEPLOY_HOST} cd \\~/${FOLDER} \\&\\& docker stack deploy --compose-file docker-compose.yml ${FOLDER}'
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