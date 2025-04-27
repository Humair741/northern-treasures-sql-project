-- Creating the stores table
CREATE TABLE stores (
  store_id INT PRIMARY KEY,
  store_name VARCHAR(100),
  city VARCHAR(50),
  province VARCHAR(2),
  region VARCHAR(20),
  size_sqft INT,
  opening_date DATE,
  manager_id INT
);

-- Creating the products table
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  sub_category VARCHAR(50),
  supplier_id INT,
  unit_price DECIMAL(10,2),
  cost_price DECIMAL(10,2),
  is_canadian_made BOOLEAN
);

-- Creating the suppliers table
CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY,
  supplier_name VARCHAR(100),
  province VARCHAR(2),
  contact_name VARCHAR(100),
  contact_email VARCHAR(100),
  supplier_rating DECIMAL(3,2),
  contract_start_date DATE
);

-- Creating the employees table
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  job_title VARCHAR(50),
  province VARCHAR(2),
  hire_date DATE,
  salary DECIMAL(10,2),
  supervisor_id INT,
  store_id INT
);

-- Creating the sales table
CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  store_id INT,
  product_id INT,
  employee_id INT,
  sale_date DATE,
  quantity INT,
  total_price DECIMAL(10,2),
  payment_method VARCHAR(20),
  loyalty_member_id INT
);

-- Creating the loyalty_members table
CREATE TABLE loyalty_members (
  member_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  join_date DATE,
  province VARCHAR(2),
  points INT,
  membership_tier VARCHAR(20)
);

-- Creating the promotions table
CREATE TABLE promotions (
  promotion_id INT PRIMARY KEY,
  promotion_name VARCHAR(100),
  start_date DATE,
  end_date DATE,
  discount_percent DECIMAL(5,2),
  product_id INT,
  region VARCHAR(20)
);

-- Creating the online_orders table
CREATE TABLE online_orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  ship_date DATE,
  shipping_province VARCHAR(2),
  shipping_cost DECIMAL(6,2),
  order_status VARCHAR(20)
);

-- Creating the order_items table
CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  unit_price DECIMAL(10,2),
  discount DECIMAL(5,2)
);

-- Creating the customer_feedback table
CREATE TABLE customer_feedback (
  feedback_id INT PRIMARY KEY,
  store_id INT,
  sale_id INT,
  rating INT,
  comment TEXT,
  feedback_date DATE,
  response_status VARCHAR(20)
);

-- Creating the store_inventory table
CREATE TABLE store_inventory (
  inventory_id INT PRIMARY KEY,
  store_id INT,
  product_id INT,
  stock_quantity INT,
  restock_level INT,
  last_restock_date DATE
);

-- Inserting data into stores table
INSERT INTO stores VALUES
(101, 'Northern Treasures Toronto-Eaton', 'Toronto', 'ON', 'Eastern', 12500, '2015-03-15', 201),
(102, 'Northern Treasures Vancouver-Robson', 'Vancouver', 'BC', 'Western', 15000, '2015-06-22', 202),
(103, 'Northern Treasures Montreal-StCatherine', 'Montreal', 'QC', 'Eastern', 14000, '2016-02-08', 203),
(104, 'Northern Treasures Calgary-Chinook', 'Calgary', 'AB', 'Western', 11000, '2016-09-30', 204),
(105, 'Northern Treasures Halifax-Spring', 'Halifax', 'NS', 'Atlantic', 9500, '2017-04-12', 205),
(106, 'Northern Treasures Ottawa-Rideau', 'Ottawa', 'ON', 'Eastern', 10500, '2017-11-05', 206),
(107, 'Northern Treasures Edmonton-WEM', 'Edmonton', 'AB', 'Western', 16000, '2018-03-20', 207),
(108, 'Northern Treasures Winnipeg-Portage', 'Winnipeg', 'MB', 'Prairie', 8800, '2018-08-15', 208),
(109, 'Northern Treasures Quebec-StFoy', 'Quebec City', 'QC', 'Eastern', 9200, '2019-05-10', 209),
(110, 'Northern Treasures Victoria-Bay', 'Victoria', 'BC', 'Western', 7500, '2019-10-23', NULL),
(111, 'Northern Treasures Saskatoon-Midtown', 'Saskatoon', 'SK', 'Prairie', 8000, '2020-07-18', NULL),
(112, 'Northern Treasures Regina-Cornwall', 'Regina', 'SK', 'Prairie', 7800, '2021-03-05', NULL);

