EXEC sp_rename 'olist_orders_dataset','orders'
EXEC sp_rename 'olist_order_items_dataset','order_items'
EXEC sp_rename 'olist_customers_dataset','customers'
EXEC sp_rename 'olist_products_dataset','products'
EXEC sp_rename 'olist_sellers_dataset','sellers'
EXEC sp_rename 'olist_order_payments_dataset','order_payments'
EXEC sp_rename 'olist_order_reviews_dataset','reviews'
EXEC sp_rename 
'product_category_name_translation.Column1',
'product_category_name',
'COLUMN'

EXEC sp_rename 
'product_category_name_translation.Column2',
'product_category_name_english',
'COLUMN'

--xóa dòng đầu
DELETE FROM product_category_name_translation
WHERE product_category_name = 'product_category_name'

--Lấy những đơn hàng được giao
/*
SELECT *
INTO clean_orders
FROM [dbo].[orders]
*/

--Tạo fact_order_item
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    o.customer_id,
	o.order_status,
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,

    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS revenue,

    o.order_delivered_customer_date,
    o.order_estimated_delivery_date

INTO fact_order_item
FROM order_items oi
JOIN clean_orders o
ON oi.order_id = o.order_id

--Thay tên state viết tắt thành tên đầy đủ
CREATE TABLE dim_state (
    state_code VARCHAR(2),
    state_name VARCHAR(50)
)

INSERT INTO dim_state VALUES
('AC','Acre'),
('AL','Alagoas'),
('AP','Amapa'),
('AM','Amazonas'),
('BA','Bahia'),
('CE','Ceara'),
('DF','Distrito Federal'),
('ES','Espirito Santo'),
('GO','Goias'),
('MA','Maranhao'),
('MT','Mato Grosso'),
('MS','Mato Grosso do Sul'),
('MG','Minas Gerais'),
('PA','Para'),
('PB','Paraiba'),
('PR','Parana'),
('PE','Pernambuco'),
('PI','Piaui'),
('RJ','Rio de Janeiro'),
('RN','Rio Grande do Norte'),
('RS','Rio Grande do Sul'),
('RO','Rondonia'),
('RR','Roraima'),
('SC','Santa Catarina'),
('SP','Sao Paulo'),
('SE','Sergipe'),
('TO','Tocantins')

--Map vào customer
SELECT
    c.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.state_name AS customer_state
INTO dim_customer
FROM [dbo].[customers] c
LEFT JOIN dim_state s
ON c.customer_state = s.state_code

--Map vào seller
SELECT
    se.seller_id,
    se.seller_city,
    s.state_name AS seller_state
INTO dim_seller
FROM [dbo].[sellers] se
LEFT JOIN dim_state s
ON se.seller_state = s.state_code

--Tạo bảng fact order
SELECT
    order_id,
    customer_id,
	order_status,

    CAST(order_purchase_timestamp AS DATE) AS order_date,
    CAST(order_approved_at AS DATE) AS approved_date,
    CAST(order_delivered_carrier_date AS DATE) AS carrier_date,
    CAST(order_delivered_customer_date AS DATE) AS delivered_date,
    CAST(order_estimated_delivery_date AS DATE) AS estimated_date,

    -- delivery days
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS delivery_days,

    -- late flag
    CASE
		WHEN order_delivered_customer_date IS NOT NULL
			 AND order_delivered_customer_date > order_estimated_delivery_date
		THEN 1 
		ELSE 0
	END AS is_late_delivery

INTO fact_order
FROM clean_orders


--Tạo bảng dim order payment
SELECT *
INTO fact_payment
FROM order_payments

--Tạo bảng review
SELECT
    order_id,
    review_score
INTO fact_review
FROM reviews

--Tạo bảng dim date
DECLARE @min_date DATE, @max_date DATE

SELECT 
    @min_date = MIN(order_date),
    @max_date = MAX(order_date)
FROM fact_order

SELECT 
    DATEADD(DAY, number, @min_date) AS DateKey,

    YEAR(DATEADD(DAY, number, @min_date)) AS Year,
    MONTH(DATEADD(DAY, number, @min_date)) AS Month,
    DAY(DATEADD(DAY, number, @min_date)) AS Day,

    DATENAME(MONTH, DATEADD(DAY, number, @min_date)) AS MonthName,

    -- ⭐ thêm vào đây
    (DATEPART(WEEKDAY, DATEADD(DAY, number, @min_date)) + @@DATEFIRST - 2) % 7 + 1 AS WeekdayNo,
    DATENAME(WEEKDAY, DATEADD(DAY, number, @min_date)) AS WeekdayName,

    YEAR(DATEADD(DAY, number, @min_date))*100 
    + MONTH(DATEADD(DAY, number, @min_date)) AS YearMonthKey,

    FORMAT(DATEADD(DAY, number, @min_date), 'yyyy-MM') AS YearMonth

INTO dim_date
FROM master..spt_values
WHERE type = 'P'
AND DATEADD(DAY, number, @min_date) <= @max_date


--Tạo dim product
SELECT
    p.product_id,

    ISNULL(
        t.product_category_name_english,
        'unknown'
    ) AS category

INTO dim_product
FROM products p
LEFT JOIN product_category_name_translation t
ON p.product_category_name = t.product_category_name

-----------------------------------------------------------
/*
CHIỀU PHÂN TÍCH
1. Doanh thu
- Tổng doanh thu 
- Tổng doanh thu theo tháng hiện tại so với cùng kỳ tháng trước
- Tổng doanh thu theo ngày trong tuần
- Doanh thu theo ngành hàng
- Doanh thu theo bang

2. Đơn hàng
- Tổng đơn hàng 
- Tỉ lệ đơn giao trễ
- Tỉ lệ hủy đơn
- Tỉ lệ giao đơn đúng hẹn hoặc sớm hơn
- Trung bình thời gian giao hàng trong một đơn
- Tổng đơn hàng theo tháng
- Tổng đơn hàng theo ngày trong tuần
- Phân bố thời gian giao hàng
- Bảng theo dõi chi tiết tổng số lượng đơn hàng, tỉ lệ giao hàng trễ, 
thời gian giao hàng trung bình, tổng đơn hàng được giao và tỉ lệ giao hàng thành công của từng bang

3. Sản phẩm
- Tổng số lượng sản phẩm đã bán
- Top N ngành hàng theo doanh thu và so với tổng đơn hàng
- Tổng doanh thu theo từng ngành hàng
- Điểm trung bình review cho top N ngành hàng có doanh thu cao
- Bảng theo dõi chi tiết tổng doanh thu, tổng số lượng đơn hàng, giá trị trung bình của một đơn hàng theo từng ngành hàng

4. Khách hàng
- Tổng số lượng khách hàng
- Phân bố khách hàng theo bang
- Top N khách hàng có doanh thu cao nhất
- Bảng theo dõi chi tiết số lượng đơn hàng, tổng doanh thu, giá trị trung bình mỗi đơn hàng của từng khách hàng

5. Phương thức thanh toán
- Phân bố phương thức thanh toán
*/


