\l qlib/

.log.file:`$"tp.log";
.log.out["Starting tickerplant..."]

\d .tp

upd:{[t;d] t: t upsert d};
subscribers:flip (`process`port`conn)!(`symbol$();`int$();`int$());
subscribe:{[proc;port] 
    .log.out "Process ",(string proc)," at port ",(string port)," attempting to connect to TP.";
    h:hopen port;
    .tp.subscribers:.tp.subscribers upsert (proc;port;h);
    .log.out "Process ",(string port)," connected to TP at ",(string h),".";
    };
unsubscribe:{[proc;port] 
    .log.out "Process ",(string proc)," at port ",(string port)," attempting to disconnect from TP.";
    h:first exec conn from .tp.subscribers where process=proc;
    hclose h;
    .tp.subscribers:delete from .tp.subscribers where process=proc;
    .log.out "Process ",(string proc)," disconnected from TP at ",(string h),".";
    };
pubToSubscribers:{[t]
    if[0=count get t; :()];
    .log.out "Publishing ",(string count get t)," records for table ",(string t)," to ",(string count .tp.subscribers)," subscribers.";
    {[t;d;sub]
        proc:sub`process;
        h:sub`conn;
        .log.out "Sending data for table ",(string t)," to process ",(string proc)," on handle ",(string h),".";
        @[h;(`.upd;t;d);{[err] .log.error "Error sending to subscriber: ",err}];
    }[t;get t] each .tp.subscribers;
    t:delete from t;
    };

\d .
system "t 5000";
.z.ts:{.tp.pubToSubscribers each tables[]};

