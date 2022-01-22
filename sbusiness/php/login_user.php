<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    echo "failed";
    die();
}
include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM tbl_users WHERE user_email = '$email' AND user_password = '$password'";

$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
while ($row = $result->fetch_assoc()) {
        $userlist = array();
        $userlist['username'] = $row['user_username'];
        $userlist['name'] = $row['user_name'];
        $userlist['phoneno'] = $row['user_phoneno'];
        $userlist['email'] = $row['user_email'];
        $userlist['password'] = $row['user_password'];
        echo json_encode($userlist);
        $conn->close();
        return;
    }
}else{
    echo "failed";
}
?>