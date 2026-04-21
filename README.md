# 🚀 **SALE ANALYSIS – OLIST E-COMMERCE**

## 📌 1. Giới thiệu
Dự án xây dựng hệ thống **Business Intelligence Dashboard** cho nền tảng thương mại điện tử Olist (Brazil), mô phỏng quy trình của một **Data Analyst / BI Developer**:

- Xử lý dữ liệu thô (Raw Data) bằng SQL  
- Thiết kế modeling (Star Schema)  
- Xây dựng Dashboard trên Power BI  
- Khai thác Insight để tăng trưởng doanh thu & tối ưu vận hành  

## 📊 2. Mô tả dữ liệu
Dataset gồm **9 bảng chính**, chia thành 3 nhóm:

### 🧑‍💼 **Customer & Seller**
- **customer**: Thông tin khách hàng (ID, vị trí địa lý)  
- **sellers**: Thông tin người bán  

### 🛒 **Order & Transaction**
- **orders**: Vòng đời đơn hàng (status, timestamp)  
- **order_items**: Chi tiết sản phẩm trong từng đơn  
- **order_payments**: Thông tin thanh toán  
- **order_reviews**: Đánh giá khách hàng  

### 📦 **Product & Location**
- **products**: Thông tin sản phẩm  
- **product_category_name_translation**: Mapping danh mục (PT → EN)  
- **geolocation**: Dữ liệu vị trí (ZIP, lat, lng)  


## 🛠️ 3. Công cụ sử dụng
- 🗄️ **SQL Server** – Data Cleaning & Transformation  
- 📊 **Power BI** – Data Modeling & Visualization  


## 📁 4. Cấu trúc dự án
   ```
   Sale_Analyst
   ├── dataset
   |    ├── olist_customers_dataset.csv
   |    ├── olist_geolocation_dataset.csv
   |    ├── olist_order_items_dataset.csv
   |    ├── olist_order_payments_dataset.csv
   |    ├── olist_order_reviews_dataset.csv
   |    ├── olist_orders_dataset.csv
   |    ├── olist_products_dataset.csv
   |    ├── olist_sellers_dataset.csv
   |    └── product_category_name_translation.csv
   |
   ├── image
   ├── Power BI
   |   └──Sale_Analysis.pbix
   |
   ├── sql
   |   └── Sale_Analysis.sql
   └── README.md
   ```
   
## ⚙️ 5. Quy trình thực hiện
   - Tiền xử lý
   - Load dữ liệu vào Power BI và thiết kế modeling
   - Xây dựng bộ thư viện Measure DAX để tính toán và giải quyết các chiều phân tích
   - Thiết kế Dashboard
   - Phân tích và đưa ra insights
     
### 🔹5.1 Tiền xử lý (SQL)
- **🧹 Data Cleaning**: Xử lý null, loại bỏ dữ liệu lỗi
- **🔄 Normalization**: Chuẩn hóa State → Full Name
- **🧠 Feature Engineering**:
  - delivery_days
   - revenue
   - is_late_delivery
- **📅 Time Modeling**: Tạo bảng dim_date
    
   Sau quá trình xử lý, các bảng chính bao gồm:

📌Bảng Fact (Dữ liệu giao dịch)
- **fact_order_item**: Chứa dữ liệu chi tiết ở cấp độ sản phẩm (order_item_id).
- **fact_order**: Quản lý vòng đời đơn hàng.
- **fact_review**: Lưu trữ điểm đánh giá (review_score) gắn với từng mã đơn hàng.

📌Bảng Dimension (Dữ liệu danh mục)
- **dim_product**: Thông tin sản phẩm và danh mục đã được chuẩn hóa sang tiếng Anh.
- **dim_customer/seller**: Thông tin địa lý chi tiết (Thành phố, Bang đầy đủ).
- **dim_date**: Bảng thời gian chuẩn hóa để phân tích các chiều thời gian (Thứ, Ngày, Tháng, Năm, YearMonth).

### 🔹5.2 Load dữ liệu vào Power BI

