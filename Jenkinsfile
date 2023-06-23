#!groovy
pipeline {
  agent any
  tools {
    terraform 'terraform-v1.1.XXX'
  }
  parameters {
    booleanParam defaultValue: false, description: 'Click to create infra from terraform', name: 'create_infra'
  }
  stages {
    stage('Terraform deploy or destroy') {
      environment {
        //Variables in stage TF_VAR_XXXXXX = "${VAR}"
      }
      steps {
        script {
          tf_exec()
        }
      }
    }
  }

  post {
    always {
      echo 'Clean WS'
      cleanWs()
      }
      success {
        echo 'Finalized'
      }
      unstable {
        echo 'something wrong'
      }
      failure {
        echo 'Pipeline failure.'
      }
      aborted {
        echo 'aborted'
      }
    }
  }


def tf_exec() {
    withCredentials([[
        $class: 'AmazonWebServicesCredentialsBinding',
        credentialsId: "credentials-id-here",
        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) {
        // Terraform
  sh 'terraform init  -no-color'
  if (params.crea_cluster == true) {
    sh 'terraform plan -no-color -var-file=main.tfvars -out plan.out'
    def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
  }
  if (params.crea_cluster == false) {
    sh 'terraform plan  -no-color -destroy -var-file=main.tfvars -out plan.out'
   }
  sh 'terraform apply -no-color -input=false plan.out'
  }
}
