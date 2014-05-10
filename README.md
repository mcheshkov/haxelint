haxelint
==========

Static analysis and style checking for Haxe in Haxe

### Install

From haxelib (not yet, soon)

    haxelib install haxelint

Manually build

    haxe build.nxml

### Usage

From command line

    neko bin/haxelint.n <HAXE SOURCES FILE OR DIR>

Using API

	var file = {name:"myfile.hx", content:"enum A{}"};
	var checker = new haxelint.Checker();
	checker.addReporter(new XMLReporter()); // see haxelint.reporter.IReporter, provide your own implementation
	checker.process([file]);