USE real_estate_listings;

-- 1. Addresses of all houses currently listed
SELECT L.address AS houseAddress
FROM Listings AS L, House AS H
WHERE L.address = H.address;

-- 2. Addresses and MLS nums of all houses currently listed
SELECT L.address AS houseAddress, L.mlsNumber
FROM Listings AS L, House AS H
WHERE L.address = H.address;

-- 3. Addresses of 3bed & 2bath currently listed
SELECT L.address AS houseAddress
FROM Listings AS L, House AS H
WHERE (L.address = H.address) AND (H.bedrooms = 3) AND (H.bathrooms = 2);

-- 4. Addresses and prices of 3bed,2bath /w price 100,000 - 250,000
-- results showing in descending order of price
SELECT H.address AS houseAddress, P.price
FROM House AS H, Property AS P
WHERE (P.address = H.address)
  AND (H.bedrooms = 3) AND (H.bathrooms = 2)
  AND (P.price BETWEEN 100000 AND 250000)
ORDER BY P.price DESC;

-- 5. Addresses and prices of all business properties of type 'office space'
-- in descending order of price
SELECT B.address, P.price
FROM BusinessProperty AS B, Property AS P
WHERE P.address = B.address AND B.type = 'office'
ORDER BY P.price DESC;

-- 6. IDs, names, phones, firm, start date of all agents
SELECT A.agentId, A.name, A.phone, F.name, A.dateStarted
FROM Agent AS A, Firm AS F
WHERE A.firmId = F.id;

-- 7. All properties currently listed by agent with id "001"
SELECT L.address
FROM Listings AS L
WHERE L.agentId = 001;

-- 8. All agent/buyer name that work with each other, sorted alphabetically by agent name
SELECT A.name AS agentName, B.name AS buyerName
FROM Agent AS A, Buyer AS B, Works_With AS W
WHERE A.agentId = W.agentId AND B.id = W.buyerId
ORDER BY A.name;

-- 9. List agent ID and the number of buyers they're working with
SELECT W.agentId, COUNT(*) AS totalBuyers
FROM Works_With AS W
GROUP BY W.agentId;

-- 10. Find all houses that meet buyer's preferences
-- results showing in shown in descending order of price
SELECT L.address, P.price
FROM Listings AS L
    JOIN House AS H ON L.address = H.address
    JOIN Property AS P ON L.address = P.address
    JOIN Buyer AS B ON B.id = 1
WHERE P.price BETWEEN B.minimumPreferredPrice AND B.maximumPreferredPrice
  AND H.bedrooms = B.bedrooms
  AND H.bathrooms = B.bathrooms
ORDER BY P.price DESC;