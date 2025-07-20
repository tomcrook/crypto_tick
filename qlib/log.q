\d .log

logDir:`$":/home/ec2-user/crypto_tick/logs"
file:`$"log.log";


out:{[msg] .log.write["INFO";msg]}
error:{[msg] .log.write["ERROR";msg]}
write:{[level;msg] .log.rawWrite[(string .z.T)," (",level,") ", msg]};
rawWrite:{[msg] 
    if [10h = type msg;
        h:hopen (` sv (logDir;.log.file)); h msg,"\n"; hclose h;
    ];
    };

\d .