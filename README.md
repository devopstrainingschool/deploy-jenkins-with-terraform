TO add the worker to the jenkins master
cat the anael.pem
and then go the manage jenkins, credentials
select  username with private key and put the key you copied under directly put the key.
# Check the pictures in this repo

# at the node, 
make sure it is direct ssh not docker
make sure not verified
if the is an error about not be able to create home directory then ssh to the slave and create it. # it will fix the issue for now.
