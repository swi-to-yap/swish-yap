:- module(servernonint,
	  [ server/0,
	    server/1				% ?Port
	  ]).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(swish).
%:- use_module(library(http/http_log)).

%%    server is det.
%%    server(?Port) is det.
%
%    Start the web-server on Port.  Port  may   be  unbound  to make the
%    system  select  a  free  port.  Port  can   also  be  of  the  form
%    `localhost:Port`  to  bind  the  server    only  to  the  localhost
%    interface.

:- http_handler('/sitemap.xml', http_reply_file(swish('sitemap.xml'), []),[]).
server :-
	server(3050).
server(Port) :-
	http_server(http_dispatch,
		    [ port(Port),
		      workers(16)
		    ]),
  thread_get_message(stop).


:- on_signal(hup, _, hup).

hup(_Signal) :-
        thread_send_message(main, stop).