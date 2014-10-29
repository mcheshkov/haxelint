package haxelint.checks;

import haxe.macro.Printer;
import haxe.macro.Expr.Binop;
import haxe.macro.Expr.Unop;
import haxelint.LintMessage.SeverityLevel;
import haxeparser.Data.Token;

@name("Spacing")
class SpacingCheck extends Check {
	public function new(){
		super();
	}

	public var spaceAroundBinop = true;
	public var noSpaceAroundUnop = true;
	public var spaceIfCondition = true;

	override function actualRun() {
		var lastExpr = null;

		ExprUtils.walkFile(_checker.ast,function(e){
			if (lastExpr == null){
				lastExpr = e;
				return;
			}

			switch e.expr {
			case EBinop(bo,l,r) if (spaceAroundBinop):
				if (r.pos.min - l.pos.max < binopSize(bo)+2) logPos('No space around ${binopString(bo)}', e.pos, INFO);
			case EUnop(uo,post,e2) if (noSpaceAroundUnop):
				var dist = 0;
				if (post){
					// (...)++;
					dist = e.pos.max - e2.pos.max;
				}
				else {
					//++(...);
					dist = e2.pos.min - e.pos.min;
				}
				if (dist > unopSize(uo)) logPos('Space around ${unopString(uo)}', e.pos, INFO);
			case EIf(econd,eif,eelse) if (spaceIfCondition):
				if (econd.pos.min - e.pos.min < "if (".length) logPos('No space between `if\' and condition', e.pos, INFO);
				if (eif.pos.min - econd.pos.max < ") ".length) logPos('No space between `if\' and condition', e.pos, INFO);
			default:
			}

			lastExpr = e;
		});
	}

	function binopSize(bo:Binop){
		return binopString(bo).length;
	}

	function binopString(bo:Binop){
		return (new Printer()).printBinop(bo);
	}

	function unopSize(uo:Unop){
		return unopString(uo).length;
	}

	function unopString(uo:Unop){
		return (new Printer()).printUnop(uo);
	}
}
