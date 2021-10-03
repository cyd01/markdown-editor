<?php
ini_set('display_errors', 1) ;
error_reporting(E_ALL) ;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
	if( isset($_REQUEST['page']) && isset($_REQUEST['data']) ) {
		if( file_exists( "pass/password.inc" ) ) {
			if( !isset($_SERVER['PHP_AUTH_USER']) || !isset($_SERVER['PHP_AUTH_PW']) ) {
				header('WWW-Authenticate: Basic realm="Protected area"');
				header('HTTP/1.0 401 Unauthorized');
				echo 'Wrong password';
				exit;
			}
			if( ($fd = fopen("pass/password.inc","r"))==false ) { http_response_code(500) ; exit; }
			$test = false ;
			while( ($buffer = fgets($fd)) !== false ) {
				$buffer = preg_replace( "/[ 	\n\r]*$/", "", $buffer ) ;
				$login = preg_replace( "/:.*$/", "", $buffer ) ;
				$password = preg_replace( "/^.*:/", "", $buffer ) ;
				if( ($_SERVER['PHP_AUTH_USER']==$login)&&($_SERVER['PHP_AUTH_PW']==$password) ) {
					$test = true ;
				}
			}
			fclose($fd);
			if( $test==false ) { 
				header('WWW-Authenticate: Basic realm="Protected area"');
				header('HTTP/1.0 401 Unauthorized');
				echo 'Wrong password';
				exit;
			}
		}
		header( "Content-type: text/plain" ) ;
		header( "Expires: 0" ) ;
		$dir = dirname( $_REQUEST['page'] ) ;
		if( !file_exists( $dir ) ) { mkdir( $dir, 0777, true ) ; }
		if( !is_dir( $dir ) ) { 
			http_response_code(403) ;
			echo "Can not create directory ".$dir." !" ;
			exit ;
		}
		file_put_contents( $_REQUEST['page'], base64_decode($_REQUEST['data']) ) ;
		echo  "Page ".$_REQUEST['page']." updated" ;
		exit(0);
	} else {
		http_response_code(400) ;
		echo "Bad request!" ;
		exit ;
	}
} else {
	http_response_code(405) ;
	echo "Method Not Allowed!" ;
	exit ;
}
?>
