      module sad_main
        use tfstk, only:sad_descriptor,mbody
        integer*4, parameter ::expnsize=7

        type sad_el
        sequence
        integer*4 nl,nlat0
c        type (sad_descriptor) elmv
        integer*8 aux,comp(1:mbody)
        end type

        type sad_comp
        sequence
        integer*4 ncomp2,id
        integer*4 nparam
        logical*1 ldummy1,update,updateseg,ldummy2
        real*8 orient
        type (sad_descriptor) dvalue(1:0)
        integer*8 kvalue(1:0)
        integer*4 ivalue(2,1:0)
        real*8 value(1:mbody)
        end type

        contains
        integer*8 function kmelaloc(n,el)
        use tfstk, only:klist,ktaloc
        use iso_c_binding
        implicit none
        integer*4 n
        type (sad_el), pointer, intent(out) :: el
        kmelaloc=ktaloc(n+1)
        call c_f_pointer(c_loc(klist(kmelaloc-1)),el)
        el%nlat0=n
c        el%elmv%k=0
        el%aux=0
        return
        end function

        integer*8 function kmcompaloc(n,cmp)
        use tfstk, only:klist,ktraaloc
        use iso_c_binding
        implicit none
        integer*4 ,intent(in)::n
        type (sad_comp), pointer, intent(out) :: cmp
        kmcompaloc=ktraaloc(0,n+expnsize+2)+2
        call c_f_pointer(c_loc(klist(kmcompaloc-2)),cmp)
        cmp%ncomp2=n+expnsize+3
        return
        end function

        subroutine loc_el(k,el)
        use tfstk, only:klist
        use iso_c_binding
        implicit none
        integer*8 ,intent(in)::k
        type (sad_el), pointer, intent(out) ::el
        call c_f_pointer(c_loc(klist(k-1)),el)
        return
        end subroutine

        subroutine loc_comp(k,cmp)
        use tfstk, only:klist
        use iso_c_binding
        implicit none
        integer*8 , intent(in)::k
        type (sad_comp), pointer, intent(out) ::cmp
        call c_f_pointer(c_loc(klist(k-2)),cmp)
        return
        end subroutine

        integer*4 function idcomp(el,i)
        implicit none
        type (sad_el),intent(in) :: el
        type (sad_comp), pointer :: cmp
        integer*4 ,intent(in)::i
        call loc_comp(el%comp(i),cmp)
        idcomp=cmp%id
        return
        end

        real*8 function dircomp(el,i)
        implicit none
        integer*4 ,intent(in)::i
        type (sad_el),intent(in) :: el
        type (sad_comp), pointer :: cmp
        call loc_comp(el%comp(i),cmp)
        dircomp=cmp%orient
        return
        end function

      end module

      module tmacro
        use mackw
        use macphys
        use macfile
        real*8, parameter :: c=cveloc,hp=plankr,e=elemch,epsrad=1.d-6,
     $       emminv=1.d-15
        real*8 amass,charge,h0,p0,omega0,trf0,crad,erad,
     $       codin(6),dleng,anrad,urad,u0,vc0,wrfeff,dp0,brho,
     $       ccintr,cintrb,pbunch,coumin,re0,pgev,emidiv,
     $       emidib,emidiq,emidis,ctouck,dvemit,h1emit,
     $       anbunch,tdummy(6),zlost,alost,
     $       taurdx,taurdy,taurdz,fridiv,beamin(21),
     $       vcalpha,vceff,vcacc,dvcacc,ddvcacc,alphap,
     $       pspac_dx,pspac_dy,pspac_dz,dvfs,rcratio,rclassic,brhoz,
     $       bradprev,amom0,circ,hvc0,cuc
        integer*8 ilattp,lspect,ipoltr,ipolb,ipoll,ipolid,ipolo
        integer*4 nflag0,nlat,np0,nturn,isynch,nspect,
     $       lplot,nplot,nuse,nclas,irad,novfl,npelm,ipelm,
     $       nparallel,pspac_nx,pspac_ny,pspac_nz,
     $       pspac_nturn,pspac_nturncalc,l_track
        logical*4 oldflagsdummy,calint,caltouck,tparaed

      end module

      module tffitcode
      implicit none
      integer*4, parameter ::
     $     mfitax=1,mfitbx=mfitax+1,mfitnx=mfitbx+1,
     $     mfitay=mfitnx+1,mfitby=mfitay+1,mfitny=mfitby+1,
     $     mfitex=mfitny+1,mfitepx=mfitex+1,
     $     mfitey=mfitepx+1,mfitepy=mfitey+1,
     $     mfitr1=mfitepy+1,mfitr2=mfitr1+1,
     $     mfitr3=mfitr2+1,mfitr4=mfitr3+1,
     $     mfitdetr=mfitr4+1,
     $     mfitdx=mfitdetr+1,mfitdpx=mfitdx+1,
     $     mfitdy=mfitdpx+1,mfitdpy=mfitdy+1,
     $     mfitdz=mfitdpy+1,mfitddp=mfitdz+1,
     $     mfitaz=mfitddp+1,mfitbz=mfitaz+1,mfitnz=mfitbz+1,
     $     mfitzx=mfitnz+1,mfitzpx=mfitzx+1,
     $     mfitzy=mfitzpx+1,mfitzpy=mfitzy+1,
     $     mfitpex=mfitzpy+1,
     $     mfitpepx=mfitpex+1,
     $     mfitpey=mfitpepx+1,mfitpepy=mfitpey+1,
     $     mfitpzx=mfitpepy+1,
     $     mfitpzpx=mfitpzx+1,
     $     mfitpzy=mfitpzpx+1,mfitpzpy=mfitpzy+1,
     $     mfitgmx=mfitpzpy+1,mfitgmy=mfitgmx+1,
     $     mfitgmz=mfitgmy+1,mfittrx=mfitgmz+1,
     $     mfittry=mfittrx+1,mfitleng=mfittry+1,
     $     mfitgx=mfitleng+1,mfitgy=mfitgx+1,mfitgz=mfitgy+1,
     $     mfitchi1=mfitgz+1,mfitchi2=mfitchi1+1,mfitchi3=mfitchi2+1,
     $     ntwissfun=mfitzpy,mfito=mfittry,mfit=mfitchi3,
     $     mfit1=mfit+12
      logical*4 :: inittws=.true.

      contains
      subroutine tfinittws
      use tfstk
      implicit none
      type (sad_descriptor) kx
      integer*4 irtc
      character*2 strfromis
      if( .not. inittws)then
        return
      endif
      call tfevals('BeginPackage[tws$`];Begin[tws$`]',kx,irtc)
      call tfevals(
     $     ' mfax='//strfromis(mfitax)//
     $     ';mfbx='//strfromis(mfitbx)//
     $     ';mfnx='//strfromis(mfitnx)//
     $     ';mfay='//strfromis(mfitay)//
     $     ';mfby='//strfromis(mfitby)//
     $     ';mfny='//strfromis(mfitny)//
     $     ';mfex='//strfromis(mfitex)//
     $     ';mfepx='//strfromis(mfitepx)//
     $     ';mfey='//strfromis(mfitey)//
     $     ';mfepy='//strfromis(mfitepy)//
     $     ';mfr1='//strfromis(mfitr1)//
     $     ';mfr2='//strfromis(mfitr2)//
     $     ';mfr3='//strfromis(mfitr3)//
     $     ';mfr4='//strfromis(mfitr4)//
     $     ';mfdetr='//strfromis(mfitdetr)//
     $     ';mfdx='//strfromis(mfitdx)//
     $     ';mfdpx='//strfromis(mfitdpx)//
     $     ';mfdy='//strfromis(mfitdy)//
     $     ';mfdpy='//strfromis(mfitdpy)//
     $     ';mfdz='//strfromis(mfitdz)//
     $     ';mfddp='//strfromis(mfitddp)//
     $     ';mfaz='//strfromis(mfitaz)//
     $     ';mfbz='//strfromis(mfitbz)//
     $     ';mfnz='//strfromis(mfitnz)//
     $     ';mfzx='//strfromis(mfitzx)//
     $     ';mfzpx='//strfromis(mfitzpx)//
     $     ';mfzy='//strfromis(mfitzy)//
     $     ';mfzpy='//strfromis(mfitzpy)//
     $     ';mfpex='//strfromis(mfitpex)//
     $     ';mfpepx='//strfromis(mfitpepx)//
     $     ';mfpey='//strfromis(mfitpey)//
     $     ';mfpepy='//strfromis(mfitpepy)//
     $     ';mfpzx='//strfromis(mfitpzx)//
     $     ';mfpzpx='//strfromis(mfitpzpx)//
     $     ';mfpzy='//strfromis(mfitpzy)//
     $     ';mfpzpy='//strfromis(mfitpzpy)//
     $     ';mfgmx='//strfromis(mfitgmx)//
     $     ';mfgmy='//strfromis(mfitgmy)//
     $     ';mfgmz='//strfromis(mfitgmz)//
     $     ';mftrx='//strfromis(mfittrx)//
     $     ';mftry='//strfromis(mfittry)//
     $     ';mfleng='//strfromis(mfitleng)//
     $     ';mfgx='//strfromis(mfitgx)//
     $     ';mfgy='//strfromis(mfitgy)//
     $     ';mfgz='//strfromis(mfitgz)//
     $     ';mfchi1='//strfromis(mfitchi1)//
     $     ';mfchi2='//strfromis(mfitchi2)//
     $     ';mfchi3='//strfromis(mfitchi3)//
     $     ';ntwissfun='//strfromis(ntwissfun)//
     $     ";End[];EndPackage[]",kx,irtc)
      inittws=.false.
      return
      end subroutine

      end module

      module ffs0
      use tfstk,only:sad_descriptor
      use tffitcode
      use tmacro
      implicit none
      integer*4 ndim1
      parameter (ndim1=201)
      integer*4 nelmhash
      parameter (nelmhash=1023)
      real*8 , parameter :: xyth=0.375d0
      integer*4 , parameter :: maxcond=4001,lblname=maxcond/4

      integer*4 , parameter :: lnvev=5,lnelv=4
      type nvev
        sequence
        real*8 valvar,valvar2
        integer*4 itouchele,itouchv,ivvar,ivarele,ivcomp,idummy
      end type

      type nelv
        sequence
        type (sad_descriptor) dcomp
        real*8 vlim(2)
        integer*4 ival,klp
      end type

      type ffsv
        sequence
        integer*8 ifaux,ifibzl,ifmult,iftwissp,
     $       iftwis,ifpos,ifgeo,ifsize,ifgamm,ifcomp,ifcoup,
     $       iferrk,ifele1,ifele2,ifmast,iffserr,
     $       iffssave,iut,ifiprev,ifinext,
     $       ielmhash,ifnvev,ifnelv
        real*8 emx,emy,emz,sigzs,fshifts,
     $       dpmax,geo0(3,4),xixf,xiyf,sizedp,
     $       ctime0,ctime2,rsconv,fitval(maxcond)
        integer*4 mfitp(maxcond),ifitp(maxcond),ifitp1(maxcond),
     $       kdp(maxcond),kfitp(maxcond),kfit(maxcond),
     $       icalc(3,maxcond),iqcol(maxcond),lfp(2,maxcond),
     $       nvar,ntouch,itmax,measp,nfc,ncalc,
     $       blname(lblname),pading,mcommon
        integer*4 ndim,ndima,nele,nfit,marki,iorgx,iorgy,iorgr,
     $       mfpnt,mfpnt1,id1,id2,nve
        logical*4 updatesize,setref
      end type

      type (ffsv), target, save:: ffv
      type (ffsv), pointer :: flv

