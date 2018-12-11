
CC=gcc
CFLAGS=-ansi -Wall 
CXX=g++
CXXFLAGS=-Wall -std=c++11

all : ../server.run ../broker.run client.run


../server.run: server.cpp
	$(CXX) $(CXXFLAGS) server.cpp -o ../server.run -lzmq

../broker.run: queue_broker.cpp
	$(CXX) $(CXXFLAGS) queue_broker.cpp -o ../broker.run -lzmq

client.run: client.c
	$(CC) $(CFLAGS) client.c -o client.run -lzmq

clean:
	rm *.run
	rm ../server.run
