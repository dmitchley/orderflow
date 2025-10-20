# OrderFlow – Project Overview

**Purpose:**  
“OrderFlow” is a small-scale **Order Management System** in Salesforce. It lets users manage products, create orders, and track order line items, including inventory updates and sales calculations. The project demonstrates **full Salesforce development skills**: custom objects, relationships, business logic (Apex), and user interfaces (LWC).

---

## Key Components

### 1. Products
- **Description:** Custom object to store product information.  
- **Fields:** Product Name, SKU, Description, Price, Stock Quantity, Category, Active/Inactive, Image URL (optional).  
- **Purpose:** Acts as the catalog of items that can be ordered.

### 2. Orders
- **Description:** Custom object representing a customer order.  
- **Fields:** Order Number (Auto Number), Customer Name, Order Date, Total Amount.  
- **Purpose:** Tracks individual orders placed by customers.

### 3. Order Line Items
- **Description:** Custom object connecting Products to Orders.  
- **Fields:** Quantity, Unit Price, Line Total (formula: Quantity × Unit Price).  
- **Relationships:**  
  - Master-Detail to Order  
  - Lookup (or Master-Detail) to Product  
- **Purpose:** Allows each order to have multiple products and calculates totals automatically.

---

## Business Logic / Features

- **Stock Management:** Decrease Stock Quantity when a product is added to an order.  
- **Validation Rules:** Prevent orders if Product is inactive or stock is insufficient.  
- **Reports & Dashboards:** Show sales by product, total orders, and inventory levels.  
- **Lightning Web Components (Optional):**  
  - User-friendly order creation screen  
  - Add multiple products to an order dynamically  
  - Real-time calculation of line totals and order total

---

## Project Goals

- Demonstrate **full Salesforce capability**, not just LWC.  
- Use **custom objects, relationships, and fields** properly.  
- Implement **Apex triggers or flows** for business logic like stock updates.  
- Build a **clean UI** via LWC to show advanced front-end skills.  
- Create **reports and dashboards** to visualize data and metrics.

---

> **In simple terms:**  
> “OrderFlow” = **Products + Orders + Order Line Items + Business Logic + Reports + UI**  
>  
> Essentially, a **mini ERP/order management system** you can fully build and showcase in a free Salesforce org.
