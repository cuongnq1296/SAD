      integer*8 function ktfmaloc(k,n,m,vec,trans,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) k
      integer*8 ktfmalocp
      integer*4 n,m,irtc
      logical*4 vec,trans
      ktfmaloc=ktfmalocp(k,n,m,vec,trans,.false.,.true.,irtc)
      return
      end

      integer*8 function ktfmalocp(k,n,m,vec,trans,map,err,irtc)
      use tfstk
      use tfshare
      use tmacro
      implicit none
      type (sad_descriptor) k
      type (sad_list), pointer :: kl,kl1,kli
      integer*8 ktaloc,kap,i0,ip,ip0
      integer*4 n,m,irtc,i,j,itfmessage
      logical*4 vec,trans,map,err
c
      ktfmalocp=-9999
c
      if(.not. tflistqd(k,kl))then
        go to 9100
      endif
      if(vec)then
        if(ktfreallistqo(kl))then
          n=kl%nl
          m=0
          if(map .and. nparallel .gt. 1)then
            irtc=1
            kap=ktfallocshared(n)
c            kap=mapalloc8(rlist(0), n, 8, irtc)
          else
            kap=ktaloc(n)
          endif
          rlist(kap:kap+n-1)=kl%rbody(1:n)
c          call tmov(rlist(ka+1),rlist(kap),n)
          ktfmalocp=kap
          irtc=0
          return
        elseif(tfnumberqd(kl%dbody(1)))then
          go to 9000
        endif
      elseif(ktfreallistqo(kl)
     $       .or. tfnonlistqk(kl%body(1),kl1))then
        go to 9000
      endif
      irtc=0
      n=kl%nl
      m=kl1%nl
      do i=1,n
        if(tfnonlistqk(kl%body(i),kli))then
          go to 9000
        endif
        if(kli%nl .ne. m)then
          go to 9000
        endif
        if(ktfnonreallistqo(kli))then
          if(err)then
            irtc=itfmessage(9,'General::wrongtype','"Real matrix"')
          else
            irtc=-1
          endif
          return
        endif
      enddo
      if(map .and. nparallel .gt. 1)then
        irtc=1
        kap=ktfallocshared(m*n)
