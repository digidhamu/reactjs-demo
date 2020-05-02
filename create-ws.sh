###############################################################################
# This script should be in the Jenkins configuration to initial the pull
# Normally, git-fetch job
# Once pulled, other script start use this script
###############################################################################
find . -mindepth 1 -exec rm -rf -- {} + 2>/dev/null
git init
git remote add origin git@github.com:digidhamu/reactjs-demo.git
git fetch origin
git checkout -b test-pr1 origin/test-pr1
###############################################################################
