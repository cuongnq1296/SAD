c     Don't confuse, Emacs. This is -*- fortran -*- mode!
      integer kwL,kwANGL,kwROT,kwK1,kwDK1,kwK2,kwDK2
      integer kwK3,kwDK3,kwE1,kwE2,kwTILT,kwDX,kwDY,kwKICK
      integer kwk0,kwk4,kwk5,kwk6,kwk7,kwk8,kwk9,kwk10,
     $     kwK11,kwK12,kwK13,kwK14,kwK15,kwK16,kwK17,kwK18,
     $     kwK19,kwK20,kwK21,kwW1
      integer kwsk0,kwsk4,kwsk5,kwsk6,kwsk7,kwsk8,kwsk9,kwsk10
      integer kwsk1,kwsk2,kwsk3,kwSK11,kwSK12,kwSK13,kwSK14
      integer kwSK15,kwSK16,kwSK17,kwSK18,kwSK19,kwSK20,kwSK21
      integer kwA3,kwA5,kwA7,kwA9,kwA11,kwA13,kwA15,kwA17
      integer kwVOLT,kwLAG,kwFREQ
      integer kwAX,kwAY,kwBX,kwBY,kwEX,kwEY,kwDP,kwDDP
      integer kwBMAX,kwPRD,kwRHO0,kwFRIN,kwEPS,kwK0FR
      integer kwRAD,kwCHRO,kwDZ
      integer kwEPX,kwEPY,kwAZ,kwSIGZ,kwPX,kwPY,kwEMIX,kwEMIY
      integer kwDPX,kwDPY,kwR1,kwR2,kwR3,kwR4,kwDETR
      integer kwRHO,kwCHI1,kwCHI2,kwCHI3,kwGEO,kwBZ,kwBND
      integer kwF1,kwF2,kwFRMD,kwRANK,kwRANP,kwRANV,kwKIN
      integer kwJDX, kwJDPX, kwJDY, kwJDPY, kwJDZ, kwJDPZ
      integer kwINDX,kwSLI,kwNP,kwDIR,kwOFFSET,kwMAX
      integer kwphi, kwharm, kwlwak, kwtwak, kwDPHI
      integer kwV1,kwV20,kwV11,kwV02
      integer kwZX,  kwZPX,  kwZY,  kwZPY,  kwXANGLE, kwPZ
      integer kwEMIZ,kwSTURN
      integer*4 kwDX1,kwDX2,kwDY1,kwDY2
      integer kwD11,  kwD12,  kwD13,  kwD14,  kwD15, kwD16
      integer kwD21,  kwD22,  kwD23,  kwD24,  kwD25, kwD26
      integer kwD31,  kwD32,  kwD33,  kwD34,  kwD35, kwD36
      integer kwD41,  kwD42,  kwD43,  kwD44,  kwD45, kwD46
      integer kwD51,  kwD52,  kwD53,  kwD54,  kwD55, kwD56
      integer kwD61,  kwD62,  kwD63,  kwD64,  kwD65, kwD66
      integer kwB11,  kwB12,  kwB13,  kwB14,  kwB15, kwB16
      integer         kwB22,  kwB23,  kwB24,  kwB25, kwB26
      integer                 kwB33,  kwB34,  kwB35, kwB36
      integer                         kwB44,  kwB45, kwB46
      integer                                 kwB55, kwB56
      integer                                        kwB66
      integer kwR11,  kwR12,  kwR13,  kwR14,  kwR15, kwR16
      integer         kwR22,  kwR23,  kwR24,  kwR25, kwR26
      integer                 kwR33,  kwR34,  kwR35, kwR36
      integer                         kwR44,  kwR45, kwR46
      integer                                 kwR55, kwR56
      integer                                        kwR66
      integer kwKx,kwQy,kwpole,kwFBx,kwFBy,kwDBZ,kwCOUPLE,
     $     kwRADI,kwDROT,kwAE1,kwAE2,kwFB1,kwFB2,kwLDEV,kwLRAD,
     $     kwFL,kwAPHI
      parameter (kwL=1,kwANGL=kwL+1,kwROT=kwANGL+1)
      parameter (kwK0=kwROT+1)
      parameter (kwK1=kwK0+1,kwDK1=kwK1+1)
      parameter (kwK2=kwDK1+1,kwDK2=kwK2+1)
      parameter (kwK3=kwDK2+1)
      parameter (kwK4=kwK3+1)
      parameter (kwK5=kwK4+1)
      parameter (kwK6=kwK5+1)
      parameter (kwK7=kwK6+1)
      parameter (kwK8=kwK7+1)
      parameter (kwK9=kwK8+1)
      parameter (kwK10=kwK9+1,kwDK3=kwK10+1)
      parameter (kwA3=kwDK3+1)
      parameter (kwA5=kwA3+1)
      parameter (kwA7=kwA5+1)
      parameter (kwA9=kwA7+1)
      parameter (kwA11=kwA9+1)
      parameter (kwA13=kwA11+1)
      parameter (kwA15=kwA13+1)
      parameter (kwA17=kwA15+1)
      parameter (kwE1=kwA17+1,kwE2=kwE1+1)
      parameter (kwTILT=kwE2+1,kwKICK=kwTILT+1)
      parameter (kwDX=kwKICK+1,kwDY=kwDX+1)
      parameter (kwVOLT=kwDY+1)
      parameter (kwPHI=kwVOLT+1,kwHARM=kwPHI+1)
      parameter (kwFREQ=kwHARM+1)
      parameter (kwAX=kwFREQ+1,kwAY=kwAX+1)
      parameter (kwBX=kwAY+1,kwBY=kwBX+1)
      parameter (kwEX=kwBY+1,kwEY=kwEX+1)
      parameter (kwDP=kwEY+1)
      parameter (kwRAD=kwDP+1,kwCHRO=kwRAD+1,kwDZ=kwCHRO+1)
      parameter (kwEPX=kwDZ+1,kwEPY=kwEPX+1)
      parameter (kwPX=kwEPY+1,kwPY=kwPX+1)
      parameter (kwSIGZ=kwPY+1,kwAZ=kwSIGZ+1)
      parameter (kwDPX=kwAZ+1,kwDPY=kwDPX+1,
     $    kwR1=kwDPY+1,kwR2=kwR1+1,kwR3=kwR2+1,kwR4=kwR3+1,
     $     kwDETR=kwR4+1,
     $    kwEMIX=kwDETR+1,kwEMIY=kwEMIX+1,
     $    kwINDX=kwEMIY+1,kwBMAX=kwINDX+1,kwPRD=kwBMAX+1,
     $     kwRHO0=kwBMAX+1)
      parameter (kwRHO=kwRHO0+1,
     $    kwCHI1=kwRHO+1,kwCHI2=kwCHI1+1,kwCHI3=kwCHI2+1,kwGEO=kwCHI3+1,
     $    kwBZ=kwGEO+1,kwBND=kwBZ+1,kwFRIN=kwBND+1,kwK0FR=kwFRIN+1,
     $    kwEPS=kwK0FR+1,
     $    kwF1=kwEPS+1,kwF2=kwF1+1,kwFRMD=kwF2+1,kwRANK=kwFRMD+1,
     $    kwRANP=kwRANK+1,kwRANV=kwRANP+1,kwKIN=kwRANV+1,
     $    kwLWAK=kwKIN+1,kwTWAK=kwLWAK+1)
      parameter (kwSK1=kwTWAK+1,kwSK2=kwSK1+1,
     $     kwSK3=kwSK2+1,kwSK4=kwSK3+1,kwSK5=kwSK4+1,kwSK6=kwSK5+1,
     $     kwSK7=kwSK6+1,kwSK8=kwSK7+1,kwSK9=kwSK8+1,kwSK10=kwSK9+1)
      parameter (kwSLI=kwSK10+1,kwNP=kwSLI+1)
      parameter (kwDIR=kwNP+1,kwLAG=kwDIR+1, kwSK0=kwLAG+1,
     $     kwJDX=kwSK0+1,kwJDPX=kwJDX+1,kwJDY=kwJDPX+1,kwJDPY=kwJDY+1)
      parameter (kwK11=kwJDPY+1,kwK12=kwK11+1,kwK13=kwK12+1,
     $     kwK14=kwK13+1)
      parameter (kwSK11=kwK14+1,kwSK12=kwSK11+1,kwSK13=kwSK12+1,
     $     kwSK14=kwSK13+1)
      parameter (kwV1=kwSK14+1)
      parameter (kwZX=kwV1+1,kwZPX=kwZX+1,kwZY=kwZPX+1,kwZPY=kwZY+1,
     $     kwXANGLE=kwZPY+1,kwPZ=kwXANGLE+1,kwEMIZ=kwPZ+1,
     $     kwSTURN=kwEMIZ+1)
      parameter (kwDX1=kwSTURN+1,kwDX2=kwDX1+1,
     $     kwDY1=kwDX2+1,kwDY2=kwDY1+1)
      parameter (kwD11=kwDY2+1,kwD12=kwD11+1,kwD13=kwD11+2,
     $           kwD14=kwD11+3,kwD15=kwD11+4,kwD16=kwD11+5)
      parameter (kwD21=kwD11+6,kwD22=kwD21+1,kwD23=kwD21+2,
     $           kwD24=kwD21+3,kwD25=kwD21+4,kwD26=kwD21+5)
      parameter (kwD31=kwD21+6,kwD32=kwD31+1,kwD33=kwD31+2,
     $           kwD34=kwD31+3,kwD35=kwD31+4,kwD36=kwD31+5)
      parameter (kwD41=kwD31+6,kwD42=kwD41+1,kwD43=kwD41+2,
     $           kwD44=kwD41+3,kwD45=kwD41+4,kwD46=kwD41+5)
      parameter (kwD51=kwD41+6,kwD52=kwD51+1,kwD53=kwD51+2,
     $           kwD54=kwD51+3,kwD55=kwD51+4,kwD56=kwD51+5)
      parameter (kwD61=kwD51+6,kwD62=kwD61+1,kwD63=kwD61+2,
     $           kwD64=kwD61+3,kwD65=kwD61+4,kwD66=kwD61+5)
