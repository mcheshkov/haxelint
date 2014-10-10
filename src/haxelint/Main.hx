package haxelint;

import haxelint.reporter.IReporter;
import hxargs.Args;
import sys.FileSystem;
import haxelint.reporter.XMLReporter;
import haxelint.reporter.Reporter;
import haxe.CallStack;
import sys.io.File;

class Main {
	public static function main() {
		var args;
		var cwd;
		var oldCwd = null;

		try{
			args = Sys.args();
			cwd = Sys.getCwd();
			if (Sys.getEnv("HAXELIB_RUN") != null){
				cwd = args.pop();
				oldCwd = Sys.getCwd();
			}
			if (oldCwd != null) Sys.setCwd(cwd); // FIXME instead of this one should gracefully parse absolute-relative path

			var reporter:IReporter = new Reporter();
			var files:Array<String> = [];

			var argHandler = Args.generate([
			@doc("Set reporter")
			["-r", "--reporter"] => function(reporterName:String) reporter = createReporter(reporterName),
			@doc("List all reporters")
			["--list-reporters"] => function() listReporters(),
			@doc("Set sources to process")
			["-s", "--source"] => function(sourcePath:String) traverse(sourcePath,files),
			_ => function(arg:String) throw "Unknown command: " + arg
			]);
			if (args.length == 0) {
				Sys.println(argHandler.getDoc());
				Sys.exit(0);
			}
			argHandler.parse(args);

			var toProcess:Array<LintFile> = [];
			for (file in files){
				var code = File.getContent(file);
				toProcess.push({name:file,content:code});
			}

			var checker = new Checker();
			checker.addAllChecks();
			checker.addReporter(reporter);
			checker.process(toProcess);
		}
		catch(e:Dynamic){
			trace(e);
			trace(CallStack.toString(CallStack.exceptionStack()));
		}
		if (oldCwd != null) Sys.setCwd(oldCwd); // FIXME instead of this one should gracefully parse absolute-relative path
	}

	//FIXME some macro maybe?
	static function listReporters():Void {
		Sys.println("default - Default reporter");
		Sys.println("xml - Checkstyle-like XML reporter");
		Sys.exit(0);
	}

	//FIXME some macro maybe?
	static function createReporter(reporterName:String):IReporter{
		return switch(reporterName){
		case "xml": new XMLReporter();
		case "default": new Reporter();
		default: throw "Unknown reporter";
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
