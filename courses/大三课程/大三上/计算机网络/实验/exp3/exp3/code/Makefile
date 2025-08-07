all: build/swr build/sws build/gbr build/gbs build/srr build/srs build/qt

build/sw: build/swr build/sws 

build/gb: build/gbr build/gbs

build/swr: build rdt_stopwait_receiver.cpp net.h queue.h
	gcc -o build/swr -pthread rdt_stopwait_receiver.cpp

build/sws: build rdt_stopwait_sender.cpp net.h queue.h
	gcc -o build/sws -pthread rdt_stopwait_sender.cpp

build/gbr: build rdt_gobackn_receiver.cpp net.h queue.h
	gcc -o build/gbr -pthread rdt_gobackn_receiver.cpp

build/gbs: build rdt_gobackn_sender.cpp net.h queue.h
	gcc -o build/gbs -pthread rdt_gobackn_sender.cpp

build/srr: build rdt_selectresend_receiver.cpp net.h queue.h
	gcc -o build/srr -pthread rdt_selectresend_receiver.cpp

build/srs: build rdt_selectresend_sender.cpp net.h queue.h
	gcc -o build/srs -pthread rdt_selectresend_sender.cpp

build/qt: build queue_test.cpp queue.h
	gcc -o build/qt queue_test.cpp

build:
	mkdir -p build

clean:
	rm -r build

.PHONY: clean