#! /bin/bash

RELEASE_TAG="v6.11.4-RC-"

create_build_number () {
  #tags=( $(git tag --list) )

  tags=("v6.11.4-RC-1" "v6.11.4-RC-3" "v6.11.4-RC-2" "v6.11.2-RC-1")

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

  #for i in "${sortedRCNumbers[@]}"
  #  do echo $i
  #  done
}

echo $(create_build_number)