#!/bin/bash

if [[ ${USER} == testee* ]];
then
	## we extract SCHOOLNUMBER from username testee_701036_001
	SCHOOL_NUMBER=${USER:7:6}
	if [ ! -d ${HOME}/Abgabe_$USER ];
	then
		ln -s /home/users/${SCHOOL_NUMBER}/t/${USER} ${HOME}/Abgabe_${USER}
	fi

	if [ ! -d ${HOME}/Abgabe_Vorlagen ];
	then
		ln -s /home/users/${SCHOOL_NUMBER}/t/Vorlagen/ ${HOME}/Abgabe_Vorlagen
	fi

	if [ ! -d ${HOME}/Schreibtisch/Abgabe_${USER} ];
	then
		ln -s /home/users/${SCHOOL_NUMBER}/t/${USER} ${HOME}/Schreibtisch/Abgabe_${USER}
	fi

	if [ ! -d ${HOME}/Schreibtisch/Vorlagen ];
	then
		ln -s /home/users/${SCHOOL_NUMBER}/t/Vorlagen/ ${HOME}/Schreibtisch/Vorlagen
	fi	
fi

