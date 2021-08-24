CONTAINER?=srcsetdev
TAG?=14-alpine

DOCKERRUN=docker container run \
	--name ${CONTAINER} \
	--rm \
	-t \
	-p 3000:3000 \
	-v `pwd`:/app \
	${CONTAINER}:${TAG}

.PHONY: build dev docker install update update-clean npm

build: docker install
	${DOCKERRUN} \
		run build
dev: docker install
	${DOCKERRUN} \
		run dev
docker:
	docker build \
		. \
		-t ${CONTAINER}:${TAG} \
		--build-arg TAG=${TAG} \
		--no-cache
install: docker
	${DOCKERRUN} \
		install
update: docker
	rm -f package-lock.json
	${DOCKERRUN} \
		install
update-clean: docker
	rm -f package-lock.json
	rm -rf node_modules/
	${DOCKERRUN} \
		install
npm: docker
	${DOCKERRUN} \
		$(filter-out $@,$(MAKECMDGOALS))
%:
	@:
# ref: https://stackoverflow.com/questions/6273608/how-to-pass-argument-to-makefile-from-command-line