-- Inserting data into employees table
INSERT INTO employees VALUES
(201, 'David', 'Chen', 'Store Manager', 'ON', '2015-01-15', 85000.00, NULL, 101),
(202, 'Sarah', 'Singh', 'Store Manager', 'BC', '2015-04-10', 88000.00, NULL, 102),
(203, 'Jean', 'Tremblay', 'Store Manager', 'QC', '2015-12-05', 86000.00, NULL, 103),
(204, 'Ahmed', 'Hassan', 'Store Manager', 'AB', '2016-08-12', 84000.00, NULL, 104),
(205, 'Emily', 'MacDonald', 'Store Manager', 'NS', '2017-02-15', 82000.00, NULL, 105),
(206, 'Michael', 'O''Connor', 'Store Manager', 'ON', '2017-09-20', 83000.00, 201, 106),
(207, 'Fatima', 'Al-Zahra', 'Store Manager', 'AB', '2018-01-10', 84500.00, 204, 107),
(208, 'Trevor', 'Johnson', 'Store Manager', 'MB', '2018-06-22', 81000.00, NULL, 108),
(209, 'Marie', 'Lavoie', 'Store Manager', 'QC', '2019-03-15', 80000.00, 203, 109),
(210, 'Jennifer', 'Wong', 'Assistant Manager', 'ON', '2015-03-20', 65000.00, 201, 101),
(211, 'Robert', 'Kim', 'Assistant Manager', 'BC', '2015-07-05', 67000.00, 202, 102),
(212, 'Sophie', 'Bergeron', 'Assistant Manager', 'QC', '2016-03-10', 66000.00, 203, 103),
(213, 'Omar', 'Mahmoud', 'Assistant Manager', 'AB', '2016-10-15', 64000.00, 204, 104),
(214, 'Grace', 'Williams', 'Assistant Manager', 'NS', '2017-05-20', 62000.00, 205, 105),
(215, 'Daniel', 'Murphy', 'Sales Lead', 'ON', '2017-12-10', 52000.00, 206, 106),
(216, 'Leila', 'Ahmadi', 'Sales Lead', 'AB', '2018-04-15', 53000.00, 207, 107),
(217, 'Matthew', 'Peters', 'Sales Lead', 'MB', '2018-09-22', 51000.00, 208, 108),
(218, 'Isabelle', 'Roy', 'Sales Lead', 'QC', '2019-06-10', 52000.00, 209, 109),
(219, 'Thomas', 'Campbell', 'Sales Associate', 'BC', '2019-11-15', 42000.00, 211, 102),
(220, 'Priya', 'Sharma', 'Sales Associate', 'ON', '2020-02-10', 41000.00, 210, 101),
(221, 'Antoine', 'Dubois', 'Sales Associate', 'QC', '2020-08-05', 41500.00, 212, 103),
(222, 'Jasmine', 'Gill', 'Sales Associate', 'AB', '2021-01-20', 42500.00, 213, 104),
(223, 'Connor', 'O''Neill', 'Sales Associate', 'NS', '2021-05-15', 40000.00, 214, 105),
(224, 'Olivia', 'Rodriguez', 'Inventory Specialist', 'ON', '2015-05-10', 55000.00, 210, 101),
(225, 'Raj', 'Patel', 'Inventory Specialist', 'BC', '2015-08-15', 56000.00, 211, 102),
(226, 'Marc', 'Gagnon', 'Inventory Specialist', 'QC', '2016-04-20', 55500.00, 212, 103),
(227, 'Aisha', 'Khan', 'Customer Service Rep', 'AB', '2016-11-25', 47000.00, 213, 104),
(228, 'Sean', 'Murray', 'Customer Service Rep', 'NS', '2017-06-30', 46000.00, 214, 105);

