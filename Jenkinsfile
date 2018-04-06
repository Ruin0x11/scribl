node {
    def app
        stage('Clone repository') {
            checkout scm
        }

    stage('Build image') {
        docker.withRegistry("localhost:5000") {
            app = docker.build("scribl:${env.BUILD_NUMBER}")
        }
    }

    stage('Test image') {
        app.inside {
            sh 'rake test'
        }
    }

    //  stage('Push image') {
    //      docker.withRegistry("localhost:5000") {
    //          app.push("${env.BUILD_NUMBER}")
    //          app.push("latest")
    //      }
    //  }
}
