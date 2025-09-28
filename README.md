# SmartBank 🏦

## 📌 Project Description
BlocBank is a mobile banking simulation app built with **Flutter** and **BLoC (flutter_bloc)** for state management and routing.  
The project is focused on iOS and Android platforms, with basic web support.  
The application simulates a simple banking system with four main features:
- Transactions
- Pay
- Top-Up
- Loan Application

---

## ⚙️ Features

### Transactions
- Displays the **current balance** 
- Shows a **list of recent transactions**, grouped by date:
  - TODAY, YESTERDAY, or in the format `d MMMM`
- Transaction types:
  - **PAYMENT** → shows name + amount (OUT transaction)
  - **TOP-UP** → shows "Top Up" + amount (with **+ sign**)
  - **Loan** → if a loan is approved, the loan amount is added here

### Pay
- Enter an amount to pay
- Add the recipient's name
- Press **Pay** → redirects back to the Transactions page with updated balance and new transaction

### Top-Up
- Enter an amount to top-up
- Press **Top-Up** → redirects back to the Transactions page with updated balance and new transaction

### Transaction Details
- View full details of a transaction
- Features:
  - **Add receipt** (not implemented)
  - **Split the bill** (only for PAYMENT transactions)  
    → halves the amount and adds a new transaction with type TOP-UP
  - **Repeating payment** (only for PAYMENT transactions)  
    → duplicates the same transaction in the list
  - **Something wrong?** → shows dialog: “Help is on the way, stay put!”

### Loan Application
- User must provide:
  - Monthly salary
  - Estimated monthly expenses
  - Loan amount
  - Loan term
- **Loan decision rules**:
  1. Random generated number > 50 (from [randomnumberapi.com](https://www.randomnumberapi.com))
  2. Account balance > 1000
  3. Monthly salary > 1000
  4. Monthly expenses < ⅓ of Monthly Salary
  5. Loan cost (amount ÷ term) < ⅓ of Monthly Salary
- First-time application:
  - **Approved** → dialog: “Yeeeyyy !! Congrats. Your application has been approved. Don’t tell your friends you have money!”  
    + Adds loan transaction to balance
  - **Declined** → dialog: “Ooopsss. Your application has been declined. It’s not your fault, it’s a financial crisis.”
- Subsequent applications:
  - Always → dialog: “Ooopsss, you applied before. Wait for notification from us.”
- If declined due to Rule 1 or Rule 2 → service will **listen for new transactions** and try again until approved  
- If declined due to Rule 3–5 → decision remains DECLINED forever

---

## 🗄️ Architecture
- **State Management & Routing**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **UI**: Flutter Widgets (Material)
- **Services**:
  - Loan decision service
  - Random number API service

---

## Figma (Screenshots)
