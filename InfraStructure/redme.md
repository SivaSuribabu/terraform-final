mvn clean package

mkdir deploy_bundle
cp target/ROOT.war deploy_bundle/

# Copy .platform folder
cp -r .platform deploy_bundle/

cd deploy_bundle
zip -r app-bundle.zip .


