c     Don't confuse, Emacs. This is -*- fortran -*- mode!
      integer*4 FLAGON,FLAGOF
      parameter (FLAGON=-1,FLAGOF=0)
c
      integer*4 HTMAX,MAXPNAME,LILISTDUMMY
      parameter(MAXPNAME=32,LILISTDUMMY=3)
      character*(MAXPNAME) NULSTR
      parameter(HTMAX=2**15-1,NULSTR='        ')
c     define `RBASE': base index number in pfalloc.f