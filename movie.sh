#!/bin/bash
export PATH=/data/tools/ambertools25/bin:$PATH
prmtop="../abl_ligand.prmtop"
ref="../step9.rst7"
name="abl_lig" #name of trajectory file (.nc file)
res="1-265"          #number of residues in system

#Remove old files
rm -f cpptraj-movie.sh $name-movie.cpptraj

#Create cpptraj input file
cat > "$name-movie.cpptraj" <<EOF
parm $prmtop
reference $ref
trajin ../$name.nc

autoimage #centers and images the trajectory
rms Autofit :$res@CA reference mass #calculate a mass weighted, RMS fit to the 1st structure

strip :WAT
strip :Na+

trajout ${name}-movie.nc
trajout trajectory.pdb pdb onlyframes 1

go
quit
EOF

#Create shell script to run cpptraj
cat > cpptraj-movie.sh <<EOF
#!/bin/bash
cpptraj -i $name-movie.cpptraj
EOF

chmod +x cpptraj-movie.sh
./cpptraj-movie.sh

exit 0
