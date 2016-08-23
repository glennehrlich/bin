#!/bin/bash

# This script runs the java interpreter, but if any specified jar
# files are found, it will prevent that jar from displaying a splash
# banner or showing in the dock. This is mainly for command line apps
# that should not be doing anything to the gui or desktop.
#
# Jars that get the special handling are specified in the
# NO_GUI_JARS variable.

NO_GUI_JARS=(\
  plantuml.jar \
)

# Build the grep command line.
GREP_PATTERNS=""
for jar in ${NO_GUI_JARS[*]}; do
    GREP_PATTERNS="-e $jar $GREP_PATTERNS"
done

# Run java.
if grep -q $GREP_PATTERNS <<< $@; then
    cmd="/usr/bin/java -Djava.awt.headless=true -splash:no $@"
else
    cmd="/usr/bin/java $@"
fi

$cmd
