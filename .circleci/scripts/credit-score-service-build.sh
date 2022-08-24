#! /bin/bash

# build
mvn clean verify -pl credit-score-service -Pcode-coverage -Pstatic-code-analysis
# verify pacts
mvn verify -pl credit-score-service -Pprovider-pacts -Dpact.verifier.publishResults=true -Dpact.provider.version=`git rev-parse --short HEAD` -Dpactbroker.tags=prod -Dpactbroker.user=rw_user -Dpactbroker.pass=rw_pass
# create pacts
## no pacts to create
# can-i-deploy
## no need to run since it doesn't create any pacts
# tag pacts as production
docker run --rm --net host ${PACT_CLI_IMG} broker create-version-tag --pacticipant credit-score-service --version `git rev-parse --short HEAD` --tag prod --broker-base-url ${PACT_BROKER_URL} --broker-username=rw_user --broker-password=rw_pass
