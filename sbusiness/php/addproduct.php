<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$productName= $_POST['productName'];
$productDescription = $_POST['productDescription'];
$productPrice = $_POST['productPrice'];
$productQuantity = $_POST['productQuantity'];
$productState = $_POST['productState'];
$productLoc = $_POST['productLoc'];
$encoded_string = $_POST['image'];

$sqlinsert = "INSERT INTO tbl_products (productName,productDescription,productPrice,productQuantity,productState,productLoc) VALUES('$productName','$productDescription','$productPrice','$productQuantity','$productState','$productLoc')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($encoded_string);
    $path = '../images/products/'.$filename.'.png';
    $is_written = file_put_contents($path, $decoded_string);
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

?>