c$$$ft={
c$$${"TRPT    ","RING    ","trpt"},
c$$${"CELL    ","INS     ","cell"},
c$$${"RFSW    ","        ","rfsw"},
c$$${"RAD     ","        ","rad"},
c$$${"FLUC    ","DAMPONLY","rfluct"},
c$$${"RADCOD  ","        ","radcod"},
c$$${"RADTAPER","        ","radtaper"},
c$$${"KEEPEXP ","        ","keepexp"},
c$$${"CALEXP  ","        ","calexp"},
c$$${"CALC6D  ","CALC4D  ","calc6d"},
c$$${"EMIOUT  ","        ","emiout"},
c$$${"CODPLOT ","        ","codplt"},
c$$${"COD     ","        ","calcod"},
c$$${"INTRA   ","        ","intra"},
c$$${"POL     ","        ","calpol"},
c$$${"RADPOL  ","        ","radpol"},
c$$${"LWAKE   ","        ","lwake"},
c$$${"TWAKE   ","        ","twake"},
c$$${"WSPAC   ","        ","wspac"},
c$$${"SPAC    ","        ","spac"},
c$$${"SELFCOD ","        ","selfcod"},
c$$${"CONV    ","        ","convgo"},
c$$${"STABLE  ","UNSTABLE","cellstab"},
c$$${"GEOCAL  ","GEOFIX  ","geocal"},
c$$${"RADLIGHT","        ","radlight"},
c$$${"PHOTONS ","        ","photons"},
c$$${"LOSSMAP ","        ","lossmap"},
c$$${"SORG    ","        ","sorg"},
c$$${"INTRES  ","        ","intres"},
c$$${"HALFRES ","        ","halfres"},
c$$${"SUMRES  ","        ","sumres"},
c$$${"DIFFRES ","        ","diffres"},
c$$${"FFSPRMPT","        ","ffsprmpt"},
c$$${"CONVCASE","        ","convcase"},
c$$${"PRSVCASE","        ","preservecase"},
c$$${"SUS     ","        ","suspend"},
c$$${"K64     ","LEGACY  ","k64"},
c$$${"GAUSS   ","UNIFORM ","gauss"},
c$$${"FIXSEED ","MOVESEED","fseed"},
c$$${"BIPOL   ","UNIPOL  ","bipol"},
c$$${"PSPAC   ","        ","pspac"},
c$$${"ORBITCAL","        ","orbitcal"},
c$$${"CALOPT  ","ORBONLY ","calopt"},
c$$${"DAPERT  ","        ","dapert"},
c$$${"IDEAL   ","REAL    ","ideal"},
c$$${"FOURIER ","        ","fourie"},
c$$${"TRACKSIZ","        ","trsize"},
c$$${"SIMULATE","OPERATE ","simulate"},
c$$${"ABSW    ","RELW    ","absweit"},
c$$${"JITTER  ","QUIET   ","jitter"},
c$$${"TRGAUSS ","TRUNI   ","trgauss"},
c$$${"BARYCOD ","        ","smearp"},
c$$${"        ","        ","dummyf1"},
c$$${"        ","        ","dummyf2"}
c$$$};
c$$$
c$$$ftt=Thread[ft];
c$$$(Print["     $  ",Null@@Table["'"//#[[k]]//"',",{k,4}]]&/@Partition[#,4])&/@ftt[[{1,2}]];
c$$$Print["     $  ",Null@@Table[#[[k]]//",",{k,4}]]&/@Partition[ftt[[3]],4];
c$$$susp;

      type flagset
        sequence
        logical*4 flags(1:0)
        logical*4
     $       trpt,cell,rfsw,rad,
     $       rfluct,radcod,radtaper,calc6d,
     $       keepexp,calexp,emiout,codplt,
     $       calcod,intra,calpol,radpol,
     $       lwake,twake,wspac,spac,
     $       selfcod,convgo,cellstab,geocal,
     $       radlight,photons,lossmap,sorg,
     $       intres,halfres,sumres,diffres,
     $       ffsprmpt,convcase,preservecase,suspend,
     $       k64,gauss,fseed,bipol,
     $       pspac,orbitcal,calopt,dapert,
     $       ideal,fourie,trsize,simulate,
     $       absweit,jitter,trgauss,smearp
      end type

      integer*4 ,parameter :: nflag=52
      type (flagset), target, save :: fff
      character*8, save :: fname(1:nflag)=(/
     $  'TRPT    ','CELL    ','RFSW    ','RAD     ',
     $  'FLUC    ','RADCOD  ','RADTAPER','CALC6D  ',
     $  'KEEPEXP ','CALEXP  ','EMIOUT  ','CODPLOT ',
     $  'COD     ','INTRA   ','POL     ','RADPOL  ',
     $  'LWAKE   ','TWAKE   ','WSPAC   ','SPAC    ',
     $  'SELFCOD ','CONV    ','STABLE  ','GEOCAL  ',
     $  'RADLIGHT','PHOTONS ','LOSSMAP ','SORG    ',
     $  'INTRES  ','HALFRES ','SUMRES  ','DIFFRES ',
     $  'FFSPRMPT','CONVCASE','PRSVCASE','SUS     ',
     $  'K64     ','GAUSS   ','FIXSEED ','BIPOL   ',
     $  'PSPAC   ','ORBITCAL','CALOPT  ','DAPERT  ',
     $  'IDEAL   ','FOURIER ','TRACKSIZ','SIMULATE',
     $  'ABSW    ','JITTER  ','TRGAUSS ','BARYCOD '/),
     $     sino(1:nflag)=(/
     $  'RING    ','INS     ','        ','        ',
     $  'DAMPONLY','        ','        ','CALC4D  ',
     $  '        ','        ','        ','        ',
     $  '        ','        ','        ','        ',
     $  '        ','        ','        ','        ',
     $  '        ','        ','UNSTABLE','GEOFIX  ',
     $  '        ','        ','        ','        ',
     $  '        ','        ','        ','        ',
     $  '        ','        ','        ','        ',
     $  'LEGACY  ','UNIFORM ','MOVESEED','UNIPOL  ',
     $  '        ','        ','ORBONLY ','        ',
     $  'REAL    ','        ','        ','OPERATE ',
     $  'RELW    ','QUIET   ','TRUNI   ','        '/)

      integer*8, pointer :: ifibzl,ifmult,iftwissp,
     $     iftwis,ifpos,ifgeo,ifsize,ifgamm,ifcomp,ifcoup,
     $     iferrk,ifele1,ifele2,ifmast,iffserr,iffssave,
     $     ifiprev,ifinext,ielmhash,ifnvev,ifnelv
      real*8, pointer :: emx,emy,emz,dpmax,xixf,xiyf,
     $     sizedp,sigzs,fshifts
      real*8, pointer, dimension(:,:) :: geo0
      integer*4, pointer :: ndim,ndima,nele,nfit,marki,iorgx,iorgy,
     $     iorgr,mfpnt,mfpnt1,id1,id2,nve,ntouch
      logical*4 , pointer :: updatesize,setref
      type (nvev), pointer,dimension(:)::nvevx
      type (nelv), pointer,dimension(:)::nelvx

      type ffs_bound
      sequence
      integer*4 lb,le
      real*8 fb,fe
      end type

      contains
        subroutine tffsvinit
        ifibzl=>ffv%ifibzl
        ifmult=>ffv%ifmult
        iftwissp=>ffv%iftwissp
        iftwis=>ffv%iftwis
        ifpos=>ffv%ifpos
        ifgeo=>ffv%ifgeo
        ifsize=>ffv%ifsize
        ifgamm=>ffv%ifgamm
        ifcomp=>ffv%ifcomp
        ifcoup=>ffv%ifcoup
        iferrk=>ffv%iferrk
        ifele1=>ffv%ifele1
        ifele2=>ffv%ifele2
        ifmast=>ffv%ifmast
        iffserr=>ffv%iffserr
        iffssave=>ffv%iffssave
        ifiprev=>ffv%ifiprev
        ifinext=>ffv%ifinext
        emx=>ffv%emx
        emy=>ffv%emy
        emz=>ffv%emz
        dpmax=>ffv%dpmax
        sizedp=>ffv%sizedp
        sigzs=>ffv%sigzs
        fshifts=>ffv%fshifts
        xixf=>ffv%xixf
        xiyf=>ffv%xiyf
        geo0=>ffv%geo0(1:3,1:4)
        ndim=>ffv%ndim
        ndima=>ffv%ndima
        nele=>ffv%nele
        nfit=>ffv%nfit
        marki=>ffv%marki
        iorgx=>ffv%iorgx
        iorgy=>ffv%iorgy
        iorgr=>ffv%iorgr
        mfpnt=>ffv%mfpnt
        mfpnt1=>ffv%mfpnt1
        id1=>ffv%id1
        id2=>ffv%id2
        nve=>ffv%nve
        ifnvev=>ffv%ifnvev
        ifnelv=>ffv%ifnelv
        ielmhash=>ffv%ielmhash
        updatesize=>ffv%updatesize
        ntouch=>ffv%ntouch
        setref=>ffv%setref
        flv=>ffv
        return
        end subroutine

        real*8 function gettwiss(key,lp)
        use tfstk
        implicit none
        integer*4 key,lp
        gettwiss=rlist(iftwis+((key-1)*(2*ndim+1)+ndim)*nlat+lp-1)
        return
        end function

        subroutine r2twiss(r1,r2,r3,r4,rt1,rt2,rt3,rt4)
        implicit none
        real*8 , intent (in) :: r1,r2,r3,r4
        real*8 , intent (out) :: rt1,rt2,rt3,rt4
        real*8 detr,trr,detr1,alambda,sqrdet1,detr2,a
        detr=r1*r4-r2*r3
        trr=r1+r4
        detr1=2.d0*(1.d0-detr)
        if(trr .ge. 0.d0)then
          alambda=detr1/(trr+sqrt(trr**2+2.d0*detr1))
        else
          alambda=detr1/(trr-sqrt(trr**2+2.d0*detr1))
        endif
        sqrdet1=sqrt(1.d0+xyth-detr)
        rt1=(r1+alambda)*sqrdet1
        rt2=r2*sqrdet1
        rt3=r3*sqrdet1
        rt4=(r4+alambda)*sqrdet1
        detr2=rt1*rt4-rt2*rt3
        do while(detr2 .lt. 1.d0)
          a=1.d0/sqrt(detr2)
          rt1=rt1*a
          rt2=rt2*a
          rt3=rt3*a
          rt4=rt4*a
          detr2=rt1*rt4-rt2*rt3
        enddo
        return
        end subroutine

        subroutine dr2dtwiss(r1,r2,r3,r4,dr1,dr2,dr3,dr4,
     $     drt1,drt2,drt3,drt4)
        implicit none
        real*8 , intent (in) :: r1,r2,r3,r4,dr1,dr2,dr3,dr4
        real*8 , intent (out) :: drt1,drt2,drt3,drt4
        real*8 detr,trr,detr1,alambda,sqrdet1,d,
     $       ddetr,dtrr,ddetr1,dalambda,dsqrdet1,dd,e
        detr=r1*r4-r2*r3
        ddetr=dr1*r4+r1*dr4-dr2*r3-r2*dr3
        trr=r1+r4
        dtrr=dr1+dr4
        detr1=2.d0*(1.d0-detr)
        ddetr1=-2.d0*ddetr
        if(trr .ge. 0.d0)then
          d=sqrt(trr**2+2.d0*detr1)
        else
          d=-sqrt(trr**2+2.d0*detr1)
        endif
        dd=(dtrr*trr+ddetr1)/d
        e=1.d0/(trr+d)
        alambda=detr1*e
        dalambda=(ddetr1-detr1*e*(dtrr+dd))*e
        sqrdet1=sqrt(1.d0+xyth-detr)
        dsqrdet1=-.5d0*ddetr/sqrdet1
        drt1=(dr1+dalambda)*sqrdet1+(r1+alambda)*dsqrdet1
        drt2=dr2*sqrdet1+r2*dsqrdet1
        drt3=dr3*sqrdet1+r3*dsqrdet1
        drt4=(dr4+dalambda)*sqrdet1+(r4+alambda)*dsqrdet1
        return
        end subroutine

        subroutine twiss2r(rt1,rt2,rt3,rt4,r1,r2,r3,r4,cc)
        implicit none
        real*8 , intent (in)  :: rt1,rt2,rt3,rt4
        real*8 , intent (out) :: r1,r2,r3,r4,cc
        real*8 detr,trr1,detr1,alambda,sqrdet1
        detr=rt1*rt4-rt2*rt3
        sqrdet1=sqrt(detr)
        trr1=(rt1+rt4)/sqrdet1
        detr1=2.d0*(detr-xyth)
        if(trr1 .ge. 0.d0)then
          alambda=detr1/
     $         (trr1+sqrt(max(0.d0,trr1**2-2.d0*detr1)))
        else
          alambda=detr1/
     $         (trr1-sqrt(max(0.d0,trr1**2-2.d0*detr1)))
        endif
        r1=rt1/sqrdet1-alambda
        r2=rt2/sqrdet1
        r3=rt3/sqrdet1
        r4=rt4/sqrdet1-alambda
        cc=sqrt(detr-xyth)
        return
        end subroutine

        subroutine dtwiss2dr(rt1,rt2,rt3,rt4,
     $     drt1,drt2,drt3,drt4,dr1,dr2,dr3,dr4,dcc)
        implicit none
        real*8 , intent (in)  :: rt1,rt2,rt3,rt4,
     $       drt1,drt2,drt3,drt4
        real*8 , intent (out) :: dr1,dr2,dr3,dr4,dcc
        real*8 detr,trr1,detr1,alambda,sqrdet1,d,dd,e,cc,
     $       ddetr,dtrr1,ddetr1,dalambda,dsqrdet1
        detr=rt1*rt4-rt2*rt3
        ddetr=drt1*rt4+rt1*drt4-drt2*rt3-rt2*drt3
        sqrdet1=sqrt(detr)
        dsqrdet1=.5d0*ddetr/sqrdet1
        detr1=2.d0*(detr-xyth)
        ddetr1=2.d0*ddetr
        trr1=(rt1+rt4)/sqrdet1
        dtrr1=((drt1+drt4)-trr1*dsqrdet1)/sqrdet1
        if(trr1 .ge. 0.d0)then
          d=sqrt(max(0.d0,trr1**2-2.d0*detr1))
        else
          d=-sqrt(max(0.d0,trr1**2-2.d0*detr1))
        endif
        dd=(trr1*dtrr1-ddetr1)/d
        e=1.d0/(trr1+d)
        alambda=detr1*e
        dalambda=(ddetr1-detr1*(dtrr1+dd)*e)*e
        dr1=(drt1-rt1*dsqrdet1/sqrdet1)/sqrdet1-dalambda
        dr2=(drt2-rt2*dsqrdet1/sqrdet1)/sqrdet1
        dr3=(drt3-rt3*dsqrdet1/sqrdet1)/sqrdet1
        dr4=(drt4-rt4*dsqrdet1/sqrdet1)/sqrdet1-dalambda
        cc=sqrt(detr-xyth)
        dcc=.5d0*ddetr/cc
        return
        end subroutine

        integer*8 function ktatwissaloc(mode,kl)
        use tfstk
        use tffitcode
        implicit none
        type (sad_rlist), pointer,intent(out)::kl
        integer*4 ,intent(in):: mode
        integer*8 kax
        kax=ktraaloc(mode,28,kl)
        kl%rbody(mfitbz)=1.d0
        ktatwissaloc=kax
        return
        end function

      end module

      module ffs_flag
        use ffs0, only:fff
        logical*4, pointer ::flags(:),
     $       trpt,cell,rfsw,rad,
     $       rfluct,radcod,radtaper,calc6d,
     $       keepexp,calexp,emiout,codplt,
     $       calcod,intra,calpol,radpol,
     $       lwake,twake,wspac,spac,
     $       selfcod,convgo,cellstab,geocal,
     $       radlight,photons,lossmap,sorg,
     $       intres,halfres,sumres,diffres,
     $       ffsprmpt,convcase,preservecase,suspend,
     $       k64,gauss,fseed,bipol,
     $       pspac,orbitcal,calopt,dapert,
     $       ideal,fourie,trsize,simulate,
     $       absweit,jitter,trgauss,smearp
        
        contains
        subroutine ffs_init_flag
        flags=>fff%flags
        rad=>fff%rad
        rfsw=>fff%rfsw
        radcod=>fff%radcod
        calcod=>fff%calcod      
        trpt=>fff%trpt
        emiout=>fff%emiout
        gauss=>fff%gauss
        bipol=>fff%bipol
        intra=>fff%intra
        cell=>fff%cell
        fseed=>fff%fseed
        dapert=>fff%dapert
        ideal=>fff%ideal
        codplt=>fff%codplt
        convgo=>fff%convgo
        calpol=>fff%calpol
        rfluct=>fff%rfluct
        k64=>fff%k64
        fourie=>fff%fourie
        ffsprmpt=>fff%ffsprmpt
        trsize=>fff%trsize
        simulate=>fff%simulate
        absweit=>fff%absweit
        jitter=>fff%jitter
        trgauss=>fff%trgauss
        lwake=>fff%lwake
        twake=>fff%twake
        smearp=>fff%smearp
        radpol=>fff%radpol
        calc6d=>fff%calc6d
        keepexp=>fff%keepexp
        calexp=>fff%calexp
        cellstab=>fff%cellstab
        spac=>fff%spac
        radlight=>fff%radlight
        geocal=>fff%geocal
        photons=>fff%photons
        wspac=>fff%wspac
        selfcod=>fff%selfcod
        pspac=>fff%pspac
        convcase=>fff%convcase
        preservecase=>fff%preservecase
        lossmap=>fff%lossmap
        orbitcal=>fff%orbitcal
        radtaper=>fff%radtaper
        sorg=>fff%sorg
        intres=>fff%intres
        halfres=>fff%halfres
        sumres=>fff%sumres
        diffres=>fff%diffres
        calopt=>fff%calopt
        suspend=>fff%suspend
        return
        end subroutine

        integer*4 function ndivrad(phi,ak,bz,eps)
        use tmacro, only:h0
        implicit none
        real*8 , parameter :: arad=0.02d0
        real*8 , intent(in)::ak,bz,phi,eps
        real*8 aka,eps1
        eps1=eps
        if(eps1 .le. 0.d0)then
          eps1=1.d0
        endif
        aka=(abs(phi)+abs(dcmplx(ak,bz))*arad)/eps1
        if(trpt)then
          ndivrad=int(1.d0+h0/100.d0*aka*10.d0)
        else
          ndivrad=int(1.d0+h0/100.d0*aka)
        endif
        return
        end function 

      end module

      module ffs
        use ffs0
        use ffs_flag

        contains
        subroutine limitcod(cod)
        real*8 , intent(inout)::cod(6)
        real*8 , parameter :: omax=1.d5,dpmin=-1.d0+1.d-5,
     $       pmax=1.d5,zmax=1.d100
        real*8 ptmax
        cod(6)=max(dpmin,min(pmax,cod(6)))
        ptmax=1.d0+cod(6)
        cod(1)=max(-omax,min(omax,cod(1)))
        cod(3)=max(-omax,min(omax,cod(3)))
        cod(2)=max(-ptmax,min(ptmax,cod(2)))
        cod(4)=max(-ptmax,min(ptmax,cod(4)))
        cod(5)=max(-zmax,min(zmax,cod(5)))
        return
        end subroutine
      end module

      module ffs_pointer
      use sad_main
      implicit none
      real*8 , pointer, contiguous :: errk(:,:),couple(:)
      integer*8, pointer, dimension(:) :: kele2 
      integer*4, pointer, dimension(:) :: mult,icomp,iele1,
     $     master,iprev,inext
      integer*4, pointer, contiguous, dimension(:,:) :: ibzl
      real*8 , pointer :: pos(:), gammab(:)
      real*8 , pointer , contiguous :: twiss(:,:,:),twiss2(:,:),
     $     geo(:,:,:),beamsize(:,:)
      integer*4 , pointer, contiguous :: itwissp(:)
      integer*8 , pointer :: latt(:)
      real*8 , pointer , contiguous :: utwiss(:,:,:)
      type (sad_el), pointer :: elatt

      contains
        subroutine ffs_init_pointer
        use tfstk
        use ffs
        use iso_c_binding
        implicit none
        call c_f_pointer(c_loc(ilist(1,ifibzl)),ibzl,[3,nlat])
        call c_f_pointer(c_loc(rlist(ifcoup)),couple,[nlat])
        call c_f_pointer(c_loc(rlist(iferrk)),errk,[2,nlat])
        call c_f_pointer(c_loc(ilist(1,ifmult)),mult,[nlat])
        call c_f_pointer(c_loc(ilist(1,ifmast)),master,[nlat])
c        call c_f_pointer(c_loc(ilist(1,ifival)),ival,[nele])
c        call c_f_pointer(c_loc(dlist(ifdcomp)),dcomp,[nele])
        call c_f_pointer(c_loc(ilist(1,ifcomp)),icomp,[nlat])
        call c_f_pointer(c_loc(ilist(1,ifele1)),iele1,[nlat])
        call c_f_pointer(c_loc(klist(ifele2)),kele2,[nlat])
c        call c_f_pointer(c_loc(ilist(1,ifklp)),klp,[nele])
        call c_f_pointer(c_loc(ilist(1,ifiprev)),iprev,[nlat])
        call c_f_pointer(c_loc(ilist(1,ifinext)),inext,[nlat])
        call c_f_pointer(c_loc(klist(ifnvev)),nvevx,[nve])
        call c_f_pointer(c_loc(klist(ifnelv)),nelvx,[nele])
        return
        end subroutine

        subroutine ffs_init_sizep
        use tfstk
        use ffs
        use iso_c_binding
        implicit none
        if(ifsize .eq. 0)then
          ifsize=ktaloc(21*nlat)
          call c_f_pointer(c_loc(rlist(ifsize)),beamsize,[21,nlat])
          updatesize=.false.
        endif
        return
        end subroutine

        subroutine ffs_twiss_pointer
        use tfstk
        use ffs
        use iso_c_binding
        implicit none
        call c_f_pointer(c_loc(klist(ilattp+1)),latt,[nlat])
        call c_f_pointer(c_loc(rlist(iftwis)),twiss,
     $       [nlat,(2*ndim+1),ntwissfun])
        twiss(1:nlat,-ndim:ndim,1:ntwissfun)=>twiss
        twiss2(1:nlat*(2*ndim+1),1:ntwissfun)=>twiss
        call c_f_pointer(c_loc(rlist(ifpos)),pos,[nlat])
        call c_f_pointer(c_loc(rlist(ifgeo)),geo,[3,4,nlat])
        call c_f_pointer(c_loc(rlist(ifgamm)),gammab,[nlat])
        call c_f_pointer(c_loc(ilist(1,iftwissp)),itwissp,[nlat])
        return
        end subroutine

        integer*4 function idelc(i)
        implicit none
        integer*4 i
        idelc=idcomp(elatt,i)
        return
        end function

        integer*4 function idtypec(i)
        use maccbk, only:idtype
        implicit none
        integer*4 ,intent(in)::i
        idtypec=idtype(idcomp(elatt,i))
        return
        end function

        integer*4 function idtypecx(i)
        use maccbk, only:idtype
        use maccode
        use tmacro, only:nlat
        implicit none
        integer*4 i
        if(i .le. 0 .or. i .ge. nlat)then
          idtypecx=icNull
        else
          idtypecx=idtype(idcomp(elatt,i))
        endif
        return
        end function

        integer*8 function idvalc(i)
        use maccbk, only:idval
        implicit none
        integer*4 i
        idvalc=idval(idcomp(elatt,i))
        return
        end function

        integer*4 function lpnamec(i)
        use maccbk
        implicit none
        integer*4 i
        lpnamec=lpname(idcomp(elatt,i))
        return
        end function

        subroutine compelc(i,cmp)
        use sad_main
        implicit none
        type (sad_comp),pointer, intent(out) :: cmp
        integer*4,intent(in)::i
        call loc_comp(elatt%comp(i),cmp)
        return
        end subroutine

        character*(MAXPNAME) function pnamec(i)
        use maccbk, only:pname,MAXPNAME
        implicit none
        integer*4,intent(in)::i
        pnamec=pname(idcomp(elatt,i))
        return
        end function

        real*8 function direlc(i)
        implicit none
        integer*4,intent(in)::i
        type (sad_comp), pointer :: cmp
        call loc_comp(elatt%comp(i),cmp)
        direlc=cmp%orient
        return
        end function

        subroutine setdirelc(i,v)
        implicit none
        integer*4 ,intent(in)::i
        real*8 ,intent(in)::v
        type (sad_comp), pointer :: cmp
        call loc_comp(elatt%comp(i),cmp)
        cmp%orient=v
        return
        end subroutine

        integer*4 function nextl(i)
        use tmacro, only:nlat
        use mackw
        implicit none
        integer*4 i,it,i1,k
        type (sad_comp), pointer :: cmp
        i1=i+1
 1      if(i1 .ge. nlat)then
          nextl=nlat
        else
          it=idtypec(i1)
          k=kytbl(kwOFFSET,it)
          if(k .ne. 0)then
            call loc_comp(elatt%comp(i1),cmp)
            if(cmp%value(k) .ne. 0.d0)then
              i1=i1+1
              go to 1
            endif
          endif
          nextl=i1
        endif
        return
        end function

        real*8 function tfvalvar(i,k) result(v)
        implicit none
        type (sad_comp), pointer :: cmps
        integer*4 i,k
        call compelc(i,cmps)
        v=cmps%value(k)
        return
        end function

        subroutine tsetfringep(cmp,ic,dir,akk,table)
        use mackw
        implicit none
        type (sad_comp) cmp
        integer*4 ic
        real*8 dir,akk,table(4),f1in,f1out,f2in,f2out
        f1in =cmp%value(kytbl(kwF1,ic))
     $       +cmp%value(kytbl(kwF1K1F,ic))
        f1out=cmp%value(kytbl(kwF1,ic))
     $       +cmp%value(kytbl(kwF1K1B,ic))
        f2in =cmp%value(kytbl(kwF2,ic))
     $       +cmp%value(kytbl(kwF2K1F,ic))
        f2out=cmp%value(kytbl(kwF2,ic))
     $       +cmp%value(kytbl(kwF2K1B,ic))
        if(dir .ge. 0.d0)then
          table(1)=-abs(akk*f1in*f1in)/24.d0
          table(2)= abs(akk)*f2in
          table(3)=-abs(akk*f1out*f1out)/24.d0
          table(4)= abs(akk)*f2out
        else
          table(3)=-abs(akk*f1in*f1in)/24.d0
          table(4)= abs(akk)*f2in
          table(1)=-abs(akk*f1out*f1out)/24.d0
          table(2)= abs(akk)*f2out
        endif
        return
        end subroutine

        subroutine tsetfringepe(cmp,ic,dir,table)
        use mackw
        implicit none
        type (sad_comp) cmp
        integer*4 ic
        real*8 dir,table(4),f1in,f1out,f2in,f2out
        if(cmp%value(kytbl(kwL,ic)) .ne. 0.d0)then
          if(cmp%value(kytbl(kwK1,ic)) .ne. 0.d0 .or.
     $         kytbl(kwSK1,ic) .ne. 0 .and.
     $         cmp%value(kytbl(kwSK1,ic)) .ne. 0.d0)then
            f1in =cmp%value(kytbl(kwF1,ic))
     $           +cmp%value(kytbl(kwF1K1F,ic))
            f1out=cmp%value(kytbl(kwF1,ic))
     $           +cmp%value(kytbl(kwF1K1B,ic))
            f2in =cmp%value(kytbl(kwF2,ic))
     $           +cmp%value(kytbl(kwF2K1F,ic))
            f2out=cmp%value(kytbl(kwF2,ic))
     $           +cmp%value(kytbl(kwF2K1B,ic))
            if(dir .ge. 0.d0)then
              table(1)=f1in
              table(2)=f2in
              table(3)=f1out
              table(4)=f2out
            else
              table(3)=f1in
              table(4)=f2in
              table(1)=f1out
              table(2)=f2out
            endif
          else
            table=0.d0
          endif
        else
          table=0.d0
        endif
        return
        end subroutine

      end module

      module tparastat
        use sad_main
        use tmacro
        real*8, save :: rstat(2,icMARK)=0.d0
        logical*4, save :: lstat(2,icMARK)=.true.

        contains

        logical*4 function tparacheck(l,cmp)
        use ffs_flag
        implicit none
        type (sad_comp) :: cmp
        integer*4 l

        select case (l)
        case (icMULT,icCAVI)
          tparacheck=rstat(1,l) .ne. amass .or.
     $         rstat(2,l) .ne. charge .or.
     $         lstat(1,l) .neqv. trpt
          if(tparacheck)then
            rstat(1,l)=amass
            rstat(2,l)=charge
            lstat(1,l)=trpt
          else
            tparacheck=.not. cmp%update
          endif

        case default
          tparacheck=.not. cmp%update

        end select
        return
        end function

        subroutine tpara(cmp)
        use kyparam
        use tfstk
        use ffs_pointer, only:idelc,idvalc,compelc,tsetfringep
        use ffs_flag, only:trpt
        use mathfun, only:akang
        implicit none
        type (sad_comp) , intent(inout):: cmp
        integer*4 ltyp
        real*8 phi,al,psi1,psi2,theta,dtheta,w,akk,sk1,
     $       fb1,fb2,harm,vnominal,frmd,
     $       cchi1,cchi2,cchi3,schi1,schi2,schi3
        complex*16 cr1
        cmp%update=.true.
        ltyp=idtype(cmp%id)
        if(kytbl(kwNPARAM,ltyp) .eq. 0)then
          return
        endif
        select case (ltyp)
        case (icBEND)
          al=cmp%value(ky_L_BEND)
          phi=cmp%value(ky_ANGL_BEND)
          if(cmp%orient .gt. 0.d0)then
            psi1=cmp%value(ky_E1_BEND)*phi+cmp%value(ky_AE1_BEND)
            psi2=cmp%value(ky_E2_BEND)*phi+cmp%value(ky_AE2_BEND)
            fb1=cmp%value(ky_F1_BEND)+cmp%value(ky_FB1_BEND)
            fb2=cmp%value(ky_F1_BEND)+cmp%value(ky_FB2_BEND)
          else
            psi1=cmp%value(ky_E2_BEND)*phi+cmp%value(ky_AE2_BEND)
            psi2=cmp%value(ky_E1_BEND)*phi+cmp%value(ky_AE1_BEND)
            fb2=cmp%value(ky_F1_BEND)+cmp%value(ky_FB1_BEND)
            fb1=cmp%value(ky_F1_BEND)+cmp%value(ky_FB2_BEND)
          endif
          if(cmp%value(ky_FRMD_BEND) .le. 0.d0)then
            if(cmp%value(ky_FRMD_BEND) .ne. -1.d0)then
              fb1=0.d0
            endif
            if(cmp%value(ky_FRMD_BEND) .ne. -2.d0)then
              fb2=0.d0
            endif
          endif
          w=phi-psi1-psi2
          if((fb1 .ne. 0.d0 .or. fb2 .ne. 0.d0) .and.
     1         al .ne. 0.d0 .and. phi .ne. 0.d0)then
            al=al-((phi*fb1)**2+(phi*fb2)**2)/al/48.d0
     1           *sin(.5d0*w)/sin(.5d0*phi)
          endif
          cmp%value(p_L_BEND)=al
          dtheta=cmp%value(ky_DROT_BEND)
          theta=cmp%value(ky_ROT_BEND)
          cmp%value(p_PSI1_BEND)=psi1
          cmp%value(p_PSI2_BEND)=psi2
          cmp%value(p_COSPSI1_BEND)=cos(psi1)
          cmp%value(p_SINPSI1_BEND)=sin(psi1)
          cmp%value(p_COSPSI2_BEND)=cos(psi2)
          cmp%value(p_SINPSI2_BEND)=sin(psi2)
          cmp%value(p_COSTHETA_BEND)=cos(theta)
          cmp%value(p_SINTHETA_BEND)=sin(theta)
          cmp%value(p_COSW_BEND)=cos(w)
          cmp%value(p_SINW_BEND)=sin(w)
          if(cmp%value(p_COSW_BEND) .ge. 0.d0)then
            cmp%value(p_SQWH_BEND)=cmp%value(p_SINW_BEND)**2
     $           /(1.d0+cmp%value(p_COSW_BEND))
          else
            cmp%value(p_SQWH_BEND)=1.d0-cmp%value(p_COSW_BEND)
          endif
          cmp%value(p_SINWP1_BEND)=sin(phi-psi2)
c          cmp%value(p_DPHIX_BEND)=phi*sin(.5d0*dtheta)**2
c          cmp%value(p_DPHIY_BEND)=.5d0*phi*sin(dtheta)
          cmp%value(p_THETA_BEND)=theta
          cmp%value(p_FB1_BEND)=fb1
          cmp%value(p_FB2_BEND)=fb2

        case (icQUAD)
          al=cmp%value(ky_L_QUAD)
          theta=cmp%value(ky_ROT_QUAD)
          cmp%value(p_THETA2_QUAD)=theta
     $         +akang(dcmplx(cmp%value(ky_K1_QUAD),0.d0),al,cr1)
          if(al .ne. 0.d0)then
            akk=cmp%value(ky_K1_QUAD)/al
            call tsetfringep(cmp,icQUAD,cmp%orient,akk,
     $           cmp%value(p_AKF1F_QUAD:p_AKF2B_QUAD))
          else
            cmp%value(p_AKF1F_QUAD:p_AKF2B_QUAD)=0.d0
          endif
          frmd=cmp%value(ky_FRMD_QUAD)
          if(cmp%orient .lt. 0.d0)then
            frmd=frmd*(11.d0+frmd*(2.d0*frmd-9.d0))/2.d0
          endif
          cmp%value(p_FRMD_QUAD)=frmd

        case (icSEXT,icOCTU,icDECA,icDODECA)
          theta=cmp%value(ky_ROT_THIN)
          cmp%value(p_COSTHETA_THIN)=cos(theta)
          cmp%value(p_SINTHETA_THIN)=sin(theta)
          cmp%value(p_THETA_THIN)=theta

        case (icUND)
          call undinit(cmp%value(1),cmp%value(p_PARAM_UND))

        case (icWIG)
          call twigp()

        case (icMULT)
          al=cmp%value(ky_L_MULT)
          phi=cmp%value(ky_ANGL_MULT)
          if(cmp%orient .gt. 0.d0)then
            psi1=cmp%value(ky_E1_MULT)*phi+cmp%value(ky_AE1_MULT)
            psi2=cmp%value(ky_E2_MULT)*phi+cmp%value(ky_AE2_MULT)
            fb1=cmp%value(ky_FB1_MULT)
            fb2=cmp%value(ky_FB2_MULT)
          else
            psi1=cmp%value(ky_E2_MULT)*phi+cmp%value(ky_AE2_MULT)
            psi2=cmp%value(ky_E1_MULT)*phi+cmp%value(ky_AE1_MULT)
            fb2=cmp%value(ky_FB1_MULT)
            fb1=cmp%value(ky_FB2_MULT)
          endif
          frmd=cmp%value(ky_FRMD_MULT)
          if(cmp%orient .lt. 0.d0)then
            frmd=frmd*(11.d0+frmd*(2.d0*frmd-9.d0))/2.d0
          endif
          cmp%value(p_FRMD_MULT)=frmd
          if(frmd .ne. 3.d0 .and. frmd .ne. 1.d0)then
            fb1=0.d0
          endif
          if(frmd .ne. 3.d0 .and. frmd .ne. 2.d0)then
            fb2=0.d0
          endif
          w=phi-psi1-psi2
          if((fb1 .ne. 0.d0 .or. fb2 .ne. 0.d0) .and.
     1         al .ne. 0.d0 .and. phi .ne. 0.d0)then
            al=al-((phi*fb1)**2+(phi*fb2)**2)/al/48.d0
     $           *sin(.5d0*w)/sin(.5d0*phi)
          endif
          cmp%value(p_L_MULT)=al
          cmp%value(p_ANGL_MULT)=phi
          cmp%value(p_PSI1_MULT)=psi1
          cmp%value(p_PSI2_MULT)=psi2
          cmp%value(p_FB1_MULT)=fb1
          cmp%value(p_FB2_MULT)=fb2
          if(al .ne. 0.d0)then
            sk1=cmp%value(ky_SK1_MULT)
            if(sk1 .eq. 0.d0)then
              akk=cmp%value(ky_K1_MULT)/al
            else
              akk=hypot(cmp%value(ky_K1_MULT),sk1)/al
c              akk=sqrt(cmp%value(ky_K1_MULT)**2+sk1**2)/al
            endif
            call tsetfringep(cmp,icMULT,cmp%orient,akk,
     $           cmp%value(p_AKF1F_MULT:p_AKF2B_MULT))
          else
            cmp%value(p_AKF1F_MULT:p_AKF2B_MULT)=0.d0
          endif
          harm=cmp%value(ky_HARM_MULT)
          if(harm .eq. 0.d0)then
            w=pi2*cmp%value(ky_FREQ_MULT)/c
          else
            w=omega0*harm/c
          endif
          if(trpt)then
            vnominal=cmp%value(ky_VOLT_MULT)/amass*abs(charge)
     $           *sin(-cmp%value(ky_PHI_MULT)*sign(1.d0,charge))
          else
            vnominal=0.d0
          endif
          cmp%value(p_W_MULT)=w
          cmp%value(p_VNOMINAL_MULT)=vnominal
          cmp%value(p_THETA2_MULT)=cmp%value(ky_ROT_MULt)+
     $         cmp%value(ky_DROT_MULT)+
     $         akang(dcmplx(cmp%value(ky_K1_MULT),
     $         cmp%value(ky_SK1_MULT)),al,cr1)
          cmp%value(p_CR1_MULT)=dble(cr1)
          cmp%value(p_CR1I_MULT)=imag(cr1)

        case (icCAVI)
          frmd=cmp%value(ky_FRMD_CAVI)
          if(cmp%orient .lt. 0.d0)then
            frmd=frmd*(11.d0+frmd*(2.d0*frmd-9.d0))/2.d0
          endif
          cmp%value(p_FRMD_CAVI)=frmd
          harm=cmp%value(ky_HARM_CAVI)
          if(harm .eq. 0.d0)then
            w=pi2*cmp%value(ky_FREQ_CAVI)/c
          else
            w=omega0*harm/c
          endif
          if(trpt)then
            vnominal=cmp%value(ky_VOLT_CAVI)/amass*abs(charge)
     $           *sin(-cmp%value(ky_PHI_CAVI)*sign(1.d0,charge))
          else
            vnominal=0.d0
          endif
          cmp%value(p_W_CAVI)=w
          cmp%value(p_VNOMINAL_CAVI)=vnominal

        case (icBEAM)
          call bbinit(cmp%value(1),cmp%value(p_PARAM_BEAM))

        case (icPROT)
          call phsinit(cmp%value(1),cmp%value(p_PARAM_Prot))

        case (icSOL)
          cchi1=cos(cmp%value(ky_CHI1_SOL))
          cchi2=cos(cmp%value(ky_CHI2_SOL))
          cchi3=cos(cmp%value(ky_CHI3_SOL))
          schi1=sin(cmp%value(ky_CHI1_SOL))
          schi2=sin(cmp%value(ky_CHI2_SOL))
          schi3=sin(cmp%value(ky_CHI3_SOL))
          cmp%value(p_R11_SOL)= cchi1*cchi3+schi1*schi2*schi3
          cmp%value(p_R12_SOL)=-cchi2*schi3
          cmp%value(p_R13_SOL)= schi1*cchi3-cchi1*schi2*schi3
          cmp%value(p_R21_SOL)=-schi1*schi2*cchi3+cchi1*schi3
          cmp%value(p_R22_SOL)= cchi2*cchi3
          cmp%value(p_R23_SOL)= cchi1*schi2*cchi3+schi1*schi3
          cmp%value(p_R31_SOL)=-schi1*cchi2
          cmp%value(p_R32_SOL)=-schi2
          cmp%value(p_R33_SOL)= cchi1*cchi2

        case default
        end select
        return
        end subroutine

        subroutine tclrpara
        use mackw
        use tmacro
        use ffs_pointer, only:compelc
        implicit none
        type (sad_comp), pointer :: cmp
        integer*4 i
        do i=1,nlat-1
          call compelc(i,cmp)
          cmp%update=cmp%nparam .le. 0
        enddo
        tparaed=.false.
        return
        end subroutine

      end module

      module ffs_fit
      use ffs, only:ntwissfun,maxcond
      use tffitcode, only:mfit1
      type ffs_stat
        real*8 tracex,tracey,tracez
        logical*4 stabx,staby,stabz,over
      end type
      integer*4 , parameter :: ndimmax=500
      type (ffs_stat) optstat(-ndimmax:ndimmax)
      integer*4 iuid(-ndimmax:ndimmax),
     $     jfam(-ndimmax:ndimmax),kfam(-ndimmax:ndimmax)
      real*8 dp(-ndimmax:ndimmax),scale(mfit1),
     $     dfam(4,-ndimmax:ndimmax),residual(-ndimmax:ndimmax),
     $     uini(ntwissfun,-ndimmax:ndimmax),wfit(maxcond),
     $     wiq(maxcond)
      logical*4 fitflg,geomet,inicond,chgini
      integer*4 nut,nfam,nfam1,nfr,nqcol,nqcol1,nfcol,nfc0
      real*8 wexponent,offmw,etamax,avebeta,wsum
      character*8 , save :: nlist(1:mfit1)=(/
     $     'AX      ','BX      ','NX      ',
     $     'AY      ','BY      ','NY      ',
     $     'EX      ','EPX     ','EY      ','EPY     ',
     $     'R1      ','R2      ','R3      ','R4      ','DETR    ',
     $     'DX      ','DPX     ','DY      ','DPY     ',
     $     'DZ      ','DDP     ',
     $     'AZ      ','BZ      ','NZ      ',
     $     'ZX      ','ZPX     ','ZY      ','ZPY     ',
     1     'PEX     ','PEPX    ','PEY     ','PEPY    ',
     1     'PZX     ','PZPX    ','PZY     ','PZPY    ',
     $     'GMX     ','GMY     ','GMZ     ',
     $     'TRX     ','TRY     ',
     $     'LENG    ',
     $     'GX      ','GY      ','GZ      ',
     $     'CHI1    ','CHI2    ','CHI3    ',
     $     'DEX     ','DEPX    ','DEY     ','DEPY    ',
     $     'DDX     ','DDPX    ','DDY     ','DDPY    ',
     $     'PDEX    ','PDEPX   ','PDEY    ','PDEPY   '/)
      end module

      module ffs_wake
      integer*8 kwakep,kwakeelm
      integer*4 nwakep
      logical*4 wake
      integer*8 , pointer :: kwaketbl(:,:)
      integer*4 , pointer :: iwakeelm(:)
      end module

      module tflinepcom
      use tfstk
      implicit none
      integer*8, save :: iflinep=0,ifinitlinep=0,ifelementp=0,
     $     ifelementkeyp=0,iftypekeyp=0
      type (sad_descriptor) ksdumm

      contains

      integer*4 function itftypekey(i,word1,lw1,kx)
      use tfstk
      implicit none
      type (sad_descriptor) , optional,intent(out)::kx
      type (sad_descriptor) ks,ka
      integer*4 i,isp0,lw1,irtc
      character*(lw1) word1
      isp0=isp
      ktastk(isp0+1)=iftypekeyp
      rtastk(isp0+2)=dble(i)
      isp=isp0+3
      ks=kxsalocb(-1,word1,lw1)
      dtastk(isp)=ks
      levele=levele+1
      call tfefunref(isp0+1,ka,.false.,irtc)
      call tfconnect(ka,irtc)
      isp=isp0
      if(irtc .ne. 0)then
        call tfreseterror
        itftypekey=0
      elseif(ktflistq(ka))then
        itftypekey=-1
        if(present(kx))then
          kx=ka
        endif
      elseif(ktfrealq(ka))then
        itftypekey=ifromd(ka)
      else
        itftypekey=0
      endif        
      return
      end function

      integer*4 function itfelementkey(i,word1,lw1)
      use tfstk
      implicit none
      type (sad_descriptor) kx,ks
      integer*4 i,isp0,lw1,irtc
      character*(lw1) word1
      isp0=isp
      ktastk(isp0+1)=ifelementkeyp
      rtastk(isp0+2)=dble(i)
      isp=isp0+3
      ks=kxsalocb(-1,word1,lw1)
      dtastk(isp)=ks
      levele=levele+1
      call tfefunref(isp0+1,kx,.false.,irtc)
      call tfconnect(kx,irtc)
      isp=isp0
      if(irtc .ne. 0)then
        call tfreseterror
        itfelementkey=0
      elseif(.not. ktfrealq(kx))then
        itfelementkey=0
      else
        itfelementkey=ifromd(kx)
      endif        
      return
      end function

      subroutine tftypekey(isp1,kx,irtc)
      use tfstk
      use maccbk
      use maccode
      use mackw
      implicit none
      type (sad_descriptor) kx
      real*8 c
      integer*4 ic,isp0,isp1,irtc,itfmessage
      if(isp .ne. isp1+1)then
        irtc=itfmessage(9,'General::narg','"1"')
        return
      endif
      if(.not. ktfrealq(dtastk(isp),c))then
        irtc=itfmessage(9,'General::wrongtype',
     $       '"Typecode for #1"')
        return
      endif
      ic=int(c)
      if(ic .lt. 0 .or. ic .gt. icMXEL)then
        irtc=itfmessage(9,'General::wrongval',
     $       '"Typecode out of range"')
        return
      endif
      isp0=isp
      call tftypekeystk(ic,.true.)
      kx=kxmakelist(isp0)
      isp=isp0
      irtc=0
      return
      end subroutine

      subroutine tftypekeystk(ic,all)
      use tfstk
      use mackw
      implicit none
      type (sad_descriptor) kx
      integer*4 ic,i,isp0
      logical*4 all
      character*(MAXPNAME) key,tfkwrd,tfkwrd1
      do i=1,kytbl(kwMAX,ic)-1
        key=tfkwrd(ic,i)
        if(all .or. key .ne. '-')then
          isp=isp+1
          if(key .eq. '-')then
            dtastk(isp)=ksdumm
          else
            dtastk(isp)=kxsalocb(-1,key,len_trim(key))
            if(kyindex1(i,ic) .ne. 0)then
              key=tfkwrd1(ic,i)
              isp0=isp
              isp=isp+1
              dtastk(isp)=kxsalocb(-1,key,len_trim(key))
              kx=kxmakelist(isp0-1)
              isp=isp0
              dtastk(isp)=kx
            endif
          endif
        endif
      enddo
      return
      end subroutine

      type (sad_descriptor) function tfkeyv(i,keyword,ia,cmp,ref,saved)
      use tfstk
      use ffs
      use tffitcode
      use ffs_pointer, only:idelc,elatt,idtypec,idvalc,sad_comp,
     $     compelc,iele1
      implicit none
      type (sad_rlist), pointer :: kld,klr
      integer*4 i,it,kl,l,j,lk,lenw
      integer*8 ia
      character*(*) keyword
      character*128 key
      logical*4 saved,plus,ref
      real*8 s
      type (sad_comp), pointer :: cmp
c     begin initialize for preventing compiler warning
      if(i .gt. 0)then
        kl=i
      else
        kl=nelvx(-i)%klp
      endif
      call compelc(kl,cmp)
      plus=.false.
      lk=lenw(keyword)
      if(lk .gt. 4 .and. keyword(lk-3:lk) .eq. '$SUM')then
        plus=.true.
        lk=lk-4
      endif
      key(1:lk)=keyword(1:lk)
      it=idtype(cmp%id)
      do l=1,kytbl(kwMAX,it)-1
        j=kyindex(l,it)
        if(j .gt. 0)then
          if(pname(kytbl(j,0))(2:) .eq. key(1:lk))then
            go to 1
          endif
          j=kyindex1(l,it)
          if(j .gt. 0)then
            if(pname(kytbl(j,0))(2:) .eq. key(1:lk))then
              go to 1
            endif
          endif
        endif
      enddo
      ia=0
      tfkeyv%k=0
      return
 1    if(i .gt. 0)then
        ia=elatt%comp(i)+l
        tfkeyv=dlist(ia)
        if(.not. ref)then
          call tftouch(iele1(i),l)
        endif
      elseif(saved)then
        ia=idvalc(kl)+l
        tfkeyv=dlist(ia)
      else
        ia=elatt%comp(kl)+l
        if(l .eq. nelvx(-i)%ival)then
          if(tfreallistq(dlist(ia),klr))then
            tfkeyv=kxavaloc(-1,klr%nl,kld)
            kld%rbody(1:klr%nl)=klr%rbody(1:klr%nl)
     $           /rlist(iferrk+(kl-1)*2)
          else
            tfkeyv=dlist(ia)
          endif
        else
          tfkeyv=dlist(ia)
        endif
        if(.not. ref)then
          call tftouch(iele1(kl),l)
        endif
      endif
      if(plus .and. tfreallistq(tfkeyv,klr))then
c        s=klr%rbody(1)
c        do i=2,klr%nl
c          s=s+klr%rbody(i)
c        enddo
        s=sum(klr%rbody(1:klr%nl))
        tfkeyv=dfromr(s)
      endif
      return
      end function

      subroutine tftouch(i,iv)
      use ffs
      use ffs_pointer
      implicit none
      integer*4 iv,j,i
      do j=1,flv%ntouch
        if(nvevx(j)%itouchele .eq. i .and. nvevx(j)%itouchv .eq. iv)then
          return
        endif
      enddo
      call tffsnvealloc(flv%ntouch+1)
      flv%ntouch=flv%ntouch+1
      nvevx(flv%ntouch)%itouchele=i
      nvevx(flv%ntouch)%itouchv=iv
      return
      end subroutine

      subroutine elcompl(i,kl)
      use tfstk
      use ffs
      use ffs_pointer
      implicit none
      type (sad_rlist), pointer,intent(out) :: kl
      integer*4 ,intent(in)::i
      integer*4 l,isp1
      if(nelvx(i)%dcomp%k .eq. 0)then
        isp1=isp
        do l=1,nlat-1
          if(iele1(l) .eq. i)then
            isp=isp+1
            rtastk(isp)=dble(l)
          endif
        enddo
        nelvx(i)%dcomp=dtfcopy(kxmakelist(isp1,kl))
        isp=isp1
      else
        call descr_sad(nelvx(i)%dcomp,kl)
      endif
      return
      end subroutine

      end module

      module ffs_seg
      contains
        logical*4 function tcheckseg(cmp,ltyp,al,lsegp,irtc) result(seg)
        use tfstk
        use mackw
        use sad_main
        use kyparam
        implicit none
        type (sad_comp) ,intent(in)::cmp
        type (sad_dlist) , pointer :: lprof,lsegp
        real*8 , intent(out)::al
        integer*4 ,intent(out)::irtc
        integer*4 ,intent(in)::ltyp
        integer*4 kl,kprof
        irtc=0
        seg=.false.
        kl=kytbl(kwL,ltyp)
        if(kl .eq. 0)then
          al=0.d0
          return
        else
          al=cmp%value(kl)
        endif
        kprof=kytbl(kwPROF,ltyp)
        if(kprof .eq. 0 .or. tfnonlistq(cmp%dvalue(kprof),lprof))then
          return
        endif
        if(.not. cmp%updateseg)then
          call tsetupseg(cmp,lprof,lsegp,irtc)
          if(irtc .ne. 0)then
            return
          endif
        else
          call descr_sad(cmp%dvalue(p_PROF_MULT),lsegp)
        endif
        seg=.true.
        return
        end function

        subroutine tsetupseg(cmp,lprof,lsegp,irtc)
        use tfstk
        use kyparam
        use mackw
        use tflinepcom
        use sad_main
        implicit none
        type (sad_comp) ::cmp
        type (sad_rlist) , pointer :: lvl
        type (sad_dlist) , pointer :: lsegp,lpi,lprof,lpi1,lk1
        type (sad_string), pointer :: stri1,stri2
        integer*4 ltyp,lls,i,nseg,irtc,itfmessage,l,itfdownlevel,
     $       isp0,i1,nk
        integer*4 ,parameter :: nc=ky_PROF_MULT-1
        logical*4 defk(nc,nc)
        irtc=0
        ltyp=idtype(cmp%id)
        isp0=isp
        select case (ltyp)
        case (icMULT)
          defk=.false.
          nseg=0
          lls=0
          levele=levele+1
          do i=1,lprof%nl
            if(tfnonlistq(lprof%dbody(i),lpi) .or. lpi%nl .lt. 2)then
              go to 9100
            endif
            if(tflistq(lpi%dbody(1),lpi1))then
              if(lpi1%nl .gt. 2 .or. lpi1%nl .le. 0)then
                go to 9100
              endif
              if(.not. ktfstringq(lpi1%dbody(1),stri1))then
                go to 9100
              endif
              if(lpi1%nl .eq. 1)then
                stri2=>stri1
              elseif(.not. ktfstringq(lpi1%dbody(2),stri2))then
                go to 9100
              endif
            elseif(ktfstringq(lpi%dbody(1),stri1))then
              stri2=>stri1
            else
              go to 9100
            endif
            if(tfnonreallistq(lpi%dbody(2),lvl))then
              go to 9100
            endif
            if(nseg .eq. 0)then
              nseg=lvl%nl
            elseif(lvl%nl .ne. nseg)then
              irtc=itfmessage(99,"FFS::unequalkeyleng",'""')
              go to 9000
            endif
            isp=isp+1
            itastk(1,isp)=itftypekey(icMULT,stri1%str,stri1%nch)
            itastk(2,isp)=itftypekey(icMULT,stri2%str,stri2%nch)
            if(itastk(1,isp) .le. 0 .or. itastk(1,isp) .gt. nc .or.
     $           itastk(2,isp) .le. 0 .or. itastk(2,isp) .gt. nc)then
              irtc=itfmessage(99,"FFS::wrongkey",'""')
              go to 9000
            elseif(defk(itastk(1,isp),itastk(2,isp)))then
              call tfdebugprint(lprof%dbody(i),
     $             'Dupricated Key in '//
     $             pname(cmp%id)(1:lpname(cmp%id)),3)
              irtc=itfmessage(99,"FFS::dupkey",'""')
              go to 9000
            endif
            defk(itastk(1,isp),itastk(2,isp))=.true.
            dtastk2(isp)=lpi%dbody(2)
            if(stri1%str(1:stri1%nch) .eq. 'L')then
              lls=isp
            endif
          enddo
          if(lls .eq. 0)then
            irtc=itfmessage(99,"FFS::noLseg",'""')
            go to 9000
          endif
          nk=isp-isp0
          if(tfnonlistq(cmp%dvalue(p_PROF_MULT),lsegp) .or.
     $         lsegp%nl .ne. nk)then
            call tflocald(cmp%dvalue(p_PROF_MULT))
            cmp%dvalue(p_PROF_MULT)=kxadaloc(0,nk,lsegp)
            lsegp%dbody(1:nk)%k=ktfoper+mtfnull
          endif
          call tflocald(lsegp%dbody(1))
          lsegp%dbody(1)=kxadaloc(0,2,lk1)
          lk1%dbody(1)=dtastk(lls)
          lk1%dbody(2)=dtfcopy(dtastk2(lls))
          i1=1
          do i=isp0+1,isp
            if(i .ne. lls .and. itastk(1,i) .eq. itastk(2,i))then
              i1=i1+1
              call tflocald(lsegp%dbody(i1))
              lsegp%dbody(i1)=kxadaloc(0,2,lk1)
              lk1%dbody(1)=dtastk(i)
              lk1%dbody(2)=dtfcopy(dtastk2(i))
            endif
          enddo
          do i=isp0+1,isp
            if(i .ne. lls .and. itastk(1,i) .ne. itastk(2,i))then
              i1=i1+1
              call tflocald(lsegp%dbody(i1))
              lsegp%dbody(i1)=kxadaloc(0,2,lk1)
              lk1%dbody(1)=dtastk(i)
              lk1%dbody(2)=dtfcopy(dtastk2(i))
            endif
          enddo
          cmp%updateseg=.true.
 9000     l=itfdownlevel()
          isp=isp0
          return
 9100     l=itfdownlevel()
          isp=isp0
          irtc=itfmessage(99,"FFS::wrongkeylist",'""')
        case default
          cmp%updateseg=.true.
        end select
        return
        end

        subroutine tfvcopycmp(cmps,cmpd,k,coeff)
        use tfstk
        use mackw
        use kyparam
        use sad_main
        implicit none
        type (sad_comp) :: cmps,cmpd
        real*8 coeff
        integer*4 k
        if(ktfrealq(cmps%dvalue(k)))then
          if(ktfnonrealq(cmpd%dvalue(k)))then
            call tflocald(cmpd%dvalue(k))
          endif
          cmpd%value(k)=cmps%value(k)*coeff
        elseif(tflistq(cmps%dvalue(k)))then
          if(ktfnonrealq(cmpd%dvalue(k)))then
            call tflocald(cmpd%dvalue(k))
          endif
          cmpd%dvalue(k)=dtfcopy1(cmps%dvalue(k))
          if(idtype(cmpd%id) .eq. icMULT .and.
     $         k .eq. ky_PROF_MULT)then
            cmpd%updateseg=.false.
          endif
        endif
        cmpd%update=cmpd%nparam .le. 0
        return
        end subroutine

        subroutine tfvcopy(is,id,k,coeff)
        use tfstk
        use mackw
        use kyparam
        use sad_main
        use ffs_pointer
        implicit none
        type (sad_comp), pointer :: cmps,cmpd
        real*8 coeff
        integer*4 is,id,k
        call compelc(id,cmpd)
        call compelc(is,cmps)
        call tfvcopycmp(cmps,cmpd,k,coeff)
        if(idtype(cmpd%id) .eq. icMULT .and.
     $       k .eq. ky_PROF_MULT)then
          cmpd%updateseg=.false.
        endif
        cmpd%update=cmpd%nparam .le. 0
        return
        end subroutine

        subroutine tfvcopycmpall(cmps,cmpd,n)
        use tfstk
        use mackw
        use sad_main
        implicit none
        type (sad_comp) :: cmps,cmpd
        integer*4 k,n
        do k=1,n
          call tfvcopycmp(cmps,cmpd,k,1.d0)
        enddo
        return
        end subroutine

        real*8 function tfvcmp(cmps,k) result(v)
        use mackw
        use tfstk
        use sad_main
        implicit none
        type (sad_comp) :: cmps
        type (sad_rlist), pointer :: las
        integer*4 j,k
        if(ktfnonrealq(cmps%dvalue(k),v))then
          if(tfreallistq(cmps%dvalue(k),las))then
            v=las%rbody(1)
            do j=2,las%nl
              v=v+las%rbody(j)
            enddo
          endif
        endif
        return
        end function

        subroutine tfsetcmp(v,cmpd,i)
        use mackw
        use tfstk
        use sad_main
        implicit none
        type (sad_comp) :: cmpd
        type (sad_rlist), pointer :: lad
        integer*4 i,k
        real*8 r0,v
        if(ktfrealq(cmpd%dvalue(i)))then
          cmpd%value(i)=v
        elseif(tfreallistq(cmpd%dvalue(i),lad))then
          r0=lad%rbody(1)
          do k=2,lad%nl
            r0=r0+lad%rbody(k)
          enddo
          if(r0 .ne. 0.d0)then
            lad%rbody(1:lad%nl)=v/r0*lad%rbody(1:lad%nl)
          else
            do k=1,lad%nl
              lad%rbody(k)=v/lad%nl
            enddo
          endif
        endif
        return
        end subroutine

      end module

      subroutine tffs
      use tfstk
      use tfcsi
      implicit none
      type (sad_descriptor) kx
      integer*4 irtc
      logical*4 err
      call tffsa(1,lfni,kx,irtc)
      if(irtc .ne. 0 .and. ierrorprint .ne. 0)then
        call tfreseterror
      endif
      call tffssaveparams(-1,0,err)
      return
      end

      subroutine tffsinitparam
      use kyparam
      use tfstk
      use ffs
      use ffs_pointer
      use tffitcode
      implicit none
      type (sad_descriptor) kdp
      type (sad_symdef), pointer :: symddp
      integer*8 j
      real*8 rgetgl1
      j=idvalc(1)
      emx=rlist(j+ky_EMIX_MARK)
      if(emx .le. 0.d0)then
        emx=rgetgl1('EMITX')
      else
        call rsetgl1('EMITX',emx)
      endif
      emy=rlist(j+ky_EMIY_MARK)
      if(emy .le. 0.d0)then
        emy=rgetgl1('EMITY')
      else
        call rsetgl1('EMITY',emy)
      endif
      emz=rlist(j+ky_EMIY_MARK)
      if(emz .le. 0.d0)then
        emz=rgetgl1('EMITZ')
      else
        call rsetgl1('EMITZ',emz)
      endif
      sizedp=rlist(j+ky_SIGE_MARK)
      if(sizedp .le. 0.d0)then
        sizedp=rgetgl1('SIGE')
      else
        call rsetgl1('SIGE',sizedp)
      endif
      sigzs=max(0.d0,rlist(j+ky_SIGZ_MARk))
      if(sigzs .le. 0.d0)then
        sigzs=rgetgl1('SIGZ')
      else
        call rsetgl1('SIGZ',sigzs)
      endif
      dpmax=max(0.d0,rlist(j+ky_DP_MARk))
      kdp=kxsymbolz('DP',2,symddp)
      if(dpmax .le. 1.d-30)then
        dpmax=rfromd(symddp%value)
      endif
      if(dpmax .le. 1.d-30)then
        dpmax=0.01d0
      endif
      symddp%value=dfromr(dpmax)
      if(rlist(latt(1)+ky_BX_MARK) .le. 0.d0)then
        rlist(latt(1)+ky_BX_MARK)=1.d0
      endif
      if(rlist(latt(1)+ky_BY_MARK) .le. 0.d0)then
        rlist(latt(1)+ky_BY_MARK)=1.d0
      endif
      if(rlist(latt(1)+ky_BZ_MARK) .le. 0.d0)then
        rlist(latt(1)+ky_BZ_MARK)=1.d0
      endif
      return
      end

      subroutine tffs_init_elmv
      use tfstk
      use ffs
      use ffs_pointer
      implicit none
c      type (sad_dlist) , pointer ::kl
c      elatt%elmv%k=ktadalocnull(0,nele,kl)
c      do i=1,nele
c        l=ilist(i,ifmult)
c        id=ilist(1,l)
cc
c
      return
      end

      subroutine tffsalloc()
      use tfstk
      use ffs
      use ffs_pointer
      use tffitcode
      use sad_main
      implicit none
      integer*4 ntwis
      marki=1
      nlat=elatt%nlat0+1
      latt(1:nlat)=>elatt%comp(1:nlat)
      if(idtypec(1) .ne. icMARK)then
        write(*,*)'The first element must be a MARK element.'
        call abort
      endif
      call tfhashelement
      call tffs_init_nele
      ifibzl =ktaloc(nlat*3/2+2)
      ifcoup=ktaloc(nlat)
      iferrk=ktaloc(nlat*2)
      ifmast =ktaloc(nlat/2+1)
      ifcomp =ktaloc(nlat/2+1)
      ifele2=ktaloc(nlat)
      ifiprev =ktaloc(nlat/2+1)
      ifinext =ktaloc(nlat/2+1)
      nve=0
      call tffsnvealloc(nele)
      ndim=1
      ndima=ndim*2+1
      ntwis =nlat*ndima
      iftwis=ktaloc(ntwis*ntwissfun)
      ifpos =ktaloc(nlat)
      ifgeo =ktaloc(nlat*12)
      ifgamm=ktaloc(nlat)
      iftwissp=ktaloc(nlat/2+1)
      ifnelv=ktaloc(nele*lnelv)
      call ffs_init_pointer
      nelvx(1:nele)%dcomp%k=i00
      call ffs_twiss_pointer
      call tfinit
      ifsize=0
c      iwakepold=ktaloc(16)
c      ifwakep=iwakepold
c      call tclr(rlist(iwakepold),16)
c      ilist(1,iwakepold)=1
c      ilist(2,iwakepold)=italoc(3)
c      rlist(ilist(2,iwakepold))=0.d0
c      rlist(iwakepold+1)=0.d0
c      ilist(1,iwakepold+2)=1
c      ilist(2,iwakepold+2)=italoc(3)
c      ilist(1,iwakepold+5)=ndim
c      ilist(2,iwakepold+5)=nlat
c      ilist(1,iwakepold+6)=int(iftwis)
c      ilist(2,iwakepold+6)=int(ifsize)
      return
      end

      subroutine tffs_init_nele
      use tfstk
      use ffs
      use ffs_pointer
      implicit none
      integer*8 j
      integer*4 i,l,k,itehash
      ifele1=ktaloc(nlat/2+1)
      ifmult=ktaloc(nlat/2+1)
      nele=0
      LOOP_L: do l=1,nlat-1
        j=ielmhash+itehash(pnamec(l),MAXPNAME)*2
        LOOP_K: do k=1,ilist(1,j+1)
          i=ilist(1,k+klist(j+2)-1)
          if(i .ge. l)then
            exit LOOP_K
          endif
          if(idelc(i) .eq. idelc(l))then
            ilist(l,ifele1)=ilist(i,ifele1)
            cycle LOOP_L
          endif
        enddo LOOP_K
        nele=nele+1
        ilist(nele,ifmult)=l
        ilist(l,ifele1)=nele
      enddo LOOP_L
c      if(elatt%elmv%k .eq. 0)then
c        call tffs_init_elmv
c      endif
      return
      end subroutine

      subroutine tffsnvealloc(nv)
      use tfstk
      use ffs
      use ffs_pointer
      use iso_c_binding
      implicit none
      integer*4 , intent(in)::nv
      integer*4 nve0
      integer*8 ifnvev1
      if(nv .lt. nve)then
        return
      endif
      nve0=nve
      nve=max(nv,nve0+128)
      ifnvev1=ktaloc(nve*lnvev)
      if(nve0 .ne. 0)then
        klist(ifnvev1:ifnvev1+nve-1)=klist(ifnvev:ifnvev+nve-1)
        call tfree(ifnvev)
      endif
      ifnvev=ifnvev1
      call c_f_pointer(c_loc(klist(ifnvev)),nvevx,[nve])
      return
      end subroutine

      subroutine tffsfree
      use tfstk
      use ffs
      use tffitcode
      implicit none
      integer*4 l,itfdownlevel,i
      levele=levele+1
      call tfresethash
c      call tfree(ilist(2,ifwakep))
c      call tfree(ilist(2,ifwakep+2))
c      call tfree(ifwakep)
      call tfree(ifnvev)
      call tfree(iftwissp)
      if(ifsize .gt. 0)then
        call tfree(ifsize)
        ifsize=0
      endif
c      call tfree(ifgamm)
      call tfree(ifgeo)
      call tfree(ifpos)
      call tfree(iftwis)
c      call tfree(ifibzl)
      call tfree(ifmast)
      call tfree(ifmult)
      call tfree(ifcoup)
      call tfree(ifinext)
      call tfree(ifiprev)
      call tfree(ifele2)
      call tfree(ifele1)
      call tfree(ifcomp)
      do i=1,nele
        call tflocald(nelvx(i)%dcomp)
      enddo
      call tfree(ifnelv)
      call tfree(iferrk)
      call tfree(ifibzl)
      call tfree(ifgamm)
      l=itfdownlevel()
      return
      end

      recursive subroutine tfffs(isp1,kx,irtc)
      use tfstk
      use ffs
      use tffitcode
      use tfcsi
      use tfrbuf
      use iso_c_binding
      use ffsfile, only:lfnp
      implicit none
      type (sad_descriptor) kx
      type (sad_string), pointer :: str
      type (csiparam) sav
      integer*4 outfl1,irtc,narg,lfn,isp1,itfmessage,itfmessagestr
      character*10 strfromis
      narg=isp-isp1
      if(narg .gt. 2)then
        irtc=itfmessage(9,'General::narg','"1 or 2"')
        return
      endif
      if(.not. ktfstringq(dtastk(isp1+1),str))then
        irtc=itfmessage(9,'General::wrongtype','"String for #1"')
        return
      endif
      call tftclupdate(7)
      outfl1=outfl
      if(narg .eq. 2)then
        if(ktfnonrealq(ktastk(isp)))then
          irtc=itfmessage(9,'General::wrongtype',
     $         '"File number for #2"')
          return
        endif
        outfl=int(rtastk(isp))
        if(outfl .eq. -1)then
          outfl=icslfno()
        endif
      else
        outfl=0
      endif
      levele=levele+1
      sav=savep
      call trbopen(lfn,ktfaddr(ktastk(isp1+1)),
     $     int8(modestring),str%nch)
      if(lfn .le. 0)then
        irtc=itfmessagestr(9,'FFS::lfn',str%str(1:str%nch))
        kx=dxnull
      else
        call trbassign(lfn)
        ipoint=1
        lrecl=0
        call tffsa(lfnp+1,lfn,kx,irtc)
        call trbclose(lfn)
        call tclrfpe
        savep=sav
        call trbassign(lfni)
        outfl=outfl1
        if(irtc .eq. 0 .and. iffserr .ne. 0)then
          irtc=itfmessagestr(9,'FFS::error',strfromis(iffserr))
        endif
      endif
      call tfconnect(kx,irtc)
      return
      end

      subroutine tfsetconvcase(f)
      use ffs_flag
      implicit none
      logical*4 f
      convcase=f
      return
      end

      subroutine tfmain(isp1,kx,irtc)
      use tfstk
      use trackbypass, only: bypasstrack
      use tfrbuf
      use tmacro
      use ffsfile
      use tfcsi,only:lfni
      implicit none
      type (sad_descriptor) kx
      integer*4 isp1,irtc,infl0,itfmessage,lfn,ierrfl,ierr,lfnb0,lfni0
      ierr=0
      if(isp .eq. isp1+2)then
        ierr=int(rtastk(isp))
      elseif(isp .ne. isp1+1)then
        irtc=itfmessage(9,'General::narg','"1 or 2"')
        return
      endif
      call tfopenread(isp1,kx,irtc)
      if(irtc .ne. 0)then
        return
      endif
      if(.not. ktfrealq(kx,lfn))then
        irtc=itfmessage(9,'General::wonrgtype','"Real"')
        return
      endif
      lfni0=lfni
      infl0=infl
      infl=lfn
      if(infl .ne. lfni)then
        call trbassign(infl)
      endif
      ierrfl=errfl
      errfl=ierr
      bypasstrack=.true.
      lfnb0=lfnbase
      lfnbase=lfnp
      call toplvl
      lfnp=lfnbase
      lfnbase=lfnb0
      bypasstrack=.false.
      errfl=ierrfl
      call trbclose(lfn)
      infl=lfni0
      if(lfni .ne. lfni0)then
        lfni=lfni0
        call trbassign(lfni)
      endif
      kx%k=ktfoper+mtfnull
      return
      end
