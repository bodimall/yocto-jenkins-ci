pipeline {
    agent any

    environment {
        YOCTO_DIR = "${WORKSPACE}/yocto"
        IMAGE_NAME = "core-image-minimal"  // Update to your actual image
        BUILD_DIR = "${YOCTO_DIR}/build"
    }

    options {
        timestamps()
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
                sh """
                    cd ${YOCTO_DIR}
                    source oe-init-build-env build
                """
            }
        }

        stage('Build Yocto Image') {
            steps {
                echo "🛠️  Building Yocto image: ${IMAGE_NAME}"
                sh """
                    cd ${BUILD_DIR}
                    source ../oe-init-build-env
                    bitbake ${IMAGE_NAME}
                """
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
