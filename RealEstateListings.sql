DROP DATABASE IF EXISTS real_estate_listings;

CREATE DATABASE real_estate_listings;

USE real_estate_listings;

CREATE TABLE Property
(
    address     VARCHAR(50)     NOT NULL,
    ownerName   VARCHAR(30)     NOT NULL,
    price       INTEGER         NOT NULL,
    PRIMARY KEY (address)
);

CREATE TABLE House
(
    bedrooms    INTEGER         NOT NULL,
    bathrooms   INTEGER         NOT NULL,
    size        INTEGER         NOT NULL,
    address     VARCHAR(50)     NOT NULL,
    FOREIGN KEY (address) REFERENCES Property(address)
);

CREATE TABLE BusinessProperty
(
    type        CHAR(20)        NOT NULL,
    size        INTEGER         NOT NULL,
    address     VARCHAR(50)     NOT NULL,
    FOREIGN KEY (address) REFERENCES Property(address)
);

CREATE TABLE Firm
(
    id          INTEGER         NOT NULL,
    name        VARCHAR(30)     NOT NULL,
    address     VARCHAR(50)     NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Agent
(
    agentId     INTEGER         NOT NULL,
    name        VARCHAR(30)     NOT NULL,
    phone       CHAR(12)        NOT NULL,
    firmId      INTEGER         NOT NULL,
    dateStarted DATE            NOT NULL,
    PRIMARY KEY (agentId),
    FOREIGN KEY (firmId) REFERENCES Firm(id)
);

CREATE TABLE Listings
(
    mlsNumber   INTEGER     NOT NULL,
    address     VARCHAR(50) NOT NULL,
    agentId     INTEGER     NOT NULL,
    dateListed  DATE        NOT NULL,
    PRIMARY KEY (mlsNumber),
    FOREIGN KEY (address) REFERENCES Property(address),
    UNIQUE (address, agentId)
);

CREATE TABLE Buyer
(
    id                      INTEGER         NOT NULL,
    name                    VARCHAR(30)     NOT NULL,
    phone                   CHAR(12)        NOT NULL,
    propertyType            CHAR(20)        NOT NULL,
    bedrooms                INTEGER,
    bathrooms               INTEGER,
    businessPropertyType    CHAR(20),
    minimumPreferredPrice   INTEGER         NOT NULL,
    maximumPreferredPrice   INTEGER         NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Works_With
(
    buyerId     INTEGER     NOT NULL,
    agentId     INTEGER     NOT NULL,
    FOREIGN KEY (buyerId) REFERENCES Buyer(id),
    FOREIGN KEY (agentId) REFERENCES Agent(agentId)
);

INSERT INTO Property (address, ownerName, price)
VALUES
    ('123 Maple St', 'John Doe', 200000),
    ('456 Oak St', 'Jane Smith', 150000),
    ('789 Pine St', 'Bill Johnson', 250000),
    ('101 Elm St', 'Sarah Davis', 150000),
    ('202 Birch St', 'Jane Brown', 120000),
    ('555 Corporate Blvd', 'Sam Write', 250000),
    ('333 Market St', 'Kyle Jacobs', 100000),
    ('777 Industrial Rd', 'Bill Dill', 600000),
    ('999 Logistics Dr', 'Veronica Hill', 450000),
    ('888 Enterprise Ave', 'Pauline Jenkins', 350000);

INSERT INTO House (bedrooms, bathrooms, size, address)
VALUES
    (3, 2, 1500, '123 Maple St'),
    (3, 2, 1800, '456 Oak St'),
    (4, 3, 2000, '789 Pine St'),
    (3, 2, 1600, '101 Elm St'),
    (2, 1, 900, '202 Birch St');

INSERT INTO BusinessProperty (type, size, address)
VALUES
    ('Gas Station', 2000, '555 Corporate Blvd'),
    ('Store', 1500, '333 Market St'),
    ('Office', 1800, '777 Industrial Rd'),
    ('Warehouse', 3000, '999 Logistics Dr'),
    ('Retail', 2500, '888 Enterprise Ave');

INSERT INTO Firm (id, name, address)
VALUES
    (1, 'Top Realty', '100 Main St'),
    (2, 'Prime Properties', '200 Central Ave'),
    (3, 'Elite Brokers', '300 Broadway St'),
    (4, 'Value Realty', '400 Market St'),
    (5, 'City Homes', '500 Elm St');

INSERT INTO Agent (agentId, name, phone, firmId, dateStarted)
VALUES
    (1, 'Zlice Walker', '123-456-7890', 1, '2019-01-15'),
    (2, 'Bob Martinez', '234-567-8901', 2, '2018-06-22'),
    (3, 'Carol White', '345-678-9012', 3, '2020-03-12'),
    (4, 'David Lee', '456-789-0123', 4, '2017-11-05'),
    (5, 'Eva King', '567-890-1234', 4, '2021-07-19');

INSERT INTO Listings (mlsNumber, address, agentId, dateListed)
VALUES
    (101, '123 Maple St', 1, '2024-01-05'),
    (102, '456 Oak St', 2, '2024-01-10'),
    (103, '789 Pine St', 3, '2024-01-15'),
    (104, '777 Industrial Rd', 4, '2024-01-20'),
    (105, '555 Corporate Blvd', 5, '2024-01-25');

INSERT INTO Buyer (id, name, phone, propertyType, bedrooms, bathrooms, businessPropertyType, minimumPreferredPrice, maximumPreferredPrice)
VALUES
    (1, 'George Adams', '123-555-1111', 'House', 3, 2, NULL, 100000, 250000),
    (2, 'Helen Brooks', '234-555-2222', 'House', 4, 3, NULL, 200000, 400000),
    (3, 'Ian Campbell', '345-555-3333', 'Business', NULL, NULL, 'Office', 150000, 300000),
    (4, 'Judy Daniels', '456-555-4444', 'House', 2, 1, NULL, 80000, 150000),
    (5, 'Kevin Evans', '567-555-5555', 'Business', NULL, NULL, 'Retail', 250000, 500000);

INSERT INTO Works_With (buyerId, agentId)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 4);