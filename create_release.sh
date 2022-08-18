#! /bin/bash

#### Create new release branch

RELEASE_NAME="0.0.3"

git checkout develop

git pull

branches=( $(git branch -a) )

RELEASE_BRANCH_NAME="v${RELEASE_NAME}"

RELEASE_BRANCH_CREATED=0

[[ " ${branches[@]} " =~ " ${RELEASE_BRANCH_NAME} " ]] && RELEASE_BRANCH_CREATED=1 || RELEASE_BRANCH_CREATED=0;

if [ $RELEASE_BRANCH_CREATED -eq 0 ]; then
	git tag "release_${RELEASE_BRANCH_NAME}"
	git checkout -b ${RELEASE_BRANCH_NAME}
else
	echo "${RELEASE_BRANCH_NAME} exist"
fi

#### Create change log

git log --oneline --decorate
git log --pretty=”%s”
git log --pretty="- %s"