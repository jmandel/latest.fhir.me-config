cd /home/fhir

cd fhir-starter
git pull

cd ../v12/smart-on-fhir
git pull

JAVA_HOME=/usr/lib/jvm/java-7-oracle/ \
/home/fhir/grails-2.3.2/bin/grails prod war

# Restart seems to end in 'no bean named transactionManager' ...
sudo service fhir stop
sleep 1
sudo service fhir-auth start

sleep 80
sudo service fhir-auth stop
sleep 1
sudo service fhir start
