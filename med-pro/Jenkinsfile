pipeline {
  agent any

  tools {
    maven 'M2_HOME'
    terraform 'terraform'
    }
  
  stages {
    stage('CheckOut') {
      steps {
        echo 'Checkout the source code from GitHub'
        git 'https://github.com/kranthi619/med-pro.git'
            }
    }
    
    stage('Package the Application') {
      steps {
        echo " Packaing the Application"
        sh 'mvn clean package'
            }
    }
    
    stage('Publish Reports using HTML') {
      steps {
      publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/med-pro/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true]) 
         }
       }

     stage('Docker Image Creation') {
       steps {
         sh 'docker build -t kranthi619/med-pro .'
             }
       } 
      stage('Docker Login') {
       steps {
         withCredentials([usernamePassword(credentialsId: 'Docker-Hub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {         
         sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
   }  
             }
         }

     stage('Push Image to DockerHub') {
       steps {
         sh 'docker push kranthi619/med-pro'
            }
        }
    
    stage('Create infrastructure') {
      steps {
        dir('med-pro') {
        sh 'sudo chmod 600 exampl.pem'
        sh 'terraform init'
        sh 'terraform validate'
        sh 'terraform apply --auto-approve'
          
        }
      }
    }
  }
}
