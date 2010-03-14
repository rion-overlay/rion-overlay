#!/bin/bash
#this script expects user to pass an argument for user to process
#
pass1=$1
new_uid=$2
new_gid=$3
#check to see if user entered anything
if [ ! $# == 3 ] ; then
 echo "Usage is pass me 3 parameters, user to change, new uid to use, and new gid to use exiting"
 exit
fi
#
#parse /etc/passwd and /etc/group for groups to change
#
myname=`cat /etc/passwd | grep -w $pass1 |awk -F: '{ print $1 }'`
myuid=`cat /etc/passwd | grep -w $pass1 |awk -F: '{ print $3 }'`
mygid1=`cat /etc/passwd | grep -w $pass1 |awk -F: '{ print $4 }'`
mygid=`cat /etc/group | grep $pass1: |awk -F: '{ print $3 }'`
mygnam=`cat /etc/group | grep -w $mygid1 | awk -F: '{ print $1 }'`
#
#check and make sure the user's primary group is also their private group
#
if [ ! $mygid1 == $mygid ] ; then
 echo "There is a mismatch between the user's primary group and their private group"
 echo "I'm exiting as their primary group is likely a shared group and should be fixed"
 exit
fi
#check and make sure the user's primary group is also their private group
if [ ! $mygnam == $myname ] ; then
  echo "There is a mismatch between the user's primary group and their private group"
  echo "I'm exiting as their primary group is likely a shared group and should be fixed"
  exit
fi
#
echo "User to change is $myname with uid of $myuid and gid of $mygid and assign user new uid of $new_uid and new gid of $new_gid"
echo -n "Do you want me to continue? [y/n]"
#
read lastchance
#
case "$lastchance" in
  y)
    echo "I'm going to continue with user, group and file system changes"
    #change private group id
    if ! /usr/sbin/groupmod -g $new_gid $myname; then
       echo "Changing private group id failed, aborting";
    fi
    if ! /usr/sbin/usermod $myname -g $myname; then
       echo "Changing user id failed, aborting. You have to change the group id back to it's original value manually."
    fi
    #change uid
    if ! /usr/sbin/usermod -u $new_uid $myname; then
       echo "Changing user id failed, aborting. You have to change the group id back to it's original value manually."
    fi
    #find files they use to own and give them ownership again
    echo "Changing all files owned by $myname to the new id... (this may take awhile)"
    find / -uid $myuid -exec chown -h $myname {} \;
    echo "Changing all files in the $myname group to the new id... (this may take awhile)"
    find / -gid $mygid -exec chgrp -h $myname {} \;
    ;;
  n)
    echo "I'm aborting all changes"
    exit
    ;;
  *)
    echo "You entered something I don't understand...aborting"
    exit
    ;;
esac