      subroutine tnorm(r,ceig,lfno)
      implicit none
      integer*4 i,j,k,lfno
      real*8 r(6,6),sa,sb,a,s,smax,cost,sint,s1,s2,s3,r1,b
      complex*16 ceig(6),cc
      do i=1,5,2
        if(imag(ceig(i)) .eq. 0.d0)then
          sa=sum(r(:,i)**2)
          sb=sum(r(:,i+1)**2)
          a=sqrt(sqrt(sa/sb))
          r(:,i  )=r(:,i  )/a
          r(:,i+1)=r(:,i+1)*a
        endif
        s=0.d0
        do j=1,5,2
          s=s+r(j,i)*r(j+1,i+1)-r(j,i+1)*r(j+1,i)
        enddo
        sa=sqrt(abs(s))
        if(s .gt. 0.d0)then
          sb=sa
        elseif(s .eq. 0.d0)then
          if(lfno .ne. 0)then
            write(lfno,*)'???-tnorm-Unstable transfer matrix.'
          endif
          sa=1.d0
          sb=1.d0
        else
          sb=-sa
          ceig(i  )=conjg(ceig(i  ))
          ceig(i+1)=conjg(ceig(i+1))
        endif
        r(:,i  )=r(:,i  )/sa
        r(:,i+1)=r(:,i+1)/sb
      enddo
      s1=(r(5,1)*r(6,2)-r(5,2)*r(6,1))**2
      s2=(r(5,3)*r(6,4)-r(5,4)*r(6,3))**2
      s3=(r(5,5)*r(6,6)-r(5,6)*r(6,5))**2
      smax=max(s1,s2,s3)
      if(smax .eq. s1)then
        j=1
      elseif(smax .eq. s2)then
        j=3
      else
        j=5
      endif
      if(j .ne. 5)then
        do k=1,6
          r1=r(k,5)
          r(k,5)=r(k,j)
          r(k,j)=r1
          r1=r(k,6)
          r(k,6)=r(k,j+1)
          r(k,j+1)=r1
        enddo
        cc=ceig(5)
        ceig(5)=ceig(j)
        ceig(j)=cc
        cc=ceig(6)
        ceig(6)=ceig(j+1)
        ceig(j+1)=cc
      endif
      s1=(r(1,1)*r(2,2)-r(1,2)*r(2,1))**2
      s2=(r(1,3)*r(2,4)-r(1,4)*r(2,3))**2
      if(s2 .gt. s1)then
        do 120 k=1,6
          r1=r(k,1)
          r(k,1)=r(k,3)
          r(k,3)=r1
          r1=r(k,2)
          r(k,2)=r(k,4)
          r(k,4)=r1
120     continue
        cc=ceig(1)
        ceig(1)=ceig(3)
        ceig(3)=cc
        cc=ceig(2)
        ceig(2)=ceig(4)
        ceig(4)=cc
      endif
      do i=1,5,2
        if(imag(ceig(i)) .ne. 0.d0)then
          a=hypot(r(i,i),r(i,i+1))
          cost=r(i,i  )/a
          sint=r(i,i+1)/a
          do j=1,6
            r1=r(j,i)
            r(j,i  )= r1*cost+r(j,i+1)*sint
            r(j,i+1)=-r1*sint+r(j,i+1)*cost
          enddo
        else
          a=r(i,i)
          if(a .ne. 0.d0)then
            b=r(i,i+1)
            do j=1,6
              r(j,i+1)=r(j,i+1)*a-b*r(j,i)
              r(j,i  )=r(j,i  )/a
            enddo
          endif
        endif
      enddo
c     call tsymp(r)
      return
      end
