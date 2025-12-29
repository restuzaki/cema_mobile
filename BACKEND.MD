# CEMA Backend Documentation

## I. Overview

The CEMA Backend is a robust RESTful API built with **Node.js** and **Express**, serving as the core infrastructure for the CEMA Design platform. It manages critical business operations including project management, task tracking, scheduling, service requests, client preference quizzes, and portfolio showcases.

Key technologies include:

- **MongoDB (Mongoose)**: Primary database for application data.
- **Firebase Realtime Database & Admin SDK**: Used for real-time chat functionality.
- **Google Gemini AI**: Integrated for automated customer support via the Chat Service.
- **JWT & Attribute-Based Access Control (ABAC)**: Ensures secure and granular permission management.

## II. Service and Middleware

### Configuration

- **Firebase Admin** (`config/firebaseAdmin.js`):
  - Centralized Firebase initialization.
  - Ensures a single instance of the Admin SDK is shared across the application.

### Services

- **Project Service** (`services/projectService.js`):

  - **Core Logic**: Manages all project-related database operations (Create, Read, Update, Delete).
  - **Permission Injection**: Uses MongoDB Aggregation to dynamically inject `_permissions` fields (e.g., `can_edit`, `can_delete`) into project data based on the user's role and `ACCESS_RULES`.
  - **Security**: Implements Row-Level Security (filtering by Manager/Client/Team) and Column-Level Security (hiding financials).
  - **Separation of Concerns**: Pure business logic; does not verify authentication (delegated to Route Middleware).

- **Chat Service** (`services/chatService.js`):
  - A background service that listens to the Firebase Realtime Database for new chat messages.
  - **AI Integration**: Utilizes Google's **Gemini 2.0 Flash** model to act as a Customer Service agent.
  - **Logic**: Automatically replies to user messages if they are sent outside of working hours (Mon-Fri, 09:00 - 17:00).
  - **Features**: Handles message updates/edits by regenerating AI responses.

### Middleware

- **Auth Middleware** (`middleware/authMiddleware.js`):

  - Validates JSON Web Tokens (JWT) provided in the request headers to authenticate users using `bcryptjs` and `jsonwebtoken`.

- **ABAC Middleware** (`middleware/abacMiddleware.js`):
  - **Attribute-Based Access Control**: Implements fine-grained permission checks at the **Route Level**.
  - **Usage**: `checkPermission(resourceName, action)`
  - **Mechanism**:
    1.  **Intercepts Request**: Runs before the controller.
    2.  **Resource Fetching**: Automatically fetches the target resource (e.g., Project by ID).
    3.  **Policy Check**: Calls `hasPermission(user, resourceName, action, data)` using rules defined in `abacPolicies.js`.
    4.  **Enforcement**: Returns `403 Forbidden` immediately if the check fails.

### Policies (`policies/abacPolicies.js`)

- **Single Source of Truth**: Uses `ACCESS_RULES` constant to define all permission overrides (e.g., `owner_only`, `max_budget`).
- **Dual Usage**: These rules are consumed by:
  - **Middleware**: For runtime API security (`hasPermission`).
  - **Service**: For database permission injection (UI flags).

**Permission Structure (`ACCESS_RULES`):**

```javascript
const ACCESS_RULES = {
  PROJECT: {
    EDIT: {
      admin: true,
      project_manager: { owner_only: true, max_budget: 1000000 },
      team_member: false,
      client: false,
    },
    DELETE: {
      admin: true,
      DEFAULT: false,
    },
    VIEW_FINANCIALS: {
      admin: true,
      project_manager: { owner_only: true },
      DEFAULT: false,
    },
  },
};
```

## III. API Route

Base URL: `/api`

### 1. Authentication

| Method | Endpoint         | Permissions / Role | Description                   |
| :----- | :--------------- | :----------------- | :---------------------------- |
| `POST` | `/register`      | Public             | Register a new user           |
| `POST` | `/login`         | Public             | Login and retrieve token      |
| `POST` | `/google-login`  | Public             | Login with Google ID Token    |
| `POST` | `/refresh-token` | Auth               | Refresh/Extend token duration |

**Response Models:**

