#!/bin/bash

function cfgChangeValue {
   sed -i 's~\('"$2"' *=*\).*~\1'"$3"'~' "$1"
}
