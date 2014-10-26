haxelint
==========

Static analysis and style checking for Haxe in Haxe

[![Build Status](https://travis-ci.org/mcheshkov/haxelint.svg?branch=master)](https://travis-ci.org/mcheshkov/haxelint)

### Install

From haxelib

    haxelib install haxelint

Manually build

    haxe build.hxml

### Usage

From command line

	haxelib run haxelint -s <HAXE SOURCES FILE OR DIR>
	
Run just `haxelib run haxelint` for help

Using API

	var file = {name:"myfile.hx", content:"enum A{}"};
	var checker = new haxelint.Checker();
	checker.addReporter(new XMLReporter()); // see haxelint.reporter.IReporter, provide your own implementation
	checker.addCheck(new Check()); // see haxelint.checks.Check class and subclasses
	checker.process([file]);