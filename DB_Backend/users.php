<?php
	include 'db_helper.php';
	
	function listUsers() {
		$dbQuery = sprintf("SELECT userId,lastKnownLoc FROM GTWAT_users");
		$result = getDBResultsArray($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function getUser($id) {
		$dbQuery = sprintf("SELECT userId,lastKnownLoc FROM GTWAT_users WHERE userId = '%s'",
			mysql_real_escape_string($id));
		$result=getDBResultRecord($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function addUser($id,$loc) {
		$dbQuery = sprintf("INSERT INTO GTWAT_users (userId,lastKnownLoc) VALUES ('%s','%s')",
			mysql_real_escape_string($id), mysql_real_escape_string($loc));
	
		$result = getDBResultInserted($dbQuery,'userId');
		
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function updateUser($id,$loc) {
		$dbQuery = sprintf("UPDATE GTWAT_users SET lastKnownLoc = '%s' WHERE userId = '%s'",
			mysql_real_escape_string($loc),
			mysql_real_escape_string($id));
		
		$result = getDBResultAffected($dbQuery);
		
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function deleteUser($id) {
		$dbQuery = sprintf("DELETE FROM GTWAT_users WHERE userId = '%s'",
			mysql_real_escape_string($id));												
		$result = getDBResultAffected($dbQuery);
		
		header("Content-type: application/json");
		echo json_encode($result);
	}
?>
