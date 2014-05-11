package haxelint.checks;

import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxeparser.Data.Definition;
import haxe.macro.Expr.Function;
import haxeparser.Data.ClassFlag;
import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

class ListenerNameCheck extends Check {
	public function new(){
		super();
	}

	override public function actualRun() {
		for (td in _checker.ast.decls){
			switch(td){
			case EClass(d): searchClass(d);
			case EAbstract(a): //trace("Abstract");

			case EEnum(d): //trace("Enum");
			case EImport(sl, mode): //trace("Import");
			case ETypedef(d): //trace("typedef");
			case EUsing(path): //trace("Using");
			}
		}
	}

	function searchClass(d:Definition<ClassFlag, Array<Field>>){
		for (f in d.data){
			switch(f.kind){
				case FFun(ff): Utils.walkFunction(ff,function(e){
					switch(e.expr){
					case ECall(e, params):
						searchCall(e,params);
					default:
					}
				});
				default:
			}
		}
	}

	function searchCall(e,p){
		if (! searchLeftCall(e)) return;
		searchCallParam(p);
	}

	function searchLeftCall(e){
		var name = "addEventListener";
		switch(e.expr){
		case EConst(CIdent(ident)): return ident == name;
		case EField(e2,field): return field == name;
		default:return false;
		}
	}

	function searchCallParam(p:Array<Expr>){
		if (p.length < 2) return;
		var listener = p[1];
		switch(listener.expr){
		case EConst(CIdent(ident)):
			var lp = _checker.getLinePos(listener.pos.min);
			checkListenerName(ident, lp.line, lp.ofs);
		default:
		}
	}

	function checkListenerName(name:String, line:Int, col:Int){
		var re = ~/^on.*/;
		var match = re.match(name);
		if (!match) log("Wrong listener name: " + name, line, col, INFO);
	}

	override function getModuleName():String{
		return "ListenerName";
	}
}
