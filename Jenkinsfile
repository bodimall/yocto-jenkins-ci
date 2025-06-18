pipeline {
    agent any

    environment {
        YOCTO_DIR = "${WORKSPACE}/yocto"
        IMAGE_NAME = "core-image-minimal"
        BUILD_DIR = "${YOCTO_DIR}/build"
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout Source') {
            steps {
                git credentialsId: '40004859-e101-4fa0-9a5a-6e35653829f7',
                    url: 'https://github.com/bodimall/yocto-jenkins-ci.git'
            }
        }

        stage('Init Yocto Build Env') {
            steps {
                dir('yocto') {
                    sh 'source oe-init-build-env build'
                }
            }
        }

        stage('Build Yocto Image') {
            steps {
                dir('yocto/build') {
                    sh '''
                        source ../oe-init-build-env
                        bitbake ${IMAGE_NAME}
                    '''
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'yocto/build/tmp/deploy/images/**/*', allowEmptyArchive: true
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
