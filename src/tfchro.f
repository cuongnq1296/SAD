      subroutine tfchro(latt,
     1              alphax,betax,psix,dx,
     1              alphay,betay,psiy,lfno)
      use kyparam
      use tfstk
      use ffs
      use tffitcode
      use ffs_pointer, only:idelc,idvalc,idtypec
      implicit real*8 (a-h,o-z)
      real*8 alphax(nlat),betax(nlat),psix(nlat)
      real*8  alphay(nlat),betay(nlat),psiy(nlat)
      real*8 dx(nlat)
      integer*8 latt(nlat)
      character*12 name
      write(lfno,*)'Element           X Chromaticity   Y Chromaticity'
      gx=0.d0
      gy=0.d0
      do 10 i=1,nlat-1
        k=idtypec(i)
        ali=rlist(idvalc(i)+1)
        if(k .eq. 4 .or. k .eq. 6 .or. k .eq. icmult)then
          if(k .eq. 4)then
            v=rlist(latt(i)+2)
            xix=-( v*betax(i)+(1.d0+alphax(i)**2)/betax(i)*ali+
     1           alphax(i+1)-alphax(i))*.5d0
            xiy=-(-v*betay(i)+(1.d0+alphay(i)**2)/betay(i)*ali+
     1           alphay(i+1)-alphay(i))*.5d0
          elseif(k .eq. 6)then
            v=rlist(latt(i)+2)
            xix= (betax(i)*dx(i)+betax(i+1)*dx(i+1))*v*.5d0
            xiy=-(betay(i)*dx(i)+betay(i+1)*dx(i+1))*v*.5d0
          elseif(k .eq. icmult)then
            v=rlist(latt(i)+ky_K1_MULT)
            xix=-( v*betax(i)+(1.d0+alphax(i)**2)/betax(i)*ali+
     1           alphax(i+1)-alphax(i))*.5d0
            xiy=-(-v*betay(i)+(1.d0+alphay(i)**2)/betay(i)*ali+
     1           alphay(i+1)-alphay(i))*.5d0
            v=rlist(latt(i)+ky_K2_MULT)
            xix=xix+(betax(i)*dx(i)+betax(i+1)*dx(i+1))*v*.5d0
            xiy=xiy-(betay(i)*dx(i)+betay(i+1)*dx(i+1))*v*.5d0
          endif
          call elname(i,name)
          write(lfno,9001)name,xix,xiy
9001      format(1x,a,1x,2f17.3)
          gx=gx+xix
          gy=gy+xiy
        endif
10    continue
      write(lfno,9001)'TOTAL       ',gx,gy
      return
      end
