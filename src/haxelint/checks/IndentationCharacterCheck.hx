package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

class IndentationCharacterCheck extends Check {
	public function new(){
		super();
	}

	override function actualRun() {
		var re;
		var tab = true;
		if (tab){
			re = ~/^\t*\S/;
		}
		else{
			re = ~/^ *\S/;
		}
		for (i in 0 ... _checker.lines.length){
			var line = _checker.lines[i];
			if (line.length > 0 && ! re.match(line)) log('Wrong indentation character', i+1, 1, INFO);
		}
	}

	override function getModuleName():String{
		return "IndentationCharacter";
	}
}
