pipeline {
    agent any

    environment {
        YOCTO_DIR = "${WORKSPACE}/yocto"
        IMAGE_NAME = "core-image-minimal"  // Change to your image (e.g. conga-q430-dev-image)
        BUILD_DIR = "${YOCTO_DIR}/build"
    }

    options {
        timestamps() // ✅ Keep this valid option
    }

    stages {
        stage('Preparation') {
            steps {
                echo "✅ Cloning done by Jenkins. Showing contents..."
                sh 'ls -la'
            }
        }

        stage('Init Yocto Build Env') {
            steps {
                echo "📦 Setting up Yocto environment..."
                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                    sh """
                        cd ${YOCTO_DIR}
                        source oe-init-build-env build
                    """
                }
            }
        }

        stage('Build Yocto Image') {
            steps {
                echo "🛠️  Building Yocto image: ${IMAGE_NAME}"
                wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
                    sh """
                        cd ${BUILD_DIR}
                        source ../oe-init-build-env
                        bitbake ${IMAGE_NAME}
                    """
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo "📁 Archiving build outputs..."
                archiveArtifacts artifacts: '**/tmp/deploy/images/**/*', allowEmptyArchive: true
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
