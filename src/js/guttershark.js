if(typeof net=="undefined")var net={};
if(typeof net.guttershark=="undefined")net.guttershark={};

/**
 * Check if popup's are blocked.
 */
net.guttershark.arePopupsBlocked=function()
{
	var o;
	var mine=window.open('','','width=1,height=1,left=0,top=0,scrollbars=no');
	if(mine)o=false;
	else o=true;
	mine.close();
	return o;
}

/**
 * Add a window onload callback to the page load.
 * @param func The function to call.
 */
net.guttershark.addLoadEvent=function(func)
{
	var oldonload=window.onload;
	if(typeof window.onload!='function')window.onload=func;
	else window.onload=function(){oldonload();func();}
}

/**
 * Get the value of a query string parameter, preventing cross scripting.
 * @param name The parameter name.
 * @caseInsensitive Whether or not to search for the parameter case insensitively.
 * @defaultValueIfNull A default value to return, if a parameter is not found, otherwise null will be returned.
 */
net.guttershark.qsSafeValue=function(name,caseInsensitive,defaultValueIfNull)
{
	name=name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
	var r="[\\?&]"+name+"=([^&#]*)";
	var rmod=""
	if(caseInsensitive)rmod+="i";
	var s=new RegExp(r,rmod);
	var res=s.exec(window.location.href.toString());
	if(!res&&defaultValueIfNull)return defaultValueIfNull;
	else if(!res)return null;
	else return res[1];
}

/**
 * Finds a language code from the window location.
 */
net.guttershark.findLangCode=function()
{
	var l = window.location.toString().toLowerCase();
	if(l.indexOf("en-us")>-1||l.indexOf("en_us")>-1) return "en-us"; //United States
	if(l.indexOf("en-au")>-1||l.indexOf("en_au")>-1) return "en-au"; //Austrailia
	if(l.indexOf("nl-be")>-1||l.indexOf("en_be")>-1) return "nl-be"; //Belgium
	if(l.indexOf("fr-be")>-1||l.indexOf("fr_be")>-1) return "fr-be"; //Belgique
	if(l.indexOf("pt-br")>-1||l.indexOf("pr_br")>-1) return "pt-br"; //Brazil
	if(l.indexOf("en-ca")>-1||l.indexOf("en_ca")>-1) return "en-ca"; //English canada
	if(l.indexOf("fr-ca")>-1||l.indexOf("fr_ca")>-1) return "fr-ca"; //French canada
	if(l.indexOf("cs-cz")>-1||l.indexOf("cs_cz")>-1) return "cs-cz"; //Chek Republic
	if(l.indexOf("es-cl")>-1||l.indexOf("es_cl")>-1) return "es-cl"; //Chile
	if(l.indexOf("es-co")>-1||l.indexOf("es_co")>-1) return "es-co"; //Columbia
	if(l.indexOf("da-dk")>-1||l.indexOf("da_dk")>-1) return "da-dk"; //Denmark
	if(l.indexOf("de-de")>-1||l.indexOf("de_de")>-1) return "de-de"; //Germany
	if(l.indexOf("el-gr")>-1||l.indexOf("el_gr")>-1) return "el-gr"; //Greece
	if(l.indexOf("es-es")>-1||l.indexOf("es_es")>-1) return "es-es"; //Spain
	if(l.indexOf("fr-fr")>-1||l.indexOf("fr_fr")>-1) return "fr-fr"; //France
	if(l.indexOf("zh-hk")>-1||l.indexOf("zh_hk")>-1) return "zh-hk"; //Hong Kong
	if(l.indexOf("hi-in")>-1||l.indexOf("hi_in")>-1) return "hi-in"; //India
	if(l.indexOf("en-ie")>-1||l.indexOf("en_ie")>-1) return "en-ie"; //Ireland
	if(l.indexOf("it-it")>-1||l.indexOf("it_it")>-1) return "it-it"; //Italy
	if(l.indexOf("ja-jp")>-1||l.indexOf("ja_jp")>-1) return "ja-jp"; //Japan
	if(l.indexOf("ko-kr")>-1||l.indexOf("ko_kr")>-1) return "ko-kr"; //Korea
	if(l.indexOf("hu-hu")>-1||l.indexOf("hu_hu")>-1) return "hu-hu"; //Hungary
	if(l.indexOf("es-mx")>-1||l.indexOf("es_mx")>-1) return "es-mx"; //Mexico
	if(l.indexOf("nl-nl")>-1||l.indexOf("nl_nl")>-1) return "nl-nl"; //Netherlands
	if(l.indexOf("en-nz")>-1||l.indexOf("en_nz")>-1) return "en-nz"; //New zealand
	if(l.indexOf("nb-no")>-1||l.indexOf("nb_no")>-1) return "nb-no"; //Norway
	if(l.indexOf("de-at")>-1||l.indexOf("de_at")>-1) return "de-at"; //Austria
	if(l.indexOf("pl-pl")>-1||l.indexOf("pl_pl")>-1) return "pl-pl"; //Poland
	if(l.indexOf("pt-pt")>-1||l.indexOf("pt_pt")>-1) return "pt-pt"; //Portugal
	if(l.indexOf("ru-ru")>-1||l.indexOf("ru_ru")>-1) return "ru-ru"; //Russia
	if(l.indexOf("zh-sg")>-1||l.indexOf("zh_sg")>-1) return "zh-sg"; //Singapore
	if(l.indexOf("sk-sk")>-1||l.indexOf("sk_sk")>-1) return "sk-sk"; //Sweden
	if(l.indexOf("en-za")>-1||l.indexOf("en_za")>-1) return "en-za"; //South Africa
	if(l.indexOf("fr-ch")>-1||l.indexOf("fr_ch")>-1) return "fr-ch"; //Switzerland
	if(l.indexOf("fi-fi")>-1||l.indexOf("fi_fi")>-1) return "fi-fi"; //Finland
	if(l.indexOf("sv-se")>-1||l.indexOf("sv_se")>-1) return "sv-se"; //Sweden
	if(l.indexOf("zh-tw")>-1||l.indexOf("zh_tw")>-1) return "zh-tw"; //Taiwan
	if(l.indexOf("en-ae")>-1||l.indexOf("en_ae")>-1) return "en-ae"; //United Arab Emirates
	if(l.indexOf("en-gb")>-1||l.indexOf("en_gb")>-1) return "en-gb"; //United Kingdom
	return "NO_LANG_CODE";
}

