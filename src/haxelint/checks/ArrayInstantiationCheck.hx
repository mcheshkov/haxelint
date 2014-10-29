package haxelint.checks;

import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

@name("ArrayInstantiation")
class ArrayInstantiationCheck extends Check {
	public function new(){
		super();
	}

	override function actualRun() {
		ExprUtils.walkFile(_checker.ast, function(e){
			switch(e.expr){
			case ENew({pack:[],name:"Array"},_):
				var lp = _checker.getLinePos(e.pos.min);
				log('Bad array instantiation', lp.line+1, lp.ofs+1, WARNING);
			default:
			}
		});
	}
}
