      subroutine surfpts(icount,imsgin,xmsgin,cmsgin,msgtype,nwds,ierr2)
C
      implicit none
      integer icount,nwds,ierr2
      real*8 alargenumber,atolerance,epsmin
      parameter (alargenumber=1.0d+20)
      parameter (atolerance=1.0d-8)
      parameter ( epsmin=0.0)
C
      character*132 logmess
C
C
C#######################################################################
C
C     PURPOSE -
C
C     THIS ROUTINE GENERATES POINTS ON THE SURFACE OF THE REQUESTED
C     SURFACE OR REGION.  THE VARIABLE ctype IS surface OR region AND
C     THE VARIABLE iname IS THE NAME OF THE SURFACE OR REGION.
C     THE POINTS ARE GENERATED BY USING RAYS FROM A USER SPECIFIED
C     CENTER, LINE OR PLANE THROUGH A SET OF USER SUPPLIED POINTS
C     AND FINDING A SURFACE INTERFACE FOR EACH RAY.  THE POINTS
C     NEEDED FOR A REGION ARE FOUND BY CALLING THE SUBROUTINE
C     regnpts AND ASKING FOR THE END POINT(S) AS REQUESTED IN cregpt.
C     cregpt is ignored if ctype is surface.
C     cregpt CAN BE inside, outside OR both if ctype is region.
C
C
C     FORMAT: SURFPTS/ITYPE/INAME/IREGPT/IPFIRST,IPLAST,ISTRIDE/
C                                          IGEOM/RAY ORIGIN
C                          -OR-
C     FORMAT: SURFPTS/ITYPE/INAME/IREGPT/pset,get,SETNAME/
C                                          IGEOM/RAY ORIGIN
C             WHERE IPFIRST,IPLAST,ISTRIDE OR pset,get,SETNAME DETERMINE
C                   THE SET OF POINTS TO SHOOT RAYS THROUGH.
C
C      SPECIFICALLY FOR ALLOWABLE GEOMETRY TYPES:
C        SURFPTS/ITYPE/INAME/IREGPT/IPFIRST,IPLAST,ISTRIDE/
C                                       xyz/x1,y1,z1/x2,y2,z2/x3,y3,z3
C             WHERE POINTS 1, 2, 3 DEFINE THE PLANE TO SHOOT RAYS FROM
C                   NORMAL TO THE PLANE.
C        SURFPTS/ITYPE/INAME/IREGPT/IPFIRST,IPLAST,ISTRIDE/
C                                       rtz/x1,y1,z1/x2,y2,z2
C             WHERE POINTS 1, 2 DEFINE THE LINE TO SHOOT RAYS FROM
C                   PERPENDICULAR TO THE LINE.
C        SURFPTS/ITYPE/INAME/IREGPT/IPFIRST,IPLAST,ISTRIDE/
C                                       rtp/xcen,ycen,zcen
C             WHERE xcen,ycen,zcen DEFINE THE CENTER OF THE SPHERE TO
C                   SHOOT RAYS FROM.
C        SURFPTS/ITYPE/INAME/IREGPT/IPFIRST,IPLAST,ISTRIDE/
C                                       points/iffirst,iflast,ifstride
C             WHERE iffirst,iflast,ifstride DEFINE A SET OF POINTS
C                   TO SHOOT RAYS FROM.
C
C
C     INPUT ARGUMENTS -
C
C        icount - CURRENT POINT COUNT
C        xmsgin - REAL ARRAY OF COMMAND INPUT VALUES
C        msgin - INTEGER ARRAY OF COMMAND INPUT VALUES
C        imsgin - INTEGER ARRAY OF COMMAND INPUT VALUES
C        nwds - NO. OF WORDS OF COMMAND INPUT VALUES
C
C
C
C     OUTPUT ARGUMENTS -
C
C        ierr2 - INVALID INPUT ERROR FLAG
C
C
C     CHANGE HISTORY -
C
C        $Log: surfpts.f,v $
C        Revision 2.00  2007/11/09 20:04:04  spchu
C        Import to CVS
C
CPVCS    
CPVCS       Rev 1.2   01 Nov 2002 14:17:46   dcg
CPVCS    fix errors in surface option - access geometry info through geom_name
CPVCS    replace duplicate usage of variable named index with index and indexs
CPVCS    
CPVCS       Rev 1.1   Tue Feb 08 13:36:16 2000   dcg
CPVCS    
CPVCS       Rev 1.0   26 Jan 2000 14:58:34   dcg
CPVCS    Initial revision.
CPVCS
CPVCS       Rev 1.20   Fri Aug 28 14:25:28 1998   dcg
CPVCS    remove single precision constants
CPVCS
CPVCS       Rev 1.19   Wed Dec 17 12:24:06 1997   dcg
CPVCS    declare ipcmoprm as a pointer
CPVCS
CPVCS       Rev 1.18   Tue Nov 25 10:02:46 1997   dcg
CPVCS    get correct size for temporary storage
CPVCS
CPVCS       Rev 1.16   Mon Apr 14 17:02:18 1997   pvcs
CPVCS    No change.
CPVCS
CPVCS       Rev 1.15   11/07/95 17:27:00   dcg
CPVCS    change flag to 2 in mmgetblk calls
CPVCS
CPVCS       Rev 1.14   09/19/95 13:09:24   dcg
CPVCS    add primative syntax checking
CPVCS
CPVCS       Rev 1.13   08/29/95 12:11:04   dcg
CPVCS    set length for names to 40 characters
CPVCS
CPVCS       Rev 1.12   08/23/95 07:03:28   het
CPVCS    Remove the CMO prefix from SB-ids
CPVCS
CPVCS       Rev 1.11   06/07/95 15:32:00   het
CPVCS    Change character*32 idsb to character*132 idsb
CPVCS
CPVCS       Rev 1.10   05/26/95 13:15:04   het
CPVCS    Replace subroutine parameter list with subroutine calles.
CPVCS
CPVCS       Rev 1.9   05/01/95 08:34:20   het
CPVCS    Modifiy all the storage block calles for long names
CPVCS
CPVCS       Rev 1.8   03/31/95 09:10:36   het
CPVCS    Add the buildid calles before all storage block calls
CPVCS
CPVCS       Rev 1.7   03/30/95 05:00:56   het
CPVCS    Change the storage block id packing and preidsb to buildid for long names
CPVCS
CPVCS       Rev 1.6   03/23/95 15:08:44   dcg
CPVCS     Add mesh object name to storage block id for surface,region info.
CPVCS
CPVCS       Rev 1.5   02/18/95 06:57:30   het
CPVCS    Changed the parameter list to be the same as pntlimc
CPVCS
CPVCS       Rev 1.4   02/03/95 16:18:32   dcg
CPVCS    Add call to cmo_get_name
CPVCS
CPVCS       Rev 1.3   12/19/94 08:27:30   het
CPVCS    Add the "comdict.h" include file.
CPVCS
CPVCS
CPVCS       Rev 1.2   12/06/94 19:07:20   het
CPVCS    Add the "call cmo_get_name" to return the current mesh object name.
CPVCS
CPVCS       Rev 1.1   12/01/94 18:40:46   het
CPVCS    Change "cmo" calles to add data type
CPVCS    Alias the "decimate2d"  command to "decimate"
CPVCS    Alias the "settets" command to "mass"
CPVCS
CPVCS       Rev 1.0   11/10/94 12:19:00   pvcs
CPVCS    Original version.
C
C#######################################################################
C
      include 'geom_lg.h'
