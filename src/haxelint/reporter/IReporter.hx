package haxelint.reporter;

import haxelint.LintMessage;

interface IReporter {
	function start():Void;
	function finish():Void;
	function fileStart(f:LintFile):Void;
	function fileFinish(f:LintFile):Void;
	function addMessage(m:LintMessage):Void;
}
