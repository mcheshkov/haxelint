package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

class HexademicalLiteralsCheck extends Check {
	public function new(){
		super();
	}

	override function actualRun() {
		Utils.walkFile(_checker.ast, function(e){
			switch(e.expr){
			case EConst(CInt(s)):
				checkString(s,e.pos);
			default:
			}
		});
	}

	function checkString(s:String, p){
		var caps = false;
		if (s.substr(0,2) == "0x"){
			var ss;
			if (caps) ss = s.toUpperCase();
			else ss = s.toLowerCase();
			var lp = _checker.getLinePos(p.min);
			if (s != ss) log('Bad hexademical literal', lp.line+1, lp.ofs+1, INFO);
		}
	}

	override function getModuleName():String{
		return "HexademicalLiterals";
	}
}
