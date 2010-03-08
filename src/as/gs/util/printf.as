package gs.util
{
	/**
	 * Python style print format.
	 * 
	 * <p>Taken from http://www.stimuli.com.br/trane/2009/feb/21/printf-as3/. I
	 * re-factored the code to fit guttershark style. Yeah I'm that anal.</p>
	 * 
	 * @example Examples of supported print formats
	 * <listing>	
	 * //setup some test vars
	 * public var d:Date=new Date(1978,2,10,14,35,5,6);
	 * public var me:Object={name:"Aaron",occupation:"developer",pi:3.1424,birth:new Date(1983,12,2)};
	 * 
	 * //string
	 * trace( printf("my name is %s, I'm a %s",me.name,me.occupation) ); //my name is aaron, I'm a developer
	 * 
	 * //named substitutions
	 * trace( printf("hello %(name)s.",me) ); //hello Aaron
	 * trace( printf("I'm %(name)s, a %(occupation)s",me) ); //I'm aaron a developer
	 * 
	 * //date formats
	 * trace( printf("%Y",d) ); //1978 (Full year)
	 * trace( printf("%y",d) ); //78 (year)
	 * trace( printf("%m",d) ); //3 (month)
	 * trace( printf("%D",d) ); //10 (day)
	 * trace( printf("%H",d) ); //14 (24 hour)
	 * trace( printf("%I",d) ); //2 (12 hour)
	 * trace( printf("%p",d) ); //p.m (a.m / p.m)
	 * trace( printf("%M",d) ); //35 (minutes)
	 * trace( printf("%S",d) ); //5 (seconds)
	 * 
	 * //floats
	 * trace( printf("this is %f.",4) ); //this is 4
	 * trace( printf("this is %f",4.4) ); //this is 4.4
	 * trace( printf("this is %f.4",4.42343232) ); //this is 4.4234
	 * //float padding
	 * trace( printf("this is_%3f",4) ); //this is_  4
	 * trace( printf("this is_%23f",4) ); //this is_     4
	 * trace( printf("this is %03f",499) ); //this is 499
	 * trace( printf("this is %3f",499) ); //this is 499
	 * trace( printf("this is %04f",8.5) ); //this is 08.5
	 * 
	 * //hex
	 * trace( printf("this is %x.",20) ); //0x14
	 * 
	 * //octal
	 * trace( printf("this is %o.",32) ); //this is 040
	 * </listing>
	 * 
	 * <script src="http://mint.codeendeavor.com/?js" type="text/javascript"></script>
	 */
	public function printf(raw:String, ...rest):String
	{
		if(raw==null)
		{
			trace("WARNING: The format string for printf was null or empty, returning an empty string.");
			return "";	
		}
		/*
		 * % -> the start of a substitution hole
		 * (some_var_name) -> [optional] used in named substitutions
		 * .xx -> [optional] the precision with witch numbers will be formated  
		 * x -> the formatter (string, hexa, float, date part)
		 */
		var SUBS_RE:RegExp=/%(?!^%)(\((?P<var_name>[\w_\d]+)\))?(?P<padding>[0-9]{1,2})?(?P<formater>[sxofaAbBcdHIjmMpSUwWxXyYZ])(\.(?P<precision>[0-9]+))?/ig;
		var result:Object=SUBS_RE.exec(raw);
		var isPositionalSubts:Boolean=!Boolean(raw.match(/%\(\s*[\w\d_]+\s*\)/));// checks for name substitutions like %(foo)s
		var matches:Array=[];
		var match:Match;
		var runs:int=0;
		var numMatches:int=0;
		var numberVariables:int=rest.length;
		var replacementValue:*;
		var formater:String;
		var varName:String;
		var precision:String;
		var padding:String;
		var paddingNum:int;
		var paddingChar:String;
		while(Boolean(result))
		{
			match=new Match();
			match.startIndex=result.index;
			match.length=String(result[0]).length;
			match.endIndex=match.startIndex+match.length;
			match.content=String(result[0]);
			formater=result.formater;
			varName=result.var_name;
			precision=result.precision;
			padding=result.padding;
			if(padding)
			{
				if(padding.length==1)
				{
					paddingNum=int(padding);
					paddingChar=" ";
				}
				else
				{
					paddingNum=int(padding.substr(-1,1));
					paddingChar=padding.substr(-2,1);
					if(paddingChar!="0")
					{
						paddingNum*=int(paddingChar);
						paddingChar=" ";
					}
				} 
			}
			if(isPositionalSubts)replacementValue=rest[matches.length];//by position, grab next subs
			else replacementValue=rest[0]==null?undefined:rest[0][varName]; //by hash / properties
			if(replacementValue==undefined)replacementValue="";
			if(replacementValue!=undefined)
			{
				if(formater==stringFormat)match.replacement=padString(replacementValue.toString(),paddingNum,paddingChar);
				else if(formater==floatFormat)
				{
					if(precision)match.replacement=padString(String(truncateNumber(Number(replacementValue),int(precision))),paddingNum,paddingChar);
					else match.replacement=padString(replacementValue.toString(),paddingNum,paddingChar);
				}
				else if(formater==integerFormat)match.replacement=padString(int(replacementValue).toString(),paddingNum,paddingChar);
				else if(formater==octalFormat)match.replacement="0"+int(replacementValue).toString(8);
				else if (formater==hexaFormat)match.replacement="0x"+int(replacementValue).toString(16);
				else if(dateFormats.indexOf(formater)>-1)
				{
					switch(formater)
					{
						case dateDayFormat:
							match.replacement=replacementValue.date;
							break;
						case dateFullyearFormat:
							match.replacement=replacementValue.fullYear;
							break;
						case dateYearFormat:
							match.replacement=replacementValue.fullYear.toString().substr(2,2);
							break;
						case dateMonthFormat:
							match.replacement=String(replacementValue.month+1);
							break;
						case dateHour24Format:
							match.replacement=replacementValue.hours;
							break;
						case dateHourFormat:
							var hours24:Number=replacementValue.hours;
							match.replacement=(hours24-12).toString();
							break;
						case dateHourAMPMFormat:
							match.replacement=(replacementValue.hours>=12?"p.m":"a.m");
							break;
						case dateLocaleFormat:
							match.replacement=replacementValue.toLocaleString();
							break;
						case dateMinuteFormat:
							match.replacement=replacementValue.minutes;
							break;
						case dateSecondsFormat:
							match.replacement=replacementValue.seconds;
							break;   
					}
				}
				matches.push(match);
			}
			runs++;
			if(runs>10000)break; //too many, break this shit.
			numMatches++;
			result=SUBS_RE.exec(raw);
		}
		if(matches.length==0)return raw;
		var buffer:Array=[];
		var subs:String;
		var lastMatch:Match;
		var previous:String=raw.substr(0,matches[0].startIndex);
		for each(match in matches)
		{
			//finds out the previous string part and the next substitition
			if(lastMatch)previous=raw.substring(lastMatch.endIndex,match.startIndex);
			buffer.push(previous);
			buffer.push(match.replacement);
			lastMatch=match;
		}
		buffer.push(raw.substr(match.endIndex,raw.length-match.endIndex));
		return buffer.join("");
	}
}

