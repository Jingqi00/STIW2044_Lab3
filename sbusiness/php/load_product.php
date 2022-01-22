<?php
include_once("dbconnect.php");

$sqlloadproduct = "SELECT * FROM tbl_products ";

$result = $conn->query($sqlloadproduct);
if ($result->num_rows > 0) {
    $products["products"] = array();
while ($row = $result->fetch_assoc()) {
        $prlist = array();
        $prlist['productID'] = $row['productID'];
        $prlist['productName'] = $row['productName'];
        $prlist['productDescription'] = $row['productDescription'];
        $prlist['productPrice'] = $row['productPrice'];
        $prlist['productQuantity'] = $row['productQuantity'];
        $prlist['productState'] = $row['productState'];
        $prlist['productLoc'] = $row['productLoc'];

        array_push($products["products"],$prlist);
    }
    $response = array('status' => 'success', 'data' => $products);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>