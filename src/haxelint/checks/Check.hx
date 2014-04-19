package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

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

	function getModuleName():String{
		throw "Unimplemented";
		return "";
	}
}