- **POST `/register`**: Returns User object (subset)

  ```json
  {
    "status": "success",
    "message": "User registered successfully",
    "data": {
      "user": {
        "_id": "ObjectId",
        "name": "string",
        "phoneNumber": "string",
        "email": "string",
        "role": "client|admin|project_manager|staff"
      }
    }
  }
  ```

- **POST `/login`**: Returns User object (all fields except password) with JWT token

  ```json
  {
    "status": "success",
    "message": "Login berhasil",
    "data": {
      "user": {
        "_id": "ObjectId",
        "email": "string",
        "name": "string",
        "phoneNumber": "string",
        "profilePicture": "string",
        "role": "client|admin|project_manager|staff",
        "createdAt": "Date",
        "googleId": "string (optional)"
      },
      "token": "string"
    }
  }
  ```

- **POST `/google-login`**: Returns User object with JWT token

  - **Request Body**: `{ "idToken": "string" }`
  - **Response**: Same as `/login`

- **POST `/refresh-token`**: Returns new JWT token
  ```json
  {
    "status": "ok",
    "message": "Token duration reset",
    "token": "string"
  }
  ```

### 2. Projects

| Method   | Endpoint        | Permissions / Role       | Description          |
| :------- | :-------------- | :----------------------- | :------------------- |
| `GET`    | `/projects`     | Auth + `projects:view`   | Get all projects     |
| `GET`    | `/projects/:id` | Auth + `projects:view`   | Get project by ID    |
| `POST`   | `/projects`     | Auth + `projects:create` | Create a new project |
| `PUT`    | `/projects/:id` | Auth + `projects:update` | Update a project     |
| `DELETE` | `/projects/:id` | Auth + `projects:delete` | Delete a project     |

**Response Models:**

- **GET `/projects`**: Returns array of projects

  ```json
  {
    "status": "success",
    "total": "number",
    "data": [
      {
        "_id": "ObjectId",
        "id": "string",
        "name": "string",
        "description": "string",
        "admin_id": "ObjectId",
        "client_id": "ObjectId",
        "clientName": "string",
        "manager_id": "ObjectId",
        "managerName": "string",
        "team_members": ["ObjectId"],
        "status": "LEAD|DESIGN|CONSTRUCTION|RETENTION|COMPLETED|CANCELLED",
        "serviceType": "ObjectId (ref Services)",
        "serviceName": "string",
        "serviceData": {
          "id": "string",
          "title": "string",
          "price": "string"
        },
        "location": {
          "address": "string",
          "coordinates": { "lat": "number", "lng": "number" }
        },
        "progress": "number (0-100)",
        "startDate": "Date",
        "endDate": "Date",
        "financials": {
          "budget_total": "number",
          "cost_actual": "number",
          "value_planned": "number",
          "value_earned": "number",
          "cpi": "number",
          "spi": "number"
        },
        "documents": [
          {
            "title": "string",
            "url": "string",
            "type": "CONTRACT|BLUEPRINT|INVOICE",
            "uploaded_at": "Date"
          }
        ],
        "createdAt": "Date",
        "updatedAt": "Date"
      }
    ]
  }
  ```

- **GET `/projects/:id`**: Returns single project object
- **POST `/projects`**: Returns created project object
- **PUT `/projects/:id`**: Returns updated project object
- **DELETE `/projects/:id`**: Returns success message
  ```json
  {
    "status": "success",
    "message": "Project deleted"
  }
  ```

### 3. Tasks

| Method   | Endpoint                    | Permissions / Role    | Description          |
| :------- | :-------------------------- | :-------------------- | :------------------- |
| `GET`    | `/tasks/:id`                | Auth + `tasks:view`   | Get task by ID       |
| `GET`    | `/tasks/project/:projectId` | Auth + `tasks:view`   | Get tasks by project |
| `POST`   | `/tasks`                    | Auth + `tasks:create` | Create a new task    |
| `PUT`    | `/tasks/:id`                | Auth + `tasks:update` | Update a task        |
| `DELETE` | `/tasks/:id`                | Auth + `tasks:update` | Delete a task        |

**Pagination Support:**

GET `/tasks/project/:projectId` supports pagination with the following query parameters:

- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20, max: 100)

**Response Models:**

