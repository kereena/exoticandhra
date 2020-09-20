
HOST=sorend@garudadri.cs.svu-ac.in

default: 
	@echo "check makefile"
	@echo "use 'make all' to dump and install new application"

all:	dump undeploy build push deploy
	@echo "All done :-)"

dump:
	if [ -d wordpress/files ]; then rm -r wordpress/files; fi
	if [ -d wordpress/images ]; then rm -r wordpress/images; fi
	if [ -d wordpress/wordpress ]; then rm -r wordpress/wordpress; fi
	cp -r /var/www/html/files/ wordpress/files/
	cp -r /var/www/html/images/ wordpress/images/
	mkdir wordpress/wordpress
	cp ~/Downloads/installer.php wordpress/wordpress/
	cp $(shell find ~/Downloads -name "exoticandhra_*_archive.zip" | tail -1) wordpress/wordpress

build:
	docker build -t registry.s.dnam.dk/ea-db mariadb
	docker build -t registry.s.dnam.dk/ea-wp wordpress

push:
	docker push registry.s.dnam.dk/ea-db
	docker push registry.s.dnam.dk/ea-wp

undeploy:
	ssh -i ../keys/id_rsa $(HOST) -- docker stack rm exoticandhra

deploy:
	scp -i ../keys/id_rsa docker-stack.yml $(HOST):/tmp/ea-stack.yml
	ssh -i ../keys/id_rsa $(HOST) -- docker pull registry.s.dnam.dk/ea-db:latest
	ssh -i ../keys/id_rsa $(HOST) -- docker pull registry.s.dnam.dk/ea-wp:latest
	ssh -i ../keys/id_rsa $(HOST) -- docker stack deploy exoticandhra -c /tmp/ea-stack.yml
