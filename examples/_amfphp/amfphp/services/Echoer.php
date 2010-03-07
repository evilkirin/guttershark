<?php

class Echoer {
	function echoString($str) {
		return $str;
	}
	
	function badVersion() {
		return nonExistantFunction();
	}
}

?>