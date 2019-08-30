      module readopt
        type ropt
        sequence
        character*64 delim
        integer*4 ndel
        logical*4 new,null,del,opt
        end type
      end module

      subroutine tfwrite(isp1,kx,irtc)
      use tfstk
      use strbuf
      implicit none
      type (sad_descriptor) kx
      type (sad_strbuf), pointer :: strb
      integer*4 isp1,irtc,itfgetrecl,narg,lfn,isp11,
     $     j,i,nc,lpw,itfmessage,isp2,itfgetlfn
      logical*4 exist
      narg=isp-isp1
      if(narg .le. 1)then
        irtc=itfmessage(9,'General::narg','"2 or more"')
        return
      endif
      lfn=itfgetlfn(isp1,.false.,irtc)
      if(irtc .ne. 0)then
        return
      endif
      lpw=itfgetrecl()
      isp11=isp
      call getstringbuf(strb,-lpw,.true.)
      exist=.false.
      isp2=isp
      do j=isp1+2,isp11
        call tfevalstk(dtastk(j),.true.,irtc)
        if(irtc .ne. 0)then
          go to 10
        endif
        do i=isp2+1,isp
          call tfconvstrb(strb,dtastk(i),nc,
     $         .false.,.false.,lfn,'*',irtc)
          if(irtc .ne. 0)then
            go to 10
          endif
          exist=exist .or. nc .gt. 0
        enddo
        isp=isp2
      enddo
      call writestringbufn(strb,.true.,lfn)
      if(.not. exist)then
        write(lfn,*,ERR=9010)
      endif
 9010 kx%k=ktfoper+mtfnull
      irtc=0
 10   call tfreestringbuf(strb)
      isp=isp11
      return
      end

      integer*4 function itfgetlfn(isp1,read,irtc) result(iv)
      use tfstk
      use tfcsi
      implicit none
      type (sad_descriptor) k
      type (sad_dlist), pointer :: kl
      integer*4 isp1,irtc,itfmessage
      logical*4 read
      iv=0
      if(isp .le. isp1)then
        irtc=itfmessage(9,'General::narg','"1 or more"')
        return
      endif
      if(ktfrealq(ktastk(isp1+1),iv))then
        go to 100
      elseif(tflistq(dtastk(isp1+1),kl))then
        if(read)then
          k=kl%dbody(1)
        else
          k=kl%dbody(2)
        endif
        if(ktfrealq(k,iv))then
          go to 100
        endif
      endif
      irtc=itfmessage(9,'General::wrongtype',
     $     '"Real number or List of two Reals"')
      return
 100  irtc=0
      if(iv .eq. -1)then
        if(read)then
          iv=lfni
        else
          iv=lfno
        endif
      elseif(iv .lt. 0)then
        irtc=itfmessage(9,'General::wrongnum','"positive, 0 or -1"')
      endif
      return
      end

      subroutine tfwritestring(isp1,kx,irtc)
      use tfstk
      use strbuf
      implicit none
      type (sad_descriptor) kx
      type (sad_strbuf), pointer :: strb
      integer*4 mmax
      parameter (mmax=1000000)
      integer*4 isp1,irtc,narg,lfn,isp11,j,i,itfgetlfn,
     $             nc,itfmessage,isp2
      narg=isp-isp1
      if(narg .le. 1)then
        irtc=itfmessage(9,'General::narg','"2 or more"')
        return
      endif
      lfn=itfgetlfn(isp1,.false.,irtc)
      if(irtc .ne. 0)then
        return
      endif
      isp11=isp
      do j=isp1+2,isp11
        call tfevalstk(dtastk(j),.true.,irtc)
        if(irtc .ne. 0)then
          isp=isp11
          return
        endif
        isp2=isp
        call getstringbuf(strb,0,.true.)
        do i=isp11+1,isp2
          call tfconvstrb(strb,dtastk(i),
     $         nc,.false.,.false.,-1,'*',irtc)
          if(irtc .ne. 0)then
            go to 10
          endif
          call writestringbuf(strb,.false.,lfn)
        enddo
        call tfreestringbuf(strb)
        isp=isp11
      enddo
      kx%k=ktfoper+mtfnull
      return
 10   call tfreestringbuf(strb)
      isp=isp11
      return
      end

      subroutine tfprintf(isp1,kx,irtc)
      use tfstk
      use tfcsi
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,isp0
      isp0=isp
      isp=isp+1
      rtastk(isp)=lfno
      ktastk(isp+1:isp+isp0-isp1)=ktastk(isp1+1:isp0)
      isp=isp+isp0-isp1
