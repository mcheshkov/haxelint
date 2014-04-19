package haxelint.reporter;

import haxelint.LintMessage;

interface IReporter {
	function start():Void;
	function finish():Void;
	function fileStart(f:File):Void;
	function fileFinish(f:File):Void;
	function addMessage(m:LintMessage):Void;
}
