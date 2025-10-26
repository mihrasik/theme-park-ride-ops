multipass launch -c 2 -d 20G -m 8G -n park-project

# change /home/dm/dst/project/theme-park-ride-ops to your local path
multipass mount /home/dm/dst/project/theme-park-ride-ops park-project:/home/ubuntu/project/theme-park-ride-ops

multipass shell park-project

multipass stop park-project
multipass start park-project
