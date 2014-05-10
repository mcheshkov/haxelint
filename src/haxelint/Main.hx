package haxelint;

import sys.FileSystem;
import haxelint.reporter.XMLReporter;
import haxelint.reporter.Reporter;
import haxe.CallStack;
import sys.io.File;
class Main {
	public static function main() {
		try{
			if (Sys.args().length != 1) throw "Bad args count";
			var fname = Sys.args()[0];
			var files:Array<String> = [];
			traverse(fname, files);

			var toProcess:Array<LintFile> = [];
			for (file in files){
				var code = File.getContent(file);
				toProcess.push({name:file,content:code});
			}

			var checker = new Checker();
			checker.addReporter(new XMLReporter());
			checker.process(toProcess);
		}
		catch(e:Dynamic){
			trace(e);
			trace(CallStack.toString(CallStack.exceptionStack()));
		}
	}

	private static function pathJoin(s:String, t:String):String{
		//FIXME
		return s + "/" + t;
	}

	private static function traverse(node:String , files:Array<String>) {
		if (FileSystem.isDirectory(node)){
			var nodes = FileSystem.readDirectory(node);
			for (child in nodes){
				traverse(pathJoin(node,child),files);
			}
		}
		else if (node.substr(-3) == ".hx"){
			files.push(node);
		}
	}
}
