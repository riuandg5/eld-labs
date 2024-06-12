#!/bin/bash

project_name=$1

mkdir $project_name
mkdir $project_name/srcs
mkdir $project_name/simsrcs
mkdir $project_name/ip
mkdir $project_name/constrs
mkdir $project_name/ss
mkdir $project_name/build

touch $project_name/build_project.tcl

touch $project_name/README.md
echo "# $project_name" >> $project_name/README.md

touch $project_name/.gitignore
echo "ip/*/*" >> $project_name/.gitignore
echo "!ip/*/*.xci" >> $project_name/.gitignore
echo "build" >> $project_name/.gitignore
echo ".Xil" >> $project_name/.gitignore
echo "*.jou" >> $project_name/.gitignore
echo "*.log" >> $project_name/.gitignore
echo "*.str" >> $project_name/.gitignore