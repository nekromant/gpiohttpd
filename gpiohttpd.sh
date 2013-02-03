#!/bin/bash
# Created by Necromant (c) 2013
# contact@ncrmnt.org
# Licensed under the terms of WTFPL

# edit port here
PORT=8080

unload_mods()
{
    echo "Unloading conflicting gpio modules"
    rmmod gpio_button_hotplug
    rmmod leds_gpio
    echo "done"
}


list_gpiochips()
{
    for chip in `ls /sys/class/gpio/|grep gpiochip`; do
        echo "${chip}"
    done
}

list_gpios()
{
    ls /sys/class/gpio/|grep gpio|grep -v gpiochip
}


export_gpiochip()
{
    chip=$1
    start=`cat /sys/class/gpio/${chip}/base`
    count=`cat /sys/class/gpio/${chip}/ngpio`
    end=$((start+count))
    echo "gpiochip${chip}: base is ${start}, count ${count}"
    i=$start
    while [ "$i" -lt "$end" ]; do
        echo "exporting $i..."
        echo $i > /sys/class/gpio/export
        i=$((i+1))
    done  
}


# Copypasted from some css tutorials on the internets. 
# Skip this scary part
css()
{
    cat <<EOF
body {
	margin: 0px 0px 0px 0px;
	padding: 0px 0px 0px 0px;
	font-family: verdana, arial, helvetica, sans-serif;
	color: #ccc;
	background-color: #333;
	}
body {
	margin: 0px 0px 0px 0px;
	padding: 0px 0px 0px 0px;
	font-family: verdana, arial, helvetica, sans-serif;
	color: #ccc;
	background-color: #333;
	}
a {
	text-decoration: none;
	font-weight: bold;
	color:  #ccc;
	outline: none;
	}
a:visited {
	color:  #ccc;
	}
a:active {
	color:  #ccc;
	}
a:hover {
	color: #ccc;
	text-decoration: underline;
	}
.ahem {
	display: none;
	}
strong, b {
	font-weight: bold;
	}
p {
	font-size: 12px;
	line-height: 22px;
	margin-top: 20px;
	margin-bottom: 10px; 
	}

/* weird ie5win bug: all line-height to font-size ratios must agree or box gets pushed around. UPDATE: this has turned out to be very rare. my current recommendation is IGNORE this warning. at the moment i'm leaving it in only in case the issue turns up again. possibly the original bug in march 2001 was caused by an unusual combination of factors, although this solved it at the time.*/

h1 {
	font-size: 24px;
	line-height: 44px;
	font-weight: bold;
	margin-top: 0;
	margin-bottom: 0;
	}
h2 {
	font-size: 18px;
	line-height: 40px;
	font-weight: bold;
	margin-top: 0;
	margin-bottom: 0;
	}
h3 {
	font-size: 16px;
	line-height: 22px;
	font-weight: bold;
	margin-top: 0;
	margin-bottom: 0;
	}
h4 {
	font-size: 14px;
	line-height: 26px;
	font-weight: bold;
	margin-top: 0;
	margin-bottom: 0;
	}
h5 {
	font-size: 12px;
	line-height: 22px;
	font-weight: bold;
	margin-top: 0;
	margin-bottom: 0;
	}
h6 {
	font-size: 10px;
	line-height: 18px;
	font-weight: bold;
	margin-top: 0;
	margin-bottom: 0;
	}
img {
	border: 0;
	}
.nowrap {
	white-space: nowrap;
	font-size: 10px;
	font-weight: bold;
	margin-top: 0;
	margin-bottom: 0;
/* must be combined with nobr in html for ie5win */
	}
.tiny {
	font-size: 9px;
	line-height: 16px;
	margin-top: 15px;
	margin-bottom: 5px; 
	}
#left {
	position: absolute;
	top: 0px;
	left: 0px;
	margin: 0px;
	padding: 10px;
	border: 0px;
	background: #666;
	width: 190px; /* ie5win fudge begins */
	voice-family: "\"}\"";
	voice-family:inherit;
	width: 170px;
	}
html>body #left {
	width: 170px; /* ie5win fudge ends */
	}
#middle {
	padding: 10px;
	border: 0px;
	background: #666;
	margin: -20px 190px 0px 190px; /* ie5win fudge begins */
	voice-family: "\"}\"";
	voice-family:inherit;
	margin-top: 0px;
	}
html>body #middle {
	margin-top: 0px; /* ie5win fudge ends */
	}
#right {
	position: absolute;
	top: 0px;
	right: 0px; /* Opera5.02 will show a space at right when there is no scroll bar */
	margin: 0px;
	padding: 10px;
	border: 0px;
	background: #666;
	width: 190px; /* ie5win fudge begins */
	voice-family: "\"}\"";
	voice-family:inherit;
	width: 170px;
	}
html>body #right {
	width: 170px; /* ie5win fudge ends */
	}
pre {
	font-size: 12px;
	line-height: 22px;
	margin-top: 20px;
	margin-bottom: 10px; 
	}
#left {
	position: absolute;
	top: 0px;
	left: 0px;
	margin: 0px;
	padding: 10px;
	border: 0px;
	background: #666;
	width: 190px; /* ie5win fudge begins */
	voice-family: "\"}\"";
	voice-family:inherit;
	width: 170px;
	}
html>body #left {
	width: 170px; /* ie5win fudge ends */
	}
#middle {
	padding: 10px;
	border: 0px;
	background: #666;
	/* ie5win fudge begins */
	margin: -20px 190px 0px 190px; 
	voice-family: "\"}\"";
	voice-family:inherit;
	margin-top: 0px;
	}
html>body #middle {
	margin-top: 0px; /* ie5win fudge ends */
	}
