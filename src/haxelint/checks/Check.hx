package haxelint.checks;

import haxe.macro.Expr.Position;
import haxelint.LintMessage.SeverityLevel;

class Check {

	public function new(){}

	var _checker:Checker;

	public function run(checker:Checker) {
		_checker = checker;
		messages = [];

		actualRun();

		return messages;
	}

	function actualRun(){
		throw "Unimplemented";
	}

	var messages:Array<LintMessage>;

	public function logPos(msg:String, pos:Position, sev:SeverityLevel){
		var lp = _checker.getLinePos(pos.min);
		log(msg, lp.line+1, lp.ofs+1, INFO);
	}

	public function log(msg:String, l:Int, c:Int, sev:SeverityLevel){
		messages.push({
		fileName:_checker.file.name,
		message:msg,
		line:l,
		column:c,
		severity:sev,
		moduleName:getModuleName()
		});
	}

	public function getModuleName():String{
		throw "Unimplemented";
		return "";
	}
}