- **GET `/tasks/project/:projectId`**: Returns array of tasks for a project with pagination

  ```json
  {
    "status": "success",
    "data": [
      {
        "_id": "ObjectId",
        "id": "string",
        "project_id": "ObjectId",
        "assigned_to": ["ObjectId"],
        "created_by": "ObjectId",
        "title": "string",
        "description": "string",
        "budget_allocation": "number",
        "due_date": "Date",
        "status": "TODO|IN_PROGRESS|IN_REVIEW|DONE",
        "attachments": [
          {
            "type": "FILE|IMAGE|LINK",
            "url": "string",
            "name": "string",
            "uploaded_at": "Date"
          }
        ],
        "is_punch_item": "boolean",
        "approval": {
          "is_approved": "boolean",
          "approved_by": "ObjectId",
          "rejection_note": "string",
          "approved_at": "Date"
        },
        "createdAt": "Date",
        "updatedAt": "Date"
      }
    ],
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 100,
    "itemsPerPage": 20,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
  ```

- **POST `/tasks`**: Returns created task object
- **PUT `/tasks/:id`**: Returns updated task object
- **DELETE `/tasks/:id`**: Returns success message
  ```json
  {
    "status": "success",
    "message": "Task deleted"
  }
  ```

### 4. Schedules

| Method   | Endpoint         | Permissions / Role        | Description           |
| :------- | :--------------- | :------------------------ | :-------------------- |
| `GET`    | `/schedules`     | Auth + `schedules:view`   | Get all schedules     |
| `GET`    | `/schedules/:id` | Auth + `schedules:view`   | Get schedule by ID    |
| `POST`   | `/schedules`     | Auth + `schedules:create` | Create a new schedule |
| `PUT`    | `/schedules/:id` | Auth + `schedules:update` | Update a schedule     |
| `DELETE` | `/schedules/:id` | Auth + `schedules:delete` | Delete a schedule     |

**POST Request Payloads (Polymorphic):**

**Scenario A: Add to Existing Project**

```json
{
  "booking_type": "EXISTING",
  "project_id": "PROJ-123...",
  "date": "2024-12-25",
  "time": "14:00",
  "event": "Meeting",
  "isOnline": true
}
```

**Scenario B: New Booking (Transaction)**

```json
{
  "booking_type": "NEW",
  "clientName": "Budi Santoso",
  "serviceType": "SRV_ID...",
  "projectDescription": "Consultation for...",
  "date": "2024-12-25",
  "time": "14:00",
  "event": "Initial Consultation",
  "isOnline": true
}
```

**Response Models:**

- **GET `/schedules`**: Returns array of schedules

  ```json
  {
    "status": "success",
    "data": [
      {
        "_id": "ObjectId",
        "id": "string",
        "client_id": "ObjectId",
        "manager_id": "ObjectId",
        "project_id": "ObjectId",
        "date": "Date",
        "time": "string (HH:MM)",
        "event": "string",
        "description": "string",
        "isOnline": "boolean",
        "location": {
          "address": "string",
          "coordinates": { "lat": "number", "lng": "number" }
        },
        "link": "string",
        "status": "UPCOMING|COMPLETED|CANCELLED",
        "created_at": "Date",
        "updated_at": "Date"
      }
    ]
  }
  ```

- **GET `/schedules/:id`**: Returns single schedule object
- **POST `/schedules`**: Returns created schedule object
- **PUT `/schedules/:id`**: Returns updated schedule object
- **DELETE `/schedules/:id`**: Returns success message
  ```json
  {
    "status": "success",
    "message": "Schedule deleted"
  }
  ```

### 5. Quiz Questions

| Method   | Endpoint              | Permissions / Role             | Description            |
| :------- | :-------------------- | :----------------------------- | :--------------------- |
| `GET`    | `/quiz-questions`     | Public                         | Get all quiz questions |
| `GET`    | `/quiz-questions/:id` | Auth + `quiz_questions:view`   | Get question by ID     |
| `POST`   | `/quiz-questions`     | Auth + `quiz_questions:create` | Create a new question  |
| `PUT`    | `/quiz-questions/:id` | Auth + `quiz_questions:update` | Update a question      |
| `DELETE` | `/quiz-questions/:id` | Auth + `quiz_questions:delete` | Delete a question      |

