
#include <zmq.hpp>

#include <unistd.h>
#include <stdlib.h>

#include <iostream>
#include <sstream>
#include <list>
#include <string>

void read_multipart_message(zmq::socket_t& socket, std::list<std::string> & list) {
    int go_on;
    do {
        zmq::message_t message;
        bool ok = socket.recv(&message, 0);

        size_t msg_size = message.size();
        char part[ msg_size + 1];
        memcpy( part, message.data(), msg_size );
        part[msg_size] = 0;

        std::string str_part(part);
        list.push_back( str_part );

        go_on = message.more();

    }
    while ( go_on );
}

std::string do_correct(std::list<std::string> & list) {
    std::hash<std::string> hash_fn;
    size_t the_hash = hash_fn( list.back() );

    std::string result("Vacio");

    // Folder
    std::stringstream mkdir;
    mkdir << "mkdir -p corrections/" << the_hash;

    system(mkdir.str().c_str());

    // Filename
    std::stringstream ss;
    ss << "corrections/" << the_hash << "/respuesta.txt";

    FILE *f = fopen(ss.str().c_str(), "w");
    if ( f != NULL ) {
        fprintf(f,"//##codigo usuario##\n");
        fwrite( list.back().c_str(), list.back().size(), 1, f);
        fprintf(f,"\n//##codigo usuario##\n");
        fclose(f);

        // Execute make
        std::stringstream cmd;
        cmd << "make ANSWER_ID=" << the_hash << " QUESTION_ID=" << list.front() << " 2>&1";

        FILE* pipe = popen(cmd.str().c_str(), "r");
        if ( pipe ) {
            result = "";
            char line[256];
            while ( fgets( line, 256, pipe ) ) {
                result.append( line );
            }
            fclose(pipe);
        }
        else {
            result = "Fail to run make";
        }
    }
    else {
        result = "Fail to create file for answer (";
        result += ss.str().c_str();
        result += ")";
    }
    return result;
}

void working_thread(zmq::context_t& context, int multipart) {
    zmq::socket_t socket (context, ZMQ_REP);
    socket.connect ("tcp://localhost:5556");
    int counter = 0;
    while (true) {
        ++counter;

        std::list<std::string> parts;

        read_multipart_message( socket, parts );

        std::cout << ">>> Received Message #" << counter << std::endl;

        for ( auto& str : parts ) {
            std::cout << "----- Part -----" << std::endl << str << std::endl;
        }
        std::cout << "<<< End Message #" << counter << std::endl;

        if ( ! multipart && parts.size() == 2 ) {
            std::string result = do_correct( parts );
            zmq::message_t reply(result.size());
            memcpy (reply.data (), result.c_str(), result.size());
            socket.send (reply);
        }
        else {
            //  Send reply back to client
            char answer[] = "Probando... Hola mundo";
            zmq::message_t reply(strlen(answer));
            memcpy (reply.data (), answer, strlen(answer));
            socket.send (reply);
        }
    }
}

int main (int argc, char **argv) {

    // generic multipart
    int multipart = (argc == 2) && ( strcmp(argv[1], "-multi") == 0 );

    //  Prepare our context and socket
    zmq::context_t context (1);

    working_thread( context, multipart );

    return 0;
}
