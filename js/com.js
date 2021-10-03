function getParamsFromString( loc ) {
	var params = {};
	if (loc.length>0 ) {
		var parts = loc.slice(1).split('&');
		if( parts.length>0 ) for( i=0 ; i<parts.length ; i++ ) {
			var pair = parts[i].split('=');
			pair[0] = decodeURIComponent(pair[0]);
			pair[1] = decodeURIComponent(pair[1]).replace(/%3D/g,'=').replace(/%26/g,'&') ;
			params[pair[0]] = (pair[1] !== 'undefined') ? pair[1] : true ;
			pair = null ;
		}
		parts = null ;
	}
	return params;
}
function getParams() {
	var params = {};
	if (location.search) {
		return getParamsFromString(location.search);
	}
	return params;
}
function setSelectionRange(input, selectionStart, selectionEnd) {
  if (input.setSelectionRange) {
    input.focus();
    input.setSelectionRange(selectionStart, selectionEnd);
  }
  else if (input.createTextRange) {
    var range = input.createTextRange();
    range.collapse(true);
    range.moveEnd('character', selectionEnd);
    range.moveStart('character', selectionStart);
    range.select();
  }
}
function setCaretToPos (input, pos) {
   setSelectionRange(input, pos, pos);
}
function force_scroll(el, pct) {
	if( el==null ) { return ; }
	el.scrollTop = parseInt( pct * el.scrollHeight ) ;
}
function loadPage(page,fctok,fctko) {
	var xhr = null ;
	try { xhr = new XMLHttpRequest() ;
	} catch(e) {
		try { xhr = new ActiveXObject("Msxml2.XMLHTTP") ;
		} catch (e2) {
			try { xhr = new ActiveXObject("Microsoft.XMLHTTP") ;
			} catch (e) { 
				alert( "No XMLHTTPRequest objects support ...") ;
			}
		}
	}
	xhr.onreadystatechange = function() {
		if(xhr.readyState == 1) {
		} else if(xhr.readyState == 4) {
			if( xhr.status == 200 ) {
				if( xhr.getResponseHeader("X-Salt") != null ) { 
					fctok( xhr.responseText, xhr.getResponseHeader("X-Salt") ) ;
				} else {
					fctok( xhr.responseText, "" ) ;
				}
			} else {
				fctko() ;
			}
		}
	}
	xhr.open( "GET", page, true ) ;
	xhr.withCredentials = true ;
	xhr.send( null ) ;
}
function savePage(url, page, data, fctok,fctko) {
	var xhr = null ;
	try { xhr = new XMLHttpRequest() ;
	} catch(e) {
		try { xhr = new ActiveXObject("Msxml2.XMLHTTP") ;
		} catch (e2) {
			try { xhr = new ActiveXObject("Microsoft.XMLHTTP") ;
			} catch (e) { 
				alert( "No XMLHTTPRequest objects support ...") ;
			}
		}
	}
	xhr.onreadystatechange = function() {
		if(xhr.readyState == 1) {
		} else if(xhr.readyState == 4) {
			if( xhr.status == 200 ) {
				if( xhr.responseText.match( /^Page .* updated/ ) ) {
					fctok() ;
				} else {
					fctko() ;
				}
			} else {
				fctko() ;
			}
		}
	}
	xhr.open( "POST", url, true ) ;
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xhr.withCredentials = true ;
	var Params = "page="+page+"&data="+encodeURIComponent(data) ;
	xhr.send( Params ) ;
}
function loadjscssfile(filename, filetype, title) {
    if (filetype=="js"){ //if filename is a external JavaScript file
        var fileref=document.createElement('script')
        fileref.setAttribute("type","text/javascript")
        fileref.setAttribute("src", filename)
    }
    else if (filetype=="css"){ //if filename is an external CSS file
        var fileref=document.createElement("link")
        fileref.setAttribute("rel", "stylesheet")
        fileref.setAttribute("type", "text/css")
	fileref.setAttribute("title", title)
        fileref.setAttribute("href", filename)
    }
    if (typeof fileref!="undefined")
        document.getElementsByTagName("head")[0].appendChild(fileref)
}
/*
loadjscssfile("myscript.js", "js") //dynamically load and add this .js file
loadjscssfile("javascript.php", "js") //dynamically load "javascript.php" as a JavaScript file
loadjscssfile("mystyle.css", "css") ////dynamically load and add this .css file
*/
function removejscssfile(filename, filetype){
    var targetelement=(filetype=="js")? "script" : (filetype=="css")? "link" : "none" //determine element type to create nodelist from
    var targetattr=(filetype=="js")? "src" : (filetype=="css")? "href" : "none" //determine corresponding attribute to test for
    var allsuspects=document.getElementsByTagName(targetelement)
    for (var i=allsuspects.length; i>=0; i--){ //search backwards within nodelist for matching elements to remove
    if (allsuspects[i] && allsuspects[i].getAttribute(targetattr)!=null && allsuspects[i].getAttribute(targetattr).indexOf(filename)!=-1)
        allsuspects[i].parentNode.removeChild(allsuspects[i]) //remove element by calling parentNode.removeChild()
    }
}
/*
removejscssfile("somescript.js", "js") //remove all occurences of "somescript.js" on page though in most browser this does not unload the script
removejscssfile("somestyle.css", "css") //remove all occurences "somestyle.css" on page
*/

function textareaSelect(el, start, end) {
    el.focus();
    if (el.setSelectionRange) { 
        el.setSelectionRange(start, end);
    } 
    else { 
        if(el.createTextRange) { 
            var normalizedValue = el.value.replace(/\r\n/g, "\n");
            start -= normalizedValue.slice(0, start).split("\n").length - 1;
            end -= normalizedValue.slice(0, end).split("\n").length - 1;
            range=el.createTextRange(); 
            range.collapse(true);
            range.moveEnd('character', end);
            range.moveStart('character', start); 
            range.select();
        } 
    }
}