**Response Models:**

- **GET `/quiz-questions`**: Returns array of quiz questions

  ```json
  {
    "status": "success",
    "data": [
      {
        "_id": "ObjectId",
        "id": "string",
        "text": "string",
        "imageUrl": "string",
        "relatedStyle": "MODERN|MINIMALIST|INDUSTRIAL|SCANDINAVIAN|JAPANDI|etc",
        "createdAt": "Date",
        "updatedAt": "Date"
      }
    ]
  }
  ```

- **GET `/quiz-questions/:id`**: Returns single quiz question object
- **POST `/quiz-questions`**: Returns created quiz question object
- **PUT `/quiz-questions/:id`**: Returns updated quiz question object
- **DELETE `/quiz-questions/:id`**: Returns success message
  ```json
  {
    "status": "success",
    "message": "Question deleted"
  }
  ```

### 6. Calculator

| Method | Endpoint               | Permissions / Role                  | Description                |
| :----- | :--------------------- | :---------------------------------- | :------------------------- |
| `GET`  | `/calculator/settings` | Public                              | Get calculator settings    |
| `PUT`  | `/calculator/settings` | Auth + `calculator_settings:update` | Update calculator settings |

**Response Models:**

- **GET `/calculator/settings`**: Returns calculator settings (singleton)

  ```json
  {
    "status": "success",
    "data": {
      "_id": "ObjectId",
      "id": "CALC-SETTINGS",
      "areaMultiplier": "number",
      "pricePerRoom": "number",
      "materials": {
        "standard": "number",
        "premium": "number",
        "luxury": "number"
      },
      "createdAt": "Date",
      "updatedAt": "Date"
    }
  }
  ```

- **PUT `/calculator/settings`**: Returns updated calculator settings
  - **Request Body:**
    ```json
    {
      "areaMultiplier": "number (optional)",
      "pricePerRoom": "number (optional)",
      "materials": {
        "standard": "number (optional)",
        "premium": "number (optional)",
        "luxury": "number (optional)"
      }
    }
    ```

### 7. Services

| Method   | Endpoint          | Permissions / Role       | Description                  |
| :------- | :---------------- | :----------------------- | :--------------------------- |
| `GET`    | `/services`       | Auth + `services:view`   | Get all available services   |
| `GET`    | `/services/shown` | Public                   | Get shown available services |
| `POST`   | `/services`       | Auth + `services:create` | Create a new service         |
| `PUT`    | `/services/:id`   | Auth + `services:update` | Update a service             |
| `DELETE` | `/services/:id`   | Auth + `services:delete` | Delete a service             |

**Response Models:**

- **GET `/services`**: Returns array of all services (Note: uses `status: "ok"`)

  ```json
  {
    "status": "ok",
    "data": [
      {
        "_id": "ObjectId",
        "title": "string",
        "category": "string",
        "price": "string",
        "image": "string",
        "description": "string",
        "features": ["string"],
        "isPopular": "boolean",
        "isShown": "boolean",
        "createdAt": "Date",
        "updatedAt": "Date"
      }
    ]
  }
  ```

- **GET `/services/shown`**: Returns array of services where `isShown: true`
- **POST `/services`**: Returns created service object (`status: "ok"`)
- **PUT `/services/:id`**: Returns updated service object (`status: "ok"`)
- **DELETE `/services/:id`**: Returns success message
  ```json
  {
    "status": "ok",
    "message": "Data berhasil dihapus"
  }
  ```

### 8. Portfolio

| Method   | Endpoint           | Permissions / Role         | Description            |
| :------- | :----------------- | :------------------------- | :--------------------- |
| `GET`    | `/portfolio`       | Auth + `portfolios:view`   | Get all portfolios     |
| `GET`    | `/portfolio/shown` | Public                     | Get shown portfolios   |
| `GET`    | `/portfolio/:id`   | Auth + `portfolios:view`   | Get portfolio by ID    |
| `POST`   | `/portfolio`       | Auth + `portfolios:create` | Create a new portfolio |
| `PUT`    | `/portfolio/:id`   | Auth + `portfolios:update` | Update a portfolio     |
| `DELETE` | `/portfolio/:id`   | Auth + `portfolios:delete` | Delete a portfolio     |

