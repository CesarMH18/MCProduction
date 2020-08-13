# MCProduction

Steps to generate Private MC samples

* Create fragment for the desired decay

You can download fragment examples from https://cms-pdmv.cern.ch/mcm

In this tutorial we are using [#Ups(2S)\to#Ups(1S)#pi#pi](py8_Ups\(2S\)2Ups\(1S\)pipi_EvtGen_TuneCP5_13TeV_cfi.py) as fragment.

* Edit and run the prepare script. (Remember signing in to the GRID in order to find the pileup files in DAS)

* You should have


* Finally send the job using crab-GEN-MiniAOD_cfg.py

  check that outputFiles match to the files generated by the script
