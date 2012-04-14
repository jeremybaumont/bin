#!/bin/bash 
#----------------------------------------------------------------
# Copyright &#169; 2006 - Philip Howard - All rights reserved
#
# command ss (secure screen)
#
# purpose Establish a screen based background shell session
#         via secure shell communications.
#
# syntax ss [options] session/username@hostname
#         ss [options] session@username@hostname
#         ss [options] username@hostname/session
#         ss [options] username@hostname session
#
# options -h hostname
#         -h=hostname
#         -i identity
#         -i=identity
#         -l loginuser
#         -l=loginuser
#         -m Multi-display mode
#         -p portnum
#         -p=portnum
#         -s session
#         -s=session
#         -t Use tty allocation (default)
#         -T Do NOT use tty allocation
#         -4 Use IPv4 (default)
#         -6 Use IPv6
#         -46 | -64 Use either IPv6 or IPv4
#
# requirements The local system must have the OpenSSH package
#         installed. The remote system must have the
#         OpenSSH package installed and have the sshd
#         daemon running. It must also have the screen(1)
#         program installed. Configuring a .screenrc
#         file on each system is recommended.
#
# note    The environment variable SESSION_NAME will be set
#         in the session created under the screen command
#         for potential use by other scripts.
#
# author Philip Howard
#----------------------------------------------------------------
whoami=$( exec whoami )
hostname=$( exec hostname )
h=""
i=( )
m=""
p=( )
s=''
t=( -t )
u="${whoami}"
v=( -4 )
#----------------------------------------------------------------
# Parse options and arguments.
#----------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case "x${1}" in
    ( x*/*@* )
    # Example: session1/lisa@centrhub
    u=$( echo "x${1}" | cut -d @ -f 1 )
    u="${u:1}"
    s=$( echo "x${u}" | cut -d / -f 2 )
    u=$( echo "x${u}" | cut -d / -f 1 )
    u="${u:1}"
    h=$( echo "x${1}" | cut -d @ -f 2 )
    shift
    break
    ;;
                                  
    ( x*@*/* )
    # Example:
    # lisa@centrhub/session1
    u=$( echo "x${1}" | cut -d @ -f 1 )
    u="${u:1}"
    h=$( echo "x${1}" | cut -d @ -f 2 )
    s=$( echo "x${h}" | cut -d / -f 2 )
    h=$( echo "x${h}" | cut -d / -f 1 )
    h="${h:1}"
    shift
    break
    ;;
                                    
    ( x*@*@* )
    # Example:
    # session1@lisa@centrhub
    s=$( echo "x${1}" | cut -d @ -f 1 )
    s="${s:1}"
    u=$( echo "x${1}" | cut -d @ -f 2 )
    h=$( echo "x${1}" | cut -d @ -f 3 )
    shift
    break
    ;;
                                
    ( x*@* )                                
    # Example: lisa@centrhub                                     
    u=$( echo "x${1}" | cut -d @ -f 1 )                                            
    u="${u:1}"                                                
    h=$( echo "x${1}" | cut -d @ -f 2 )
    # Next argument
    # should be session name.
    shift
        
    if [[ $# -gt 0 ]]; then                
        s="${1}"                        
        shift                            
    fi
                                
    break
    ;;
                                        
    (x-h=* )                                            
    h="${1:3}"                                                
    ;;
                                                    
    ( x-h )                                                        
    shift                                                            
    h="${1}"                                                                
    ;;
                                                                    
    (x-i=*)
    i="${1:3}"
    if [[ -z "${i}" ]];  then
        i=( )
    else
        i=( -i "${1:3}" )
    fi
    ;;
          
    ( x-i )          
    shift
    i=( -i "${1}" )
    ;;
          
    ( x-l=* | x-u=* )
          u="${1:3}"
          ;;
          ( x-l | x-u )
          shift
          u="${1}"
          ;;
          ( x-m | x--multi )
          m=1
          ;;
          ( x-p=* )
      p="${1:3}"
      if [[ -z "${p}" ]];  then
           p=( )
    else
         p=( -p "${1:3}" )
         fi
         ;;
         ( x-p )
    shift
    p=( -p "${1}" )
    ;;
    ( x-s=* )
    s="${1:3}"
    ;;
    ( x-s )
    shift
    s="${1}"
    ;;
    ( x-t )
    t=( -t )
    ;;
    ( x-T )
    t=( )
    ;;
    ( x-4 )
    v=( -4 )
    ;;
    ( x-6 )
    v=( -6 )
    ;;
    ( x-46 | x-64 )
    v=( )
    ;;

    ( x-* )
    echo "Invalid option: '${1}'"
    die=1
    ;;
    
    ( * )
    echo "Invalid argument: '${1}'"
    die=1
    ;;
esac
                             
shift
done

#----------------------------------------------------------------
# Make sure essential information is present.
#----------------------------------------------------------------
                            
if [[ -z "${u}" ]]; then
    echo "User name is missing"                                   
    die=1
fi
if [[ -z "${h}" ]]; then
    echo "Host name is missing"
    die=1
fi
                                                 
[[ -z "${die}" ]] || exit 1
#----------------------------------------------------------------
# Run screen on the remote only if a session name is given.
#----------------------------------------------------------------                                                 
c=( ssh "${v[@]}" "${i[@]}" "${p[@]}" "${t[@]}" "${u}@${h}" )
                                                 
if [[ -n "${s}" ]]; then                                                      
    o="-DR"                                                           
    if [[ -n "${m}" ]]; then
        o="-x"
    fi
    x="exec /usr/bin/env SESSION_NAME='${s}' screen ${o} '${s}'"
    c=("${c[@]}" "${x}")                                                                     
fi
                                                                     
exec "${c[@]}"