**Response Models:**

- **GET `/portfolio`**: Returns array of all portfolios

  ```json
  {
    "status": "success",
    "total": "number",
    "data": [
      {
        "_id": "ObjectId",
        "id": "string",
        "displayName": "string",
        "category": "string",
        "description": "string",
        "endDate": "Date",
        "photoUrl": "string",
        "isShown": "boolean"
      }
    ]
  }
  ```

- **GET `/portfolio/shown`**: Returns array of portfolios where `isShown: true`
- **GET `/portfolio/:id`**: Returns single portfolio object
- **POST `/portfolio`**: Returns created portfolio object
- **PUT `/portfolio/:id`**: Returns updated portfolio object
- **DELETE `/portfolio/:id`**: Returns success message
  ```json
  {
    "status": "success",
    "message": "Portfolio deleted"
  }
  ```

### 9. Users (Admin)

| Method   | Endpoint     | Permissions / Role    | Description       |
| :------- | :----------- | :-------------------- | :---------------- |
| `GET`    | `/users`     | Auth + `users:view`   | Get all users     |
| `GET`    | `/users/:id` | Auth (Own) / Admin    | Get user by ID    |
| `POST`   | `/users`     | Auth + `users:create` | Create a new user |
| `PUT`    | `/users/:id` | Auth (Own) / Admin    | Update user info  |
| `DELETE` | `/users/:id` | Auth + `users:delete` | Delete user       |

**Response Models:**

- **GET `/users`**: Returns array of users
  ```json
  {
    "status": "success",
    "total": "number",
    "data": [
      {
        "_id": "ObjectId",
        "email": "string",
        "name": "string",
        "role": "string"
      }
    ]
  }
  ```
- **GET `/users/:id`**: Returns user object
- **POST `/users`**: Returns created user object
- **PUT `/users/:id`**: Returns updated user object
- **DELETE `/users/:id`**: Returns success message

### 10. Chat (Internal & Client)

| Method  | Endpoint             | Permissions / Role | Description              |
| :------ | :------------------- | :----------------- | :----------------------- |
| `POST`  | `/chat/send`         | Auth               | Send message (User)      |
| `POST`  | `/chat/reply`        | Admin Only         | Reply to message (Admin) |
| `PATCH` | `/chat/reset-unread` | Admin Only         | Reset unread count       |

**Response Models:**

- **POST `/chat/send`**:
  ```json
  { "success": true, "message": "Pesan terkirim" }
  ```
- **POST `/chat/reply`**:
  ```json
  { "success": true, "message": "Balasan terkirim" }
  ```
- **PATCH `/chat/reset-unread`**:
  ```json
  { "success": true }
  ```

### 11. Contact

| Method | Endpoint   | Permissions / Role | Description        |
| :----- | :--------- | :----------------- | :----------------- |
| `POST` | `/contact` | Public             | Send contact email |

**Response Models:**

- **POST `/contact`**:
  ```json
  { "success": true, "data": { ... } }
  ```

### 12. Time Logs

Time Logs module provides time tracking functionality for project tasks with auto-approval logic and role-based access control.

| Method | Endpoint         | Permissions / Role        | Description           |
| :----- | :--------------- | :------------------------ | :-------------------- |
| `POST` | `/time-logs`     | Auth + `time_logs:create` | Create a new time log |
| `GET`  | `/time-logs`     | Auth + `time_logs:view`   | Get all time logs     |
| `GET`  | `/time-logs/:id` | Auth + `time_logs:view`   | Get time log by ID    |
| `PUT`  | `/time-logs/:id` | Auth + `time_logs:update` | Update a time log     |

**Key Features:**

- **Auto-approval**: Time logs created by Project Managers and Admins are automatically approved
- **Duration Calculation**: `duration_minutes` is automatically calculated from `start_at` and `end_at`
- **Role-based Filtering**:
  - Staff can only view their own time logs
  - Project Managers can view time logs for projects they manage
  - Admins can view all time logs

**Request Models:**

