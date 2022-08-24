#! /bin/bash

# build
buildevents cmd $TRACE_ID $STEP_ID 'build' -- \
    mvn clean verify -pl special-membership-service -Pcode-coverage -Pstatic-code-analysis
# verify pacts
buildevents cmd $TRACE_ID $STEP_ID 'verify pacts' -- \
    mvn verify -pl special-membership-service -Pprovider-pacts -Dpact.verifier.publishResults=true -Dpact.provider.version=`git rev-parse --short HEAD` -Dpactbroker.tags=prod -Dpactbroker.user=rw_user -Dpactbroker.pass=rw_pass
# create pacts
buildevents cmd $TRACE_ID $STEP_ID 'create pacts' -- \
    mvn verify -pl special-membership-service -Pconsumer-pacts
buildevents cmd $TRACE_ID $STEP_ID 'publish pacts' -- \
    docker run --rm --net host -v `pwd`/special-membership-service/target/pacts:/target/pacts ${PACT_CLI_IMG} publish /target/pacts --consumer-app-version `git rev-parse --short HEAD` --tag `git rev-parse --abbrev-ref HEAD` --broker-base-url ${PACT_BROKER_URL} --broker-username=rw_user --broker-password=rw_pass
# simulate that we run the providers' support pipelines
## simulate that there is a prod version of the provider deployed
buildevents cmd $TRACE_ID $STEP_ID 'tag pacts for production' -- \
    docker run --rm --net host ${PACT_CLI_IMG} broker create-version-tag --auto-create-version --pacticipant credit-score-service --version `git rev-parse --short HEAD` --tag prod --broker-base-url ${PACT_BROKER_URL} --broker-username=rw_user --broker-password=rw_pass
## verify pacts of special membership service that were just published
buildevents cmd $TRACE_ID $STEP_ID 'verify published pacts' -- \
    mvn verify -pl credit-score-service -Pprovider-pacts -Dpact.verifier.publishResults=true -Dpact.provider.version=`git rev-parse --short HEAD` -Dpactbroker.consumers=special-membership-service -Dpactbroker.tags=`git rev-parse --abbrev-ref HEAD` -Dpactbroker.user=rw_user -Dpactbroker.pass=rw_pass
# meanwhile, this is happening in the special membership service pipeline
# can-i-deploy
buildevents cmd $TRACE_ID $STEP_ID 'pact verify can-i-deploy' -- \
    docker run --rm --net host ${PACT_CLI_IMG} broker can-i-deploy -v --pacticipant special-membership-service --version `git rev-parse --short HEAD` --to prod --broker-base-url ${PACT_BROKER_URL} --broker-username=rw_user --broker-password=rw_pass
# tag pacts as production
buildevents cmd $TRACE_ID $STEP_ID 'tag pacts as production' -- \
    docker run --rm --net host ${PACT_CLI_IMG} broker create-version-tag --auto-create-version --pacticipant special-membership-service --version `git rev-parse --short HEAD` --tag prod --broker-base-url ${PACT_BROKER_URL} --broker-username=rw_user --broker-password=rw_pass
