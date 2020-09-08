#! /bin/bash

#apt-get -y update

# quiet installation
export DEBIAN_FRONTEND=noninteractive


## MuseScore: Classical music notationprogramm:
## mixxx: DJ - mixing software
## Adour: Audio & MIDI sequencer
## Hydrogen: Drum machine
## Rosegarden: MIDI - sequencer
## Qtractor: Audio & MIDI sequencer
## LMMS: Audio & MIDI sequencer
## Qsyth amSynth: Synthsizer
## jack: jack daemon, jack - gui, jack - keyboard
## a2jmidid: alsa to jack MIDI daemon
## VMPK: virtual keyboard
## calf-plugins: music studio effects and instruments
## sooperlooper: music loop station
apt-get -y install musescore3 audacity adour hydrogen rosegarden qtractor lmms qsyth amsynth jackd qjackctl jack-keyboard a2jmidid vmpk calf-plugins sooperlooper

## Multimedia-Codecs
apt-get -y install libmp3lame0 libk3b6 libk3b6-extracodecs
apt-get -y install libavcodec-extra libavcodec-ffmpeg-extra56
apt-get -y install libxine2 libxine2-ffmpeg
