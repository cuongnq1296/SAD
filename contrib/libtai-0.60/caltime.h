#ifndef CALTIME_H
#define CALTIME_H

#include <libtai/caldate.h>
#include <libtai/tai.h>

struct caltime {
  struct caldate date;
  int hour;
  int minute;
  int second;
  long offset;
} ;

extern void caltime_tai(struct caltime *, struct tai *);
extern void caltime_utc(struct caltime *, struct tai *, int*, int *);

extern unsigned int caltime_fmt(char *, struct caltime *);
extern unsigned int caltime_scan(char *, struct caltime *);

#endif
