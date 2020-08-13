# MCProduction

Steps to generate Private MC samples

* Create fragment for the desired decay

You can download fragment examples from https://cms-pdmv.cern.ch/mcm

In this tutorial we are using [ups2s2ups1spipi](py8_Ups\(2S\)2Ups\(1S\)pipi_EvtGen_TuneCP5_13TeV_cfi.py) as fragment.

* Edit and run the [prepare script](prepare-ups2s2ups1spipi-2018.sh). (Remember signing in to the GRID in order to find the pileup files in DAS)

* You should have produced several python config files for all the steps

* Test locally using [the script](MCcrabJobScript.sh)

* Finally send the job using [crab config file](crab-GEN-MiniAOD_cfg.py)
