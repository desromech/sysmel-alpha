#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>

#define EMIT_COMMENT(str) printf("## " str "\n");
#define EMIT_CONSTANT_INT(name) printf("compileTime constant " #name " := %d.\n", (int)name)
#define EMIT_CONSTANT_HEX_INT(name) printf("compileTime constant " #name " := 16r%08x.\n", (int)name)

int main()
{
    EMIT_COMMENT("fcntl.h");
    EMIT_CONSTANT_HEX_INT(O_RDONLY);
    EMIT_CONSTANT_HEX_INT(O_WRONLY);
    EMIT_CONSTANT_HEX_INT(O_RDWR);
    EMIT_CONSTANT_HEX_INT(O_CREAT);
    EMIT_CONSTANT_HEX_INT(O_EXCL);
    EMIT_CONSTANT_HEX_INT(O_NOCTTY);
    EMIT_CONSTANT_HEX_INT(O_TRUNC);
    EMIT_CONSTANT_HEX_INT(O_APPEND);
    EMIT_CONSTANT_HEX_INT(O_NONBLOCK);
    EMIT_CONSTANT_HEX_INT(O_NDELAY);
    EMIT_CONSTANT_HEX_INT(O_SYNC);
    EMIT_CONSTANT_HEX_INT(O_FSYNC);
    EMIT_CONSTANT_HEX_INT(O_ASYNC);
    EMIT_CONSTANT_HEX_INT(O_DIRECTORY);
    EMIT_CONSTANT_HEX_INT(O_NOFOLLOW);
    EMIT_CONSTANT_HEX_INT(O_CLOEXEC);
#ifdef O_LARGEFILE
    EMIT_CONSTANT_HEX_INT(O_LARGEFILE);
#endif
#ifdef O_DIRECT
    EMIT_CONSTANT_HEX_INT(O_DIRECT);
#endif
#ifdef O_NOATIME
    EMIT_CONSTANT_HEX_INT(O_NOATIME);
#endif
#ifdef O_PATH
    EMIT_CONSTANT_HEX_INT(O_PATH);
#endif
#ifdef O_DSYNC
    EMIT_CONSTANT_HEX_INT(O_DSYNC);
#endif
#ifdef O_TMPFILE
    EMIT_CONSTANT_HEX_INT(O_TMPFILE);
#endif

    EMIT_COMMENT("sys/mman.h")
    EMIT_CONSTANT_HEX_INT(PROT_NONE);
    EMIT_CONSTANT_HEX_INT(PROT_READ);
    EMIT_CONSTANT_HEX_INT(PROT_WRITE);
    EMIT_CONSTANT_HEX_INT(PROT_EXEC);
    EMIT_CONSTANT_HEX_INT(MAP_SHARED);
    EMIT_CONSTANT_HEX_INT(MAP_PRIVATE);
    EMIT_CONSTANT_HEX_INT(MAP_32BIT);
    EMIT_CONSTANT_HEX_INT(MAP_ANON);
    EMIT_CONSTANT_HEX_INT(MAP_ANONYMOUS);
    EMIT_CONSTANT_HEX_INT(MAP_DENYWRITE);
    EMIT_CONSTANT_HEX_INT(MAP_EXECUTABLE);
    EMIT_CONSTANT_HEX_INT(MAP_FILE);
    EMIT_CONSTANT_HEX_INT(MAP_FIXED);
    EMIT_CONSTANT_HEX_INT(MAP_GROWSDOWN);
    EMIT_CONSTANT_HEX_INT(MAP_HUGETLB);
    EMIT_CONSTANT_HEX_INT(MAP_LOCKED);
    EMIT_CONSTANT_HEX_INT(MAP_NONBLOCK);
    EMIT_CONSTANT_HEX_INT(MAP_NORESERVE);
    EMIT_CONSTANT_HEX_INT(MAP_POPULATE);
    EMIT_CONSTANT_HEX_INT(MAP_STACK);
    EMIT_CONSTANT_HEX_INT(MAP_SHARED_VALIDATE);
    EMIT_CONSTANT_HEX_INT(MAP_SYNC);
#ifdef MAP_HUGE_2MB
    EMIT_CONSTANT_HEX_INT(MAP_HUGE_2MB);
#endif
#ifdef MAP_HUGE_1GB
    EMIT_CONSTANT_HEX_INT(MAP_HUGE_1GB);
#endif
#ifdef MAP_UNINITIALIZED
    EMIT_CONSTANT_HEX_INT(MAP_UNINITIALIZED);
#endif

    EMIT_COMMENT("sys/socket.h");
    EMIT_CONSTANT_INT(SHUT_RD);
    EMIT_CONSTANT_INT(SHUT_WR);
    EMIT_CONSTANT_INT(SHUT_RDWR);

    EMIT_CONSTANT_INT(AF_UNIX);
    EMIT_CONSTANT_INT(AF_LOCAL);
    EMIT_CONSTANT_INT(AF_INET);
    EMIT_CONSTANT_INT(AF_INET6);
    EMIT_CONSTANT_INT(AF_NETLINK);
    EMIT_CONSTANT_INT(AF_PACKET);

    EMIT_CONSTANT_INT(SOCK_STREAM);
    EMIT_CONSTANT_INT(SOCK_DGRAM);
    EMIT_CONSTANT_INT(SOCK_SEQPACKET);
    EMIT_CONSTANT_INT(SOCK_RAW);

    EMIT_CONSTANT_INT(SOL_SOCKET);
    EMIT_CONSTANT_INT(SO_ACCEPTCONN);
    EMIT_CONSTANT_INT(SO_ATTACH_FILTER);
    EMIT_CONSTANT_INT(SO_ATTACH_REUSEPORT_CBPF);
    EMIT_CONSTANT_INT(SO_ATTACH_REUSEPORT_EBPF);
    EMIT_CONSTANT_INT(SO_BINDTODEVICE);
    EMIT_CONSTANT_INT(SO_BROADCAST);
    EMIT_CONSTANT_INT(SO_BSDCOMPAT);
    EMIT_CONSTANT_INT(SO_DEBUG);
    EMIT_CONSTANT_INT(SO_DETACH_FILTER);
    EMIT_CONSTANT_INT(SO_DOMAIN);
    EMIT_CONSTANT_INT(SO_ERROR);
    EMIT_CONSTANT_INT(SO_DONTROUTE);
    EMIT_CONSTANT_INT(SO_INCOMING_CPU);
    EMIT_CONSTANT_INT(SO_KEEPALIVE);
    EMIT_CONSTANT_INT(SO_LINGER);
    EMIT_CONSTANT_INT(SO_MARK);
    EMIT_CONSTANT_INT(SO_OOBINLINE);
    EMIT_CONSTANT_INT(SO_PASSCRED);
    EMIT_CONSTANT_INT(SO_PASSSEC);
    EMIT_CONSTANT_INT(SO_PEEK_OFF);
    EMIT_CONSTANT_INT(SO_PEERCRED);
    EMIT_CONSTANT_INT(SO_PRIORITY);
    EMIT_CONSTANT_INT(SO_PROTOCOL);
    EMIT_CONSTANT_INT(SO_RCVBUF);
    EMIT_CONSTANT_INT(SO_RCVBUFFORCE);
    EMIT_CONSTANT_INT(SO_RCVLOWAT);
    EMIT_CONSTANT_INT(SO_SNDLOWAT);
    EMIT_CONSTANT_INT(SO_RCVTIMEO);
    EMIT_CONSTANT_INT(SO_SNDTIMEO);
    EMIT_CONSTANT_INT(SO_REUSEADDR);
    EMIT_CONSTANT_INT(SO_REUSEPORT);
    EMIT_CONSTANT_INT(SO_RXQ_OVFL);
    EMIT_CONSTANT_INT(SO_SNDBUF);
    EMIT_CONSTANT_INT(SO_SNDBUFFORCE);
    EMIT_CONSTANT_INT(SO_TIMESTAMP);
    EMIT_CONSTANT_INT(SO_TYPE);
    EMIT_CONSTANT_INT(SO_BUSY_POLL);

    EMIT_CONSTANT_INT(IPPROTO_IP);
    EMIT_CONSTANT_INT(IPPROTO_UDP);
    EMIT_CONSTANT_INT(IPPROTO_TCP);
    EMIT_CONSTANT_INT(IPPROTO_IPV6);
    return 0;
}
