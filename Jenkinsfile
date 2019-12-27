node {
    stage("git-checkout") {
        git branch: "${BRANCH}",
                credentialsId: "${CREDENTIALS_ID}",
                url: "http://git.goodwinsoft.net/peizuo/${APP_NAME}.git"
    }
    stage("maven-build") {
        sh '''
            /opt/apache-maven-3.6.1/bin/mvn -Dmaven.test.failure.ignore clean package
        '''
    }
    stage("docker-build") {
        sh '''
            docker build -t ${REGISTRY}/${APP_NAME}:latest .
        '''
    }
    stage("service-deploy") {
        sh '''
            sed -i "s/REGISTRY/${REGISTRY}/g" deploy-${PROFILE}.yml
            docker stack deploy --with-registry-auth -c deploy-${PROFILE}.yml cloud-service
            docker service update --force cloud-service_${APP_NAME}
            sleep 30 && [ -z $(docker ps -a | grep -E "Exited.*cloud-service_${APP_NAME}" | awk '{ print $1; }') ] || docker ps -a | grep -E "Exited.*cloud-service_${APP_NAME}" | awk '{ print $1; }' | xargs docker rm
            [ -z $(docker images | grep none | awk '{ print $3; }') ] || docker images | grep none | awk '{ print $3; }' | xargs docker rmi
        '''
    }
}