c        kap=mapalloc8(rlist(0), m*n, 8, irtc)
      else
        kap=ktaloc(m*n)
      endif
      if(kap .lt. 0)then
        irtc=itfmessage(999,'General::memoryfull',' ')
        return
      endif
      if(trans)then
        do i=1,n
          i0=ktfaddr(kl%body(i))
          ip0=kap+(i-1)*m-1
          rlist(ip0+1:ip0+m)=rlist(i0+1:i0+m)
        enddo
      else
        do i=1,n
          i0=ktfaddr(kl%body(i))
          do j=1,m
            ip=kap+(j-1)*n+i-1
            rlist(ip)=rlist(i0+j)
          enddo
        enddo
      endif
      irtc=0
      ktfmalocp=kap
      return
 9000 if(err)then
        irtc=itfmessage(9,'General::wrongtype','"Matrix"')
      else
        irtc=-1
      endif
      return
 9100 if(err)then
        irtc=itfmessage(9,'General::wrongtype',
     $       '"Numerical List or Matrix"')
      else
        irtc=-1
      endif
      return
      end

      subroutine tfl2m(kl,a,n,m,trans)
      use tfstk
      implicit none
      type (sad_list) kl
      type (sad_list), pointer :: kli
      integer*4 n,m,i
      real*8 a(n,m)
      logical*4 trans
      if(trans)then
        do i=1,m
          call loc_list(ktfaddr(kl%body(i)),kli)
          a(:,i)=kli%rbody(1:n)
        enddo
      else
        do i=1,n
          call loc_list(ktfaddr(kl%body(i)),kli)
          a(i,:)=kli%rbody(1:m)
        enddo
      endif
      return
      end

      subroutine tfl2cm(kl,c,n,m,trans,irtc)
      use tfstk
      implicit none
      type (sad_list) kl
      type (sad_list), pointer :: kli
      type (sad_complex), pointer :: cx
      integer*8 kij
      integer*4 n,m,irtc,i,j
      complex*16 c(n,m)
      logical*4 trans
      if(trans)then
        do i=1,m
          call loc_sad(ktfaddr(kl%body(i)),kli)
          do j=1,n
            kij=kli%body(j)
            if(ktfrealq(kij))then
              c(j,i)=kli%rbody(j)
            elseif(tfcomplexqx(kij,cx))then
              c(j,i)=cx%cx(1)
            else
              irtc=-1
              return
            endif
          enddo
        enddo
      else
        do i=1,n
          call loc_sad(ktfaddr(kl%body(i)),kli)
          do j=1,m
            kij=kli%body(j)
            if(ktfrealq(kij))then
              c(i,j)=kli%rbody(j)
            elseif(tfcomplexqx(kij,cx))then
              c(i,j)=cx%cx(1)
            else
              irtc=-1
              return
            endif
          enddo
        enddo
      endif
      irtc=0
      return
      end

      subroutine tfmsize(k,n,m,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) k
      type (sad_list), pointer ::kl,kl1,kli
      integer*4 n,m,irtc,i,itfmessage
      if(.not. tflistqd(k,kl))then
        irtc=itfmessage(9,'General::wrongtype','"List"')
        return
      endif
      if(ktfreallistqo(kl))then
        n=kl%nl
        m=-1
        irtc=0
        return
      endif
      if(tfnonlistqk(kl%body(1),kl1))then
        go to 9000
      endif
      n=kl%nl
      m=kl1%nl
      do i=1,n
        if(tfnonlistqk(kl%body(i),kli))then
          go to 9000
        endif
        if(kli%nl .ne. m)then
          go to 9000
        endif
        if(ktfnonreallistqo(kli))then
          irtc=itfmessage(9,'General::wrongtype','"Real matrix"')
          return
        endif
      enddo
      irtc=0
      return
 9000 irtc=itfmessage(9,'General::wrongtype','"Matrix"')
      return
      end

      integer*8 function ktfcmaloc(k,n,m,vec,trans,err,irtc)
      use tfstk
      implicit none
      type (sad_descriptor) k
      type (sad_complex), pointer :: cxi
      type (sad_list), pointer :: kl,kl1,kli,klj
      integer*8 ktaloc,kap,ki,ip0,kj,kaj
      integer*4 n,m,irtc,i,j,itfmessage
      logical*4 vec,trans,err
      ktfcmaloc=0
      if(.not. tflistqd(k,kl))then
        go to 9100
      endif
      irtc=0
      if(vec)then
        n=kl%nl
        m=0
        if(ktfreallistqo(kl))then
          kap=ktaloc(n*2)
          do i=1,n
            rlist(kap+i*2-2)=kl%rbody(i)
            rlist(kap+i*2-1)=0.d0
          enddo
          ktfcmaloc=kap
          return
        elseif(tfnumberqd(kl%dbody(1)))then
          kap=ktaloc(n*2)
          do i=1,n
            ki=kl%body(i)
            if(ktfrealq(ki))then
              klist(kap+i*2-2)=ki
              klist(kap+i*2-1)=0
            else
              if(tfcomplexqx(ki,cxi))then
                rlist(kap+i*2-2)=cxi%re
                rlist(kap+i*2-1)=cxi%im
              else
                go to 8900
              endif
            endif
          enddo
          ktfcmaloc=kap
          return
        endif
      elseif(ktfreallistqo(kl) .or. tfnumberqd(kl%dbody(1)))then
        go to 9000
      endif
      if(tfnonlistqk(kl%body(1),kl1))then
        ktfcmaloc=-1
        go to 9000
      endif
      irtc=0
      n=kl%nl
      m=kl1%nl
      do i=1,n
        if(tfnonlistqk(kl%body(i),kli))then
          ktfcmaloc=-1
          go to 9000
        endif
        if(kli%nl .ne. m)then
          ktfcmaloc=-1
          go to 9000
        endif
      enddo
      kap=ktaloc(m*n*2)
      if(trans)then
        do i=1,n
          call loc_sad(ktfaddr(kl%body(i)),kli)
          ip0=kap+(i-1)*2*m-2
          if(ktfreallistqo(kli))then
            do j=1,m
              rlist(ip0+j*2  )=kli%rbody(j)
              rlist(ip0+j*2+1)=0.d0
            enddo
          else
            do j=1,m
              kj=kli%body(j)
              if(ktfrealq(kj))then
                klist(ip0+j*2  )=kj
                klist(ip0+j*2+1)=0
              else
                kaj=ktfaddr(kj)
                if(ktflistq(kj,klj)  .and.
     $               klj%head .eq. ktfoper+mtfcomplex .and.
     $               ktfreallistqo(klj) .and. klj%nl .eq. 2)then
                  rlist(ip0+j*2  )=klj%rbody(1)
                  rlist(ip0+j*2+1)=klj%rbody(2)
                else
                  call tfree(kap)
                  ktfcmaloc=-1
                  go to 9000
                endif
              endif
            enddo
          endif
        enddo
      else
        do i=1,n
          call loc_sad(ktfaddr(kl%body(i)),kli)
          if(ktfreallistqo(kli))then
            do j=1,m
              ip0=kap+(j-1)*2*n+i*2-2
              rlist(ip0  )=kli%rbody(j)
              rlist(ip0+1)=0.d0
            enddo
          else
            do j=1,m
              kj=kli%body(j)
              ip0=kap+(j-1)*2*n+i*2-2
              if(ktfrealq(kj))then
                klist(ip0  )=kj
                klist(ip0+1)=0
              else
                kaj=ktfaddr(kj)
                if(ktflistq(kj,klj)  .and.
     $               klj%head .eq. ktfoper+mtfcomplex .and.
     $               ktfreallistqo(klj) .and. klj%nl .eq. 2)then
                  rlist(ip0  )=rlist(kaj+1)
                  rlist(ip0+1)=rlist(kaj+2)
                else
                  call tfree(kap)
                  ktfcmaloc=-1
                  go to 9000
                endif
              endif
            enddo
          endif
        enddo
      endif
      irtc=0
      ktfcmaloc=kap
      return
 8900 call tfree(kap)
      ktfcmaloc=-1
      if(err)then
        irtc=itfmessage(9,'General::wrongtype',
     $       '"Numeric vector"')
      else
        irtc=-1
      endif
      return
 9000 if(err)then
        irtc=itfmessage(9,'General::wrongtype','"Matrix"')
      else
        irtc=-1
      endif
      return
 9100 if(err)then
        irtc=itfmessage(9,'General::wrongtype','"List"')
      else
        irtc=-1
      endif
      return
      end

      integer*8 function ktfc2l(cx,n)
      use tfstk
      implicit none
      integer*8 ktfcm2l
      integer*4 n
      complex*16 cx(n)
      ktfc2l=ktfcm2l(cx,0,n,1,.false.,.false.)
      return
      end

      subroutine nanchecka(a,n,m,ndim,tag,k)
      implicit none
      integer*4 n,m,ndim,i,j,k
      real*8 a(ndim,m)
      character*(*) tag
      logical*4 isnan
      do i=1,m
        do j=1,n
          if(isnan(a(j,i)))then
            write(*,'(2a,3i6,Z18)')'nanchecka ',tag,k,j,i,a(j,i)
            return
          endif
        enddo
      enddo
      return
      end

      integer*8 function ktfcm2l(a,n,m,nd,trans,conj)
      use tfstk
      implicit none
      type (sad_list), pointer :: kl,klx,klxi,klj
      integer*8 kax,kaxi,ktcalocm,kai,kc,kaj
      integer*4 n,m,nd,i,j
      logical*4 trans,conj,c
      real*8 imag_sign
      complex*16 a(nd,m)
      if(conj)then
        imag_sign=-1.d0
      else
        imag_sign=1.d0
      endif
      kc=0
      if(n .eq. 0)then
        kax=ktaaloc(-1,m,klx)
        c=.false.
        do i=1,m
          if(imag(a(1,i)) .eq. 0.d0)then
            klx%rbody(i)=dble(a(1,i))
            if(kc .ne. 0)then
              kai=kc+(i-1)*6
              call tflocal1(kai)
            endif
          else
            if(kc .eq. 0)then
              kc=ktcalocm(m-i+1)-(i-1)*6
            endif
            kai=kc+(i-1)*6
            call loc_list(kai,kl)
            kl%rbody(1)=dble(a(1,i))
            kl%rbody(2)=imag_sign*imag(a(1,i))
            klx%body(i)=ktflist+kai
