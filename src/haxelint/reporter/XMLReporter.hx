package haxelint.reporter;

import haxelint.LintMessage.SeverityLevel;
class XMLReporter implements IReporter{
	public function new(){

	}

	public function start(){
		var sb = new StringBuf();
		sb.add("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
		sb.add("<checkstyle version=\"HAXELINT\">\n");
		Sys.stdout().writeString(sb.toString());
	}

	public function finish(){
		var sb = new StringBuf();
		sb.add("</checkstyle>\n");
		Sys.stdout().writeString(sb.toString());
	}

	function encode(s:String):String{
		return s;
	}

	public function fileStart(f:LintFile){
		var sb = new StringBuf();
		sb.add("<file name=\"");
		sb.add(encode(f.name));
		sb.add("\">\n");
		Sys.stdout().writeString(sb.toString());
	}

	public function fileFinish(f:LintFile){
		var sb = new StringBuf();
		sb.add("</file>\n");
		Sys.stdout().writeString(sb.toString());
	}

	static function severityString(s:SeverityLevel):String{
		return switch(s){
		case INFO: return "info";
		case WARNING: return "warning";
		case ERROR: return "error";
		}
	}

	public function addMessage(m:LintMessage){
		var sb:StringBuf = new StringBuf();

		sb.add("<error line=\"");
		sb.add(m.line);
		sb.add("\"");
		if (m.column > 0) {
			sb.add(" column=\"");
			sb.add(m.column);
			sb.add("\"");
		}
		sb.add(" severity=\"");
		sb.add(severityString(m.severity));
		sb.add("\"");
		sb.add(" message=\"");
		sb.add(encode(m.message));
		sb.add("\"");
		sb.add(" source=\"");
		sb.add(encode(m.fileName));
		sb.add("\"/>\n");

		Sys.stdout().writeString(sb.toString());
	}
}
