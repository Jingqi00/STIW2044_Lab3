<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$username = $_POST['username'];
$name = $_POST['name'];
$phoneno = $_POST['phoneno'];
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO tbl_users (user_username,user_name,user_phoneno,user_email,user_password) VALUES('$username','$name','$phoneno','$email','$password')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendEmail($email);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

function sendEmail($email)
{
    //send email function here
}
?>