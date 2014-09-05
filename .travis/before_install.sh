#!/bin/sh
sudo add-apt-repository ppa:eyecreate/haxe -y &&
sudo apt-get update &&
sudo apt-get install haxe -y &&
mkdir ~/haxelib &&
haxelib -notimeout setup ~/haxelib &&
haxelib -notimeout install hxparse    # This is bad, but $ haxelib -notimeout install build.hxml
haxelib -notimeout install haxeparser # requires user interaction FOR GODS SAKE
haxelib -notimeout install haxeparser-substituted
haxelib -notimeout install compiletime