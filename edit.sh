#!/bin/bash
###
#   Internal routine for HTTP
###
# (internal) routine to store POST data
function cgi_get_POST_vars()
{

    # only handle POST requests here
    [ "$REQUEST_METHOD" != "POST" ] && return

    # save POST variables (only first time this is called)
    [ ! -z "$QUERY_STRING_POST" ] && return

    # skip empty content
    [ -z "$CONTENT_LENGTH" ] && return

    # check content type
    # FIXME: not sure if we could handle uploads with this..
    [ "${CONTENT_TYPE}" != "application/x-www-form-urlencoded" ] && \
        echo "bash.cgi warning: you should probably use MIME type "\
             "application/x-www-form-urlencoded!" 1>&2

    # convert multipart to urlencoded
    local handlemultipart=0 # enable to handle multipart/form-data (dangerous?)
    if [ "$handlemultipart" = "1" -a "${CONTENT_TYPE:0:19}" = "multipart/form-data" ]; then
        boundary=${CONTENT_TYPE:30}
        read -N $CONTENT_LENGTH RECEIVED_POST
        # FIXME: don't use awk, handle binary data (Content-Type: application/octet-stream)
        QUERY_STRING_POST=$(echo "$RECEIVED_POST" | awk -v b=$boundary 'BEGIN { RS=b"\r\n"; FS="\r\n"; ORS="&" }
           $1 ~ /^Content-Disposition/ {gsub(/Content-Disposition: form-data; name=/, "", $1); gsub("\"", "", $1); print $1"="$3 }')

    # take input string as is
    else
        read -t 2 -N $CONTENT_LENGTH QUERY_STRING_POST
    fi

    return
}

# (internal) routine to decode urlencoded strings
function cgi_decodevar()
{
    [ $# -ne 1 ] && return
    local v t h
    # replace all + with whitespace and append %%
    t="${1//+/ }%%"
    while [ ${#t} -gt 0 -a "${t}" != "%" ]; do
        v="${v}${t%%\%*}" # digest up to the first %
        t="${t#*%}"       # remove digested part
        # decode if there is anything to decode and if not at end of string
        if [ ${#t} -gt 0 -a "${t}" != "%" ]; then
            h=${t:0:2} # save first two chars
            t="${t:2}" # remove these
            v="${v}"`echo -e \\\\x${h}` # convert hex to special char
        fi
    done
    # return decoded string
    echo "${v}"
    return
}

# routine to get variables from http requests
# usage: cgi_getvars method varname1 [.. varnameN]
# method is either GET or POST or BOTH
# the magic varible name ALL gets everything
function cgi_getvars()
{
    [ $# -lt 2 ] && return
    local q p k v s
    # get query
    case $1 in
        GET)
            [ ! -z "${QUERY_STRING}" ] && q="${QUERY_STRING}&"
            ;;
        POST)
            cgi_get_POST_vars
            [ ! -z "${QUERY_STRING_POST}" ] && q="${QUERY_STRING_POST}&"
            ;;
        BOTH)
            [ ! -z "${QUERY_STRING}" ] && q="${QUERY_STRING}&"
            cgi_get_POST_vars
            [ ! -z "${QUERY_STRING_POST}" ] && q="${q}${QUERY_STRING_POST}&"
            ;;
    esac
    shift
    s=" $* "
    # parse the query data
    while [ ! -z "$q" ]; do
        p="${q%%&*}"  # get first part of query string
        k="${p%%=*}"  # get the key (variable name) from it
        v="${p#*=}"   # get the value from it
        q="${q#$p&*}" # strip first part from query string
        # decode and assign variable if requested
        [ "$1" = "ALL" -o "${s/ $k /}" != "$s" ] && \
            export "$k"="`cgi_decodevar \"$v\"`"
    done
    return
}


###
#  Base64 routine
###
# fallback base64 implementation
# works with busybox

encode(){

    hexdump -v -e '2/1 "%02x"' | \
        sed -e 's/0/0000 /g;s/1/0001 /g;s/2/0010 /g;s/3/0011 /g;
                s/4/0100 /g;s/5/0101 /g;s/6/0110 /g;s/7/0111 /g;
                s/8/1000 /g;s/9/1001 /g;s/a/1010 /g;s/b/1011 /g;
                s/c/1100 /g;s/d/1101 /g;s/e/1110 /g;s/f/1111 /g;' | \
        tr -d ' ' | \
        sed -e 's/[01]\{6\}/\0 /g' | \
        sed -e 's_000000_A_g; s_000001_B_g; s_000010_C_g; s_000011_D_g;
                s_000100_E_g; s_000101_F_g; s_000110_G_g; s_000111_H_g;
                s_001000_I_g; s_001001_J_g; s_001010_K_g; s_001011_L_g;
                s_001100_M_g; s_001101_N_g; s_001110_O_g; s_001111_P_g;
                s_010000_Q_g; s_010001_R_g; s_010010_S_g; s_010011_T_g;
                s_010100_U_g; s_010101_V_g; s_010110_W_g; s_010111_X_g;
                s_011000_Y_g; s_011001_Z_g; s_011010_a_g; s_011011_b_g;
                s_011100_c_g; s_011101_d_g; s_011110_e_g; s_011111_f_g;
                s_100000_g_g; s_100001_h_g; s_100010_i_g; s_100011_j_g;
                s_100100_k_g; s_100101_l_g; s_100110_m_g; s_100111_n_g;
                s_101000_o_g; s_101001_p_g; s_101010_q_g; s_101011_r_g;
                s_101100_s_g; s_101101_t_g; s_101110_u_g; s_101111_v_g;
                s_110000_w_g; s_110001_x_g; s_110010_y_g; s_110011_z_g;
                s_110100_0_g; s_110101_1_g; s_110110_2_g; s_110111_3_g;
                s_111000_4_g; s_111001_5_g; s_111010_6_g; s_111011_7_g;
                s_111100_8_g; s_111101_9_g; s_111110_+_g; s_111111_/_g;

                s_0000_A=_g;  s_0001_E=_g;  s_0010_I=_g;  s_0011_M=_g;
                s_0100_Q=_g;  s_0101_U=_g;  s_0110_Y=_g;  s_0111_c=_g;
                s_1000_g=_g;  s_1001_k=_g;  s_1010_o=_g;  s_1011_s=_g;
                s_1100_w=_g;  s_1101_0=_g;  s_1110_4=_g;  s_1111_8=_g;

                s_00_A==_;    s_01_Q==_;    s_10_g==_;    s_11_w==_;
                ' | \
                tr -d ' ' | \
                sed -e 's/.\{64\}/\0\n/g'
        echo
}

decode(){
 
printf "$(
tr -d '\n' | \
sed -e '               
        s_A==_@@_;    s_Q==_@,_;    s_g==_,@_;    s_w==_,,_;

        s_A=_@@@@_;  s_E=_@@@,_;  s_I=_@@,@_;  s_M=_@@,,_;
        s_Q=_@,@@_;  s_U=_@,@,_;  s_Y=_@,,@_;  s_c=_@,,,_;
        s_g=_,@@@_;  s_k=_,@@,_;  s_o=_,@,@_;  s_s=_,@,,_;
        s_w=_,,@@_;  s_@=_,,@,_;  s_4=_,,,@_;  s_8=_,,,,_;

        s_A_@@@@@@_g; s_B_@@@@@,_g; s_C_@@@@,@_g; s_D_@@@@,,_g;
        s_E_@@@,@@_g; s_F_@@@,@,_g; s_G_@@@,,@_g; s_H_@@@,,,_g;
        s_I_@@,@@@_g; s_J_@@,@@,_g; s_K_@@,@,@_g; s_L_@@,@,,_g;
        s_M_@@,,@@_g; s_N_@@,,@,_g; s_O_@@,,,@_g; s_P_@@,,,,_g;
        s_Q_@,@@@@_g; s_R_@,@@@,_g; s_S_@,@@,@_g; s_T_@,@@,,_g;
        s_U_@,@,@@_g; s_V_@,@,@,_g; s_W_@,@,,@_g; s_X_@,@,,,_g;
        s_Y_@,,@@@_g; s_Z_@,,@@,_g; s_a_@,,@,@_g; s_b_@,,@,,_g;
        s_c_@,,,@@_g; s_d_@,,,@,_g; s_e_@,,,,@_g; s_f_@,,,,,_g;
        s_g_,@@@@@_g; s_h_,@@@@,_g; s_i_,@@@,@_g; s_j_,@@@,,_g;
        s_k_,@@,@@_g; s_l_,@@,@,_g; s_m_,@@,,@_g; s_n_,@@,,,_g;
        s_o_,@,@@@_g; s_p_,@,@@,_g; s_q_,@,@,@_g; s_r_,@,@,,_g;
        s_s_,@,,@@_g; s_t_,@,,@,_g; s_u_,@,,,@_g; s_v_,@,,,,_g;
        s_w_,,@@@@_g; s_x_,,@@@,_g; s_y_,,@@,@_g; s_z_,,@@,,_g;
        s_0_,,@,@@_g; s_1_,,@,@,_g; s_2_,,@,,@_g; s_3_,,@,,,_g;
        s_4_,,,@@@_g; s_5_,,,@@,_g; s_6_,,,@,@_g; s_7_,,,@,,_g;
        s_8_,,,,@@_g; s_9_,,,,@,_g; s_+_,,,,,@_g; s_/_,,,,,,_g;
        ' | \
    sed -e 's/[,@]\{4\}/\0 /g' | \
    sed -e 's/@@@@/0/g; s/@@@,/1/g; s/@@,@/2/g; s/@@,,/3/g;
            s/@,@@/4/g; s/@,@,/5/g; s/@,,@/6/g; s/@,,,/7/g;
            s/,@@@/8/g; s/,@@,/9/g; s/,@,@/a/g; s/,@,,/b/g;
            s/,,@@/c/g; s/,,@,/d/g; s/,,,@/e/g; s/,,,,/f/g;' | \
    tr -d ' ' | \
    sed -e 's/../\\x\0/g'
    )"
}

###
#  MAIN PROCEDURE
###
# register all GET and POST variables
if [ ! -z "$ROOTDIR" ] ; then
	if [ -d $ROOTDIR ] ; then
		cd "$ROOTDIR"
	fi
fi

cgi_getvars BOTH ALL

if [ "$REQUEST_METHOD" != "POST" ] ; then
	echo "Status: 405"
	echo "Content-type:text/plain"
	echo "Cache-Control: no-cache, no-store, must-revalidate"
	echo "Expires: 0"
	echo
	echo "Method not allowed!"
	
elif [ -z "$page" -o -z "$data" ] ; then
	echo "Status: 400"
	echo "Content-type:text/plain"
	echo "Cache-Control: no-cache, no-store, must-revalidate"
	echo "Expires: 0"
	echo
	echo "Wrong parameters!"
	
else

dir=$(dirname $page)
if [ -f $dir ] ; then
	echo "Status: 403"
	echo "Content-type:text/plain"
	echo "Cache-Control: no-cache, no-store, must-revalidate"
	echo "Expires: 0"
	echo
	echo "File exists! Can not create directory $dir"
	
elif [ ! -d $dir ] ; then 
	mkdir -p $dir
fi

# Sending headers
echo "Content-type:text/plain"
echo "Cache-Control: no-cache, no-store, must-revalidate"
echo "Expires: 0"
echo "RootDir: $ROOTDIR"
echo

echo -n "$data" | decode > $page

if [ $? -eq 0 ] ; then
	echo -n "Page $page updated"
else
	echo -n "Error !"
fi

fi

#
# Execute with busybox
# busybox.exe bash -c "export TINYWEB_CMD='busybox bash' ; export TINYWEB_CAT='busybox cat' ; tinyweb.exe"
#
