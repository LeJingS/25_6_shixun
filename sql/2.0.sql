-- 核心数据表模块
CREATE TABLE departments (
  department_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  department_name VARCHAR(50) NOT NULL,
  created_at DATETIME NOT NULL
) COMMENT '部门表';

CREATE TABLE roles (
  role_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(50) NOT NULL,
  description VARCHAR(255)
) COMMENT '角色表';

CREATE TABLE permissions (
  permission_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  permission_name VARCHAR(50) NOT NULL,
  description VARCHAR(255)
) COMMENT '权限表';

CREATE TABLE users (
  user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(100) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  department_id BIGINT NOT NULL,
  status TINYINT(1) NOT NULL DEFAULT 1,
  last_login DATETIME,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (department_id) REFERENCES departments(department_id)
) COMMENT '用户信息表';
CREATE INDEX idx_username ON users(username);

CREATE TABLE user_role_mapping (
  mapping_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (role_id) REFERENCES roles(role_id)
) COMMENT '用户-角色关联表';

CREATE TABLE role_permission_mapping (
  mapping_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  role_id BIGINT NOT NULL,
  permission_id BIGINT NOT NULL,
  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
) COMMENT '角色-权限映射表';

CREATE TABLE logs (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT,
  action VARCHAR(100) NOT NULL,
  timestamp DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
) COMMENT '系统日志表';
CREATE INDEX idx_logs_timestamp ON logs(timestamp);

-- 收银销售模块
CREATE TABLE categories (
  category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL,
  parent_id BIGINT
) COMMENT '商品分类表';

CREATE TABLE brands (
  brand_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  brand_name VARCHAR(50) NOT NULL,
  description VARCHAR(255)
) COMMENT '品牌表';

CREATE TABLE products (
  product_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category_id BIGINT NOT NULL,
  brand_id BIGINT,
  price DECIMAL(10,2) NOT NULL,
  cost_price DECIMAL(10,2),
  unit VARCHAR(20) NOT NULL,
  barcode VARCHAR(50) NOT NULL,
  status TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (category_id) REFERENCES categories(category_id),
  FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
) COMMENT '商品信息表';
CREATE INDEX idx_product_name ON products(name);
CREATE UNIQUE INDEX idx_barcode ON products(barcode);

CREATE TABLE discount_rules (
  rule_id INT AUTO_INCREMENT PRIMARY KEY,
  rule_name VARCHAR(50) NOT NULL
) COMMENT '折扣规则类型字典表';
INSERT INTO discount_rules (rule_name) VALUES 
  ('满减'), ('折扣率'), ('限时活动');

CREATE TABLE discounts (
  discount_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  rule_id INT NOT NULL,
  value DECIMAL(10,2) NOT NULL,
  start_time DATETIME,
  end_time DATETIME,
  FOREIGN KEY (rule_id) REFERENCES discount_rules(rule_id)
) COMMENT '折扣规则表';

CREATE TABLE coupons (
  coupon_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  valid_from DATETIME,
  valid_to DATETIME
) COMMENT '优惠券表';

CREATE TABLE payment_methods (
  method_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  method_name VARCHAR(50) NOT NULL
) COMMENT '支付方式表';

CREATE TABLE sales_records (
  sale_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  cashier_id BIGINT NOT NULL,
  total_amount DECIMAL(15,2) NOT NULL,
  payment_method_id BIGINT NOT NULL,
  sale_time DATETIME NOT NULL,
  FOREIGN KEY (cashier_id) REFERENCES users(user_id),
  FOREIGN KEY (payment_method_id) REFERENCES payment_methods(method_id)
) COMMENT '销售记录表';
CREATE INDEX idx_sale_time ON sales_records(sale_time);