C
C#######################################################################
C
      real*8 xmsgin(nwds)
      integer imsgin(nwds),msgtype(nwds)
C
      character*32 cmsgin(*)
      logical surftst
C
      character*32 isubname
C
      character*32 cmo,geomnm
C
      real*8 sfact(20),rout,outs(*)
 
      integer mpary1,mpary2,iout
      pointer(ipmpary1, mpary1(*))
      pointer(ipmpary2, mpary2(*))
      pointer (ipout,outs)
C
      character*32 isurfnm
      character*8 cgeom, ctype, cregpt
      character*32 cpt1, cpt2, cpt3
      character*32 cpf1, cpf2, cpf3
C
C#######################################################################
C
      pointer (ipisetwd, isetwd)
      pointer (ipitp1, itp1)
      integer isetwd(10000000), itp1(1000000)
      pointer (ipxic, xic)
      pointer (ipyic, yic)
      pointer (ipzic, zic)
      real*8 xic(1000000), yic(1000000), zic(1000000)
C
      real*8 xck,yck,zck,s,ckmin,ckmax,distx,sf,xr2,yr2,zr2,srchval,
     *  zdiff,zmax1,zmin1,ydiff,ymax1,ymin1,xdiff,xmin1,xmax1,
     *  xr1,yr1,zr1,au,bu,cu,dista,a,b,c,d,
     *  x1in,y1in,z1in,x2in,y2in,z2in,x3in,y3in,z3in,
     *  x1,y1,z1,x2,y2,z2,x3,y3,z3
      integer ismax,nsfact,ipf,ip,i1,icntin,lout,
     *  mpno,mpno2,ipt1,ipt2,ipt3,ismin,index,ipf1,ipf2,ipf3,
     *  icharlnf,len1,ierrw,icscode,indexs,
     *  ierror,npoints,length,ilen,ityp,ierr,i
