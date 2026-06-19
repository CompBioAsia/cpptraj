#!/bin/bash
export PATH=/data/tools/ambertools25/bin:$PATH
offset=1
ref=../abl_ligand.inpcrd
prmtop=../abl_ligand.prmtop

# Clean start
rm -f rmsd.cpptraj

# Write cpptraj input
{
  echo "parm $prmtop"
  echo "trajin ../abl_lig.nc 1 last $offset"
  echo "reference $ref parm $prmtop [$ref]"
  echo "autoimage"
  echo "rms @CA ref [$ref] out $ref-rmsd-pre.csv mass"
  echo "rms :265 ref [$ref] out $ref-rmsd-ligpre.csv mass nofit"
  echo "go"
  echo "quit"
} >> rmsd.cpptraj

# Run cpptraj
cpptraj -i rmsd.cpptraj
# add actual commas to the .csv file so the frame number and rmsd are in seperate columns in excel

sed 's/^ *//; s/ \+/,/g' $ref-rmsd-pre.csv > ablrmsd.csv
rm $ref-rmsd-pre.csv

sed 's/^ *//; s/ \+/,/g' $ref-rmsd-ligpre.csv > ligrmsd.csv
rm $ref-rmsd-ligpre.csv
