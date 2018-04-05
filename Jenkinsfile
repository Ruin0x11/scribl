node {
    def app
        stage('Clone repository') {
            checkout scm
        }

    stage('Build image') {
        app = docker.build("scribl:${env.BUILD_NUMBER}")
    }

    stage('Test image') {
        app.inside {
            sh 'rake test'
        }
    }

    stage('Push image') {
        docker.withRegistry("http://localhost:5000") {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}
