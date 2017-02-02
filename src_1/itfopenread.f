      integer*4 function itfopenread(k,disp,irtc)
      use tfrbuf
      implicit none 
      type (sad_descriptor) k
      integer*4 irtc,nc,itfmessage,nextfn,in
      character*255 fname,tfgetstr
      logical*4 disp
      itfopenread=-1
      if(.not. ktfstringqd(k))then
        itfopenread=-1
        irtc=itfmessage(9,'General::wrongval',
     $       '"Filename","argument"')
        return
      endif
      fname=tfgetstr(k,nc)
      call texpfn(fname)
      nc=len_trim(fname)
      in=nextfn(0)
      if(in .ne. 0)then
        if(disp)then
          open(in,file=fname(1:nc),status='OLD',err=9000,
     $         disp='DELETE')
        else
          open(in,file=fname(1:nc),status='OLD',err=9000)
        endif
        call tfreadbuf(irbinit,in,int8(2),int8(0),0,' ')
        itfopenread=in
        irtc=0
        return
      endif
 9000 irtc=itfmessage(999,'General::fileopen','"'//fname(1:nc)//'"')
      itfopenread=-2
      return
      end

      integer*4 function itfopenwrite(k,irtc)
      use tfrbuf
      implicit none 
      type (sad_descriptor) k
      integer*4 irtc,nc,i,itfmessage,nextfn
      character*255 fname,tfgetstr
      itfopenwrite=-1
      if(.not. ktfstringqd(k))then
        itfopenwrite=-1
        irtc=itfmessage(9,'General::wrongval',
     $       '"Filename","argument"')
        return
      endif
      fname=tfgetstr(k,nc)
      call texpfn(fname)
      nc=len_trim(fname)
      i=nextfn(0)
      if(i .ne. 0)then
        open(i,file=fname(1:nc),status='UNKNOWN',
c     $       buffercount=16,
     $       err=9000)
        itfopenwrite=i
        irtc=0
        return
      endif
 9000 irtc=itfmessage(999,'General::fileopen','"'//fname(1:nc)//'"')
      itfopenwrite=-2
      return
      end

      integer*4 function itfopenappend(k,irtc)
      use tfrbuf
      implicit none 
      type (sad_descriptor) k
      integer*4 irtc,nc,i,itfmessage,nextfn
      character*255 fname,tfgetstr
      itfopenappend=-1
      if(.not. ktfstringq(k))then
        itfopenappend=-1
        irtc=itfmessage(9,'General::wrongval',
     $       '"Filename","argument"')
        return
      endif
      fname=tfgetstr(k,nc)
      call texpfn(fname)
      nc=len_trim(fname)
      i=nextfn(0)
      if(i .ne. 0)then
        open(i,file=fname,status='UNKNOWN',access='APPEND',
c     $       buffercount=16,
     $       err=9000)
        itfopenappend=i
        irtc=0
        return
      endif
 9000 irtc=itfmessage(999,'General::fileopen','"'//fname(1:nc)//'"')
      itfopenappend=-2
      return
      end