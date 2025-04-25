# 💄 GlamSphere: Online Makeup Store 🛍️

Welcome to **GlamSphere**! This is a fully functional e-commerce website for makeup products. Built with **Node.js**, **Express**, **EJS**, and **MySQL**, it provides an intuitive platform for users to browse and purchase makeup items. The project integrates a **Razorpay** payment gateway for secure transactions.

## 🚀 Features

* **Product Listing** 📦 Browse through a list of makeup products available for purchase. Each product comes with details like price, description, and images.
* **Makeup Store Interface** 🛍️ A clean, user-friendly interface for a seamless shopping experience.
* **Login/Signup** 🔐 Users can create accounts, login, and manage their profiles. Authentication is handled securely.
* **MySQL Database** 🗃️ All product details, user information, and order history are stored in a MySQL database.
* **Shopping Cart** 🛒 Add products to your cart, view the total cost, and proceed to checkout.
* **Place Order** 📋 Finalize your purchase by placing an order with selected items in the cart.
* **Payment Gateway (Razorpay)** 💳 Secure payment integration through Razorpay for a smooth and safe checkout experience.

## 🛠️ Technologies Used

* **Node.js**: JavaScript runtime for building the backend.
* **Express**: Web framework for Node.js to handle routing and requests.
* **EJS**: Templating engine for rendering dynamic HTML pages.
* **HTML/CSS/JS**: Frontend technologies to build the website's user interface.
* **MySQL**: Relational database management system to store products, users, and orders.
* **Razorpay**: Payment gateway for secure transactions.

## 📥 Getting Started

### Prerequisites

* Node.js installed on your machine.
* MySQL installed and running.

### Installation

1. **Clone the repository:**

```bash
git clone https://github.com/fatima-amani/Online-Makeup-Store.git
cd Online-Makeup-Store
```

2. **Install dependencies:**
   Run the following command to install the required npm packages:

```bash
npm install
```

3. **Set up the database:**
   * Create a MySQL database and import the necessary tables
   * Add your database credentials in the `.env` file 

4. **Configure environment variables:**
   Create a `.env` file in the root directory with the following configurations:

```
# Razorpay Configuration
# Replace with your actual Razorpay credentials, You can get these from your Razorpay dashboard
RAZORPAY_KEY_ID=your_key_id
RAZORPAY_KEY_SECRET=your_key_secret

# MySQL Database Configuration
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=makeup_store
DB_PORT=3306
```

5. **Start the server:**
   Run the following command to start the application:

```bash
npm start
```

6. **Access the app**: 
   Open your browser and go to `http://localhost:3000` to start browsing and making purchases.

## 🔒 Security

This application implements several security features:
- Password hashing
- Input sanitization
- Secure payment processing through Razorpay

## 👩‍💻 Authors

**Fatima Amani**  
GitHub: [@fatima-amani](https://github.com/fatima-amani)

**Darshana Nagar**  
GitHub: [@Drshna-02](https://github.com/Drshna-02)

⭐ **Like what you see?** Star this repository on GitHub! ⭐