c      do i=1,isp0-isp1
c        isp=isp+1
c        ktastk(isp)=ktastk(isp1+i)
c      enddo
      call tfwrite(isp0,kx,irtc)
      isp=isp0
      return
      end

      subroutine tfdebugprint(k,pr1,nline)
      use tfstk
      use tfrbuf
      implicit none
      type (sad_descriptor) k
      integer*4 irtc,nline,l,itfdownlevel
      character*(*) pr1
      prolog=pr1
      ncprolog=min(len_trim(pr1)+1,len(prolog))
      prolog(ncprolog:ncprolog)=' '
      levele=levele+1
      call tfprint1(k,6,79,nline,.true.,.true.,irtc)
      if(irtc .gt. 0 .and. ierrorprint .ne. 0)then
        call tfreseterror
      endif
      l=itfdownlevel()
      return
      end

      subroutine tfshort(isp1,kx,irtc)
      use tfstk
      use tfrbuf
      use tfcsi
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,itfgetrecl,nret,itfmessage
      if(isp .eq. isp1+1)then
        call tfprint1(dtastk(isp),
     $       lfno,-itfgetrecl(),1,.true.,.true.,irtc)
      elseif(isp .eq. isp1+2)then
        if(ktfnonrealq(ktastk(isp)))then
          irtc=itfmessage(9,'General::wrongtype','"real number"')
          return
        endif
        nret=int(rtastk(isp))
        call tfprint1(dtastk(isp1+1),
     $       lfno,-itfgetrecl(),abs(nret),nret .ge. 0,
     $       .true.,irtc)
      else
        irtc=itfmessage(9,'General::narg','"1 or 2"')
      endif
      kx%k=ktfoper+mtfnull
      return
      end

      subroutine tfprint1(k,lfno,lrec,nret,cr,str,irtc)
      use tfstk
      use tfrbuf
      use strbuf
      implicit none
      type (sad_descriptor) k,kxlongstr,ks,kr
      type (sad_strbuf), pointer :: strb
      integer*4 lfno,irtc,nc,lrec,nret,irtc1,isp0
      logical*4 cr,str
      save kxlongstr
      data kxlongstr%k /0/
      isp0=isp
      call getstringbuf(strb,lrec,.true.)
      if(nret .gt. 0)then
        strb%remlines=nret
      endif
      if(ncprolog .gt. 0)then
        call putstringbufp(strb,prolog(1:ncprolog),lfno,irtc)
        if(irtc .ne. 0)then
          go to 9000
        endif
      endif
      call tfconvstrb(strb,k,nc,str,.false.,lfno,' ',irtc)
      if(irtc .eq. 0)then
        call writestringbufn(strb,cr,lfno)
      elseif(irtc .eq. -1)then
        irtc=0
      elseif(irtc .gt. 0)then
        kr=dlist(ktfaddr(kerror)+2)
        if(kxlongstr%k .eq. 0)then
          call tfevals('Hold[General::longstr]',ks,irtc1)
          if(irtc1 .ne. 0)then
            irtc=irtc1
            go to 9000
          endif
          kxlongstr=dtfcopy1(ks)
        endif
        if(tfsameq(kr,kxlongstr))then
          call tfreseterror
          irtc=0
        endif
      endif
 9000 call tfreestringbuf(strb)
      ncprolog=0
      isp=isp0
      return
      end

      subroutine tfdefinition(isp1,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx,ki,k
      type (sad_symbol), pointer ::sym
      type (sad_symdef), pointer ::symd
      type (sad_dlist), pointer :: klh,kli,klx
      integer*8 ii,ka0,kadi,kad,ka
      integer*4 isp1,irtc,i,isp00,isp0,kk,iop,ispv,icomp
      icomp=0
      call tfgetoption('Compiled',ktastk(isp),kx,irtc)
      if(irtc .eq. -1)then
        ispv=isp
      elseif(irtc .ne. 0)then
        return
      elseif(ktfrealq(kx))then
        if(kx%k .ne. 0)then
          icomp=1
        endif
        ispv=isp-1
      else
        ispv=isp
      endif
      isp00=isp
      do i=isp1+1,ispv
        isp0=isp
        k=dtastk(i)
        if(ktfoperq(k,ka))then
          ka=klist(ifunbase+ka)
          k%k=ktfsymbol+ka
        endif
        if(ktfsymbolq(k,sym))then
          call tfsydef(sym,sym)
          call sym_symdef(sym,symd)
          ka0=ksad_loc(symd%upval)
          if(ktfrefq(symd%value,ka))then
            k=dlist(ka)
          else
            k=symd%value
          endif
        else
          ka0=0
        endif
        isp=isp+1
        if(ka0 .ne. 0)then
          dtastk(isp)=kxadaloc(-1,2,klh)
          klh%head%k=ktfoper+mtfsetdelayed
          klh%dbody(1)%k=ktfsymbol+ktfcopy1(ka0+6)
          klh%dbody(2)=dtfcopy(k)
          do kk=1,0,-1
            if(kk .eq. 1)then
              iop=mtfsetdelayed
            else
              iop=mtfupsetdelayed
            endif
            kad=klist(ka0+kk)
            do while(kad .ne. 0)
              if(ilist(1,kad+2) .eq. maxgeneration)then
                do ii=kad+3,kad+ilist(2,kad+2)+3
                  kadi=klist(ii)
                  do while(kadi .ne. 0)
                    isp=isp+1
                    dtastk(isp)=kxadaloc(-1,2,kli)
                    kli%head%k=ktfoper+iop
                    kli%dbody(1)=dtfcopy1(dlist(kadi+3+icomp))
                    kli%dbody(2)=dtfcopy(dlist(kadi+5+icomp))
                    if(kli%dbody(2)%k .eq. ktfref)then
                      kli%dbody(2)=dtfcopy(dlist(kadi+6))
                    endif
                    kadi=klist(kadi)
                  enddo
                enddo
              else
                isp=isp+1
                dtastk(isp)=kxadaloc(-1,2,kli)
                kli%head%k=ktfoper+iop
                kli%dbody(1)=dtfcopy1(dlist(kad+3+icomp))
                kli%dbody(2)=dtfcopy(dlist(kad+5+icomp))
                if(kli%dbody(2)%k .eq. ktfref)then
                  kli%dbody(2)=dtfcopy(dlist(kad+6))
                endif
              endif
              kad=klist(kad)
            enddo
          enddo
        else
          dtastk(isp)=k
        endif
        ki=kxmakelist(isp0)
        isp=isp0+1
        dtastk(isp)=ki
      enddo
      kx=kxmakelist(isp00,klx)
      klx%head%k=ktfoper+mtfhold
      isp=isp00
      irtc=0
      return
      end

      subroutine tfgetf(fname)
      use tfstk
      use tfcode
      implicit none
      character*(*) fname
      type (sad_descriptor) kx,k
      integer*4 irtc
      k=kxsalocb(-1,fname,len_trim(fname))
      call tfget(k,kx,irtc)
      return
      end

      recursive subroutine tfget(k,kx,irtc)
      use tfstk
      use tfrbuf
      use tfcsi
      implicit none
      type (sad_descriptor) k,kx,kf,kfn
      type (csiparam) sav
      integer*4 irtc,itfgeto,lfn,isp0,itf,nc
      isp0=isp
      isp=isp+1
      dtastk(isp)=k
c      call tfdebugprint(k,'tfget',1)
      call tfopenread(isp0,kfn,irtc)
      isp=isp0
      if(irtc .ne. 0)then
        return
      endif
      lfn=int(rfromd(kfn))
      call cssave(sav)
      rec=.false.
      levele=levele+1
      kx%k=ktfoper+mtfnull
      call tfreadbuf(irbassign,lfn,i00,i00,0)
      lfn1=0
      call skipln
c      write(*,*)'tfget-0 ',lfn,ipoint,lrecl,buffer(1:1)
      itf=0
      do while(itf .ge. 0)
        itf=itfgeto(kf)
c        write(*,*)'tfget-i ',itf,ipoint,lrecl,
c     $       '''',buffer(ipoint:lrecl),''''
c        call tfdebugprint(kf,'tfget',1)
        if(itf .ge. 0)then
          kx=kf
        elseif(itf .eq. -1)then
          itf=0
          call skipln
c          write(*,*)'tfget-skipln ',ios
        endif
        if(ios .ne. 0)then
          ios=0
          itf=min(-1,itf)
        endif
      enddo
      call tfconnect(kx,0)
      close(lfn)
c      write(*,*)'tfget-6 ',lfni,buffer(ipoint:ipoint)
      call tfreadbuf(irbclose,lfn,i00,i00,nc)
c      write(*,*)'tfget-6.5 ',lfni,ipoint
      call csrestore(sav)
c      write(*,*)'tfget-7 ',lfni,ipoint
      call tfreadbuf(irbassign,lfni,i00,i00,0)
c      write(*,*)'tfget-8 ',lfni,ipoint
      if(itf .eq. -3)then
        irtc=irtcabort
      else
        irtc=0
      endif
      return
      end

      subroutine tfread1(isp1,lfn,kx,irtc)
      use tfstk
      use tfrbuf
      use tfcsi
      implicit none
      type (sad_descriptor) kx,kf
      type (csiparam) sav
      integer*4 isp1,irtc,itfgeto,nc,itf,lfni0,
     $     lfn,itfmessage
      integer*8 is
      logical*4 openf
      if(isp .gt. isp1+1)then
        irtc=itfmessage(9,'General::narg','"1"')
        return
      endif
      lfni0=lfni
      openf=lfn .gt. 0 .and. lfn .ne. lfni0
      if(openf)then
        call cssave(sav)
        call tfreadbuf(irbassign,lfn,i00,i00,0)
        lfn1=0
        nc=0
        if(itbuf(lfn) .ge. modestring .and. ipoint .le. 0)then
          call skipln
        endif
        call tfreadbuf(irbreadbuf,lfn,i00,i00,nc)
      endif
      levele=levele+1
 1    itf=itfgeto(kf)
      if(itf .ge. 0)then
        kx=kf
      else
        kx%k=ktfoper+mtfnull
      endif
c      call tfdebugprint(kx,'read1',1)
c      WRITE(*,*)'with: ',lfni,ipoint,lrecl,itf
      if(itf .eq. -1)then
        call tprmptget(-1,-1,0)
        if(ios .eq. 0)then
          go to 1
        endif
      endif
      if(ios .ne. 0)then
c        write(*,*)'read1 ',ios
        ios=0
        kx%k=kxeof
        if(openf)then
          call tfreadbuf(irbreset,lfn,i00,i00,nc)
        endif
      elseif(openf .and. itbuf(lfn) .gt. modewrite)then
c        call tfreadbuf(irbsetpoint,lfn,int8(ipoint),i00,nc)
      endif
      call tfconnect(kx,0)
      if(openf)then
        call csrestore(sav)
        call tfreadbuf(irbassign,lfni,i00,i00,0)
      endif
      irtc=0
      return
      end

      recursive subroutine tfskip(isp1,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,i,narg,isp0,nrpt
      narg=isp-isp1
      if(narg .ge. 3 .and.
     $     ktfrealq(dtastk(isp1+3),nrpt))then
        isp0=isp
        do i=1,nrpt
          ktastk(isp0+1)=ktastk(isp1+1)
          ktastk(isp0+2)=ktastk(isp1+2)
          ktastk(isp0+3:isp0+narg-1)=ktastk(isp1+4:isp1+narg)
c          do j=4,narg
c            ktastk(isp0+j-1)=ktastk(isp1+j)
c          enddo
          isp=isp0+narg-1
          call tfskip(isp0,kx,irtc)
          isp=isp0
          if(irtc .ne. 0)then
            return
          endif
          if(kx%k .eq. kxeof)then
            return
          endif
        enddo
      else
        call tfread(isp1,kx,irtc)
      endif
      return
      end

      subroutine tfread(isp1,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,lfn,itfgetlfn,irtc
      lfn=itfgetlfn(isp1,.true.,irtc)
      if(irtc .eq. 0)then
        call tfreadf(isp1,lfn,kx,irtc)
      endif
      return
      end

      subroutine tfreadf(isp1,lfn,kx,irtc)
      use tfstk
      use readopt
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,lfn
      type(ropt) opts
      call tfreadoptions(isp1,opts,.true.,irtc)
      if(irtc .eq. 0)then
        isp=min(isp,isp1+2)
        call tfreadfs(isp1,lfn,opts,kx,irtc)
      endif
      return
      end

      subroutine tfreadfs(isp1,lfn,opts,kx,irtc)
      use tfstk
      use readopt
      implicit none
      type (sad_descriptor) kx,k1,k2
      type (sad_dlist), pointer :: list
      integer*4 isp1,irtc,isp0,n1,narg,itfmessage,lfn,i1
      type(ropt) opts
      type (sad_descriptor)
     $     itfexprs,itfstrs,itfwords,itfreals,itfchars,
     $     itfbyte,itfbinint,itfbinsint,itfbinreal,itfbindble
      data itfexprs%k,itfstrs%k,itfwords%k,itfreals%k,itfchars%k,
     $     itfbyte%k,itfbinint%k,itfbinsint%k,itfbinreal%k,itfbindble%k
     $     /0,0,0,0,0, 0,0,0,0,0/
      narg=isp-isp1
      if(narg .eq. 0)then
        irtc=itfmessage(9,'General::narg','"1 or more"')
      elseif(narg .eq. 1)then
        call tfread1(isp1,lfn,kx,irtc)
      else
        if(itfexprs%k .eq. 0)then
          itfexprs=kxsymbolf('Expression',10,.true.)
          itfstrs=kxsymbolf('String',6,.true.)
          itfwords=kxsymbolf('Word',4,.true.)
          itfreals=kxsymbolf('Real',4,.true.)
          itfchars=kxsymbolf('Character',9,.true.)
          itfbyte=kxsymbolf('Byte',4,.true.)
          itfbinsint=kxsymbolf('BinaryShortInteger',18,.true.)
          itfbinint=kxsymbolf('BinaryInteger',13,.true.)
          itfbinreal=kxsymbolf('BinaryReal',10,.true.)
          itfbindble=kxsymbolf('BinaryDouble',12,.true.)
        endif
        k2=dtastk(isp1+2)
        if(ktfsymbolq(k2))then
          if(tfsamesymbolq(k2,itfexprs))then
            isp0=isp
            isp=isp+1
            ktastk(isp)=ktastk(isp1+1)
            call tfread1(isp0,lfn,kx,irtc)
            isp=isp0
          elseif(tfsamesymbolq(k2,itfstrs))then
            isp0=isp
            isp=isp+1
            ktastk(isp)=ktastk(isp1+1)
            n1=opts%ndel
            opts%ndel=0
            call tfreadstringf(lfn,kx,.false.,opts,irtc)
            opts%ndel=n1
            isp=isp0
          elseif(tfsamesymbolq(k2,itfwords))then
            call tfreadstringf(lfn,kx,.false.,opts,irtc)
          elseif(tfsamesymbolq(k2,itfchars))then
            call tfreadstringf(lfn,kx,.true.,opts,irtc)
          elseif(tfsamesymbolq(k2,itfreals))then
            call tfreadstringf(lfn,kx,.false.,opts,irtc)
            if(irtc .ne. 0)then
              return
            endif
            if(ktfstringq(kx))then
              isp0=isp
              isp=isp+1
              dtastk(isp)=kx
              call tftoexpression(isp0,kx,irtc)
              isp=isp0
            endif
          elseif(tfsamesymbolq(k2,itfbyte))then
            call tfreadbyte(isp1,lfn,kx,1,irtc)
          elseif(tfsamesymbolq(k2,itfbinsint))then
            call tfreadbyte(isp1,lfn,kx,2,irtc)
          elseif(tfsamesymbolq(k2,itfbinint))then
            call tfreadbyte(isp1,lfn,kx,3,irtc)
          elseif(tfsamesymbolq(k2,itfbinreal))then
            call tfreadbyte(isp1,lfn,kx,4,irtc)
          elseif(tfsamesymbolq(k2,itfbindble))then
            call tfreadbyte(isp1,lfn,kx,5,irtc)
          else
            go to 9000
          endif
        elseif(ktflistq(k2,list))then
          if(list%head%k .eq. ktfoper+mtflist)then
            call tfreadfm(lfn,list,list%nl,opts,.false.,kx,irtc)
          elseif(list%head%k .eq. ktfoper+mtftimes .and.
     $           list%nl .eq. 2)then
            k1=list%dbody(1)
            if(ktfnonrealq(k1,i1))then
              go to 9000
            endif
            call tfreadfm(lfn,list,i1,opts,.true.,kx,irtc)
          else
            go to 9000
          endif
        else
          go to 9000
        endif
      endif
      return
 9000 irtc=itfmessage(9,'General::wrongval',
     $     '"(n*) BinaryDouble, BinaryInteger, BinaryReal, '//
     $     ' BinaryShortInteger, Byte, Character, Expression, '//
     $     ' BinaryFloat, Real, String, or Word is","for 2nd arg"')
      return
      end

      subroutine tfreadfm(lfn,list,m,opts,mult,kx,irtc)
      use tfstk
      use readopt
      implicit none
      type (sad_descriptor) kx,kxi
      type (sad_dlist) list
      type (sad_dlist), pointer ::kl,klx
      integer*4 lfn,irtc,isp0,isp2,kk,m
      logical*4 mult
      type(ropt) opts
      isp2=isp
      do kk=1,m
        isp0=isp
        isp=isp0+2
        if(mult)then
          dtastk(isp)=list%dbody(2)
        else
          dtastk(isp)=list%dbody(kk)
        endif
        call tfreadfs(isp0,lfn,opts,kxi,irtc)
        if(irtc .ne. 0)then
          isp=isp2
          return
        endif
        isp=isp0
        if(ktfsequenceq(kxi%k,kl))then
          call tfgetllstkall(kl)
        else
          isp=isp+1
          dtastk(isp)=kxi
        endif
      enddo
      kx=kxmakelist0(isp2,klx)
      if(mult)then
        klx%head%k=ktfoper+mtfnull
      endif
      irtc=0
      return
      end

      subroutine tfreadstring(isp1,kx,char1,del,irtc)
      use tfstk
      use tfrbuf
      use readopt
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,itfgetlfn,lfn
      logical*4 char1,del
      type(ropt)  opts
      lfn=itfgetlfn(isp1,.true.,irtc)
      call tfreadoptions(isp1,opts,del,irtc)
      if(irtc .eq. 0)then
        call tfreadstringf(lfn,kx,char1,opts,irtc)
      endif
      return
      end

      subroutine tfreadoptions(isp1,opts,del,irtc)
      use tfstk
      use tfrbuf
      use readopt
      implicit none
      integer*4 isp1,irtc,isp0,ispopt,itfmessage
      logical*4 del
      character*64 tfgetstr
      integer*4 nopt
      parameter (nopt=3)
      integer*8 kaopt(nopt)
      character*14 optname(nopt)
      data kaopt/nopt*0/
      data optname/
     $     'WordSeparators',
     $     'ReadNewRecord ',
     $     'NullWords     '/
      type(ropt)  opts
      opts%null=.false.
      opts%new=.true.
      if(del)then
        opts%ndel=5
        opts%delim=' ,'//char(10)//char(9)//char(13)
      else
        opts%ndel=0
      endif
      if(isp .gt. isp1+2)then
        isp0=isp
        call tfgetoptionstk(isp1+3,kaopt,optname,nopt,ispopt,irtc)
        isp=isp0
        if(irtc .ne. 0)then
          return
        endif
        if(ispopt .ne. isp1+3)then
          irtc=itfmessage(9,'General::narg','"2 (+ options)"')
          return
        endif
        opts%opt=.false.
        if(ktfstringq(ktastk(isp0+1)))then
          opts%delim=tfgetstr(ktastk(isp0+1),opts%ndel)
          opts%opt=.true.
        elseif(ktastk(isp0+1) .ne. ktfref)then
          irtc=itfmessage(9,'General::wrongval',
     $         '"Character-string is","for WordSeparators ->"')
          return
        endif
        if(ktfrealq(ktastk(isp0+2)))then
          opts%new=rtastk(isp0+2) .ne. 0.d0
          opts%opt=.true.
        elseif(ktastk(isp0+2) .ne. ktfref)then
          irtc=itfmessage(9,'General::wrongval',
     $         '"True or False is","for ReadNewRecord ->"')
          return
        endif
        if(ktfrealq(ktastk(isp0+3)))then
          opts%null=rtastk(isp0+3) .ne. 0.d0
          opts%opt=.true.
        elseif(ktastk(isp0+3) .ne. ktfref)then
          irtc=itfmessage(9,'General::wrongval',
     $         '"True or False is","for NullWords ->"')
          return
        endif
        if(.not. opts%opt)then
          irtc=itfmessage(9,'General::wrongopt',' ')
        endif
      endif
      return
      end

      subroutine tfreadstringf(lfn,kx,char1,opts,irtc)
      use tfstk
      use tfrbuf
      use tfcsi
      use readopt
      implicit none
      type (sad_descriptor) kx
c      type (sad_string), pointer :: str
      integer*8 ib,is,ie
      integer*4 irtc,lfn,isw,next,nc1,nc,lfni0,isavebuf
      logical*4 char1,fb
      type(ropt) opts
      irtc=0
      isw=1
      lfni0=lfni
      if(lfn .ne. lfni)then
        call tfreadbuf(irbassign,lfn,i00,i00,0)
      endif
      fb=lfn .le. 0 .or. itbuf(lfn) .lt. modestring
 20   call tfreadbuf(irbgetpoint,lfn,ib,is,nc)
c      write(*,*)'tfreadstring ',lfn,ib,is,nc,fb
 10   if(nc .lt. 0)then
        if(.not. fb .or. lfn .gt. 0 .and. lfn .ne. lfni)then
          call tfreadbuf(irbreadrecordbuf,lfn,ib,is,nc)
          if(nc .ge. 0)then
            go to 20
          else
            go to 101
          endif
        else
          nc=isavebuf()
          if(nc .le. 0)then
            if(lfn .eq. 0)then
              go to 101
            endif
            if(opts%new)then
              call tprmptget(-1,-1,0)
              if(ios .ne. 0)then
                go to 101
              endif
              nc=isavebuf()
            else
              nc=0
              go to 1
            endif
          endif
        endif
      endif
      if(nc .eq. 0)then
        if(lfn .eq. 0)then
          kx%k=kxeof
        else
          if(opts%new)then
            if((opts%ndel .gt. 0 .and. .not. opts%null) .or. char1)then
              nc=-1
              go to 10
            endif
            call tfreadbuf(irbeor2bor,lfn,i00,i00,nc)
          endif
          kx=dxnulls
        endif
        go to 1000
      endif
      if(char1)then
        nc1=1
        next=2
      elseif(opts%ndel .gt. 0)then
        call tfword(buffer(is:is+nc-1),opts%delim(1:opts%ndel),
     $       isw,nc1,next,opts%null)
        if(nc1 .le. 0 .and. .not. opts%null)then
          if(opts%new)then
            nc=-1
            go to 10
          else
            nc1=0
            next=nc+1
          endif
        endif
c            write(*,*)'readstringf-word ',is,isw,nc1,next,'''',
c     $           buffer(is+isw-1:is+isw+nc1-2),''''
      else
        nc1=nc
        next=nc+1
      endif
      if(opts%new .and. next .gt. nc)then
        call tfreadbuf(irbbor,lfn,i00,i00,nc)
      else
        call tfreadbuf(irbmovepoint,lfn,i00,i00,next-1)
      endif
      nc=nc1
      ie=is+isw-2+nc
      if(buffer(ie:ie) .eq. char(10))then
        nc=nc-1
      endif
c      write(*,*)'tfrstr-9 ',is,ie,nc,'''',
c     $     buffer(is+isw-1:is+isw-1+nc-1),''''
 1    kx=kxsalocb(-1,buffer(is+isw-1:),nc)
      go to 1000
 101  kx%k=kxeof
 1000 if(lfn .ne. lfni0)then
        call tfreadbuf(irbassign,lfni0,i00,i00,0)
      endif
      return
      end

      subroutine tfreadbyte(isp1,lfn,kx,mode,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,lfn,itfmessage,fgetc,mode,narg,
     $     isp0,ibuf(2),jbuf(4),i,nb,          ispopt
      real*8 rbuf,vx
      real*4 sbuf(2)
      character bbuf(8)
      equivalence (bbuf,rbuf),(rbuf,ibuf),(rbuf,jbuf),(rbuf,sbuf)
      logical*4 opt,little
      integer*4 nopt
      parameter (nopt=1)
      integer*8 kaopt(nopt)
      character*9 optname(nopt)
      data kaopt/nopt*0/
      type (sad_descriptor), save :: itflittle,itfbig
      data itflittle%k,itfbig%k /0,0/
      data optname/
     $     'ByteOrder'/
      narg=isp-isp1
      irtc=0
      if(lfn .eq. 0)then
        kx%k=kxeof
        return
      endif
      if(itflittle%k .eq. 0)then
        itflittle=kxsymbolf('LittleEndian',12,.true.)
        itfbig=kxsymbolf('BigEndian',9,.true.)
      endif
      little=.false.
      if(narg .gt. 2)then
        isp0=isp
        call tfgetoptionstk(isp1+3,kaopt,optname,nopt,ispopt,irtc)
        isp=isp0
       if(irtc .ne. 0)then
          return
        endif
        if(ispopt .ne. isp1+3)then
          irtc=itfmessage(9,'General::narg','"2 (+ options)"')
          return
        endif
        opt=.false.
        if(iand(ktfmask,ktastk(isp0+1)) .eq. ktfsymbol)then
          if(tfsamesymbolq(dtastk(isp0+1),itflittle))then
            little=.true.
            opt=.true.
          elseif(tfsamesymbolq(dtastk(isp0+1),itfbig))then
            little=.false.
            opt=.true.
          else
            irtc=itfmessage(9,'General::wrongval',
     $           '"LittleEndian or BigEndian","for ByteOrder ->"')
          endif
        elseif(iand(ktfmask,ktastk(isp0+1)) .ne. ktfoper)then
          irtc=itfmessage(9,'General::wrongval',
     $         '"LittleEndian or BigEndian","for ByteOrder ->"')
          return
        endif
        if(.not. opt)then
          irtc=itfmessage(9,'General::wrongopt',' ')
          return
        endif
      endif
      nb=mode
      if(mode .eq. 3)then
        nb=4
      elseif(mode .eq. 5)then
        nb=8
      endif
      rbuf=0.d0
      if(little)then
        do i=nb,1,-1
          irtc=fgetc(lfn,bbuf(i))
          if(irtc .ne. 0)then
            go to 101
          endif
        enddo
      else
        do i=1,nb
          irtc=fgetc(lfn,bbuf(i))
          if(irtc .ne. 0)then
            go to 101
          endif
        enddo
      endif
      go to (10,20,30,40,50),mode
 10   vx=ichar(bbuf(1))
      go to 1000
 20   vx=jbuf(1)
      go to 1000
 30   vx=ibuf(1)
      go to 1000
 40   vx=sbuf(1)
      go to 1000
 50   vx=rbuf
 1000 kx=dfromr(vx)
      return
 101  kx%k=kxeof
      irtc=0
      return
      end

      subroutine tfword(str,del,is,nw,next,null)
      implicit none
      integer*4 nw,is,nc,i,next
      character*(*) str,del
      logical*4 null
      nc=len(str)
      if(null)then
        is=1
        if(index(del,str(1:1)) .gt. 0)then
          next=2
          nw=0
          return
        endif
      else
        do i=1,nc
          if(index(del,str(i:i)) .le. 0)then
            is=i
            go to 10
          endif
        enddo
        is=nc+1
        nw=0
        next=nc+1
        return
      endif
 10   do i=is+1,nc
        if(index(del,str(i:i)) .gt. 0)then
          nw=i-is
          next=i+1
          return
        endif
      enddo
      next=nc+1
      nw=next-is
      return
      end

      subroutine tftoexpression(isp1,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      type (sad_string), pointer :: str
      integer*4 isp1,irtc,nc,itfmessage
      if(isp .le. isp1)then
        kx%k=ktfoper+mtfnull
        irtc=0
        return
      endif
      if(isp .gt. isp1+1 .or.
     $     .not. ktfstringq(dtastk(isp),str))then
        kx=dtastk(isp)
        irtc=itfmessage(9,'General::wrongtype','"Character-string"')
        return
      endif
      nc=str%nch
      irtc=0
      if(nc .le. 0)then
        kx%k=ktfoper+mtfnull
        return
      endif
      call tfevalb(str%str(1:nc),nc,kx,irtc)
      return
      end

      subroutine tfopenread(isp1,kx,irtc)
      use tfstk
      use tfcsi
      use tfrbuf
      implicit none
      type (sad_descriptor) kx
      type (sad_string), pointer :: str
      integer*8 ka,kfromr,kfile,mapallocfile,ksize
      integer*4 irtc,isp1,ifile,lfn,itfmessage,nc
      logical*4 disp
      if(isp .ne. isp1+1)then
        irtc=itfmessage(9,'General::narg','"1"')
        return
      endif
      if(ktfstringq(ktastk(isp)))then
        ka=ktfaddr(ktastk(isp))
        call loc_string(ka,str)
        nc=str%nch
        if(nc .le. 0)then
          irtc=itfmessage(9,'General::wrongval',
     $         '"filename or \"!command\"","argument"')
          return
        endif
        disp=.false.
        if(str%str(1:1) .eq. '!')then
          call tfsystemcommand(str%str,nc,kx,irtc)
          if(irtc .ne. 0)then
            return
          endif
          disp=.true.
c          if(str%str(nc:nc) .eq. '&')then
c            lfn=itfopenread(kx,disp,irtc)
c            kx%k=kfromr(dble(lfn))
c            return
c          endif
          call loc_string(ktfaddr(kx),str)
        else
          if(nc .gt. 2) then
             if (str%str(nc-1:nc) .eq. '.z' .or.
     $           str%str(nc-1:nc) .eq. '.Z')then
               call tfuncompress(str%str,nc,kx,irtc)
               if(irtc .ne. 0)then
                 return
               endif
               call loc_string(ktfaddr(kx),str)
               disp=.true.
             endif
          endif
          if(nc .gt. 3) then
             if (str%str(nc-2:nc) .eq. '.gz')then
               call tfungzip(str%str,nc,kx,irtc)
               if(irtc .ne. 0)then
                 return
               endif
               call loc_string(ktfaddr(kx),str)
               disp=.true.
             endif
          endif
          if(nc .gt. 4) then
             if (str%str(nc-3:nc) .eq. '.bz2')then
               call tfunbzip2(str%str,nc,kx,irtc)
               if(irtc .ne. 0)then
                 return
               endif
               call loc_string(ktfaddr(kx),str)
               disp=.true.
             endif
          endif
        endif
        kfile=mapallocfile(str%str,ifile,ksize,irtc)
        if(irtc .ne. 0)then
          irtc=itfmessage(999,'General::fileopen',str%str(1:str%nch))
          kx=dxfailed
        else
          call tfreadbuf(irbopen,lfn,kfile/8,ksize+modemapped,ifile)
          kx%k=kfromr(dble(lfn))
        endif
      endif
      return
      end

      subroutine tfuncompress(cmd,nc,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 irtc,nc
      character*(*) cmd
c      call tfsystemcommand('!uncompress -c '//cmd(:nc),
c     $     nc+15,itx,iax,vx,irtc)
      call tfsystemcommand('!cat '//cmd(:nc)//'|uncompress -c',
     $     nc+19,kx,irtc)
      return
      end

      subroutine tfungzip(cmd,nc,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 irtc,nc
      character*(*) cmd
      call tfsystemcommand('!gzip -dc '//cmd(:nc),
     $     nc+10,kx,irtc)
      return
      end

      subroutine tfunbzip2(cmd,nc,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 irtc,nc
      character*(*) cmd
      call tfsystemcommand('!bzip2 -dc '//cmd(:nc),
     $     nc+11,kx,irtc)
      return
      end

      subroutine tfsystemcommand(cmd,nc,kx,irtc)
      use tfrbuf
      use tfstk
      implicit none
      type (sad_descriptor) kx
      type (sad_descriptor), save :: ntable(1000)
      integer*4 , parameter :: llbuf=1024
      integer*4 irtc,nc,system,itfsyserr,lw,ir,i,m
      integer*4 l
      character post
      character*(*) cmd
      character*(llbuf) buff,tfgetstr
      data ntable(:)%k /1000*0/
      l=nextfn(moderead)
      if(ntable(l)%k .eq. 0)then
        call tftemporaryname(isp,kx,irtc)
        ntable(l)=dtfcopy(kx)
      else
        kx=ntable(l)
        irtc=0
      endif
      buff=tfgetstr(kx,lw)
      post=' '
      m=nc
      do i=nc,1,-1
        m=i
        if(cmd(i:i) .eq. '&')then
          post='&'
          m=i-1
          exit
        elseif(cmd(i:i) .ne. ' ')then
          exit
        endif
      enddo
      ir=system(cmd(2:m)//' > '//buff(:lw)//' '//post)
c      write(*,*)'tfsyscmd ',ir,' ',cmd(2:m),' ',buff(:lw)
      if(ir .lt. 0)then
        irtc=itfsyserr(999)
        return
      endif
      call tpause(10000)
      if(post .eq. '&')then
        call tpause(10000)
      endif
c      ir=system('chmod 777 '//buff(:lw)//char(0))
c      if(ir .lt. 0)then
c        irtc=itfsyserr(999)
c        return
c      endif
      return
      end

      subroutine tfstringtostream(isp1,kx,irtc)
      use tfstk
      use tfrbuf
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,itfmessage,iu,nc
      if(isp .ne. isp1+1)then
        irtc=itfmessage(9,'General::narg','"1"')
        return
      elseif(ktfnonstringq(ktastk(isp)))then
        irtc=itfmessage(9,'General::wrongtype',
     $       '"Character-string"')
        return
      endif
      call tfreadbuf(irbopen,iu,ktfaddr(ktastk(isp)),
     $     modestring,nc)
      if(iu .le. 0)then
        irtc=itfmessage(9,'General::fileopen','"(String)"')
      else
        kx=dfromr(dble(iu))
        irtc=0
      endif
      return
      end

      subroutine tfclosef(k,irtc)
      use tfstk, only:ktfnonrealq
      use tfcode
      use tfrbuf
      implicit none
      type (sad_descriptor) k
      integer*4 irtc,iu,itfmessage,nc
      if(ktfnonrealq(k,iu))then
        irtc=itfmessage(9,'General::wrongtype','"Real number"')
        return
      endif
      call tfreadbuf(irbclose,iu,i00,i00,nc)
      irtc=0
      return
      end

      subroutine tftemporaryname(isp1,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      type (sad_symdef), pointer :: symd
      type (sad_string), pointer :: str
      integer*4 isp1,irtc,lw,i,tftmpnam,getpid,lm,itfmessage
      character*1024 buff
      character*256 machine
      data lm /0/
      save machine
      type (sad_descriptor) ixmachine
      data ixmachine%k /0/
      if(isp .eq. isp1+1)then
        if(ktastk(isp) .ne. ktfoper+mtfnull)then
          irtc=itfmessage(9,'General::wrongval','Null')
          return
        endif
      elseif(isp1 .ne. isp)then
        irtc=itfmessage(9,'General::narg','0')
        return
      endif
      if(ixmachine%k .eq. 0)then
        ixmachine=kxsymbolz('System`$MachineName',19)
      endif
      if(lm .eq. 0)then
        call descr_sad(ixmachine,symd)
        call descr_sad(symd%value,str)
        lm=min(256,str%nch)
        machine(1:lm)=str%str(1:lm)
        do i=1,lm
          if(machine(i:i) .eq. '.')then
            lm=i-1
            exit
          endif
        enddo
      endif
      buff(1:9)='/tmp/tmp_'
      buff(10:10+lm)=machine(:lm)//"_"
      write(buff(11+lm:18+lm),'(I8.8)')getpid()
      buff(19+lm:25+lm)='.XXXXXX'
      buff(26+lm:26+lm)=char(0)
      lw=tftmpnam(buff)
      kx=kxsalocb(-1,buff,lw)
      irtc=0
      return
      end

      subroutine tfseek(isp1,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx,k1
      integer*4 isp1,irtc,lfn,ioff,ls,   ierr
      integer*4 fseek,itfmessage,itfsyserr
      external fseek
      type (sad_descriptor), save :: iabof,iacp
      data iabof%k,iacp%k/0,0/
      if(iabof%k .eq. 0)then
        iabof=kxsymbolf('BeginningOfFile',15,.true.)
        iacp= kxsymbolf('CurrentPosition',15,.true.)
      endif
      if(isp .eq. isp1+2)then
        ls=1
      elseif(isp .ne. isp1+3)then
        go to 9000
      else
        k1=dtastk(isp)
        if(.not. ktfsymbolq(k1))then
          go to 9000
        endif
        if(tfsamesymbolq(k1%k,kxeof))then
          ls=2
        elseif(tfsamesymbolq(k1,iabof))then
          ls=0
        elseif(tfsamesymbolq(k1,iacp))then
          ls=1
        else
          go to 9000
        endif
      endif
      if(.not. ktfrealq(dtastk(isp1+1)) .or.
     $     .not. ktfrealq(dtastk(isp1+2)))then
        go to 9000
      endif
      lfn=int(rtastk(isp1+1))
      ioff=int(rtastk(isp1+2))
      ierr=fseek(lfn,ioff,ls)
      if(ierr .ne. 0)then
        irtc=itfsyserr(9)
      endif
      kx%k=ktfoper+mtfnull
      return
 9000 irtc=itfmessage(9,'General::wrongtype',
     $       '"Seek[fileno,offset,'//
     $       'EndOfFile|BeginningOfFile|CurrentPosition]"')
      return
      end

      subroutine tfflush(isp1,kx,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,narg,lfn,itfmessage,itfgetlfn
      narg=isp-isp1
      if(narg .ne. 1)then
        irtc=itfmessage(9,'General::narg','"1"')
        return
      endif
      lfn=itfgetlfn(isp1,.false.,irtc)
      if(irtc .ne. 0)then
        return
      endif
      endfile(lfn,err=1)
 1    call flush(lfn)
      backspace(lfn,err=10)
 10   irtc=0
      kx%k=ktfoper+mtfnull
      return
      end