- **POST `/time-logs`**:

  ```json
  {
    "project_id": "PROJ-1234567890",
    "task_id": "TASK-1234567890 (optional)",
    "start_at": "2025-12-27T09:00:00.000Z",
    "end_at": "2025-12-27T17:00:00.000Z",
    "description": "Frontend development work"
  }
  ```

- **PUT `/time-logs/:id`** (Update Fields):

  ```json
  {
    "start_at": "2025-12-27T09:00:00.000Z (optional)",
    "end_at": "2025-12-27T17:00:00.000Z (optional)",
    "description": "Updated description (optional)"
  }
  ```

- **PUT `/time-logs/:id`** (Update Status - PM/Admin only):
  ```json
  {
    "status": "APPROVED | REJECTED",
    "rejection_note": "Required if status is REJECTED"
  }
  ```

**Response Models:**

- **POST `/time-logs`**: Returns created time log object

  ```json
  {
    "status": "success",
    "message": "Time log created successfully",
    "data": {
      "_id": "ObjectId",
      "id": "TIMELOG-1234567890",
      "project_id": "ObjectId",
      "manager_id": "ObjectId",
      "task_id": "ObjectId (optional)",
      "user_id": "ObjectId",
      "start_at": "Date",
      "end_at": "Date",
      "duration_minutes": "number (auto-calculated)",
      "description": "string",
      "status": "PENDING | APPROVED | REJECTED",
      "rejection_note": "string (if rejected)",
      "approved_by": "ObjectId (if approved)",
      "approved_at": "Date (if approved)",
      "createdAt": "Date",
      "updatedAt": "Date"
    }
  }
  ```

- **GET `/time-logs`**: Returns array of time logs (filtered by role) with pagination

  **Query Parameters:**

  - `project_id` (optional): Filter by project ID
  - `status` (optional): Filter by status (PENDING, APPROVED, REJECTED)
  - `user_id` (optional, Admin/PM only): Filter by specific user
  - `page` (optional): Page number (default: 1)
  - `limit` (optional): Items per page (default: 20, max: 100)

  ```json
  {
    "status": "success",
    "data": [
      {
        "_id": "ObjectId",
        "id": "TIMELOG-1234567890",
        "project_id": {
          "id": "string",
          "name": "string"
        },
        "task_id": {
          "id": "string",
          "title": "string"
        },
        "user_id": {
          "name": "string",
          "email": "string"
        },
        "start_at": "Date",
        "end_at": "Date",
        "duration_minutes": "number",
        "description": "string",
        "status": "PENDING | APPROVED | REJECTED",
        "approved_by": {
          "name": "string",
          "email": "string"
        },
        "approved_at": "Date",
        "createdAt": "Date",
        "updatedAt": "Date"
      }
    ],
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 100,
    "itemsPerPage": 20,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
  ```

- **GET `/time-logs/:id`**: Returns single time log object
- **PUT `/time-logs/:id`**: Returns updated time log object

  ```json
  {
    "status": "success",
    "message": "Time log updated successfully",
    "data": {
      /* time log object */
    }
  }
  ```

**Auto-approval Logic:**

| User Role         | Initial Status | Approved By | Approved At  |
| :---------------- | :------------- | :---------- | :----------- |
| `staff`           | `PENDING`      | `null`      | `null`       |
| `project_manager` | `APPROVED`     | `user._id`  | `new Date()` |
| `admin`           | `APPROVED`     | `user._id`  | `new Date()` |

### 13. Expenses

Expenses module provides expense tracking and approval functionality for project-related costs with automatic amount rounding and role-based access control.

| Method | Endpoint        | Permissions / Role       | Description          |
| :----- | :-------------- | :----------------------- | :------------------- |
| `POST` | `/expenses`     | Auth + `expenses:create` | Create a new expense |
| `GET`  | `/expenses`     | Auth + `expenses:view`   | Get all expenses     |
| `GET`  | `/expenses/:id` | Auth + `expenses:view`   | Get expense by ID    |
| `PUT`  | `/expenses/:id` | Auth + `expenses:update` | Update an expense    |

**Key Features:**

- **Auto-approval**: Expenses created by Project Managers and Admins are automatically approved
- **Amount Rounding**: Amount is automatically rounded to 2 decimal places
- **Multi-currency Support**: Supports IDR, USD, and SGD
- **Categories**: TRANSPORTATION, MATERIAL, MEAL, OTHER
- **Role-based Filtering**: Same as Time Logs (Staff own, PM projects, Admin all)

