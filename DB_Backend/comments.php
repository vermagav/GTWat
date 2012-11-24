<?php
	include 'db_helper.php';
	
	function listComments() {
		$dbQuery = sprintf("SELECT commentId,entryId,text,time,userId FROM GTWAT_comments");
		$result = getDBResultsArray($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function getComment($id) {
		$dbQuery = sprintf("SELECT commentId,entryId,text,time,userId FROM GTWAT_comments WHERE commentId = '%s'",
			mysql_real_escape_string($id));
		$result=getDBResultRecord($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function addComment($commentId,$entryId,$text,$time,$userId) {
		$dbQuery = sprintf("INSERT INTO GTWAT_comments (commentId,entryId,text,time,userId) VALUES ('%s','%s','%s','%s','%s')",
			mysql_real_escape_string($commentId),mysql_real_escape_string($entryId),mysql_real_escape_string($text),mysql_real_escape_string($time),mysql_real_escape_string($userId));
		$result = getDBResultInserted($dbQuery,'personId');
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function updateComment($commentId,$entryId,$text,$time,$userId) {
		$dbQuery = sprintf("UPDATE GTWAT_comments SET entryId = '%s', text = '%s', time = '%s', userId = '%s' WHERE commentId = '%s'",
			mysql_real_escape_string($entryId),mysql_real_escape_string($text),mysql_real_escape_string($time),mysql_real_escape_string($userId),mysql_real_escape_string($commentId));
		$result = getDBResultAffected($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
	
	function deleteComment($id) {
		$dbQuery = sprintf("DELETE FROM GTWAT_comments WHERE commentId = '%s'",
			mysql_real_escape_string($id));												
		$result = getDBResultAffected($dbQuery);
		header("Content-type: application/json");
		echo json_encode($result);
	}
?>
