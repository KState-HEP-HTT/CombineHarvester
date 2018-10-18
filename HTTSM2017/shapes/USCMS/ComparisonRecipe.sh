#!/bin/sh 
############################################################
##   usage : source ComparisonRecipe.sh outputname title  ##
############################################################

while getopts "c:n:y:i:" OPTION
do
  case $OPTION in 
    c) 
      channel=$OPTARG
      ;;
    i)
      input=$OPTARG
      ;;
    n)
      name=$OPTARG
      ;;
    y)
      year=$OPTARG
      ;;
  esac
done

# Unrolling
python Unroll_2Drelaxed.py -s -c $channel -i $input

# now prepare to run the limits:
cd $CMSSW_BASE/src/CombineHarvester/HTTSM2017/bin
MorphingSM2017 --output_folder=$name --postfix="-2D" --control_region=0 --manual_rebin=false --real_data=false --mm_fit=false --ttbar_fit=false

# add MC stat uncertainties:                                                                                                                                   
sh _do_mc_Stat.sh  output/$name

cd output/$name
combineTool.py -M T2W -i {cmb,$channel}/* -o workspace.root --parallel 18
cp ../../../scripts/texName.json .
cp ../../../scripts/plot1DScan.py .

# Run on mjj and save outputs with name "*_title"
combine -M MultiDimFit -m 125 --algo grid --points 101 --rMin 0 --rMax 10 cmb/125/workspace.root -n nominal_$year -t -1 --expectSignal=1
combine -M MultiDimFit --algo none --rMin 0 --rMax 10 cmb/125/workspace.root -m 125 -n bestfit --saveWorkspace -t -1 --expectSignal=1
combine -M MultiDimFit --algo grid --points 101 --rMin 0 --rMax 10 -m 125 -n stat higgsCombinebestfit.MultiDimFit.mH125.root --snapshotName MultiDimFit --freezeParameters all --fastScan  -t -1 --expectSignal=1

# make plots
python ./plot1DScan.py --main higgsCombinenominal_${year}.MultiDimFit.mH125.root --POI r -o cms_output_freeze_All --others 'higgsCombinestat.MultiDimFit.mH125.root:Freeze all:2' --breakdown syst,stat

