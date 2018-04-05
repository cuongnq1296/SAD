      module version
        character*19, parameter ::
c                     /'1234567890123456789'/
     $     versionid  ='1.1.1.3.3k64       ',
     $     versiondate='5/1/2018 22:00:00  '
        character*25 builtdate
        character*30 startdat
      end module

      program MAIN
      use version
      use maccbk
c      use tfmem, only:talocinit
      use tfmem
      implicit none
c
c
      call fdate1(startdat)
      call buildinfo_get_string('Built:Date', builtdate)
c
      write(*,*)
     $     '*** Welcome to SAD Ver.',versionid(1:len_trim(versionid)),
     $     ' built at ',builtdate(1:len_trim(builtdate)),' ***'
      write(*,*)'*** Today: ',startdat(1:len_trim(startdat)),' ***'
c
      call talocinit
      call inifil
      call initbl
      call tftokinit
      call ktfinitshare
c
      call toplvl
      end