c            klist(kax+i)=ktflist+ktcalocv(0,dble(a(1,i)),
c     $           imag_sign*imag(a(1,i)))
            c=.true.
          endif
        enddo
        if(c)then
          klx%attr=lconstlist+lnonreallist
        else
          klx%attr=lconstlist
        endif
      else
        if(trans)then
          kax=ktadaloc(-1,m,klx)
          do i=1,m
            kaxi=ktaaloc(0,n,klxi)
            kc=0
            c=.false.
            do j=1,n
              if(imag(a(j,i)) .eq. 0.d0)then
                klxi%rbody(j)=dble(a(j,i))
                if(kc .ne. 0)then
                  kaj=kc+(j-1)*6
                  call tflocal1(kaj)
                endif
              else
                if(kc .eq. 0)then
                  kc=ktcalocm(n-j+1)-(j-1)*6
                endif
                kaj=kc+(j-1)*6
                call loc_list(kaj,klj)
                klj%rbody(1)=dble(a(j,i))
                klj%rbody(2)=imag_sign*imag(a(j,i))
                klxi%body(j)=ktflist+kaj
                c=.true.
              endif
            enddo
            if(c)then
              klxi%attr=lconstlist+lnonreallist
            else
              klxi%attr=lconstlist
            endif
            klx%body(i)=ktflist+kaxi
          enddo
          klxi%attr=ior(klxi%attr,lconstlist)
        else
          kax=ktadaloc(-1,n,klx)
          do i=1,n
            kaxi=ktaaloc(0,m,klxi)
            kc=0
            c=.false.
            do j=1,m
              if(imag(a(i,j)) .eq. 0.d0)then
                klxi%rbody(j)=dble(a(i,j))
                if(kc .ne. 0)then
                  kaj=kc+(j-1)*6
                  call tflocal1(kaj)
                endif
              else
                if(kc .eq. 0)then
                  kc=ktcalocm(m-j+1)-(j-1)*6
                endif
                kaj=kc+(j-1)*6
                call loc_list(kaj,klj)
                klj%rbody(1)=dble(a(i,j))
                klj%rbody(2)=imag_sign*imag(a(i,j))
                klxi%body(j)=ktflist+kaj
                c=.true.
              endif
            enddo
            if(c)then
              klxi%attr=lconstlist+lnonreallist
            else
              klxi%attr=lconstlist
            endif
            klx%body(i)=ktflist+kaxi
          enddo
          klxi%attr=ior(klxi%attr,lconstlist)
        endif
      endif
      ktfcm2l=kax
      return
      end