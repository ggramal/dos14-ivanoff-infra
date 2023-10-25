pipeline {
  agent any
  stage('Lint') {
    when {
      anyOf {
        branch pattern:"feature-*"
        branch pattern: "fix-*"
      }
    }
    agent {
      docker {
        image 'python:3.11.3-buster'
        args '-u 0'
        }
      }
      steps {
        sh 'pip poetry install'
        sh 'poetry install --with dev'
        sh 'poetry run --black --check *.py **/*.py'
      }
    }
    stage('Build') {
      when {
        branch "master"
        }
      steps {
        script {
          def image = docker.build "esergiusz/dos14-authz:${env.GIT_COMMIT}"
          docker.withRegistry('','dockerhub-esa') {
            image.push()
          }
        }
      }
    }
  }
}