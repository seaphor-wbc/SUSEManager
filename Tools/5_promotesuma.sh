#!/bin/bash
# Set working directory and refresh repository
#WRKDIR=/home/smiller/MyNewRepos/GitHub/SUSEManager
WRKDIR=~/SUSEManager
cd $WRKDIR
git pull origin master
#
NEWREV=$(( `ls -1 $WRKDIR | grep ^5 | tail -n1 | awk -F- '{print $2}'` + 1 ));
BASENAME="`ls -1 $WRKDIR | grep ^5 | tail -n1 | awk -F- '{print $1}'`"
ARCHFIL="`ls -1 $WRKDIR | grep ^5 | head -n1`"
LATEFIL="`ls -1 $WRKDIR | grep ^5 | tail -n1`"
REVDATE=`date +%d\ %B\ %Y`
SCRPTNAME='suma-channel-mgr.sh'
VERNAME='suma-channel-mgr'
# Promote latest working to Latest_Stable
cp -r $WRKDIR/$LATEFIL $WRKDIR/tempfil
sed -i "s/SCRIPT_RELEASE_DATE\=\"?? ??? 201?\"/SCRIPT_RELEASE_DATE\=\"$REVDATE\"/g" $WRKDIR/$LATEFIL/*
cp $WRKDIR/$LATEFIL/* $WRKDIR/Latest_Stable/$SCRPTNAME
mv $WRKDIR/$ARCHFIL $WRKDIR/Archive/.
mv $WRKDIR/tempfil $WRKDIR/$BASENAME-$NEWREV
mv $WRKDIR/$BASENAME-$NEWREV/* $WRKDIR/$BASENAME-$NEWREV/$VERNAME\_5.0.0-$NEWREV
sed -i s/SCRIPT_RELEASE\=\"5.0.0-..\"/SCRIPT_RELEASE\=\"5.0.0-$NEWREV\"/g $WRKDIR/$BASENAME-$NEWREV/$VERNAME\_5.0.0-$NEWREV
# Push promotion to github repository and exit [will not work, need to add syntax to apply user and pass]
if [[ -a ~/.githubrepo ]]; then
  source ~/.githubrepo
  cd $WRKDIR
  CPFIL="`ls -1 $WRKDIR | grep ^5 | tail -n2 | head -n1`"
  git add *
  git commit -a -m "$CPFIL is now Latest_Stable - Promoted to 5.0.0-$NEWREV on $REVDATE"
  git push https://$MYUSER:$MYPASS@github.com/seaphor-wbc/SUSEManager.git
#  git push origin master
fi
exit 0
