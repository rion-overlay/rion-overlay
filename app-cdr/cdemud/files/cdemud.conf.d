# Config file for /etc/init.d/cdemu-daemon

CDEMUD_DEVICES=1
#ifndef ALSA
CDEMUD_BACKEND=null
#else
CDEMUD_BACKEND=ALSA
CDEMUD_AUDIODEV=default
#endif