c
      parameter (kwB11=kwD61+6,kwB12=kwB11+1,kwB13=kwB11+2,
     $           kwB14=kwB11+3,kwB15=kwB11+4,kwB16=kwB11+5)
      parameter (kwB22=kwB11+6,kwB23=kwB11+7,kwB24=kwB11+8,
     $           kwB25=kwB11+9,kwB26=kwB11+10)
      parameter (kwB33=kwB11+11,kwB34=kwB11+12,
     $           kwB35=kwB11+13,kwB36=kwB11+14)
      parameter (kwB44=kwB11+15,kwB45=kwB11+16,kwB46=kwB11+17)
      parameter (kwB55=kwB11+18,kwB56=kwB11+19,kwB66=kwB11+20)
      parameter (kwR11=kwB11+21,kwR12=kwR11+1,kwR13=kwR11+2,
     $           kwR14=kwR11+3,kwR15=kwR11+4,kwR16=kwR11+5)
      parameter (kwR22=kwR11+6,kwR23=kwR11+7,kwR24=kwR11+8,
     $           kwR25=kwR11+9,kwR26=kwR11+10)
      parameter (kwR33=kwR11+11,kwR34=kwR11+12,
     $           kwR35=kwR11+13,kwR36=kwR11+14)
      parameter (kwR44=kwR11+15,kwR45=kwR11+16,kwR46=kwR11+17)
      parameter (kwR55=kwR11+18,kwR56=kwR11+19,kwR66=kwR11+20)
      parameter (kwKx=kwR11+21,kwQy=kwkx+1,kwpole=kwQy+1)
      parameter (kwFBx=kwpole+1,kwFBy=kwFBx+1)
      parameter (kwDBZ=kwFBy+1)
      parameter (kwK15=kwDBZ+1,kwK16=kwK15+1,kwK17=kwK16+1,
     $           kwK18=kwK17+1,kwK19=kwK18+1,kwK20=kwK19+1,
     $           kwK21=kwK20+1)
      parameter (kwSK15=kwK21+1,kwSK16=kwSK15+1,kwSK17=kwSK16+1,
     $           kwSK18=kwSK17+1,kwSK19=kwSK18+1,kwSK20=kwSK19+1,
     $           kwSK21=kwSK20+1)
      parameter (kwV20=kwSK21+1,kwV11=kwV20+1,kwV02=kwV11+1,
     $     kwJDZ=kwV02+1,kwJDPZ=kwJDZ+1,kwOFFSET=kwJDPZ+1,
     $     kwCOUPLE=kwOFFSET+1,kwDDP=kwCOUPLE+1,kwRADI=kwDDP+1,
     $     kwDPHI=kwRADI+1,kwW1=kwDPHI+1,kwDROT=kwW1+1,
     $     kwAE1=kwDROT+1,kwAE2=kwAE1+1,
     $     kwFB1=kwAE2+1,kwFB2=kwFB1+1,
     $     kwLDEV=kwFB2+1,kwLRAD=kwLDEV+1,
     $     kwFL=kwLRAD+1,kwAPHI=kwFL+1)
      parameter (kwMAX=kwAPHI+1)
c
      integer kytbl
      common /kywdtb/ kytbl(0:kwMAX,0:icMXEL)