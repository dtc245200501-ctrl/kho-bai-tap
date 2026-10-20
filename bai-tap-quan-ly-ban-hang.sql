-- Bài tập: Thao tác với CSDL Quản lý bán hàng (MySQL)
CREATE DATABASE IF NOT EXISTS QuanLyBanHang CHARACTER SET utf8mb4;
USE QuanLyBanHang;

CREATE TABLE IF NOT EXISTS Customer (
    cID INT PRIMARY KEY,
    cName VARCHAR(25),
    cAge TINYINT
);

CREATE TABLE IF NOT EXISTS `Order` (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

CREATE TABLE IF NOT EXISTS Product (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice INT
);

CREATE TABLE IF NOT EXISTS OrderDetail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

-- Thêm dữ liệu mẫu. Chạy phần INSERT một lần để tránh trùng khóa.
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- 1. Hiển thị mã, ngày và tổng tiền đã lưu của tất cả hóa đơn.
-- Cột lưu tổng tiền trong đề là oTotalPrice, ban đầu có giá trị NULL.
SELECT oID, oDate, oTotalPrice AS oPrice
FROM `Order`;

-- 2. Danh sách khách hàng đã mua hàng và sản phẩm họ đã mua.
SELECT DISTINCT C.cID, C.cName, P.pID, P.pName
FROM Customer C
JOIN `Order` O ON C.cID = O.cID
JOIN OrderDetail OD ON O.oID = OD.oID
JOIN Product P ON OD.pID = P.pID;

-- 3. Khách hàng không mua bất kỳ sản phẩm nào.
SELECT C.cID, C.cName, C.cAge
FROM Customer C
WHERE NOT EXISTS (
    SELECT 1
    FROM `Order` O
    JOIN OrderDetail OD ON O.oID = OD.oID
    WHERE O.cID = C.cID
);

-- 4. Mã hóa đơn, ngày bán và giá tiền tính từ số lượng nhân đơn giá.
SELECT O.oID, O.oDate, SUM(OD.odQTY * P.pPrice) AS oPrice
FROM `Order` O
JOIN OrderDetail OD ON O.oID = OD.oID
JOIN Product P ON OD.pID = P.pID
GROUP BY O.oID, O.oDate
ORDER BY O.oID;
-- Tổng tiền tương ứng hóa đơn 1, 2, 3: 60, 32, 24.
