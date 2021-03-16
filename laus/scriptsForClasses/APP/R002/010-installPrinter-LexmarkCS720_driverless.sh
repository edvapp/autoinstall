#!/bin/bash

### USAGE:
## installs printer ${PRINTER_NAME}
## with driver ${PRINTER_DRIVER}
## and ${PRINTER_LOCATION}
## and ${PRINTER_CONNECTION}
##
## AND should be named after printer modell 
## example: installPrinter_Brother_HL-7050.sh
##
## BECAUSE, enables installation of new printer with new name
## without problems

#### START DEFINE PARAMETER

PRINTER_NAME="Raum-002-Printer"
PRINTER_LOCATION="Drucker im Raum 002"
# ATTENTION: r002pr01:443 because r002pr01:631 will not work 
PRINTER_CONNECTION="ipps://r002pr01:443/ipp/print"
# PRINTER_CONNECTION="ipp://r002pr01:631/ipp/print" works

## HELP to find printer modell:
## Find Print Driver with:
## >> lpinfo --make-and-model 'Lexmark' -m

# ATTENTION: r002pr01:443 
PRINTER_DRIVER="driverless:ipp://r002pr01:443/ipp/print"

#### END DEFINE PARAMETER


## check if printer ${PRINTER_NAME} already installed
## remove, if already installed, and enable installation of new one
if [ "$(lpstat -v | grep ${PRINTER_NAME})" != "" ];
then
	lpadmin -x ${PRINTER_NAME}
fi


## Options in lpadmin declared:
# -E		Enables the destination and accepts jobs
# -p		Specifies a PostScript Printer Description file to use with the printer.
# -v		device-uri
# -m		Sets a standard System V interface script or PPD file for the printer from the model directory or using one of the driver interfaces
# -L		Provides a textual location of the destination.

#	Note the two -E options. The first one (before -p) forces encryption when connecting to the server. The last one enables the destination and starts accepting jobs.

lpadmin -E -p "${PRINTER_NAME}" -v "${PRINTER_CONNECTION}" -m "${PRINTER_DRIVER}" -L "${PRINTER_LOCATION}" -E

# set as Default Printer
lpadmin -d ${PRINTER_NAME} 