Sau khi tạo các bảng fact và dim, tiến hành load dữ liệu vào Power BI và thực hiện modeling:
- **⭐ Thiết kế mô hình Star Schema**: Thiết lập quan hệ 1-nhiều (1:*) giữa các bảng Dimension và Fact.
- **🎯 Data Granularity**: Đảm bảo độ chi tiết của dữ liệu ở mức order_item_id để có thể đào sâu (drill-down) từ tổng quan doanh thu sàn xuống từng sản phẩm cụ thể.

### 🔹5.3 Xây dựng thư viện Measure

- **💰 Calculated Measures**: Tính toán các chỉ số tài chính như: Tổng doanh thu, AOV (Average Order Value), Tổng đơn hàng, Tổng khách hàng, Tỷ lệ hủy đơn, Tỷ lệ giao trễ.
- **📈 Time Intelligence**: So sánh doanh thu cùng kỳ, tốc độ tăng trưởng theo tháng.
- **🎯 Data Filtering Logic**: Sử dụng các hàm CALCULATE, FILTER, VALUES để tính toán Review Score "thuần" (chỉ tính trên các đơn hàng đơn lẻ - Single Item Order) nhằm loại bỏ nhiễu dữ liệu.

### 🔹5.4 Thiết kế Dashboard

Product được trình bày theo 4 trang chính: 
#### 📊 Overview Analyst:
  - Tổng quan doanh thu & tăng trưởng
  - Phân bố địa lý
#### 🚚 Order & Delivery Analyst:
  - Hiệu suất giao hàng
  - Tỷ lệ giao trễ theo bang
#### 📦 Product Analyst:
  - Phân tích danh mục sản phẩm theo quy luật Pareto (80/20)
  - Tìm ra các ngành hàng "Star" (Doanh thu cao, Review tốt)
  - Các nhóm tiềm năng giá trị cao.
#### 👥 Customer Analyst:
  - Phân khúc khách hàng dựa trên hành vi chi tiêu
  - Đề xuất chiến lược giữ chân khách hàng hiệu quả.

### 💡5.5 Phân tích và đưa ra insights
#### 📈 5.5.1 Tổng quan kinh doanh
- Theo dõi "sức khỏe" tài chính và nhịp độ tăng trưởng của sàn Olist.
- Xác định các điểm bùng nổ doanh thu theo chu kỳ thời gian.
- Phân tích trọng điểm địa lý để xác định các thị trường trọng điểm và các vùng tiềm năng chưa được khai thác.

#### 🚚 5.5.2 Vận hành & Logistics
- Đánh giá hiệu suất chuỗi cung ứng và trải nghiệm giao hàng.
- Bóc tách thời gian giao hàng thực tế và xác định tỷ lệ giao trễ theo từng bang.
- Nhận diện các "điểm nghẽn" trong quy trình vận chuyển chặng cuối để tối ưu hóa tốc độ đến tay khách hàng.

#### 📦 5.5.3 Chiến lược sản phẩm
- Tối ưu hóa danh mục hàng hóa dựa trên hiệu quả kinh doanh và chất lượng.
- Áp dụng quy luật Pareto (80/20) để phân loại ngành hàng chủ lực.
- Kết hợp Doanh thu và điểm Review để xác các nhóm sản phẩm chủ lực, sản phẩm rủi ro chất lượng và nhóm tiềm năng giá trị cao.

#### 👥 5.5.4 Hành vi khách hàng
- Thấu hiểu chân dung khách hàng và xây dựng lòng trung thành.
- Phân khúc khách hàng dựa trên mức chi tiêu và tần suất quay lại mua hàng.
- Đánh giá sự khác biệt trong hành vi của nhóm khách hàng "Cá mập" và nhóm khách hàng trung thành đơn giá thấp để đề xuất chiến lược chăm sóc khách hàng phù hợp.
  
## 🎯 6. Giá trị dự án 
- Xây dựng quy trình phân tích dữ liệu từ **SQL → Power BI**
- Thực hành các kỹ năng cốt lõi:
  - Data Cleaning & Transformation
  - Data Modeling (Star Schema cơ bản)
  - Xây dựng các chỉ số kinh doanh bằng DAX
- Làm quen với tư duy phân tích:
  - Từ dữ liệu → trực quan hóa → rút ra insight
 
# ⭐ Thanks for reading!
