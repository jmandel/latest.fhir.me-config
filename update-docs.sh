#!/bin/bash
EMAILS="jmandel@gmail.com, grahame@healthintersections.com.au, e.kramer@furore.com"
DATE=$(date +"%Y-%m-%d")
NAME="Nightly Build $DATE"


prepareToBuild (){
  git reset --hard git-svn
  rm fhir-error-dump.txt
  rm -rf temp/*
}

toolsBuild (){
  prepareToBuild
  java -jar -Xmx1024m tools/bin/org.hl7.fhir.tools.jar `pwd` -name "$NAME" \
    > fhir-dump-details.txt \
    2>&1
  checkStatus
}

antBuild (){
  prepareToBuild
  ant -f tools/java/org.hl7.fhir.tools.core/build.xml cleanall Publisher \
     -Dargs=\"$(pwd) -name $NAME\" \
      > fhir-dump-details.txt \
      2>&1
  checkStatus
}

checkStatus (){
  if [ $? -eq 0 -a ! -f fhir-error-dump.txt ]
  then
    STATUS=success
  else 
    STATUS=failure
  fi
}

copyAndPublish() {
    rm -rf /home/fhir/docs
    cp -r publish /home/fhir/docs
    cd /home/fhir/docs
}

emailError() {
  echo -e "*** Changes since yesteday***\n\n" > fhir-build-msg.txt
  git log --after={1.day.ago} >> fhir-build-msg.txt
  cat fhir-error-dump.txt >> fhir-build-msg.txt
  echo -e "\n---\n\n*** Publisher Output***\n\n" >> fhir-build-msg.txt
  cat fhir-dump-details.txt >> fhir-build-msg.txt
  cat -v fhir-build-msg.txt | mailx -s "$1" "$EMAILS"
  rm fhir-build-msg.txt
}

cd /home/fhir/fhir-svn/build
git svn fetch
toolsBuild

if [ $STATUS == "failure" ]
then
  emailError "Failure building via tools.jar: latest.fhir.me" 
else
  antBuild
  if [ $STATUS == "failure" ]
  then
    emailError "Failure building via ant (tools.jar worked): latest.fhir.me" 
  else
    copyAndPublish
    echo "FHIR Build succeeded" | mailx -s "Sucess: latest.fhir.me build" "$EMAILS"
  fi
fi