-- Inserting data into suppliers table
INSERT INTO suppliers VALUES
(301, 'Canadian Outfitters Ltd.', 'ON', 'James Wilson', 'james@canadianoutfitters.ca', 4.8, '2015-01-10'),
(302, 'West Coast Craft Co.', 'BC', 'Linda Chang', 'linda@westcoastcraft.ca', 4.7, '2015-02-15'),
(303, 'Quebec Artisanal Products', 'QC', 'Pierre Laporte', 'pierre@qcartisanal.ca', 4.9, '2015-04-20'),
(304, 'Prairie Goods Supply', 'SK', 'Emma Grant', 'emma@prairiegoods.ca', 4.5, '2015-07-10'),
(305, 'Atlantic Treasures Inc.', 'NS', 'Ryan MacDougall', 'ryan@atlantictreasures.ca', 4.6, '2015-10-05'),
(306, 'Northern Apparel Co.', 'ON', 'Samantha Lee', 'samantha@northernapparel.ca', 4.8, '2016-01-15'),
(307, 'Rocky Mountain Supplies', 'AB', 'Jason Chen', 'jason@rockymtsupplies.ca', 4.4, '2016-05-20'),
(308, 'Maple Craftsmanship', 'QC', 'Natalie Trudeau', 'natalie@maplecrafts.ca', 4.9, '2016-09-10'),
(309, 'Great Lakes Distributors', 'ON', 'Derek Singh', 'derek@greatlakesdist.ca', 4.3, '2017-02-15'),
(310, 'Island Artisan Collective', 'BC', 'Michelle Wong', 'michelle@islandartisans.ca', 4.7, '2017-06-22');

-- Inserting data into products table
INSERT INTO products VALUES
(401, 'Canadian Maple Syrup - 500ml', 'Food', 'Condiments', 303, 24.99, 12.50, TRUE),
(402, 'Handcrafted Cedar Coasters (Set of 4)', 'Home', 'Kitchen', 302, 32.99, 15.00, TRUE),
(403, 'Premium Wool Blanket', 'Home', 'Bedding', 301, 149.99, 75.00, TRUE),
(404, 'Canadian Wildlife Coffee Table Book', 'Books', 'Photography', 305, 45.99, 22.50, TRUE),
(405, 'Mountie Plush Toy', 'Toys', 'Stuffed Animals', 306, 19.99, 8.00, TRUE),
(406, 'Wilderness Survival Kit', 'Outdoor', 'Safety', 307, 89.99, 45.00, TRUE),
(407, 'Hand-carved Wooden Bear', 'Art', 'Sculptures', 308, 79.99, 40.00, TRUE),
(408, 'Inukshuk Stone Sculpture', 'Art', 'Sculptures', 309, 34.99, 17.50, TRUE),
(409, 'Fleece-Lined Winter Gloves', 'Clothing', 'Accessories', 306, 29.99, 12.00, TRUE),
(410, 'Local Craft Beer Gift Set', 'Food', 'Beverages', 310, 49.99, 25.00, TRUE),
(411, 'Canadian Landscape Canvas Print', 'Art', 'Wall Decor', 302, 129.99, 65.00, TRUE),
(412, 'Birch Bark Canoe Model', 'Art', 'Models', 304, 199.99, 100.00, TRUE),
(413, 'Organic Maple Sugar Candy', 'Food', 'Sweets', 303, 14.99, 6.00, TRUE),
(414, 'Cedar Plank Salmon Cooking Kit', 'Food', 'Cooking', 310, 39.99, 20.00, TRUE),
(415, 'Canadian National Parks Guide', 'Books', 'Travel', 309, 22.99, 11.50, TRUE),
(416, 'Recycled Wool Socks', 'Clothing', 'Footwear', 306, 18.99, 8.50, TRUE),
(417, 'Saskatoon Berry Jam', 'Food', 'Preserves', 304, 12.99, 5.50, TRUE),
(418, 'Canadian Flag Toque', 'Clothing', 'Headwear', 301, 24.99, 10.00, TRUE),
(419, 'Ice Wine - 375ml', 'Food', 'Beverages', 303, 59.99, 30.00, TRUE),
(420, 'Outdoor Adventure Multi-tool', 'Outdoor', 'Tools', 307, 45.99, 22.00, FALSE),
(421, 'Granite Whiskey Stones', 'Home', 'Barware', 302, 34.99, 17.00, TRUE),
(422, 'Leather-bound Journal', 'Stationery', 'Notebooks', 308, 39.99, 18.00, TRUE),
(423, 'Wild Rice Blend', 'Food', 'Grains', 304, 15.99, 7.00, TRUE),
(424, 'Northern Lights Photography Print', 'Art', 'Photography', 305, 79.99, 35.00, TRUE),
(425, 'Urban Commuter Backpack', 'Bags', 'Backpacks', 306, 129.99, 65.00, FALSE);