C#######################################################################
C
      isubname='surfpts'
C
C
      call cmo_get_name(cmo,ierror)
      call cmo_get_attinfo('geom_name',cmo,iout,rout,geomnm,
     *                        ipout,lout,ityp,ierror)
c
C
      call cmo_get_info('nnodes',cmo,
     *                  npoints,ilen,ityp,ierror)
      call cmo_get_info('isetwd',cmo,ipisetwd,ilen,ityp,ierr)
      call cmo_get_info('itp1',cmo,ipitp1,ilen,ityp,ierr)
      call cmo_get_info('xic',cmo,ipxic,ilen,ityp,ierr)
      call cmo_get_info('yic',cmo,ipyic,ilen,ityp,ierr)
      call cmo_get_info('zic',cmo,ipzic,ilen,ityp,ierr)
C
C
C     ******************************************************************
C     CHECK THAT xtype IS 'SURFACE' OR 'REGION'.
C
      ctype=cmsgin(1)
      if (ctype(1:7).ne.'surface' .and. ctype(1:6).ne.'region') then
         ierr2=1
         write(logmess,9000) ctype
 9000    format('  ERROR - INVALID TYPE ID ',a8)
         call writloga('default',0,logmess,0,ierrw)
         go to 9999
      endif
C
C     ******************************************************************
C     GET SURFACE or region NAME.
C
      isurfnm=cmsgin(2)
C
C     ******************************************************************
C     SET REGION POINT LOCATOR DEFAULT.
C
      cregpt=cmsgin(3)
      len1=icharlnf(cregpt)
      if (cregpt(1:len1).ne.'i' .and. cregpt(1:len1).ne.'o' .and.
     &    cregpt(1:len1).ne.'b' .and.
     &    cregpt(1:len1).ne.'in' .and. cregpt(1:len1).ne.'out' .and.
     &    cregpt(1:len1).ne.'inside' .and.
     &    cregpt(1:len1).ne.'outside' .and.
     &    cregpt(1:len1).ne.'both') then
         cmsgin(3)='outside'
         msgtype(3)=3
      endif
C
C     ******************************************************************
C     DETERMINE GEOMETRY TYPE AND VALIDATE.
C
      cgeom=cmsgin(7)
      if (cgeom(1:3).ne.'xyz' .and. cgeom(1:3).ne.'rtz' .and.
     &    cgeom(1:3).ne.'rtp' .and.
     &    cgeom(1:6).ne.'points') then
         ierr2=1
         write(logmess,9001) cgeom
 9001    format('  ERROR - INVALID GEOMETRY TYPE ',a8)
         call writloga('default',0,logmess,0,ierrw)
         go to 9999
      endif
