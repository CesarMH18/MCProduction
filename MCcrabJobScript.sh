#!/bin/bash

#If not arguments were passed to the script the set default values
if [[ $# -eq 0 ]] ; then
  CHANNEL_DECAY="ups2s2ups1spipi"
  YEAR="2018"
else
  for i in "$@"
  do
    case $i in
      #When arguments were passed by crab job, parse them
      CHANNEL_DECAY=*)
      CHANNEL_DECAY="${i#CHANNEL*=}"
      ;;
      YEAR=*)
      YEAR="${i#YEAR*=}"
      ;;
    esac
  done
fi


if [ "$YEAR" == "2016" ] ; then
  GEN_REL="CMSSW_7_1_43_patch1"
  GEN_SCRAM="slc6_amd64_gcc481"
  RECO_REL="CMSSW_8_0_33"
  RECO_SCRAM="slc6_amd64_gcc530"
  MINI_REL="CMSSW_9_4_15"
  MINI_SCRAM="slc6_amd64_gcc630"
elif [ "$YEAR" == "2017" ] ; then
  GEN_REL="CMSSW_9_3_16"
  GEN_SCRAM="slc6_amd64_gcc630"
  RECO_REL="CMSSW_9_4_15"
  RECO_SCRAM="slc6_amd64_gcc630"
  MINI_REL="CMSSW_9_4_15"
  MINI_SCRAM="slc6_amd64_gcc630"
elif [ "$YEAR" == "2018" ] ; then
  GEN_REL="CMSSW_10_2_20_UL"
  GEN_SCRAM="slc7_amd64_gcc700"
  RECO_REL="CMSSW_10_2_20_UL"
  RECO_SCRAM="slc7_amd64_gcc700"
  MINI_REL="CMSSW_10_2_20_UL"
  MINI_SCRAM="slc7_amd64_gcc700"
fi


echo "================= cmssw environment prepration Gen step ===================="
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=$GEN_SCRAM
if [ -r $GEN_REL/src ] ; then
  echo release $GEN_REL already exists
else
  scram p CMSSW $GEN_REL
fi
cd $GEN_REL/src
eval `scram runtime -sh`
scram b
cd ../../

echo "================= PB: CMSRUN starting Gen step ===================="
# PSet is the name that crab assigns to the config file of the job
cmsRun -j FrameworkJobReport.xml  -p PSet.py
#cmsRun -j ${CHANNEL_DECAY}_step0.log -p step0-GS-${CHANNEL_DECAY}_cfg.py


echo "================= cmssw environment prepration Reco step ===================="
export SCRAM_ARCH=$RECO_SCRAM
if [ -r $RECO_REL/src ] ; then
  echo release $RECO_REL already exists
else
  scram p CMSSW $RECO_REL
fi
cd $RECO_REL/src
eval `scram runtime -sh`
scram b
cd ../../

echo "================= PB: CMSRUN starting Reco step ===================="
cmsRun -e -j ${CHANNEL_DECAY}_step1.log step1-DR-${CHANNEL_DECAY}_cfg.py
#cleaning
#rm -rfv step0-GS-${CHANNEL_DECAY}.root

echo "================= PB: CMSRUN starting Reco step 2 ===================="
cmsRun -e -j ${CHANNEL_DECAY}_step2.log  step2-DR-${CHANNEL_DECAY}_cfg.py
#cleaning
#rm -rfv step1-DR-${CHANNEL_DECAY}.root


echo "================= cmssw environment prepration MiniAOD format ===================="
export SCRAM_ARCH=$MINI_SCRAM
if [ -r $MINI_REL/src ] ; then
  echo release $MINI_REL already exists
else
  scram p $MINI_REL
fi

cd $MINI_REL/src
eval `scram runtime -sh`
#scram b distclean && scram b vclean && scram b clean
scram b
cd ../../

echo "================= PB: CMSRUN starting step 3 ===================="
cmsRun -e -j ${CHANNEL_DECAY}_step3.log  step3-MiniAOD-${CHANNEL_DECAY}_cfg.py
#cleaning
#rm -rfv step2-DR-${CHANNEL_DECAY}.root

echo "================= PB: CMSRUN starting Skimming ===================="
cmsRun -e -j ${CHANNEL_DECAY}_skimming.log Skimming_MC_cfg.py inputFiles=file:step3-MiniAOD-${CHANNEL_DECAY}.root outputFile=MC-${YEAR}-${CHANNEL_DECAY}.root
#cleaning
#rm -rfv step3-MiniAOD-${CHANNEL_DECAY}.root
