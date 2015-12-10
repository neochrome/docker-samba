build:
	@docker build -t dev/$$(basename $$PWD) .

start: remove build
	@docker run -d --name $$(basename $$PWD) \
		-p 445:445 \
		-v /var/run/docker.sock:/docker.sock \
		-v $$PWD:/shares/work-dir:ro \
		-v /tmp:/shares/tmp \
		dev/$$(basename $$PWD)

stop:
	-@docker kill $$(basename $$PWD) 1>&2

remove: stop
	-@docker rm $$(basename $$PWD) 1>&2

clean: remove
	-@docker rmi dev/$$(basename $$PWD)

debug: build
	@docker run --rm -it \
		-p 445:445 \
		-v /var/run/docker.sock:/docker.sock \
		-v $$PWD:/shares/work-dir:ro \
		-v /tmp:/shares/tmp \
		--entrypoint /bin/sh \
		dev/$$(basename $$PWD)
