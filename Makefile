all: example build server

example:
	-mkdir n
	echo '# Hello World' > n/Hello\ World.md
	echo '' >> n/Hello\ World.md
	echo '## Section' >> n/Hello\ World.md
	echo '' >> n/Hello\ World.md
	echo 'Example' >> n/Hello\ World.md

build:
	stack build
	stack exec n build

server:
	stack exec n server -- --host 127.0.0.1 --port 12345 & ./editord 12346

clean:
	stack exec n clean

.PHONY: example build build server clean
