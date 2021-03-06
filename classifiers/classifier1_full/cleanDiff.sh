#!/bin/bash

baseDir="/vol/ek/assaff/peptalk_copy/PlacementProtocol/SVM/bound/noHoles_results/"
noncleanDir=$baseDir"SVMResultsTrain"
cleanDir=$baseDir"SVMResultsTrain.clean"
mkdir temp

for cleanPdb in $cleanDir/????.results.pdb
do

    # useful variables    
    pdbBasename=$(basename $cleanPdb)
    pdbResults=${pdbBasename%.*}
    pdbId=${pdbResults%.*}
    bindingResSource=$baseDir/BindingResidues/$pdbId.res
    noncleanPdb=$noncleanDir/$pdbBasename
    
    # temp files
    noncleanRes=1.tmp
    cleanRes=2.tmp
    removedRes=$pdbId.removed.tmp
    bindingRes=$pdbId.binding.tmp
    
    # get ca atoms from pdb files
    awk '  { if($3=="CA") print $0} '  $noncleanPdb > $noncleanRes
    awk '  { if($3=="CA") print $0} '  $cleanPdb > $cleanRes
    
    # get the ca atoms that were removed in cleaning
    diff --side-by-side --suppress-common-lines --left-column $noncleanRes $cleanRes | awk '{print $4,$6}' | sort > $removedRes
    
    # get binding residues
    sort $bindingResSource > $bindingRes
    
    #calculate how many binders were removed in cleaning
    removedBinders=`comm -1 -2 $bindingRes $removedRes | wc -l`
    #totalBinders=`wc -l $bindingRes`
    #ratio=\'$removedBinders/$totalBinders\'
    echo $pdbId $removedBinders
    # remove temp files
    #rm -f $noncleanRes $cleanRes $removedRes $bindingRes
    mv *tmp temp/
    #exit
done

