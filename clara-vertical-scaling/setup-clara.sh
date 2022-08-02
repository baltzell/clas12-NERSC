#!/usr/bin/env bash
unset CLASSPATH
unset JAVA_HOME

cd myClara
export CLARA_HOME=`pwd`
cd -
cd user_data
export CLARA_USER_DATA=`pwd`
cd -

export CCDB_CONNECTION=sqlite:///$CLARA_USER_DATA/data/ccdb_2022-01-09.sqlite
export RCDB_CONNECTION=sqlite:///$CLARA_USER_DATA/data/ccdb_2022-01-09.sqlite
export CLAS12DIR=$CLARA_HOME/plugins/clas12

export JAVA_TOOL_OPTIONS="-XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler"
