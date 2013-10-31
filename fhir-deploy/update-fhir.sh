cd /home/fhir

cd fhir-starter
git pull

cd ../smart-on-fhir
git pull

GRAILS_HOME=/home/fhir/grails-2.2.4 \
JAVA_HOME=/usr/lib/jvm/java-7-oracle/ \
/home/fhir/grails-2.2.4/bin/grails prod build-standalone --jetty
sudo service fhir restart
sudo service fhir-auth restart