C
C     ******************************************************************
C     GET INPUT ORIGIN DATA.
C
      call test_argument_type(9,2,8,imsgin,xmsgin,cmsgin,msgtype,nwds)
      x1in=xmsgin(8)
      y1in=xmsgin(9)
      z1in=xmsgin(10)
      x2in=xmsgin(11)
      y2in=xmsgin(12)
      z2in=xmsgin(13)
      x3in=xmsgin(14)
      y3in=xmsgin(15)
      z3in=xmsgin(16)
C
C     ******************************************************************
C     GET RAY ORIGIN POINT SET FOR points.
C
      if (cgeom(1:6) .eq. 'points') then
         if(msgtype(8).eq.1) then
            ipf1=imsgin(8)
            ipf2=imsgin(9)
            ipf3=imsgin(10)
         else
            cpf1=cmsgin(8)
            cpf2=cmsgin(9)
            cpf3=cmsgin(10)
         endif
      endif
C
C     ******************************************************************
C     GET RAY ORIGIN PLANE FOR xyz GEOMETRY
C
      if (cgeom(1:3) .eq. 'xyz') then
C
C        ---------------------------------------------------------------
C        TRANSFORM THE POINTS FROM THE CURRENT COORD. SYSTEM TO THE
C        NORMAL COORD. SYSTEM.
C
         call xyznorm(x1in,y1in,z1in,x1,y1,z1)
         call xyznorm(x2in,y2in,z2in,x2,y2,z2)
         call xyznorm(x3in,y3in,z3in,x3,y3,z3)
C
C        ---------------------------------------------------------------
C        SET UP THE EQUATION OF THE PLANE FROM THE 3 POINTS.
C
         a=  (y2-y1)*(z3-z1) - (y3-y1)*(z2-z1)
         b=-((x2-x1)*(z3-z1) - (x3-x1)*(z2-z1))
         c=  (x2-x1)*(y3-y1) - (x3-x1)*(y2-y1)
         d=a*x1+b*y1+c*z1
C
C        ---------------------------------------------------------------
C        DETERMINE THE UNIT VECTOR.
C
         au=a/sqrt(a*a + b*b + c*c)
         bu=b/sqrt(a*a + b*b + c*c)
         cu=c/sqrt(a*a + b*b + c*c)
C
      endif
C
C     ******************************************************************
C     GET RAY ORIGIN LINE FOR rtz GEOMETRY
C
      if (cgeom(1:3) .eq. 'rtz') then
C
C        ---------------------------------------------------------------
C        TRANSFORM THE POINTS FROM THE CURRENT COORD. SYSTEM TO THE
C        NORMAL COORD. SYSTEM.
C
         call xyznorm(x1in,y1in,z1in,x1,y1,z1)
         call xyznorm(x2in,y2in,z2in,x2,y2,z2)
C
C        ---------------------------------------------------------------
C        CALCULATE THE DISTANCE BETWEEN THE TWO POINTS.
C
         dista=sqrt((x2-x1)**2 + (y2-y1)**2 + (z2-z1)**2)
C
      endif
C
C     ******************************************************************
C     GET RAY ORIGIN POINT FOR rtp GEOMETRY
C
      if (cgeom(1:3) .eq. 'rtp') then
C
C        ---------------------------------------------------------------
C        TRANSFORM THE POINT FROM THE CURRENT COORD. SYSTEM TO THE
C        NORMAL COORD. SYSTEM.
C
         call xyznorm(x1in,y1in,z1in,x1,y1,z1)
         xr1=x1
         yr1=y1
         zr1=z1
         x2=x1
         y2=y1
         z2=z1
      endif
C
C     ******************************************************************
C
C     SET THE MINIMUM SEARCH RANGE TO SMALLEST X, Y, OR Z RANGE
C
      index=ismin(npoints,xic,1)
      xmin1=xic(index)
      index=ismax(npoints,xic,1)
      xmax1=xic(index)
      xdiff=xmax1-xmin1