-- Inserting data into loyalty_members table
INSERT INTO loyalty_members VALUES
(501, 'Alexandra', 'Kim', 'alexandra.kim@email.com', '2018-03-15', 'ON', 3450, 'Gold'),
(502, 'Marcus', 'Johnson', 'marcus.j@email.com', '2018-05-22', 'BC', 2100, 'Silver'),
(503, 'Camille', 'Tremblay', 'camille.t@email.com', '2018-08-10', 'QC', 4200, 'Gold'),
(504, 'Farhan', 'Ahmed', 'farhan.a@email.com', '2018-11-05', 'AB', 1850, 'Silver'),
(505, 'Jessica', 'Wilson', 'jessica.w@email.com', '2019-01-20', 'NS', 900, 'Bronze'),
(506, 'Richard', 'O''Brien', 'richard.o@email.com', '2019-04-15', 'ON', 3600, 'Gold'),
(507, 'Layla', 'Hassan', 'layla.h@email.com', '2019-07-22', 'BC', 750, 'Bronze'),
(508, 'Noah', 'Martin', 'noah.m@email.com', '2019-10-08', 'QC', 1250, 'Silver'),
(509, 'Olivia', 'Singh', 'olivia.s@email.com', '2020-01-15', 'AB', 2800, 'Gold'),
(510, 'William', 'Thompson', 'william.t@email.com', '2020-04-10', 'MB', 1600, 'Silver'),
(511, 'Sophie', 'Lavoie', 'sophie.l@email.com', '2020-07-05', 'QC', 550, 'Bronze'),
(512, 'Liam', 'Murphy', 'liam.m@email.com', '2020-10-12', 'ON', 1800, 'Silver'),
(513, 'Emma', 'Jackson', 'emma.j@email.com', '2021-01-07', 'BC', 950, 'Bronze'),
(514, 'Lucas', 'Roy', 'lucas.r@email.com', '2021-04-20', 'QC', 300, 'Bronze');

-- Inserting data into sales table
INSERT INTO sales VALUES
(601, 101, 401, 220, '2023-01-15', 2, 49.98, 'Credit', 501),
(602, 101, 403, 210, '2023-01-15', 1, 149.99, 'Credit', 501),
(603, 102, 402, 219, '2023-01-18', 3, 98.97, 'Debit', 502),
(604, 103, 405, 221, '2023-01-20', 2, 39.98, 'Cash', NULL),
(605, 104, 406, 222, '2023-01-22', 1, 89.99, 'Credit', 504),
(606, 105, 404, 223, '2023-01-25', 2, 91.98, 'Debit', 505),
(607, 106, 408, 215, '2023-01-28', 1, 34.99, 'Credit', 506),
(608, 107, 410, 216, '2023-01-30', 2, 99.98, 'Credit', 509),
(609, 108, 412, 217, '2023-02-02', 1, 199.99, 'Credit', 510),
(610, 109, 413, 218, '2023-02-05', 4, 59.96, 'Debit', NULL),
(611, 101, 415, 220, '2023-02-08', 2, 45.98, 'Cash', 512),
(612, 102, 416, 219, '2023-02-10', 3, 56.97, 'Credit', 513),
(613, 103, 417, 221, '2023-02-12', 2, 25.98, 'Debit', 503),
(614, 104, 418, 222, '2023-02-15', 3, 74.97, 'Credit', NULL),
(615, 105, 419, 223, '2023-02-18', 1, 59.99, 'Credit', 505),
(616, 106, 401, 215, '2023-02-20', 2, 49.98, 'Debit', 506),
(617, 107, 407, 216, '2023-02-22', 1, 79.99, 'Cash', NULL),
(618, 108, 409, 217, '2023-02-25', 2, 59.98, 'Credit', 510),
(619, 109, 411, 218, '2023-02-28', 1, 129.99, 'Credit', 508),
(620, 101, 421, 210, '2023-03-03', 2, 69.98, 'Debit', 501),
(621, 102, 422, 211, '2023-03-05', 1, 39.99, 'Credit', NULL),
(622, 103, 423, 212, '2023-03-08', 3, 47.97, 'Cash', 503),
(623, 104, 424, 213, '2023-03-10', 1, 79.99, 'Credit', 504),
(624, 105, 425, 214, '2023-03-12', 1, 129.99, 'Debit', NULL),
(625, 106, 402, 215, '2023-03-15', 2, 65.98, 'Credit', 512),
(626, 107, 405, 216, '2023-03-18', 3, 59.97, 'Debit', 509),
(627, 108, 408, 217, '2023-03-20', 1, 34.99, 'Cash', NULL),
(628, 109, 410, 218, '2023-03-22', 2, 99.98, 'Credit', 508),
(629, 101, 414, 220, '2023-03-25', 1, 39.99, 'Credit', 501),
(630, 102, 416, 219, '2023-03-28', 2, 37.98, 'Debit', 502);