/**
 * The Paths class is used for all Path definitions in guttershark.
 */
net.guttershark.Paths=new function()
{
	var _paths={};
	this.addPath=function(pathId,path)
	{
		if(!pathId)
		{
			alert("Parameter pathId required.");
			return;
		}
		if(!path)
		{
			alert("Parameter path required.");
			return;
		}
		_paths[pathId]=path;
	}
	this.getPath=function(pathIds)
	{
		if(!pathIds)
		{
			alert("Parameter pathIds required.");
			return;
		}
		var fp = "";
		for(var i = 0; i < pathIds.length; i++)
		{
			if(!_paths[pathIds[i]])
			{
				alert("Path for id {"+pathIds[i]+"} not defined.")
				return;
			}
			fp += _paths[pathIds[i]];
		}
		return fp;
	}
	this.isPathDefined=function(path)
	{
		return !(_paths[path]===false);
	}
	this.assetLogicPing=function()
	{
		return true;
	}
}

/**
 * Class for Cookies.
 */
net.guttershark.Cookies=new function()
{
	this.writeSessionCookie=function(cookieName,cookieValue)
	{
		if(testSessionCookie())
		{
	    document.cookie=escape(cookieName)+"="+escape(cookieValue)+"; path=/";
	    return true;
	  }
	  else return false;
	}
	this.getCookieValue=function(cookieName)
	{
	  var exp = new RegExp(escape(cookieName)+"=([^;]+)");
	  if(exp.test(document.cookie + ";"))
		{
			exp.exec(document.cookie + ";");
	    return unescape(RegExp.$1);
	  }
	  else return false;
	}
	this.testSessionCookie=function()
	{
		document.cookie="testSessionCookie=Enabled";
		if(getCookieValue("testSessionCookie")=="Enabled") return true;
	  else return false;
	}
	this.testPersistentCookie=function()
	{
		writePersistentCookie("testPersistentCookie","Enabled","minutes",1);
	  if(getCookieValue("testPersistentCookie")=="Enabled") return true;
		else return false;
	}
	this.writePersistentCookie=function(CookieName,CookieValue,periodType,offset)
	{
		var expireDate=new Date();
		offset=offset/1;
		var myPeriodType = periodType;
	  switch(myPeriodType.toLowerCase())
		{
			case "years": 
				var year = expireDate.getYear();
	     	// Note some browsers give only the years since 1900, and some since 0.
	     	if (year < 1000) year = year + 1900;
	     	expireDate.setYear(year + offset);
	     	break;
	    case "months":
	      expireDate.setMonth(expireDate.getMonth() + offset);
	      break;
	    case "days":
	      expireDate.setDate(expireDate.getDate() + offset);
	      break;
	    case "hours":
	      expireDate.setHours(expireDate.getHours() + offset);
	      break;
	    case "minutes":
	      expireDate.setMinutes(expireDate.getMinutes() + offset);
	      break;
	    default:
	      alert("Invalid periodType parameter for writePersistentCookie()");
	      break;
	  } 
	  document.cookie = escape(CookieName)+"="+escape(CookieValue)+"; expires="+expireDate.toGMTString()+"; path=/";
	}
	this.deleteCookie=function(cookieName)
	{
		if(getCookieValue(cookieName)) writePersistentCookie(cookieName,"Pending delete","years",-1);
		return true;     
	}
}