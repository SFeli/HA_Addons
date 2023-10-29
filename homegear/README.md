# Home Assistant Add-on: Homegear by SFeli

_in Work - not running well - please no issues I'm still work on it !! - Add-on to MAX-Thermostate._

![Supports amd64 Architecture][amd64-shield]
![Supports i386 Architecture][i386-shield]

[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg

_Home Assistant / HASSIO - Add-On für Homegear mit dem einzigen Modul MAX! (Heizkörperthermostat)_

_build.yaml .. ist eine Vorbelegung für das Dockerfile im Bezug auf das zugrundliegende Linux-System 
        in diesem Fall wird das Debian-Linux Bullseye (11.8) genutzt._
_Dockerfile .. in dieser Datei werden alle Informationen (u.a. auch von der Vorbelegung im build.yaml) 
        zusammengestellt und mit weiteren Schritten ergänzt, damit ein Docker-Image generiert werden kann.
        Da dieses Docker-Image als Hassio-Add-On laufen soll ist das S6-Overlay ebenfalls enthalten.
        Das S6-Overlay managed die Prozesse übergreifend für die HassIO-Installation._
_Config.yaml .. diese Datei ist speziell für Hassio erstellt und dient zur Einbindung in die HACS-Umwelt.
        So wird das Add-On erst bei einem fehlerfreien Config.yaml angezeigt._