-- Inserting data into promotions table
INSERT INTO promotions VALUES
(701, 'Canada Day Sale', '2023-06-25', '2023-07-05', 15.00, NULL, NULL),
(702, 'Back to School', '2023-08-15', '2023-09-05', 10.00, NULL, NULL),
(703, 'Fall Harvest Special', '2023-09-20', '2023-10-15', 20.00, 401, NULL),
(704, 'Winter Essentials', '2023-11-01', '2023-11-30', 25.00, 403, NULL),
(705, 'Holiday Gift Ideas', '2023-12-01', '2023-12-24', 15.00, NULL, 'Eastern'),
(706, 'New Year New You', '2023-12-26', '2024-01-15', 30.00, NULL, 'Western'),
(707, 'Valentine''s Day', '2024-02-01', '2024-02-14', 10.00, NULL, NULL),
(708, 'Spring Outdoor Sale', '2024-03-15', '2024-04-15', 20.00, 406, NULL),
(709, 'Eastern Regional Special', '2024-05-01', '2024-05-15', 15.00, NULL, 'Eastern'),
(710, 'Western Regional Special', '2024-05-01', '2024-05-15', 15.00, NULL, 'Western');

-- Inserting data into online_orders table
INSERT INTO online_orders VALUES
(801, 501, '2023-01-10', '2023-01-12', 'ON', 9.99, 'Delivered'),
(802, 503, '2023-01-15', '2023-01-18', 'QC', 12.99, 'Delivered'),
(803, 505, '2023-01-22', '2023-01-25', 'NS', 15.99, 'Delivered'),
(804, 506, '2023-01-30', '2023-02-02', 'ON', 9.99, 'Delivered'),
(805, 502, '2023-02-05', '2023-02-08', 'BC', 14.99, 'Delivered'),
(806, 507, '2023-02-12', '2023-02-15', 'BC', 14.99, 'Delivered'),
(807, 509, '2023-02-18', '2023-02-21', 'AB', 12.99, 'Delivered'),
(808, 510, '2023-02-25', '2023-02-28', 'MB', 13.99, 'Delivered'),
(809, 512, '2023-03-05', '2023-03-08', 'ON', 9.99, 'Delivered'),
(810, 513, '2023-03-12', '2023-03-15', 'BC', 14.99, 'Delivered'),
(811, 514, '2023-03-20', '2023-03-23', 'QC', 12.99, 'Delivered'),
(812, 508, '2023-03-28', '2023-03-30', 'QC', 12.99, 'Delivered'),
(813, 504, '2023-04-05', NULL, 'AB', 12.99, 'Processing'),
(814, 511, '2023-04-12', NULL, 'QC', 12.99, 'Shipped'),
(815, NULL, '2023-04-18', NULL, 'ON', 9.99, 'Cancelled');