#right {
	position: absolute;
	top: 0px;
	right: 0px; /* Opera5.02 will show a space at right 
	when there is no scroll bar */
	margin: 0px;
	padding: 10px;
	border: 0px;
	background: #666;
	width: 190px; /* ie5win fudge begins */
	voice-family: "\"}\"";
	voice-family:inherit;
	width: 170px;
	}
html>body #right {
	width: 170px; /* ie5win fudge ends */
	}
EOF
}

# The JS part. Sends ajax requests to update the page
# with the new data every second
# Hell yeah, ajax, js and bash to drive gpios. 
# This is so far the most insane stuff I've done

js()
{
    cat <<EOF
function log(t)
{
  document.getElementById("log").innerHTML += '<br>' + t;
}

function clean_log()
{
  document.getElementById("log").innerHTML = "";
}

function get_radio(rname) {
      var rads = document.getElementsByName(rname);
      for (var rad=0;rad<=rads.length-1;rad++) {
        if(rads[rad].checked) {
          return rads[rad].value; 
        }
      }
      return null;
    }


function post_value(path) 
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }

xmlhttp.overrideMimeType('text/plain');
xmlhttp.open("GET",path,true);
xmlhttp.send();
}

function set_gpio(g)
{
var dir = get_radio(g + ".dir");
var v   = get_radio(g + ".v");

if (dir=="out") 
  v = "/" + v;
 else
  v = "";

post_value(g + "/" + dir + v);
}


function update_values()
{
var xmlhttp;
if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }

xmlhttp.onreadystatechange=function()
  {
  if (xmlhttp.readyState==4)
    {
    text = xmlhttp.responseText;
    gpios = text.split(";");
    for (var j = 0; j < gpios.length; j++) {
     inf = gpios[j].split(",");
     if (inf.length > 1) {
     document.getElementById(inf[0] + ".dir." + inf[1]).checked=true;
     document.getElementById(inf[0] + ".v." + inf[2]).checked=true;
      }
     }
    }
  }

xmlhttp.overrideMimeType('text/plain');
xmlhttp.open("GET","/poll",true);
xmlhttp.send();
}
EOF
}

welcome()
{
    cat <<EOF
<b>Welcome to gpiohttpd server by Necromant</b><br>
Created using the voodoo of bash, html, css and javascript<br>
EOF
}


#gpio2
mkgpioitem()
{
    cat <<EOF
<tr>
 <td>$1</td>
 <td>
<input onchange="set_gpio('$1');" type="radio" name="$1.dir" id="$1.dir.in" value="in">input
<input onchange="set_gpio('$1');" type="radio" name="$1.dir" id="$1.dir.out" value="out">output
</td>
 <td>
<input onchange="set_gpio('$1');" type="radio" name="$1.v" id="$1.v.0" value="0">0
<input onchange="set_gpio('$1');" type="radio" name="$1.v" id="$1.v.1" value="1">1
</td>
</td>
EOF
}

mkgpiotable()
{
    cat <<EOF
<form name="gpios">
<table border="1px">
<tr><td><b>gpio</b></td><td><b>direction</b></td><td><b>value</b></td></tr>
EOF
    for g in `list_gpios`; do
	mkgpioitem $g
    done
    cat <<EOF
</table>
</form>
EOF
}

mkhtml()
{
    cat <<EOF
<html>
<head>
<script>
`js`
</script>
  <style type="text/css">
   `css`
  </style>
</head>
<body onload="update_values();setInterval('update_values()', 5000 );">

<div id="left">
<p>gpiohttpd@almery </p>
</div>

<div id="middle">
<pre> `welcome` </pre>
<pre> `mkgpiotable` </pre>
<pre id="log">ajax log started</pre>
[ 
<a href="#" onclick="clean_log()">Clean log</a> |
<a href="#" onclick="update_values()">Refresh</a> 
]
</div>

</body>
</html> 
EOF
}




r=read
e="echo -e"
h="HTTP/1.0";
o="$h 200 OK\r\n";
c="Content";

if [ "$1" == "loop" ]; then
    read a f c
    z=stuff
    while [ ${#z} -gt 2 ]; do 
	read z;
    done;  
    if [ "$f" == "/" ]; then
	$e $o
	echo "`mkhtml`"
	exit 0
    fi
    if [ "$f" == "/poll" ]; then
	    $e $o
	    for g in `list_gpios`; do
		dir=`cat /sys/class/gpio/$g/direction`
		val=`cat /sys/class/gpio/$g/value`
		echo -ne "$g,$dir,$val;"
	    done
	    echo -e "\r\n"
	    exit 0
    fi
    if [ "$f" == "/list" ]; then
	$e $o
	$e "gpio1,gpio2,gpio3,gpio4"
	exit 0
    fi
    #If we reach this, then we need to write gpio data
    gpio=`echo $f |cut -d'/' -f2`
    dir=`echo $f |cut -d"/" -f3`
    value=`echo $f |cut -d"/" -f4`
    $e $o
    $e "$gpio $dir $value"
    #Actually write the gpio values here
    echo $dir > /sys/class/gpio/${gpio}/direction
    if [ ! -z "$value" ]; then
	echo $value > /sys/class/gpio/${gpio}/value
    fi
else
    echo "Necromant's gpiohttpd running on port 8080..."
    echo "Original bashhttpd oneliner idea by Alexey Sveshnikov"
    unload_mods
    echo "Exporting all avaliable gpio"
    for chip in `ls /sys/class/gpio/|grep gpiochip`; do
	export_gpiochip $chip
    done 

    while [ $? -eq 0 ]; do 
	nc -vlp 8080 -c -e "$0 loop"
    done
fi
