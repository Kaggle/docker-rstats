String cron_string = BRANCH_NAME == "main" ? "H 12 * * 1,3" : ""

pipeline {
  agent { label 'ephemeral-linux' }
  options {
    // The Build GPU stage depends on the image from the Push CPU stage
    disableConcurrentBuilds()
  }
  triggers {
    cron(cron_string)
  }
  environment {
    GIT_COMMIT_SHORT = sh(returnStdout: true, script:"git rev-parse --short=7 HEAD").trim()
    GIT_COMMIT_SUBJECT = sh(returnStdout: true, script:"git log --format=%s -n 1 HEAD").trim()
    GIT_COMMIT_AUTHOR = sh(returnStdout: true, script:"git log --format='%an' -n 1 HEAD").trim()
    GIT_COMMIT_SUMMARY = "`<https://github.com/Kaggle/docker-rstats/commit/${GIT_COMMIT}|${GIT_COMMIT_SHORT}>` ${GIT_COMMIT_SUBJECT} - ${GIT_COMMIT_AUTHOR}"
    MATTERMOST_CHANNEL = sh(returnStdout: true, script: "if [[ \"${GIT_BRANCH}\" == \"main\" ]]; then echo \"#kernelops\"; else echo \"#builds\"; fi").trim()
    // See b/152450512
    GITHUB_PAT = credentials('github-pat')
    PRETEST_TAG = sh(returnStdout: true, script: "if [[ \"${GIT_BRANCH}\" == \"main\" ]]; then echo \"ci-pretest\"; else echo \"${GIT_BRANCH}-pretest\"; fi").trim()
    STAGING_TAG = sh(returnStdout: true, script: "if [[ \"${GIT_BRANCH}\" == \"main\" ]]; then echo \"staging\"; else echo \"${GIT_BRANCH}-staging\"; fi").trim()
  }

  stages {
    stage('Docker CPU Build') {
      steps {
        sh '''#!/bin/bash
          set -exo pipefail

          ./build | ts
          date
          ./push ${PRETEST_TAG}
        '''
      }
    }

    stage('Test CPU Image') {
      steps {
        sh '''#!/bin/bash
          set -exo pipefail

          date
          ./test --image gcr.io/kaggle-images/rstats:${PRETEST_TAG}
        '''
      }
    }

    stage('Docker GPU Build') {
      agent { label 'ephemeral-linux-gpu' }
      steps {
        sh '''#!/bin/bash
          set -exo pipefail
          # Remove images (dangling or not) created more than 120h (5 days ago) to prevent disk from filling up.
          docker image prune --all --force --filter "until=120h" --filter "label=kaggle-lang=r"
          # Remove any dangling images (no tags).
          # All builds for the same branch uses the same tag. This means a subsequent build for the same branch
          # will untag the previously built image which is safe to do. Builds for a single branch are performed
          # serially.
          docker image prune -f
          ./build --gpu --base-image-tag ${PRETEST_TAG} | ts
          date
          ./push --gpu ${PRETEST_TAG}
        '''
      }
    }

    stage('Test GPU Image') {
      agent { label 'ephemeral-linux-gpu' }
      steps {
        sh '''#!/bin/bash
          set -exo pipefail
          date
          ./test --gpu --image gcr.io/kaggle-private-byod/rstats:${PRETEST_TAG}
        '''
      }
    }

    stage('Package Versions') {
      parallel {
        stage('CPU Diff') {
          steps {
            sh '''#!/bin/bash
            set -exo pipefail

            docker pull gcr.io/kaggle-images/rstats:${PRETEST_TAG}
            ./diff --target gcr.io/kaggle-images/rstats:${PRETEST_TAG}
          '''
          }
        }
        stage('GPU Diff') {
          agent { label 'ephemeral-linux-gpu' }
          steps {
            sh '''#!/bin/bash
            set -exo pipefail
            
            docker pull gcr.io/kaggle-private-byod/rstats:${PRETEST_TAG}
            ./diff --gpu --target gcr.io/kaggle-private-byod/rstats:${PRETEST_TAG}
          '''
          }
        }
      }
    }

    stage('Label CPU/GPU Staging Images') {
      steps {
        sh '''#!/bin/bash
          set -exo pipefail

          gcloud container images add-tag gcr.io/kaggle-images/rstats:${PRETEST_TAG} gcr.io/kaggle-images/rstats:${STAGING_TAG}
          gcloud container images add-tag gcr.io/kaggle-private-byod/rstats:${PRETEST_TAG} gcr.io/kaggle-private-byod/rstats:${STAGING_TAG}
        '''
      }
    }
  }

  post {
    failure {
      mattermostSend color: 'danger', message: "*<${env.BUILD_URL}console|${JOB_NAME} failed>* ${GIT_COMMIT_SUMMARY} @kernels-backend-ops", channel: env.MATTERMOST_CHANNEL
    }
    success {
      mattermostSend color: 'good', message: "*<${env.BUILD_URL}console|${JOB_NAME} passed>* ${GIT_COMMIT_SUMMARY}", channel: env.MATTERMOST_CHANNEL
    }
    aborted {
      mattermostSend color: 'warning', message: "*<${env.BUILD_URL}console|${JOB_NAME} aborted>* ${GIT_COMMIT_SUMMARY}", channel: env.MATTERMOST_CHANNEL
    }
  }
}
