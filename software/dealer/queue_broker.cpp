
//
//  Simple message queuing broker in C++
//  Same as request-reply broker but using QUEUE device
//
// Olivier Chamoux <olivier.chamoux@fr.thalesgroup.com>

#include "zhelpers.hpp"

int main (int argc, char *argv[])
{
    void *context = zmq_init(1);

    //  Socket facing clients
    void* frontend = zmq_socket (context, ZMQ_ROUTER);
    int ok_bind1 = zmq_bind (frontend, "tcp://*:5555");

    //  Socket facing services
    void* backend = zmq_socket (context, ZMQ_DEALER);
    int ok_bind2 = zmq_bind (backend, "tcp://*:5556");

    //  Start the proxy
    zmq_proxy(frontend, backend, nullptr);
    return 0;
}