**Request Models:**

- **POST `/expenses`**:

  ```json
  {
    "project_id": "PROJ-1234567890",
    "title": "Transportation to client site",
    "amount": 123.456,
    "currency": "IDR | USD | SGD",
    "category": "TRANSPORTATION | MATERIAL | MEAL | OTHER",
    "date": "2025-12-27T00:00:00.000Z",
    "receipt_url": "https://example.com/receipt.pdf (optional)"
  }
  ```

- **PUT `/expenses/:id`** (Update Fields):

  ```json
  {
    "title": "string (optional)",
    "amount": "number (optional)",
    "currency": "IDR | USD | SGD (optional)",
    "category": "TRANSPORTATION | MATERIAL | MEAL | OTHER (optional)",
    "date": "Date (optional)",
    "receipt_url": "string (optional)"
  }
  ```

- **PUT `/expenses/:id`** (Update Status - PM/Admin only):
  ```json
  {
    "status": "APPROVED | REJECTED",
    "rejection_note": "Required if status is REJECTED"
  }
  ```

**Response Models:**

- **POST `/expenses`**: Returns created expense object

  ```json
  {
    "status": "success",
    "message": "Expense created successfully",
    "data": {
      "_id": "ObjectId",
      "id": "EXPENSE-1234567890",
      "project_id": "ObjectId",
      "manager_id": "ObjectId",
      "user_id": "ObjectId",
      "title": "string",
      "amount": "number (rounded to 2 decimals)",
      "currency": "IDR | USD | SGD",
      "category": "TRANSPORTATION | MATERIAL | MEAL | OTHER",
      "date": "Date",
      "receipt_url": "string",
      "status": "PENDING | APPROVED | REJECTED",
      "rejection_note": "string (if rejected)",
      "approved_by": "ObjectId (if approved)",
      "approved_at": "Date (if approved)",
      "createdAt": "Date",
      "updatedAt": "Date"
    }
  }
  ```

- **GET `/expenses`**: Returns array of expenses (filtered by role) with pagination

  **Query Parameters:**

  - `project_id` (optional): Filter by project ID
  - `status` (optional): Filter by status (PENDING, APPROVED | REJECTED)
  - `category` (optional): Filter by category
  - `user_id` (optional, Admin/PM only): Filter by specific user
  - `page` (optional): Page number (default: 1)
  - `limit` (optional): Items per page (default: 20, max: 100)

  ```json
  {
    "status": "success",
    "data": [
      {
        "_id": "ObjectId",
        "id": "EXPENSE-1234567890",
        "project_id": {
          "id": "string",
          "name": "string"
        },
        "user_id": {
          "name": "string",
          "email": "string"
        },
        "title": "string",
        "amount": "number",
        "currency": "string",
        "category": "string",
        "date": "Date",
        "receipt_url": "string",
        "status": "PENDING | APPROVED | REJECTED",
        "approved_by": {
          "name": "string",
          "email": "string"
        },
        "approved_at": "Date",
        "createdAt": "Date",
        "updatedAt": "Date"
      }
    ],
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 100,
    "itemsPerPage": 20,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
  ```

- **GET `/expenses/:id`**: Returns single expense object
- **PUT `/expenses/:id`**: Returns updated expense object

  ```json
  {
    "status": "success",
    "message": "Expense updated successfully",
    "data": {
      /* expense object */
    }
  }
  ```

**Auto-approval Logic:**

| User Role         | Initial Status | Approved By | Approved At  |
| :---------------- | :------------- | :---------- | :----------- |
| `staff`           | `PENDING`      | `null`      | `null`       |
| `project_manager` | `APPROVED`     | `user._id`  | `new Date()` |
| `admin`           | `APPROVED`     | `user._id`  | `new Date()` |

**Data Integrity Features:**

- **Amount Rounding**: Amounts are automatically rounded to 2 decimal places (e.g., 123.456 → 123.46)
- **Validation**:
  - For Time Logs: `end_at` must be after `start_at`
  - For Expenses: `amount` must be non-negative
  - Rejection note is required when status is REJECTED
