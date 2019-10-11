#!/bin/bash

(cd cadabra; echo "> cadabra adm ..."; build.sh)
(cd code;    echo "> compile adm ..."; build.sh)
