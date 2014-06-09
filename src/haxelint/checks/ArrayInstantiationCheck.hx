package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

class ArrayInstantiationCheck extends Check {
	public function new(){
		super();
	}

	override function actualRun() {
		Utils.walkFile(_checker.ast, function(e){
			switch(e.expr){
			case ENew({pack:[],name:"Array"},_):
				var lp = _checker.getLinePos(e.pos.min);
				log('Bad array instantiation', lp.line+1, lp.ofs+1, WARNING);
			default:
			}
		});
	}

	override function getModuleName():String{
		return "ArrayInstantiation";
	}
}