/**
 * Date format strings lookup.
 */
const dateFormats:String="aAbBcDHIjmMpSUwWxXyYZ";

/**
 * Converts to a string
 */
const stringFormat:String="s";

/**
 * Outputs as a Number, can use the precision specifier: %.2sf will output a float with 2 decimal digits.
 */
const floatFormat:String="f";

/**
 * Outputs as an Integer.
 */
const integerFormat:String="d";

/**
 * Converts to an OCTAL number
 */
const octalFormat:String="o";

/**
 * Converts to a Hexa number (includes 0x)
 */
const hexaFormat:String="x";

/**
 * Day of month, from 0 to 30 on <code>Date</code> objects.
 */
const dateDayFormat:String="D";

/**
 * Full year, e.g. 2007 on <code>Date</code> objects.
 */
const dateFullyearFormat:String="Y";

/**
 * Year, e.g. 07 on <code>Date</code> objects.
 */
const dateYearFormat:String="y";

/**
 * Month from 1 to 12 on <code>Date</code> objects.
 */
const dateMonthFormat:String="m";

/**
 * Hours (0-23) on <code>Date</code> objects.
 */
const dateHour24Format:String="H";

/**
 * Hours 0-12 on <code>Date</code> objects.
 */
const dateHourFormat:String="I";

/** 
 * a.m or p.m on <code>Date</code> objects.
 */
const dateHourAMPMFormat:String="p";

/**
 * Minutes on <code>Date</code> objects.
 */
const dateMinuteFormat:String="M";

/**
 * Seconds on <code>Date</code> objects.
 */
const dateSecondsFormat:String="S";

/**
 * A string rep of a <code>Date</code> object on the current locale.
 */
const dateLocaleFormat:String="c";

/**
 * A value object for each match.
 */
class Match
{
	public var startIndex:int;
	public var endIndex:int;
	public var length:int;
	public var content:String;
	public var replacement:String;
	public var before:String;
	public function toString():String
	{
		return "Match ["+startIndex+" - "+endIndex+"] ("+length+") "+content+", replacement:"+replacement+";";
	}
}
function truncateNumber(raw:Number,decimals:int=2):Number 
{
	var power:int=Math.pow(10,decimals);
	return Math.round(raw*(power))/power;
}
function padString(str:String, paddingNum:int, paddingChar:String=" "):String
{
	if(paddingChar==null) return str;
	var i:int=0;
	var buf:Array=[];
	for(;i<Math.abs(paddingNum)-str.length;i++)buf.push(paddingChar);
	if(paddingNum<0)buf.unshift(str);
	else buf.push(str);
	return buf.join("");
}