#!/bin/bash

export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_20_UL/src ] ; then
  echo release CMSSW_10_2_20_UL already exists
else
  scram p CMSSW_10_2_20_UL
fi
cd CMSSW_10_2_20_UL/src
eval `scram runtime -sh`

pyfile="py8_Ups(2S)2Ups(1S)pipi_EvtGen_TuneCP5_13TeV_cfi.py"

curl -s --insecure https://raw.githubusercontent.com/CesarMH18/MCProduction/master/$pyfile --retry 2 --create-dirs -o Configuration/GenProduction/python/$pyfile

scram b
cd ../../

cmsDriver.py Configuration/GenProduction/python/$pyfile --fileout file:step0-GS-ups2s2ups1spipi.root --mc --eventcontent RAWSIM --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN,SIM --nThreads 1 --geometry DB:Extended --era Run2_2018 --customise Configuration/DataProcessing/Utils.addMonitoring --python_filename step0-GS-ups2s2ups1spipi_cfg.py --no_exec -n 1000;
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper \nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" step0-GS-ups2s2ups1spipi_cfg.py


export SCRAM_ARCH=slc7_amd64_gcc700
if [ -r CMSSW_10_2_20_UL/src ] ; then
  echo release CMSSW_10_2_20_UL already exists
else
  scram p CMSSW CMSSW_10_2_20_UL
fi
cd CMSSW_10_2_20_UL/src
eval `scram runtime -sh`

scram b
cd ../../

cmsDriver.py step1 --filein file:step0-GS-ups2s2ups1spipi.root  --fileout file:step1-DR-ups2s2ups1spipi.root --pileup_input "dbs:/Neutrino_E-10_gun/RunIISummer17PrePremix-PUAutumn18_102X_upgrade2018_realistic_v15-v1/GEN-SIM-DIGI-RAW" --mc --eventcontent PREMIXRAW --datatier GEN-SIM-RAW --conditions 102X_upgrade2018_realistic_v15 --step DIGI,DATAMIX,L1,DIGI2RAW,HLT:@relval2018 --procModifiers premix_stage2 --nThreads 1 --geometry DB:Extended --datamix PreMix --era Run2_2018 --python_filename step1-DR-ups2s2ups1spipi_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n -1;
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper\nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate() " step1-DR-ups2s2ups1spipi_cfg.py

cmsDriver.py step2 --filein file:step1-DR-ups2s2ups1spipi.root --fileout file:step2-DR-ups2s2ups1spipi.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 102X_upgrade2018_realistic_v15 --step RAW2DIGI,L1Reco,RECO,RECOSIM,EI --procModifiers premix_stage2 --nThreads 1 --era Run2_2018 --python_filename step2-DR-ups2s2ups1spipi_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n -1 ;
sed -i "20 a from IOMC.RandomEngine.RandomServiceHelper import RandomNumberServiceHelper\nrandSvc = RandomNumberServiceHelper(process.RandomNumberGeneratorService)\nrandSvc.populate()" step2-DR-ups2s2ups1spipi_cfg.py


export SCRAM_ARCH=slc7_amd64_gcc700
if [ -r CMSSW_10_2_20_UL/src ] ; then
  echo release CMSSW_10_2_20_UL already exists
else
  scram p CMSSW_10_2_20_UL
fi
cd CMSSW_10_2_20_UL/src
eval `scram runtime -sh`

scram b
cd ../../

cmsDriver.py step1 --filein file:step2-DR-ups2s2ups1spipi.root --fileout file:step3-MiniAOD-ups2s2ups1spipi.root --mc --eventcontent MINIAODSIM --runUnscheduled --datatier MINIAODSIM --conditions 102X_upgrade2018_realistic_v15 --step PAT --nThreads 1 --geometry DB:Extended --era Run2_2018 --python_filename step3-MiniAOD-ups2s2ups1spipi_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n -1;
