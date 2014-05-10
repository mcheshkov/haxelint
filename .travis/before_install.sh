#!/bin/sh
sudo add-apt-repository ppa:eyecreate/haxe -y &&
sudo apt-get update &&
sudo apt-get install haxe -y &&
mkdir ~/haxelib &&
haxelib -notimeout setup ~/haxelib &&
haxelib -notimeout install