var tracking;
var gDomain="m.webtrends.com";
var gDcsId="";
var gFpc="WT_FPC";
var gaJsHost=(("https:"==document.location.protocol)?"https://ssl.":"http://www.");
var ganalyticsUA="UA-xxxxxx-x";
var pageTracker;
var atlasimg;

//webtrends setup
if(document.cookie.indexOf(gFpc+"=")==-1)document.write("<script type='text/javascript' src='http"+(window.location.protocol.indexOf('https:')==0?'s':'')+"://"+gDomain+"/"+gDcsId+"/wtid.js"+"'><\/script>");

//ganalytics setup
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
if(ganalyticsUA!="UA-xxxxxx-x")
{
	pageTracker=_gat._getTracker(ganalyticsUA);
	pageTracker._initData();
	pageTracker._trackPageview();
}

//atlas setup
atlasimg=new Image();

//tracking
function Tracking(){this.xmlDoc=null;}

//public function for tracking call, from flash,silverlight,or html
function track(xmlid,extra)
{
	var target;
	var wp;
	var redirect;
	var info=getTrackingInfo(xmlid);
	trackForId(xmlid,extra);
	target="_self";
	try{if(info.target)target=info.target;}catch(e){}
	try{wp=info.windowParameters;}catch(e){}
	try{redirect=info.redirect;}catch(e){}
	if(!redirect)return;
	if(wp)window.open(info.redirect,target,wp);
	else window.open(info.redirect,target);
}

//public function for flash/silverlight tracking calls.
//this is not part of the Tracking object, just a
//function defined in the page.
function flashTrack(xmlid,extra)
{
	tracking.track(xmlid,extra);
}

//prepare the tracking framework by loading xml.
function setupTracking(xmlFile)
{
	tracking=new Tracking();
	tracking.loadXML(xmlFile);
}

//executes the atlas,webtrends,and ganalytics calls.
function trackForId(xmlid,extra)
{
	atlas(xmlid);
	webtrends(xmlid,extra);
	_ganalytics(xmlid);
	omniture(xmlid,extra);
}

//google analytics
function _ganalytics(xmlid)
{
	var info=this.getTrackingInfo(xmlid);
	if(!info.ganalytics)return;
	try{pageTracker._trackPageview(info.ganalytics.toString());}catch(e){}
}

//omniture
function omniture(xmlid,extra)
{
	var info=getTrackingInfo(xmlid);
	if(!info.omniture)return;
	var i=0;
	var l=info.omniture.length;
	var om=info.omniture;
	var nn,nv;
	//if(s==undefined)alert("word");
	//for(i;i<l;i++)s[nn]=nv;
	/*var s_code=s.t();if(s_code)document.write(s_code);*/
}

//webtrends
function webtrends(xmlid,extra)
{
	var info=this.getTrackingInfo(xmlid);
	if(!info.webtrends) return;
	var webtrends=info.webtrends;
	var parts=xmlid.split(",");
	var dcsuri=parts[0];
	var ti=parts[1];
	var cg_n=parts[2];
	if(!ti)ti="undefined";
	if(!cg_n)cg_n="undefined";
	if(extra)
	{
		if(extra[0])dcsuri+=extra[0];
		if(extra[1])ti+=extra[1];
		if(extra[2])cg_n+=extra[2];
	}
	try
	{
		//dcsMultiTrack accepts "pairs" of parameters.
		//alert('DCS.dcsuri: ' + dcsuri + ' WT.ti: ' + ti + ' WT_cg_n: ' + cg_n);
		dcsMultiTrack('DCS.dcsuri',dcsuri,'WT.ti',ti,'WT_cg_n',cg_n);
	}
	catch(e){}
}

//atlas
function atlas(xmlid)
{
	var info=getTrackingInfo(xmlid);
	if(!info.atlas)return;
	var timestamp=new Date();
	var qs="?qstr=random="+Math.ceil(Math.random()*99999999)+timestamp.getUTCFullYear()+timestamp.getUTCMonth()+timestamp.getUTCDate()+timestamp.getUTCHours()+timestamp.getUTCMinutes()+timestamp.getUTCSeconds()+timestamp.getUTCMilliseconds();
	atlasimg.src=info.atlas+qs;
}

//create an xml http request
function createXMLHttpRequest()
{
	if(typeof XMLHttpRequest!="undefined")return new XMLHttpRequest();
	else if (typeof ActiveXObject!="undefined")return new ActiveXObject("Microsoft.XMLHTTP");
	else throw new Error("XMLHttpRequest not supported");
}

//load a tracking.xml file.
function loadXML(file)
{
 	var request=this.createXMLHttpRequest();
	request.open("GET",file,true);
	request.onreadystatechange=function(){if(request.readyState==4)xmlready(request.responseXML);}
	request.send(null);
}

//when xml ready
function xmlready(xml)
{
	xmlDoc=xml;
}

//get tracking information from the xml file.
function getTrackingInfo(xmlid)
{
	var trackNodes=xmlDoc.getElementsByTagName("track");
	var index;
	var i=0;
	var results={};
	for(i=0;i<trackNodes.length;i++)if(xmlid==trackNodes[i].attributes.getNamedItem("id").value)index=i;
	if(null==index)return index;
	try{results.webtrends=trackNodes[index].getElementsByTagName("webtrends").item(0).firstChild.nodeValue;}catch(e){}
	try{results.atlas=trackNodes[index].getElementsByTagName("atlas").item(0).firstChild.nodeValue;}catch(e){}
	try{results.ganalytics=trackNodes[index].getElementsByTagName("ganalytics").item(0).firstChild.nodeValue;}catch(e){}
	try{results.redirect=trackNodes[index].getElementsByTagName("redirect").item(0).firstChild.nodeValue;}catch(e){}
	try{results.target=trackNodes[index].getElementsByTagName("redirect").item(0).attributes.getNamedItem("target").value;}catch(e){}
	try{results.windowParameters=trackNodes[index].getElementsByTagName("redirect").item(0).attributes.getNamedItem("windowParameters").value;}catch(e){}
	try
	{
		var om=[];
		var o=trackNodes[index].getElementsByTagName("omniture").item(0);
		var i=0;
		var l=o.childNodes.length;
		var s=""
		var nn;
		var nv;
		for(i;i<l;i++)
		{
			if(o.childNodes[i].nodeName.toString()=="#text")continue;
			nn=o.childNodes[i].nodeName;
			nv=o.childNodes[i].firstChild.nodeValue;
			om.push(nn,nv);
		}
		results.omniture=om;
	}
	catch(e){}
	return results;
}

Tracking.prototype.createXMLHttpRequest=createXMLHttpRequest;
Tracking.prototype.loadXML=loadXML;
Tracking.prototype.track=track;
Tracking.prototype.trackForId=trackForId;
Tracking.prototype.webtrends=webtrends;
Tracking.prototype.atlas=atlas;
Tracking.prototype.getTrackingInfo=getTrackingInfo;