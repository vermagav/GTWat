<?php
	include 'db_helper.php';
	
	function listPins() {
		$dbQuery = sprintf("SELECT entryId,userId,location,subject,specLocation,time,description,DBAddTime FROM GTWAT_pins");
		$result = getDBResultsArray($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function getPin($id) {
		$dbQuery = sprintf("SELECT entryId,userId,location,subject,specLocation,time,description,DBAddTime FROM GTWAT_pins WHERE entryId = '%s'",
			mysql_real_escape_string($id));
		$result=getDBResultRecord($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function addPin($entryId,$userId,$location,$subject,$specLocation,$time,$description,$DBAddTime) {
		$dbQuery = sprintf("INSERT INTO GTWAT_pins (entryId,userId,location,subject,specLocation,time,description,DBAddTime) VALUES ('%s','%s','%s','%s','%s','%s','%s','%s')", mysql_real_escape_string($entryId), mysql_real_escape_string($userId), mysql_real_escape_string($location), mysql_real_escape_string($subject), mysql_real_escape_string($specLocation), mysql_real_escape_string($time), mysql_real_escape_string($description), mysql_real_escape_string($DBAddTime));
		$result = getDBResultInserted($dbQuery,'userId');
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function updatePin($entryId,$userId,$location,$subject,$specLocation,$time,$description,$DBAddTime) {
		$dbQuery = sprintf("UPDATE GTWAT_pins SET userId='%s',location='%s',subject='%s',specLocation='%s',time='%s',description='%s',DBAddTime='%s' WHERE entryId = '%s'", mysql_real_escape_string($userId), mysql_real_escape_string($location), mysql_real_escape_string($subject), mysql_real_escape_string($specLocation), mysql_real_escape_string($time), mysql_real_escape_string($description), mysql_real_escape_string($DBAddTime), mysql_real_escape_string($entryId));
		$result = getDBResultAffected($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function deletePin($id) {
		$dbQuery = sprintf("DELETE FROM GTWAT_pins WHERE entryId = '%s'",
			mysql_real_escape_string($id));												
		$result = getDBResultAffected($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
?>
