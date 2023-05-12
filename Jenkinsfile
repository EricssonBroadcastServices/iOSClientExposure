
import groovy.json.JsonSlurperClassic
import groovy.json.JsonSlurper
import java.time.LocalDateTime

env.PATH = '/usr/bin/:/Users/empiosdev/.fastlane/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin'

node("Players iMac") {
    try {
        stage ('Clean up Directory 🗑️') {
            // clean up our workspace
            deleteDir()
            // clean up tmp directory
            dir("${workspace}@tmp") {
                deleteDir()
            }
        }

        stage('Checkout 🛒') {
            checkout scm

            currentBuild.description = " iOSClientExposure - ${currentBuild.startTimeInMillis}"
            echo "Git checkout of iOSClientExposure was success 🎉"
        }

        stage('Build Xcode project 🛠️') {

            echo "Start building the iOS schema 🛠️"
            def workspace = pwd()

            sh """
                #!/bin/bash
                cd ${workspace}
                fastlane ios build_xcode_project
            """ 

            echo "Xcode project built successfully 🎉"
        }

        stage('Run Unit Tests 🧪') {

            echo "Start runing tests🧪"

            sh """
                #!/bin/bash
                cd ${workspace}
                fastlane ios run_spm_tests workspace:${workspace} slackUrl:${SLACK_URL}
            """ 

            echo "Unit Tests were successfully completed 🎉"
        }

        stage(' Validate Pods 🚁') {

            echo "Start validating pods 🚗"

            def workspace = pwd()

            sh """
                #!/bin/bash
                cd ${workspace}
                fastlane ios validate_pod
            """ 

            echo "Pod validation success 🎉"
        }

    } catch(e) {
        echo "Showing error::::::::::::"
        echo "Error has occured ${e}"
            throw e
    }

}