-- Inserting data into order_items table
INSERT INTO order_items VALUES
(901, 801, 401, 2, 24.99, 0.00),
(902, 801, 415, 1, 22.99, 0.00),
(903, 802, 403, 1, 149.99, 15.00),
(904, 803, 405, 1, 19.99, 0.00),
(905, 803, 404, 1, 45.99, 5.00),
(906, 804, 410, 1, 49.99, 0.00),
(907, 805, 402, 2, 32.99, 5.00),
(908, 806, 416, 3, 18.99, 0.00),
(909, 807, 406, 1, 89.99, 10.00),
(910, 808, 412, 1, 199.99, 20.00),
(911, 809, 408, 2, 34.99, 0.00),
(912, 810, 409, 2, 29.99, 5.00),
(913, 811, 413, 3, 14.99, 0.00),
(914, 812, 419, 1, 59.99, 10.00),
(915, 813, 424, 1, 79.99, 0.00),
(916, 814, 417, 2, 12.99, 0.00),
(917, 815, 401, 2, 24.99, 5.00),
(918, 801, 418, 1, 24.99, 0.00),
(919, 804, 422, 1, 39.99, 5.00),
(920, 807, 425, 1, 129.99, 20.00);

-- Inserting data into customer_feedback table
INSERT INTO customer_feedback VALUES
(1001, 101, 601, 5, 'Great service and product quality!', '2023-01-20', 'Responded'),
(1002, 102, 603, 4, 'Good experience but store was a bit crowded.', '2023-01-22', 'Responded'),
(1003, 103, 604, 3, 'Product was good but staff seemed rushed.', '2023-01-25', 'Responded'),
(1004, 104, 605, 5, 'Excellent shopping experience!', '2023-01-27', 'Responded'),
(1005, 105, 606, 4, 'Nice selection of Canadian products.', '2023-01-30', 'Responded'),
(1006, 106, 607, 4, 'Helpful staff and good quality items.', '2023-02-02', 'Responded'),
(1007, 107, 608, 5, 'Love the local products section!', '2023-02-05', 'Responded'),
(1008, 108, 609, 3, 'Good products but prices are a bit high.', '2023-02-07', 'Pending'),
(1009, 109, 610, 4, 'Nice store layout and friendly staff.', '2023-02-10', 'Pending'),
(1010, 101, 611, 5, 'Always find unique gifts here!', '2023-02-12', 'Responded'),
(1011, NULL, NULL, 2, 'Online order was delayed significantly.', '2023-03-05', 'Resolved'),
(1012, NULL, NULL, 3, 'Website was difficult to navigate.', '2023-03-10', 'Pending');

-- Inserting data into store_inventory table
INSERT INTO store_inventory VALUES
(1101, 101, 401, 45, 20, '2023-03-10'),
(1102, 101, 403, 12, 10, '2023-03-10'),
(1103, 101, 405, 30, 15, '2023-03-10'),
(1104, 101, 407, 8, 10, '2023-03-10'),
(1105, 102, 402, 25, 15, '2023-03-12'),
(1106, 102, 404, 18, 10, '2023-03-12'),
(1107, 102, 406, 6, 8, '2023-03-12'),
(1108, 102, 408, 22, 12, '2023-03-12'),
(1109, 103, 401, 35, 20, '2023-03-15'),
(1110, 103, 403, 7, 10, '2023-03-15'),
(1111, 103, 405, 25, 15, '2023-03-15'),
(1112, 103, 409, 20, 15, '2023-03-15'),
(1113, 104, 402, 18, 15, '2023-03-18'),
(1114, 104, 404, 12, 10, '2023-03-18'),
(1115, 104, 406, 14, 8, '2023-01-20'),
(1116, 104, 410, 5, 10, '2023-03-18'),
(1117, 105, 407, 10, 8, '2023-03-20'),
(1118, 105, 409, 15, 15, '2023-03-20'),
(1119, 105, 411, 7, 5, '2023-03-20'),
(1120, 105, 413, 30, 20, '2023-03-20');