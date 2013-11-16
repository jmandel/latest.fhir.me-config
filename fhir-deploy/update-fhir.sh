cd /home/fhir

cd fhir-starter
git pull

cd ../v12/smart-on-fhir
git pull

JAVA_HOME=/usr/lib/jvm/java-7-oracle/ \
/home/fhir/grails-2.3.2/bin/grails prod war
sudo service fhir restart
sudo service fhir-auth restart
