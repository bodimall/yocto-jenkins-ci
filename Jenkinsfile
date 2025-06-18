pipeline {
    agent any

    environment {
        IMAGE_NAME = "core-image-minimal"
    }

    stages {
        stage('Checkout CI/CD Repo') {
            steps {
                git credentialsId: '40004859-e101-4fa0-9a5a-6e35653829f7',
                    url: 'https://github.com/bodimall/yocto-jenkins-ci.git'
            }
        }

        stage('Clone Yocto Project') {
            steps {
                sh '''
                    git clone https://github.com/my-org/my-yocto-project.git
                    cd my-yocto-project
                    . oe-init-build-env build
                '''
            }
        }

        stage('Build Yocto Image') {
            steps {
                sh '''
                    cd my-yocto-project/build
                    bitbake core-image-minimal
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 Build completed successfully!'
        }
        failure {
            echo '❌ Build failed. Please check logs.'
        }
    }
}
