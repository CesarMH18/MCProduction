from CRABClient.UserUtilities import config
import datetime
import time

config = config()

ts = time.time()
st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M')

channel = 'ups2s2ups1spipi'
year = '2018'
step = 'PrivateMC-'+year
nEvents = 1000
NJOBS = 1
myrun = 'step0-GS-ups2s2ups1spipi_cfg.py'
myname = step+'-'+channel

config.General.requestName = step+'-'+channel+'-'+st
config.General.transferOutputs = True
config.General.transferLogs = False
config.General.workArea = 'crab_'+step+'-'+channel

config.JobType.pluginName = 'PrivateMC'
config.JobType.psetName = myrun
config.JobType.inputFiles = ['step1-DR-ups2s2ups1spipi_cfg.py',
                             'step2-DR-ups2s2ups1spipi_cfg.py',
                             'step3-MiniAOD-ups2s2ups1spipi_cfg.py',
                             'Skimming_MC_cfg.py']
config.JobType.disableAutomaticOutputCollection = True
config.JobType.eventsPerLumi = 10000
config.JobType.numCores = 1
config.JobType.maxMemoryMB = 3300
config.JobType.scriptExe = 'MCcrabJobScript.sh'
config.JobType.scriptArgs = ['CHANNEL_DECAY='+channel,'YEAR='+year]
config.JobType.outputFiles = ['MC-'+year+'-'+channel+'.root']
config.Data.outputPrimaryDataset = myname
config.Data.splitting = 'EventBased'
config.Data.unitsPerJob = nEvents
config.Data.totalUnits = config.Data.unitsPerJob * NJOBS
config.Data.outLFNDirBase = '/store/user/cmondrag/'
config.Data.publication = False

config.Site.storageSite = 'T2_IT_Bari'
