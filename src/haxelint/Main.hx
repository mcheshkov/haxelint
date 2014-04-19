package haxelint;

import haxelint.reporter.XMLReporter;
import haxelint.reporter.Reporter;
import haxe.CallStack;
import sys.io.File;
class Main {
	public static function main() {
		try{
			if (Sys.args().length != 1) throw "Bad args count";
			var fname = Sys.args()[0];

			var code = File.getContent(fname);
			var checker = new Checker();
			checker.addReporter(new XMLReporter());
			checker.process([{name:fname,content:code}]);
		}
		catch(e:Dynamic){
			trace(e);
			trace(CallStack.toString(CallStack.exceptionStack()));
		}
	}
}
