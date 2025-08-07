all: build/ts build/tc build/us build/uc

build/ts: build tcp_server.cpp net.h
	gcc -o build/ts tcp_server.cpp

build/tc: build tcp_client.cpp net.h
	gcc -o build/tc tcp_client.cpp

build/us: build udp_server.cpp net.h
	gcc -o build/us udp_server.cpp

build/uc: build udp_client.cpp net.h
	gcc -o build/uc udp_client.cpp

build:
	mkdir -p build

clean:
	rm -r build

.PHONY: clean