CREATE TABLE sales_details (
  detail_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  sale_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (sale_id) REFERENCES sales_records(sale_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '销售明细表';

CREATE TABLE coupon_usage (
  usage_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  coupon_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  used_time DATETIME NOT NULL,
  FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
) COMMENT '优惠券使用记录表';

CREATE TABLE returns (
  return_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  sale_id BIGINT NOT NULL,
  reason TEXT NOT NULL,
  return_time DATETIME NOT NULL,
  FOREIGN KEY (sale_id) REFERENCES sales_records(sale_id)
) COMMENT '退货记录表';

CREATE TABLE return_details (
  detail_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  return_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (return_id) REFERENCES returns(return_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '退货明细表';

-- 采购入库模块 (修复外键引用顺序)
CREATE TABLE suppliers (
  supplier_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  contact_person VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  address VARCHAR(255) NOT NULL,
  status TINYINT(1) NOT NULL DEFAULT 1
) COMMENT '供应商信息表';

CREATE TABLE supplier_products (
  sp_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  supplier_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  supply_price DECIMAL(10,2) NOT NULL,
  lead_time INT NOT NULL,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '供应商供应商品表';

-- 先创建warehouses表解决外键依赖
CREATE TABLE warehouses (
  warehouse_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(255) NOT NULL,
  capacity INT,
  manager_id BIGINT,
  shelf_num VARCHAR(50) COMMENT '货架号',  -- 修复: 避免使用保留字
  row_num VARCHAR(50) COMMENT '行号',     -- 修复: 避免使用保留字
  column_num VARCHAR(50) COMMENT '列号',  -- 修复: 避免使用保留字
  FOREIGN KEY (manager_id) REFERENCES users(user_id)
) COMMENT '仓库表';

CREATE TABLE purchase_orders (
  order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  supplier_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  total_amount DECIMAL(15,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT '待审核',
  order_date DATETIME NOT NULL,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
) COMMENT '采购订单表';

CREATE TABLE purchase_order_details (
  detail_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '采购订单明细表';

CREATE TABLE purchase_receipts (
  receipt_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  received_by BIGINT NOT NULL,
  receive_time DATETIME NOT NULL,
  FOREIGN KEY (order_id) REFERENCES purchase_orders(order_id),
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
  FOREIGN KEY (received_by) REFERENCES users(user_id)
) COMMENT '采购收货单';

CREATE TABLE purchase_receipt_details (
  detail_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  receipt_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  batch_number VARCHAR(50) NOT NULL,
  expire_date DATE,
  FOREIGN KEY (receipt_id) REFERENCES purchase_receipts(receipt_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '采购收货明细表';

CREATE TABLE inventories (
  inventory_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  batch_number VARCHAR(50),
  location VARCHAR(100),
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
) COMMENT '库存表';

CREATE TABLE stock_logs (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  change_quantity INT NOT NULL,
  reason VARCHAR(255) NOT NULL,
  timestamp DATETIME NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '库存变动日志表';

CREATE TABLE low_stock_alerts (
  alert_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  threshold INT NOT NULL,
  triggered_at DATETIME NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '库存预警表';

-- 管理部门模块
CREATE TABLE employees (
  employee_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  name VARCHAR(100) NOT NULL,
  gender VARCHAR(10),
  position VARCHAR(100) NOT NULL,
  department_id BIGINT NOT NULL,
  phone VARCHAR(20) NOT NULL,
  hire_date DATE NOT NULL,
  status TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (department_id) REFERENCES departments(department_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
) COMMENT '员工信息表';
CREATE INDEX idx_employee_name ON employees(name);

CREATE TABLE employee_attendance (
  attendance_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT NOT NULL,
  date DATE NOT NULL,
  check_in DATETIME,
  check_out DATETIME,
  status VARCHAR(20) NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) COMMENT '员工考勤记录表';

CREATE TABLE salaries (
  salary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT NOT NULL,
  base_salary DECIMAL(15,2) NOT NULL,
  bonus DECIMAL(15,2),
  deductions DECIMAL(15,2),
  net_salary DECIMAL(15,2) NOT NULL,
  month VARCHAR(7) NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) COMMENT '工资表';

CREATE TABLE shifts (
  shift_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT NOT NULL,
  day_of_week VARCHAR(10) NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) COMMENT '排班表';

CREATE TABLE performance_reviews (
  review_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT NOT NULL,
  score DECIMAL(5,2) NOT NULL,
  reviewer_id BIGINT NOT NULL,
  review_date DATETIME NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  FOREIGN KEY (reviewer_id) REFERENCES employees(employee_id)
) COMMENT '绩效考核表';

CREATE TABLE notifications (
  notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  sender_id BIGINT NOT NULL,
  send_time DATETIME NOT NULL,
  FOREIGN KEY (sender_id) REFERENCES users(user_id)
) COMMENT '内部通知公告表';

CREATE TABLE tasks (
  task_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  assigner_id BIGINT NOT NULL,
  deadline DATETIME NOT NULL,
  FOREIGN KEY (assigner_id) REFERENCES users(user_id)
) COMMENT '任务分配表';

CREATE TABLE task_assignments (
  assignment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  task_id BIGINT NOT NULL,
  employee_id BIGINT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT '进行中',
  assigned_at DATETIME NOT NULL,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id),
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) COMMENT '任务分配明细表';

CREATE TABLE feedbacks (
  feedback_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  employee_id BIGINT NOT NULL,
  content TEXT NOT NULL,
  submitted_at DATETIME NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
) COMMENT '员工反馈建议表';

CREATE TABLE reports (
  report_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  generated_by BIGINT NOT NULL,
  generated_at DATETIME NOT NULL,
  data TEXT NOT NULL,
  FOREIGN KEY (generated_by) REFERENCES users(user_id)
) COMMENT '各类报表汇总表';

-- 后勤部门模块
CREATE TABLE asset_types (
  type_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  type_name VARCHAR(50) NOT NULL
) COMMENT '资产类型表';

CREATE TABLE asset_locations (
  location_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  area VARCHAR(100) NOT NULL,
  shelf VARCHAR(50) NOT NULL,
  notes VARCHAR(255)
) COMMENT '资产存放位置表';

CREATE TABLE assets (
  asset_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  type_id BIGINT NOT NULL,
  purchase_date DATE NOT NULL,
  value DECIMAL(15,2) NOT NULL,
  location_id BIGINT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT '在用',
  FOREIGN KEY (type_id) REFERENCES asset_types(type_id),
  FOREIGN KEY (location_id) REFERENCES asset_locations(location_id)
) COMMENT '固定资产表';

CREATE TABLE maintenance_requests (
  request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  asset_id BIGINT NOT NULL,
  requested_by BIGINT NOT NULL,
  description TEXT NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT '处理中',
  submitted_at DATETIME NOT NULL,
  FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
  FOREIGN KEY (requested_by) REFERENCES users(user_id)
) COMMENT '设备维修申请表';

CREATE TABLE maintenance_records (
  record_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  request_id BIGINT NOT NULL,
  technician_id BIGINT NOT NULL,
  repair_cost DECIMAL(15,2),
  completion_time DATETIME NOT NULL,
  FOREIGN KEY (request_id) REFERENCES maintenance_requests(request_id),
  FOREIGN KEY (technician_id) REFERENCES users(user_id)
) COMMENT '维修记录表';

CREATE TABLE vendors (
  vendor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  contact_person VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  service_type VARCHAR(50) NOT NULL
) COMMENT '后勤服务提供商表';

CREATE TABLE service_contracts (
  contract_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  vendor_id BIGINT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id)
) COMMENT '服务合同表';

CREATE TABLE cleaning_schedules (
  schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  area VARCHAR(100) NOT NULL,
  time TIME NOT NULL,
  frequency VARCHAR(50) NOT NULL,
  responsible_id BIGINT NOT NULL,
  FOREIGN KEY (responsible_id) REFERENCES users(user_id)
) COMMENT '清洁排班表';

CREATE TABLE security_logs (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  event TEXT NOT NULL,
  occurred_at DATETIME NOT NULL,
  reported_by BIGINT NOT NULL,
  FOREIGN KEY (reported_by) REFERENCES users(user_id)
) COMMENT '安保日志表';

CREATE TABLE waste_disposal_records (
  disposal_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  reason VARCHAR(255) NOT NULL,
  disposal_time DATETIME NOT NULL,
  operator_id BIGINT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
  FOREIGN KEY (operator_id) REFERENCES users(user_id)
) COMMENT '废弃商品处理记录表';

-- 报表分析模块
CREATE TABLE daily_sales_summary (
  summary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  sale_date DATE NOT NULL,
  total_sales DECIMAL(15,2) NOT NULL,
  total_orders INT NOT NULL,
  total_customers INT NOT NULL
) COMMENT '每日销售汇总表';

CREATE TABLE monthly_sales_summary (
  summary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  year INT NOT NULL,
  month INT NOT NULL,
  total_sales DECIMAL(15,2) NOT NULL,
  total_orders INT NOT NULL
) COMMENT '每月销售汇总表';

CREATE TABLE product_sales_ranking (
  ranking_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  total_quantity INT NOT NULL,
  total_amount DECIMAL(15,2) NOT NULL,
  rank_date DATE NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '商品销量排行榜';

CREATE TABLE customer_behavior_analysis (
  analysis_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  total_purchases INT NOT NULL,
  avg_spending DECIMAL(15,2) NOT NULL,
  favorite_category VARCHAR(50),
  last_purchase_time DATETIME NOT NULL
) COMMENT '顾客行为分析表';

CREATE TABLE inventory_turnover_rate (
  analysis_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT NOT NULL,
  turnover_rate DECIMAL(10,2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
) COMMENT '库存周转率分析表';

CREATE TABLE profit_loss_statement (
  statement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  revenue DECIMAL(15,2) NOT NULL,
  cost_of_goods_sold DECIMAL(15,2) NOT NULL,
  gross_profit DECIMAL(15,2) NOT NULL,
  operating_expenses DECIMAL(15,2) NOT NULL,
  net_profit DECIMAL(15,2) NOT NULL
) COMMENT '利润损益表';

CREATE TABLE dashboards (
  dashboard_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  title VARCHAR(100) NOT NULL,
  layout_config TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
) COMMENT '可视化仪表盘配置表';

-- 扩展模块
CREATE TABLE customers (
  customer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100),
  member_since DATETIME NOT NULL
) COMMENT '会员客户表';

CREATE TABLE member_cards (
  card_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  card_number VARCHAR(50) NOT NULL,
  points INT NOT NULL DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT '有效',
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) COMMENT '会员卡信息表';

CREATE TABLE loyalty_points (
  point_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  amount INT NOT NULL,
  reason VARCHAR(255) NOT NULL,
  change_time DATETIME NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) COMMENT '积分记录表';

CREATE TABLE orders_online (
  order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  total_amount DECIMAL(15,2) NOT NULL,
  payment_status VARCHAR(20) NOT NULL,
  order_time DATETIME NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) COMMENT '线上订单表';

CREATE TABLE delivery_addresses (
  address_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  address VARCHAR(255) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) COMMENT '配送地址表';

CREATE TABLE delivery_records (
  record_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  courier VARCHAR(50) NOT NULL,
  tracking_number VARCHAR(50) NOT NULL,
  status VARCHAR(20) NOT NULL,
  delivered_at DATETIME,
  FOREIGN KEY (order_id) REFERENCES orders_online(order_id)
) COMMENT '配送记录表';

CREATE TABLE sms_notifications (
  sms_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  phone VARCHAR(20) NOT NULL,
  content TEXT NOT NULL,
  send_time DATETIME NOT NULL,
  status VARCHAR(20) NOT NULL
) COMMENT '短信通知记录表';

CREATE TABLE email_templates (
  template_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  subject VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  created_at DATETIME NOT NULL
) COMMENT '邮件模板表';