pipeline {
    agent {
        label 'jenkins-slave2'
    }

    parameters {

        string(name: 'VERSION', description: 'Explicit version to deploy (i.e., "v0.1"). Leave blank to build latest commit')
        
        string(name: 'TEMPLATE_FILE_NAME', defaultValue: 'dev-nginx-template.conf', description: '''Template File Name
        dev-nginx-template.conf
        butterfly-nginx-template.conf
        ''')

        string(name: 'MODIFIED_FILE_NAME', defaultValue: 'dev.conf', description: '''Template File Name
        dev.conf
        butterfly.conf''')

    
        string(name: 'SERVER_NAME', defaultValue: 'dev-cca.cloud.247-inc.net', description: '''Server Name
        dev-cca.cloud.247-inc.net
        dev-cca-247ci-butterfly.cloud.247-inc.net dev-cca-247ci-bjs.cloud.247-inc.net 247ci-bjs-dev-internal.cloud.247-inc.net 247ci-omni-dev-internal.cloud.247-inc.net
        ''')

        string(name: 'ROOT_DIRECTORY', defaultValue: '/opt/247ci-dev-dev-frontend', description: '''Root Directory
        /opt/247ci-butterfly-dev-frontend
        /opt/247ci-dev-dev-frontend
        ''')

        string(name: 'API_FORWARD_PORT', defaultValue: '80', description: '''API Forwarded-Port
        80
        ''')

        string(name: 'API_PROXY_PASS', defaultValue: 'http://127.0.0.1:9088/api/', description: '''API Proxy Pass
        http://127.0.0.1:9089/api/
        http://127.0.0.1:9088/api/
        ''')
        
        string(name: 'AUTH_FORWARD_PORT', defaultValue: '80', description: '''AUTH Forwarded-Port
        80
        ''')

        string(name: 'AUTH_PROXY_PASS', defaultValue: 'https://sso-247-inc.oktapreview.com/oauth2/aus14la6k8dMmd8pn0h8', description: '''AUTH Proxy Pass
        https://sso-247-inc.oktapreview.com/oauth2/aus14la6k8dMmd8pn0h8
        https://sso-247-inc.oktapreview.com/oauth2/aus14la6k8dMmd8pn0h8
        ''')

        string(name: 'TARGET_SERVER_DNS', defaultValue: '', description: '''Target server DNS or IP 
        20.40.49.121
        ''')

        string(name: 'TARGET_PATH', defaultValue: '', description: '''Target server path to deploy the code
        /etc/nginx/proxy-confs/
        ''')

        string(name: 'USER_NAME', defaultValue: '', description: '''Username of Target server.
        root
        ''')
    }

    // environment {
    //     TEMPLATE_FILE = "${params.TEMPLATE_FILE_NAME}"
    //     MODIFIED_FILE = "${params.MODIFIED_FILE_NAME}"
    // }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/tajuddin-sonata/nginx-template.git'
            }
        }

        stage('Generate Nginx Config') {
            steps {
                script {
                    // Read the template file
                    def template = readFile('src/' + params.TEMPLATE_FILE_NAME)
                    
                    // Replace placeholders with actual values
                    template = template.replaceAll('\\$SERVER_NAME', params.SERVER_NAME)
                                    .replaceAll('\\$ROOT_DIRECTORY', params.ROOT_DIRECTORY)
                                    .replaceAll('\\$API_FORWARD_PORT', params.API_FORWARD_PORT)
                                    .replaceAll('\\$API_PROXY_PASS', params.API_PROXY_PASS)
                                    .replaceAll('\\$AUTH_FORWARD_PORT', params.AUTH_FORWARD_PORT)
                                    .replaceAll('\\$AUTH_PROXY_PASS', params.AUTH_PROXY_PASS)

                    // Write the modified template to the destination file
                    writeFile file: "src/${params.MODIFIED_FILE_NAME}", text: template
                    
                    // Print the modified template
                    echo template
                }
            }
        }

        stage('Deploy artifacts to Nexus & Azure') {
            steps {
                script {
                    echo "Deploy artifact to Nexus & Azure !!!"
                    def ver = params.VERSION

                    sh """
                        #!/bin/bash
                
                        if [ -z "$ver" ]; then
                            artifact_version=\$(git describe --tags)
                            echo "\${artifact_version}" > src/version.txt
                            cd src
                            zip -r "../az-ci-nginx-\${artifact_version}.zip" *
                            cd $WORKSPACE
                            echo "CREATED [az-ci-nginx-\${artifact_version}.zip]"
                            curl -v -u deployment:deployment123 --upload-file \
                                "az-ci-nginx-\${artifact_version}.zip" \
                                "http://74.225.187.237:8081/repository/packages/cca/ci-config-service/az-ci-nginx-\${artifact_version}.zip"
                        else
                            artifact_version=$ver
                            echo "Downloading specified artifact version from Nexus..."
                            curl -v -u deployment:deployment123 -O "http://74.225.187.237:8081/repository/packages/cca/ci-config-service/az-ci-nginx-\${artifact_version}.zip"
                        fi
                        rm -rf "az-ci-nginx-\${artifact_version}"
                        unzip "az-ci-nginx-\${artifact_version}.zip" -d "az-ci-nginx-\${artifact_version}"

                    """
                }
            }
        }

        // stage('copy the file to server') {
        //     steps {
        //         script {
        //             echo "copying the file to the target server"
        //             sh "scp -r ${params.MODIFIED_FILE_NAME} ${params.USER_NAME}@${params.TARGET_SERVER_DNS}:${params.TARGET_PATH}"
        //         }
        //     }
        // }

    }
}