<?php
$host = "localhost";
$user = "root";
$password = "";
$database = "real_estate_listings";

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if(isset($_GET['type'])) {
    $type = $_GET['type'];

    switch ($type) {
        case 'listings':
            fetchListings($conn);
            break;

        case 'houses':
            fetchPreferredHouses($conn);
            break;

        case 'businesses':
            fetchPreferredBusinesses($conn);
            break;

        case 'agents':
            fetchAgents($conn);
            break;

        case 'buyers':
            fetchBuyers($conn);
            break;

        case 'query':
            fetchQuery($conn);
            break;

        default:
            echo "Invalid request";
    }
}

// LISTINGS TAB
function fetchListings($conn) {
    echo "<h3>All Listings</h3>";
    fetchAllListings($conn);

    echo "<h3>House Listings</h3>";
    fetchHouses($conn);

    echo "<h3>Business Listings</h3>";
    fetchBusinesses($conn);
}
function fetchAllListings($conn) {
    $sql = "SELECT L.mlsNumber, P.address, P.ownerName, P.price, A.name as agentName 
            FROM Listings AS L
            JOIN Property AS P ON L.address = P.address
            JOIN Agent AS A ON L.agentId = A.agentId";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table border='1'><tr><th>MLS Number</th><th>Address</th><th>Owner</th><th>Price</th><th>Agent</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['mlsNumber']}</td><td>{$row['address']}</td><td>{$row['ownerName']}</td><td>{$row['price']}</td><td>{$row['agentName']}</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No listings found.";
    }
}
function fetchHouses($conn) {
    $sql = "SELECT P.address, P.ownerName, H.bedrooms, H.bathrooms, H.size, P.price 
            FROM House AS H
            JOIN Property AS P ON H.address = P.address
            JOIN Listings AS L ON H.address = L.address";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table border='1'><tr><th>Address</th><th>Owner</th><th>Bedrooms</th><th>Bathrooms</th><th>Size (sq ft)</th><th>Price</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['address']}</td><td>{$row['ownerName']}</td><td>{$row['bedrooms']}</td><td>{$row['bathrooms']}</td><td>{$row['size']}</td><td>{$row['price']}</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No houses found.";
    }
}

function fetchBusinesses($conn) {
    $sql = "SELECT P.address, P.ownerName, B.type, B.size, P.price 
            FROM BusinessProperty B
            JOIN Property P ON B.address = P.address
            JOIN Listings L ON B.address = L.address";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table border='1'><tr><th>Address</th><th>Owner</th><th>Business Type</th><th>Size (sq ft)</th><th>Price</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['address']}</td><td>{$row['ownerName']}</td><td>{$row['type']}</td><td>{$row['size']}</td><td>{$row['price']}</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No businesses found.";
    }
}

// SEARCH HOUSES TAB
function fetchPreferredHouses($conn) {
    $minPrice = isset($_GET['minPrice']) ? (int)$_GET['minPrice'] : 0;
    $maxPrice = isset($_GET['maxPrice']) ? (int)$_GET['maxPrice'] : PHP_INT_MAX;
    $bedrooms = isset($_GET['bedrooms']) ? (int)$_GET['bedrooms'] : 0;
    $bathrooms = isset($_GET['bathrooms']) ? (int)$_GET['bathrooms'] : 0;

    $sql = "SELECT P.address, P.ownerName, H.bedrooms, H.bathrooms, H.size, P.price
            FROM House AS H
            JOIN Property AS P ON H.address = P.address
            JOIN Listings AS L ON H.address = L.address
            WHERE P.price BETWEEN $minPrice AND $maxPrice
                  AND H.bedrooms = $bedrooms
                  AND H.bathrooms = $bathrooms";

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table border='1'><tr><th>Address</th><th>Owner</th><th>Bedrooms</th><th>Bathrooms</th><th>Size</th><th>Price</th></tr>";
        while($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['address']}</td><td>{$row['ownerName']}</td>
                  <td>{$row['bedrooms']}</td><td>{$row['bathrooms']}</td><td>{$row['size']}</td><td>{$row['price']}</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No houses matched criteria.";
    }
}

function fetchPreferredBusinesses($conn) {
    $minPrice = isset($_GET['minPrice']) ? (int)$_GET['minPrice'] : 0;
    $maxPrice = isset($_GET['maxPrice']) ? (int)$_GET['maxPrice'] : PHP_INT_MAX;
    $minSize = isset($_GET['minSize']) ? (int)$_GET['minSize'] : 0;
    $maxSize = isset($_GET['maxSize']) ? (int)$_GET['maxSize'] : PHP_INT_MAX;

    $sql = "SELECT P.address, P.ownerName, B.size, B.type, P.price
            FROM BusinessProperty AS B 
            JOIN Property AS P ON B.address = P.address
            JOIN Listings AS L ON B.address = L.address
            WHERE P.price BETWEEN $minPrice AND $maxPrice
                  AND B.size BETWEEN $minSize AND $maxSize";

    $result = $conn->query($sql);

    if($result->num_rows > 0) {
        echo "<table border='1'><tr><th>Address</th><th>Owner</th><th>Size</th><th>Type</th><th>Price</th>";
        while($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['address']}</td><td>{$row['ownerName']}</td>
                  <td>{$row['size']}</td><td>{$row['type']}</td><td>{$row['price']}</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No businesses matched criteria.";
    }
}

function fetchAgents($conn) {
    $sql = "SELECT a.name, a.phone, f.name as firmName, a.dateStarted 
            FROM Agent a
            JOIN Firm f ON a.firmId = f.id";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table border='1'><tr><th>Agent Name</th><th>Phone</th><th>Firm</th><th>Date Started</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['name']}</td><td>{$row['phone']}</td><td>{$row['firmName']}</td><td>{$row['dateStarted']}</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No agents found.";
    }
}

function fetchBuyers($conn) {
    $sql = "SELECT name, phone, propertyType, bedrooms, bathrooms, minimumPreferredPrice, maximumPreferredPrice 
            FROM Buyer";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<table border='1'><tr><th>Buyer Name</th><th>Phone</th><th>Property Type</th><th>Bedrooms</th><th>Bathrooms</th><th>Min Price</th><th>Max Price</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>{$row['name']}</td><td>{$row['phone']}</td><td>{$row['propertyType']}</td><td>{$row['bedrooms']}</td><td>{$row['bathrooms']}</td><td>{$row['minimumPreferredPrice']}</td><td>{$row['maximumPreferredPrice']}</td></tr>";
        }
        echo "</table>";
    } else {
        echo "No buyers found.";
    }
}

$conn->close();
?>