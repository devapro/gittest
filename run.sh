#! /bin/bash

create_build_number () {
  tags=( $(git tag --list) )

  #tags=("v6.11.4-RC-1" "v6.11.4-RC-3" "v6.11.4-RC-2" "v6.11.2-RC-1")

  RCNumbers=($(for i in "${tags[@]}"
  do
    if [[ "$i" =~ "$RELEASE_TAG".* ]]; then
      echo "${i/$RELEASE_TAG}"
    fi
  done))

  sortedRCNumbers=($(for i in "${RCNumbers[@]}"; do echo $i; done | sort -n))

  lastRCNumber=${sortedRCNumbers[@]: -1}

  lastRCNumber=$((lastRCNumber+1))

  echo "$lastRCNumber"
}

# release name X.XX.X
RELEASE_NAME=$1
if [ -z "$RELEASE_NAME" ]
then
      echo "Please set RELEASE_NAME"
      exit 1
fi

# name of the develop branch
DEVELOP_BRANCH="test/test_develop"

# checkout develop branch
git checkout ${DEVELOP_BRANCH}
git pull

# check if release branch already exist
branches=( $(git branch -a) )

RELEASE_BRANCH_NAME="test/test_v${RELEASE_NAME}" # "release/v${RELEASE_NAME}"
RELEASE_TAG="v${RELEASE_NAME}-RC-"

RELEASE_BRANCH_CREATED=0

[[ " ${branches[@]} " =~ " ${RELEASE_BRANCH_NAME} " ]] && RELEASE_BRANCH_CREATED=1 || RELEASE_BRANCH_CREATED=0;

if [ $RELEASE_BRANCH_CREATED -eq 0 ]; then
  # create a new release branch
	git tag "${RELEASE_TAG}1"
	git push --tags
	git checkout -b "${RELEASE_BRANCH_NAME}"
	git push -u origin "${RELEASE_BRANCH_NAME}"
	echo "new release branch ${RELEASE_BRANCH_NAME} created"
else
  # add new tag if release branch already created
	echo "${RELEASE_BRANCH_NAME} already exist"
	git checkout "${RELEASE_BRANCH_NAME}"
	nextBuildNumber=$(create_build_number)
	if [ -z "$nextBuildNumber" ]
  then
        git tag "${RELEASE_TAG}1"
  else
        git tag "${RELEASE_TAG}${nextBuildNumber}"
  fi

	git push --tags

fi