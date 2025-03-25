pipeline {
    agent any



    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/sapteshs19/Healthcare1.git'

            

            }        
        }
      stage('package '){
            steps{
                sh 'mvn package'
            }
        }
       stage('Generate Test Reports') {
           steps {
               publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/Healthcare1/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                    }
            }
       stage('Docker Build & Push') {
            steps {
                script {
                    sh 'docker build -t sapteshs19/healthcare:latest .'
                    sh 'docker login -u sapteshs19 -p Iamsaptesh@123'
                    sh 'docker push sapteshs19/healthcare:latest'
                }
            }
        }
       stage('Config & Deployment') {
            steps {
                
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS-ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('terraform-files') {
                    sh 'sudo chmod 600 new.pem'
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
}
    }
}
}
}
}
