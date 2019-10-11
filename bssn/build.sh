#!/bin/bash

(cd cadabra; echo "> cadabra bssn ..."; build.sh)
(cd code;    echo "> compile bssn ..."; build.sh)