C
      index=ismin(npoints,yic,1)
      ymin1=yic(index)
      index=ismax(npoints,yic,1)
      ymax1=yic(index)
      ydiff=ymax1-ymin1
C
      index=ismin(npoints,zic,1)
      zmin1=zic(index)
      index=ismax(npoints,zic,1)
      zmax1=zic(index)
      zdiff=zmax1-zmin1
C
      srchval=((xdiff+ydiff+zdiff)/3.)*atolerance
      if (srchval .lt. epsmin) srchval=epsmin
C
C     ******************************************************************
C
C     SET THE POINT INDEX BOUNDARIES.
C
      if(msgtype(4).eq.1) then
         ipt1=imsgin(4)
         ipt2=imsgin(5)
         ipt3=imsgin(6)
      else
         cpt1=cmsgin(4)
         cpt2=cmsgin(5)
         cpt3=cmsgin(6)
      endif
C
C     ******************************************************************
C
C     CHECK POINT LIMITS AND TRANSLATE TO VALID LIMITS IF NECESSARY.
C
      isubname="surfpts"
      length=npoints
      call mmgetblk("mpary1",isubname,ipmpary1,length,2,icscode)
      mpno=length
      if(msgtype(4).eq.1) then
         call pntlimn(ipt1,ipt2,ipt3,ipmpary1,mpno,npoints,isetwd,itp1)
      elseif(msgtype(4).eq.3) then
         call pntlimc(cpt1,cpt2,cpt3,ipmpary1,mpno,npoints,isetwd,itp1)
      endif
C
      if (cgeom(1:6) .eq. 'points') then
         call mmgetblk("mpary2",isubname,ipmpary2,length,2,icscode)
         mpno2=length
         if(msgtype(8).eq.1) then
            call pntlimn(ipf1,ipf2,ipf3,ipmpary2,mpno2,npoints,
     *                   isetwd,itp1)
         elseif(msgtype(8).eq.3) then
            call pntlimc(cpf1,cpf2,cpf3,ipmpary2,mpno2,npoints,
     *                   isetwd,itp1)
         endif
      endif
C
C     ******************************************************************
C     DETERMINE THE AMOUNT OF MEMORY TO ALLOCATE
C
      npoints=npoints+mpno

      call cmo_set_info('nnodes',cmo,npoints,1,1,ierror)
      call cmo_newlen(cmo,ierror)
      call cmo_get_info('xic',cmo,ipxic,ilen,ityp,ierr)
      call cmo_get_info('yic',cmo,ipyic,ilen,ityp,ierr)
      call cmo_get_info('zic',cmo,ipzic,ilen,ityp,ierr)
C
C
C     ******************************************************************
C     SAVE CURRENT POINT COUNT
C
       icntin=icount
C
C     ******************************************************************
C     GENERATE SURFACE POINTS ON A SURFACE
C
      if (ctype(1:7) .eq. 'surface') then
c
C     ******************************************************************
C     GET surface information.
C
      call mmfindbk('csall',geomnm,ipcsall,length,ierror)
      if(ierror.ne.0) then
         write(logmess,'(a,a)') 'Error in surfpt command: ',
     *    'Mesh has no surfaces '
         call writloga('default',0,logmess,0,ierror)
         go to 9999
      endif
      call mmfindbk('istype',geomnm,ipistype,length,ierror)
      call mmfindbk('ibtype',geomnm,ipibtype,length,ierror)
      call mmfindbk('sheetnm',geomnm,ipsheetnm,length,ierror)
      call mmfindbk('surfparam',geomnm,ipsurfparam,length,ierror)
      call mmfindbk('offsparam',geomnm,ipoffsparam,length,ierror)
C
      do i=1,nsurf
         if(csall(i).eq.isurfnm) then
            index=i
            go to 12
         endif
      enddo
      write(logmess,9002) isurfnm
 9002 format('  WARNING: SURFACE ',a8,' DOES NOT EXIST')
      call writloga('default',0,logmess,0,ierrw)
      go to 9998
