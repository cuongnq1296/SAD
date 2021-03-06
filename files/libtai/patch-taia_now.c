--- taia_now.c.orig	2008-03-09 17:05:16.000000000 +0100
+++ taia_now.c	2008-03-09 17:01:15.000000000 +0100
@@ -1,15 +1,24 @@
 #include <sys/types.h>
 #include <sys/time.h>
 #include "taia.h"
+#include "hasclock_gettime.h"
 
 /* XXX: breaks tai encapsulation */
 
 void taia_now(t)
 struct taia *t;
 {
+#ifdef HASCLOCK_GETTIME
+  struct timespec now;
+  clock_gettime(CLOCK_REALTIME,&now);
+  t->sec.x = 4611686018427387914ULL + (uint64) now.tv_sec;
+  t->nano = now.tv_nsec;
+  t->atto = 500000000UL; /* 0.5 nsec */
+#else
   struct timeval now;
   gettimeofday(&now,(struct timezone *) 0);
   t->sec.x = 4611686018427387914ULL + (uint64) now.tv_sec;
   t->nano = 1000 * now.tv_usec + 500;
   t->atto = 0;
+#endif
 }
