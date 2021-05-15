#!/bin/bash

if [[ $USER == testee* ]];
then
	if [ ! -d $HOME/Abgabe_$USER ];
	then
		ln -s /home/shares/schueler/Testees/Abgabe_$USER $HOME/Abgabe_$USER
	fi

	if [ ! -d $HOME/Abgabe_Vorlagen ];
	then
		ln -s /home/shares/schueler/Testees/Vorlagen/ $HOME/Abgabe_Vorlagen
	fi

	if [ ! -d $HOME/Schreibtisch/Abgabe_$USER ];
	then
		ln -s /home/shares/schueler/Testees/Abgabe_$USER $HOME/Schreibtisch/Abgabe_$USER
	fi

	if [ ! -d $HOME/Schreibtisch/Vorlagen ];
	then
		ln -s /home/shares/schueler/Testees/Vorlagen/ $HOME/Schreibtisch/Vorlagen
	fi	
fi

