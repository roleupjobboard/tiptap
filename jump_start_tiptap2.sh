#!/usr/bin/env bash
# Jump_start script helps to switch between projects faster
# jump_start.sh is the top level script file in which are injected other
# components.
# JUMP_START_DIR can be set to override the default root directory
# PROJECT_NAME is expected to be set to the name of the project

JUMP_START_DIR=~/source
STEP_STAR_COLOR="\033[1;34m"

# https://www.ynonperek.com/2017/09/04/bash-cheat-sheet/
set -e
set -o noclobber




function step
{
        NC='\033[0m' # No Color
	STAR_COLOR="${STEP_STAR_COLOR:-'\033[0;32m'}"

        echo -e "${STAR_COLOR}*${NC} $1"
}





function project_name_from_script_name
{
	SCRIPT_NAME=$BASH_SOURCE # for instance source jump_start_test.sh
	NAKED_SCRIPT_NAME=`basename ${SCRIPT_NAME} ".sh"` # for instance jump_start_test
	PREFIX="jump_start_"
	[[ ${NAKED_SCRIPT_NAME} =~ ^${PREFIX} ]] || { echo ""; return 1;}
	echo "${NAKED_SCRIPT_NAME##$PREFIX}"
	return 0
}

PROJECT_NAME="${PROJECT_NAME:-`project_name_from_script_name`}"




JUMP_START_DIR=${JUMP_START_DIR:-~/projects}
WDIR=$(realpath ${JUMP_START_DIR}/${PROJECT_NAME})
step "Creating working folder ${WDIR}..."
mkdir -p ${WDIR}
cd ${WDIR}





NVM_DIR=${NVM_DIR:-${WDIR}/nvm}
NVM_VERSION="v0.33.6"
NODE_VERSION="lts/*"

if [ ! -d "$NVM_DIR" ]; then
        # Following https://github.com/creationix/nvm#manual-install
        step "Installing NVM into ${NVM_DIR}..."
        git clone https://github.com/creationix/nvm.git "${NVM_DIR}"
	cd ${NVM_DIR}
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
else
        step "Skipping creationix/nvm clone, folder $NVM_DIR exists..."
	cd ${NVM_DIR}
fi
step "Configuring NVM..."
#npm config delete prefix
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
step "Switching to node $NODE_VERSION..."
nvm install $NODE_VERSION
nvm use --delete-prefix $NODE_VERSION
step "Installing dependencies..."
#npm install




REPOSITORY="roleupjobboard/tiptap"




GITHUB_DIR=${GITHUB_DIR:-${WDIR}/trunk}
SHOULD_SSH_CLONE=true

if [ ! -d "$GITHUB_DIR" ]; then
        step "Downloading repository $REPOSITORY..."
        if [ "$SHOULD_SSH_CLONE" = true ] ; then
                git clone git@github.com:$REPOSITORY $GITHUB_DIR
        else
                git clone https://github.com/$REPOSITORY $GITHUB_DIR
        fi
else
        step "Skipping $REPOSITORY clone, folder $GITHUB_DIR exists..."
fi

cd $GITHUB_DIR
step "Downloading repository $REPOSITORY updates..."
git fetch --all



set +e
set +o noclobber