C
C        ---------------------------------------------------------------
C        LOOP THROUGH THE USER DEFINED POINTS
C
  12  do 50 i1=1,mpno
            ip=mpary1(i1)
C
C           ............................................................
C           GET THE POINT THE RAY GOES THROUGH
C
            xr2=xic(ip)
            yr2=yic(ip)
            zr2=zic(ip)
C
C           ............................................................
C           DETERMINE THE RAY ORIGIN POINT FOR xyz FROM THE PLANE NORMAL
C           AND THE DISTANCE FROM xr2,yr2,zr2 TO THE PLANE.
C
            if (cgeom(1:3) .eq. 'xyz') then
               sf=(a*xr2 + b*yr2 + c*zr2 - d)/sqrt(a*a + b*b + c*c)
               xr1=xr2-au*sf
               yr1=yr2-bu*sf
               zr1=zr2-cu*sf
            endif
C
C           ............................................................
C           DETERMINE THE RAY ORIGIN POINT FOR rtz FROM THE
C           PERPENDICULAR
C
            if (cgeom(1:3) .eq. 'rtz') then
               distx=((x2-x1)*(xr2-x1)+(y2-y1)*(yr2-y1)+
     &                (z2-z1)*(zr2-z1))/dista
               sf=distx/dista
               xr1=x1+sf*(x2-x1)
               yr1=y1+sf*(y2-y1)
               zr1=z1+sf*(z2-z1)
            endif
C
C           ............................................................
C           GET THE RAY ORIGIN POINT FOR points FROM THE LIST SET
C
            if (cgeom(1:6) .eq. 'points') then
               ipf=mpary2(i1)
               xr1=xic(ipf)
               yr1=yic(ipf)
               zr1=zic(ipf)
            endif
C
C           ............................................................
C           CALL getsfact TO CALCULATE THE DISTANCE FACTOR FOR THE
C           POSITION ALONG THE RAY THAT INTERSECTS THE SURFACE
C           NOTE: THE CORRECT S FACTOR MUST BE POSITIVE.
C
            ckmin=0
            ckmax=alargenumber
            call getsfact(xr1,yr1,zr1,xr2,yr2,zr2,cmo,istype(index),
     &           surfparam(offsparam(index)+1),sheetnm(index),
     &           ckmin,ckmax,srchval,sfact,nsfact)
C
C           ............................................................
C           IF THE POINT IS ON THE SURFACE, CALCULATE AND SAVE THE POINT
C
            if (nsfact .gt. 0) then
               indexs=ismax(nsfact,sfact,1)
               s=sfact(indexs)
               xck=xr1+s*(xr2-xr1)
               yck=yr1+s*(yr2-yr1)
               zck=zr1+s*(zr2-zr1)
               if(surftst(xck,yck,zck,srchval,cmo,istype(index),
     &           surfparam(offsparam(index)+1),sheetnm(index),
     &           'eq      '))
     &            then
                  icount=icount+1
                  xic(icount)=xck
                  yic(icount)=yck
                  zic(icount)=zck
               endif
            endif
C
   50    continue
C
      endif
C
C     ******************************************************************
C     GENERATE SURFACE POINTS ON A REGION
C
      if (ctype(1:6) .eq. 'region')
     &   call regnpts(icount,imsgin(2),xmsgin(2),cmsgin(2),msgtype(2),
     &   nwds-1,ierr2)
C     ******************************************************************
C     PRINT OUT THE NUMBER OF POINTS GENERATED ON THIS SURFACE
C
      write(logmess,6000) icntin+1,icount,isurfnm
 6000 format('  SURFPTS GENERATED POINTS ',i6,' TO ',i6,
     &       ' FOR ',a8)
      call writloga('default',0,logmess,0,ierrw)
C
C     ******************************************************************
C     RELEASE TEMPORARY MEMORY
C
 9998 call mmrelprt(isubname,icscode)
C
C
C     ******************************************************************
C     SET UP THE CFT IMMUNE STATEMENT FOR DDT
C
      goto 9999
 9999 continue
C
      return
      end
