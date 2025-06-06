# 📦 Backend Project - Product & Enterprise Management

## 📋 Overview

This project is a Supabase-backed backend for a multi-enterprise product management system. It supports user registration, enterprise creation, product registration, and flexible product binding to multiple enterprises.

The architecture is designed to **start simple**, yet be **ready to scale** when real-world complexity arises.

---

## ✅ Key Concepts

- **Users** can register and log in (using Supabase Auth).
- Each **user creates enterprises**.
- Products are **not directly tied to a single enterprise** — instead, they are **bound using a link table** (`enterprise_products`).
- The system supports **product variants** (e.g., size, color, weight), with custom options per enterprise.
- **Packing types** (e.g., UN, KG) are managed in a separate table and are not editable by users.

---

## 📁 Database Structure (Core Tables)

### `products`

Stores product master data.

| Column                 | Type      | Required | Notes                         |
|------------------------|-----------|----------|-------------------------------|
| id                     | UUID      | ✅        | Primary key                   |
| name                   | Text      | ✅        | Product name                  |
| reducedName            | Text      | ❌        | Short display name            |
| salePrice              | Numeric   | ✅        |                               |
| packingId              | UUID      | ✅        | FK → `packings.id`            |
| department             | Text      | ✅        |                               |
| parentProductId        | UUID      | ❌        | For variants                  |
| ...other fields...     | various   | ❌        | Refer to schema               |

---

### `packings`

Static table used for packing types like KG, UN, CX.

| Column           | Type      | Notes                         |
|------------------|-----------|-------------------------------|
| id               | UUID      | Primary key                   |
| name             | Text      | 'KG', 'CX', 'UN'              |
| allowFractionate | Boolean   | e.g., true for 'KG'           |

---

### `enterprise_products`

This table binds products to enterprises.

| Column         | Type    | Notes                             |
|----------------|---------|-----------------------------------|
| enterpriseId   | UUID    | FK → `enterprises.id`             |
| productId      | UUID    | FK → `products.id`                |
| ...optional fields... | | For future per-enterprise overrides|

---

### `variant_keys` & `variant_values`

Custom attributes (e.g., "Color", "Size") that are user-defined per enterprise.

- **variant_keys** → "Color", "Weight"
- **variant_values** → "Red", "500g"

---

### `product_variants`

Binds a specific product to variant options.

| Column         | Type   | Notes                            |
|----------------|--------|----------------------------------|
| productId      | UUID   | FK → `products.id`               |
| variantKeyId   | UUID   | FK → `variant_keys.id`           |
| variantValueId | UUID   | FK → `variant_values.id`         |

---

## 🔧 Future Planning

- **Product visibility via lanes**: Currently not needed. Can be added later by introducing a new "lane" table and adjusting the `enterprise_products` logic.
- **Per-enterprise overrides**: Use additional columns in `enterprise_products` when needed (e.g., custom price, stock).
- **Shared product catalogs**: Could be introduced using lanes or catalog templates.

---

## 🔐 Auth Model

- Uses Supabase Auth for login/registration.
- Users are linked to the enterprise they create.
- Permission checks must be done at the application level or using Row-Level Security (RLS).

---

## 📌 Design Philosophy

| Principle                  | Applied? |
|----------------------------|----------|
| Start simple               | ✅        |
| Plan for scale             | ✅        |
| Keep database normalized   | ✅        |
| Support multi-enterprise   | ✅        |
| Custom UX-friendly variants| ✅        |

---

## 📞 Questions or Updates

This README should be kept up-to-date as schema evolves.

If you have questions or want to propose an improvement, create a ticket or contact the lead developer.

