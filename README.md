📌 1. Giới thiệu
Dự án tập trung vào việc xây dựng hệ thống báo cáo quản trị thông minh cho Olist – nền tảng thương mại điện tử hàng đầu Brazil. Dự án giải quyết trọn vẹn quy trình của một kỹ sư dữ liệu và chuyên viên BI: từ việc xử lý dữ liệu thô (Raw Data), thiết kế kho dữ liệu (Data Warehouse) đến việc xây dựng Dashboard trực quan nhằm tìm ra các Insight tăng trưởng doanh thu và tối ưu vận hành.

2. Dữ liệu

3. Quy trình thực hiện
   - Tiền xử lý
   - Load dữ liệu vào Power BI và thiết kế modeling
   - Xây dựng bộ thư viện Measure DAX để tính toán và giải quyết các chiều phân tích
   - Thiết kế Dashboard
   - Phân tích và đưa ra insights
     
3.1 Tiền xử lý
  Sử dụng SQL Server để thực hiện các kỹ thuật xử lý dữ liệu:
  - Data Cleaning: Loại bỏ các bản ghi không hợp lệ, xử lý giá trị khuyết thiếu (ISNULL) cho danh mục sản phẩm.
  - Normalization: Chuyển đổi mã bang (State Code) sang tên đầy đủ (Full State Name) để tối ưu hóa việc trực quan hóa bản đồ.
  - Feature Engineering: Tính toán các trường dữ liệu mới như delivery_days, revenue và gắn cờ is_late_delivery để phân tích hiệu suất vận hành.
  - Time Series Modeling: Khởi tạo bảng dim_date bằng Script để đảm bảo tính liên tục của dữ liệu thời gian.
    
   Sau quá trình xử lý, các bảng chính bao gồm:
Bảng Fact (Dữ liệu giao dịch)
- fact_order_item: Chứa dữ liệu chi tiết ở cấp độ sản phẩm (order_item_id). Bao gồm giá bán (price), phí vận chuyển (freight_value) và doanh thu thực tế (revenue).
- fact_order: Quản lý vòng đời đơn hàng, các mốc thời gian giao hàng và chỉ số giao trễ (is_late_delivery).
- fact_review: Lưu trữ điểm đánh giá (review_score) gắn với từng mã đơn hàng.

Bảng Dimension (Dữ liệu danh mục)
- dim_product: Thông tin sản phẩm và danh mục đã được chuẩn hóa sang tiếng Anh.
- dim_customer/seller: Thông tin địa lý chi tiết (Thành phố, Bang đầy đủ).
- dim_date: Bảng thời gian chuẩn hóa để phân tích các chiều thời gian (Thứ, Ngày, Tháng, Năm, YearMonth).

3.2 Load dữ liệu vào Power BI
Sau khi tạo các bảng fact và dim, tiến hành load dữ liệu vào Power BI và thực hiện modeling:
- Thiết kế mô hình Star Schema: Thiết lập quan hệ 1-nhiều (1:*) giữa các bảng Dimension và Fact.
- Data Granularity: Đảm bảo độ chi tiết của dữ liệu ở mức order_item_id để có thể đào sâu (drill-down) từ tổng quan doanh thu sàn xuống từng sản phẩm cụ thể.

3.3 Xây dựng thư viện Measure
- Calculated Measures: Tính toán các chỉ số tài chính như: Tổng doanh thu, AOV (Average Order Value), Tổng đơn hàng, Tổng khách hàng, Tỷ lệ hủy đơn, Tỷ lệ giao trễ.
- Time Intelligence: So sánh doanh thu cùng kỳ, tốc độ tăng trưởng theo tháng.
- Data Filtering Logic: Sử dụng các hàm CALCULATE, FILTER, VALUES để tính toán Review Score "thuần" (chỉ tính trên các đơn hàng đơn lẻ - Single Item Order) nhằm loại bỏ nhiễu dữ liệu.

3.4 Thiết kế Dashboard
Product được trình bày theo 4 trang chính: 
- Overview Analyst: Cái nhìn toàn cảnh về sức khỏe tài chính, xu hướng doanh thu theo thời gian và phân bố địa lý.
- Order & Delivery Analyst: Bóc tách hiệu suất logistics, xác định các bang có tỷ lệ giao trễ cao và tối ưu hóa quy trình vận hành.
- Product Analyst: Phân tích danh mục sản phẩm theo quy luật Pareto (80/20), tìm ra các ngành hàng "Star" (Doanh thu cao, Review tốt) và các nhóm tiềm năng giá trị cao.
- Customer Analyst: Phân khúc khách hàng dựa trên hành vi chi tiêu, từ đó đề xuất chiến lược giữ chân khách hàng hiệu quả.

3.5 Phân tích và đưa ra insights
3.5.1 Tổng quan kinh doanh
- Trọng tâm: Theo dõi "sức khỏe" tài chính và nhịp độ tăng trưởng của sàn Olist.
- Phân tích chính:
  - Xác định các điểm bùng nổ doanh thu theo chu kỳ thời gian.
  - Phân tích trọng điểm địa lý để xác định các thị trường trọng điểm và các vùng tiềm năng chưa được khai thác.

3.5.2 Vận hành & Logistics
- Trọng tâm: Đánh giá hiệu suất chuỗi cung ứng và trải nghiệm giao hàng.
- Phân tích chính:
  - Bóc tách thời gian giao hàng thực tế và xác định tỷ lệ giao trễ theo từng bang.
  - Nhận diện các "điểm nghẽn" trong quy trình vận chuyển chặng cuối để tối ưu hóa tốc độ đến tay khách hàng.

3.5.3 Chiến lược sản phẩm
- Trọng tâm: Tối ưu hóa danh mục hàng hóa dựa trên hiệu quả kinh doanh và chất lượng.
- Phân tích chính:
  - Áp dụng quy luật Pareto (80/20) để phân loại ngành hàng chủ lực.
  - Kết hợp Doanh thu và điểm Review để xác các nhóm sản phẩm chủ lực, sản phẩm rủi ro chất lượng và nhóm tiềm năng giá trị cao.

3.5.4 Hành vi khách hàng
- Trọng tâm: Thấu hiểu chân dung khách hàng và xây dựng lòng trung thành.
- Phân tích chính:
  - Phân khúc khách hàng dựa trên mức chi tiêu và tần suất quay lại mua hàng.
  - Đánh giá sự khác biệt trong hành vi của nhóm khách hàng "Cá mập" và nhóm khách hàng trung thành đơn giá thấp để đề xuất chiến lược chăm sóc khách hàng phù hợp.
  
