import FWCore.ParameterSet.Config as cms
from FWCore.ParameterSet.VarParsing import VarParsing

options = VarParsing('analysis')
options.parseArguments()

input_filename = "file:step3-MiniAOD-ups2s2ups1spipi.root"
ouput_filename = "MC-ups2s2ups1spipi.root"

if any(options.inputFiles):
    input_filename = options.inputFiles
if any(options.outputFile):
    ouput_filename = options.outputFile

process = cms.Process('skimming')

process.load("FWCore.MessageLogger.MessageLogger_cfi")
process.MessageLogger.cerr.FwkReport.reportEvery = 1000
process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(-1))
process.source = cms.Source("PoolSource", fileNames = cms.untracked.vstring(input_filename))
process.TFileService = cms.Service("TFileService", fileName = cms.string(ouput_filename))
process.options   = cms.untracked.PSet( wantSummary = cms.untracked.bool(False))

process.out = cms.OutputModule("PoolOutputModule",
      outputCommands = cms.untracked.vstring('drop *',
                     'keep recoVertexs_offlineSlimmedPrimaryVertices_*_*',
                     'keep *_offlineBeamSpot_*_*',
                     'keep *_TriggerResults_*_HLT',
                     'keep *_oniaPhotonCandidates_*_*',
                     'keep *_prunedGenParticles_*_*',
                     'keep *_genParticles_*_*',
                     'keep *_packedGenParticles_*_*',
                     'keep *_packedPFCandidates_*_*',
                     'keep *_slimmedPatTrigger_*_*',
                     'keep *_slimmedMuons_*_*',
                     'keep *_*_*_SIM'
      ),
      fileName = cms.untracked.string(ouput_filename)
)
process.pend = cms.EndPath(process.out)
