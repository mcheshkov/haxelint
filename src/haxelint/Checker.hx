package haxelint;

import haxelint.checks.Check;
import haxelint.checks.ListenerNameCheck;
import haxeparser.Data.TypeDef;
import haxelint.reporter.IReporter;
import haxelint.checks.IndentCheck;
import haxeparser.HaxeLexer;
import haxeparser.Data.Token;

class Checker {
	var checks:Array<Check>;
	var reporters:Array<IReporter>;
	public var file:File;

	public function new(){
		checks = [
		new IndentCheck(),
		new ListenerNameCheck()
		];
		reporters = [];
	}

	public function addReporter(r:IReporter):Void{
		reporters.push(r);
	}

	function makePosIndices(){
		var code = file.content;
		linesIdx = [];

		var last = 0;
		var left = false;

		for (i in 0...code.length){
			if (code.charAt(i) == '\n'){
				linesIdx.push({l:last, r:i});
				last = i+1;
				left = false;
			}
			left = true;
		}
		if (left) linesIdx.push({l:last, r:code.length-1});
	}

	var linesIdx:Array<{l:Int,r:Int}>;

	public function getLinePos(off:Int):{line:Int,ofs:Int}{
		for (i in 0...linesIdx.length){
			if (linesIdx[i].l <= off && linesIdx[i].r >= off) return {line:i,ofs:off-linesIdx[i].l};
		}
		throw "Bad offset";
	}

	public var lines:Array<String>;

	function makeLines(){
		var code = file.content;
		var left = false;
		var s = 0;
		lines = [];
		for (i in 0...code.length){
			if (code.charAt(i) == "\n"){
				lines.push(code.substr(s,i-s));
				s=i+1;
				left = false;
			}
			else left = true;
		}
		if (left) lines.push(code.substr(s,code.length-s));
	}

	public var tokens:Array<Token>;

	function makeTokens(){
		var code = file.content;
		tokens = [];
		var lexer = new HaxeLexer(byte.ByteData.ofString(code), file.name);
		var t:Token = lexer.token(HaxeLexer.tok);
		while (t.tok != Eof){
			tokens.push(t);

			t = lexer.token(haxeparser.HaxeLexer.tok);
		}
	}

	public var ast:{pack: Array<String>, decls: Array<TypeDef> };

	function makeAST(){
		var code = file.content;
		var parser = new haxeparser.HaxeParser(byte.ByteData.ofString(code), file.name);
		ast = parser.parse();
	}

	public function process(files:Array<File>):Void{
		for (reporter in reporters) reporter.start();

		for (file in files) run(file);

		for (reporter in reporters) reporter.finish();
	}

	public function run(file:File){
		for (reporter in reporters) reporter.fileStart(file);

		this.file = file;
		makeLines();
		makePosIndices();
		makeTokens();
		makeAST();

		for (check in checks){
			var messages = check.run(this);
			for (reporter in reporters) for (m in messages) reporter.addMessage(m);
		}

		for (reporter in reporters) reporter.fileFinish(file);
	}
}
