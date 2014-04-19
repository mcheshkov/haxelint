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
				case FFun(ff): searchFunction(ff);
				default:
			}
		}
	}

	function searchFunction(f:Function){
		var body = f.expr;
		if (body == null) return;

		searchExpr(body);
	}

	function searchExpr(expr:Expr){
		switch(expr.expr){
		//case EConst( c ): trace("EConst");
		case EArray( e1, e2 ):
			//trace("EArray");
			searchExpr(e1);
			searchExpr(e2);
		case EBinop( op, e1, e2 ):
			//trace("EBinop");
			searchExpr(e1);
			searchExpr(e2);
		case EField( e, field ):
			//trace("EField");
			searchExpr(e);
		case EParenthesis( e ):
			//trace("EParenthesis");
			searchExpr(e);
		case EObjectDecl( fields ):
			//trace("EObjectDecl");
			for (f in fields){
				searchExpr(f.expr);
			}
		case EArrayDecl( values ):
			//trace("EArrayDecl");
			for (v in values){
				searchExpr(v);
			}
		case ECall( e, params ):
//			//trace("ECall", e, params);
			searchCall(e,params);
		case ENew( t, params ):
			//trace("ENew");
			for (f in params){
				searchExpr(f);
			}
		case EUnop( op, postFix, e ):
			//trace("EUnop");
			searchExpr(e);
		case EVars( vars ):
			//trace("EVars");
			for (v in vars){
				if (v.expr != null) searchExpr(v.expr);
			}
		case EFunction( name, f ):
			//trace("EFunction");
			if (f.expr != null) searchExpr(f.expr);
		case EBlock( exprs ):
			//trace("EBlock");
			for (expr2 in exprs) searchExpr(expr2);
		case EFor( it, expr ):
			//trace("EFor");
			searchExpr(it);
			searchExpr(expr);
		case EIn( e1, e2 ):
			//trace("EIn");
			searchExpr(e1);
			searchExpr(e2);
		case EIf( econd, eif, eelse ):
			//trace("EIf");
			searchExpr(econd);
			searchExpr(eif);
			if (eelse != null) searchExpr(eelse);
		case EWhile( econd, e, normalWhile ):
			//trace("EWhile");
			searchExpr(econd);
			searchExpr(e);
		case ESwitch( e, cases, edef ):
			//trace("ESwitch");
			searchExpr(e);
			for (c in cases){
				for (v in c.values) searchExpr(v);
				if (c.guard != null)searchExpr(c.guard);
				if (c.expr != null)searchExpr(c.expr);
			}
			if (edef != null && edef.expr != null) searchExpr(edef);
		case ETry( e, catches ):
			//trace("ETry");
			searchExpr(e);
			for (c in catches) searchExpr(c.expr);
		case EReturn( e ):
			//trace("EReturn");
			if (e!= null) searchExpr(e);
		case EBreak: //trace("EBreak");
		case EContinue: //trace("EContinue");
		case EUntyped( e ):
			//trace("EUntyped");
			searchExpr(e);
		case EThrow( e ):
			//trace("EThrow");
			searchExpr(e);
		case ECast( e, t ):
			//trace("ECast");
			searchExpr(e);
		case EDisplay( e, isCall ):
			//trace("EDisplay");
			searchExpr(e);
		//case EDisplayNew( t ): //trace("EDisplayNew");
		case ETernary( econd, eif, eelse ):
			//trace("ETernary");
			searchExpr(econd);
			searchExpr(eif);
			searchExpr(eelse);
		case ECheckType( e, t ):
			//trace("ECheckType");
			searchExpr(e);
		case EMeta( s, e ):
			//trace("EMeta");
			searchExpr(e);
		default:
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
