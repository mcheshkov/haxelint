package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data;
import haxe.macro.Expr;

@name("Naming")
class NamingCheck extends Check {
	public function new(){
		super();
	}

	var camelCaseRE = ~/^_?[a-z]\w*$/;
	var bigCamelCaseRE = ~/^_?[A-Z]\w*$/;
	var capsRE = ~/^_?[A-Z][A-Z0-9_]*$/;
	var privateRE = ~/^_/;

	override function actualRun() {
		checkClassFields();
		checkLocalVars();
	}
	
	function checkClassFields(){
		for (td in _checker.ast.decls){
			switch (td.decl){
				case EClass(d):
					checkFields(d);
				default:
			}
		}
	}

	function checkFields(d:Definition<ClassFlag, Array<Field>>){
		for (field in d.data) checkField(field);
	}

	function checkField(f:Field){
		var isInline = false;
		for (ff in f.access){
			if (ff.match(AInline)){
				isInline = true;
				break;
			}
		}
		var isPrivate = true;
		for (ff in f.access){
			switch(ff){
			case APublic:
				isPrivate = false;
				break;
			case APrivate:
				isPrivate = true;
				break;
			default:
			}
		}

		if (isPrivate && !isInline){
			if (! privateRE.match(f.name)){
				logPos('Invalid casing of private field ${f.name}',f.pos,SeverityLevel.INFO);
				return;
			}
		}

		var re = isInline ? capsRE : camelCaseRE;
		if (! re.match(f.name)) logPos('Invalid casing of variable ${f.name}',f.pos,SeverityLevel.INFO);
	}

	function checkLocalVars(){
		Utils.walkFile(_checker.ast, function(e){
			switch(e.expr){
				case EVars(vars):
					for (v in vars){
						if (! camelCaseRE.match(v.name)) logPos('Invalid casing of variable ${v.name}',e.pos,SeverityLevel.INFO);
					}
				default:
			}
		});
	}
}
