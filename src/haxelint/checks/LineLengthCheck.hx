package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

class LineLengthCheck extends Check {
	public function new(){
		super();
	}

	override function actualRun() {
		var length = 120;
		for (i in 0 ... _checker.lines.length){
			var line = _checker.lines[i];
			if (line.length > length) log('Too long line', i+1, 1, INFO);
		}
	}

	override function getModuleName():String{
		return "LineLength";
	}
}
