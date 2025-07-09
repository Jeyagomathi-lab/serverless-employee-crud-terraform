# Serverless Employee CRUD API using Terraform on AWS

Hi! I'm Jeyagomathi and this is one of my hands-on AWS cloud automation projects where I’ve implemented a **Serverless CRUD API** using:

- AWS Lambda (Python)
- API Gateway (REST API)
- DynamoDB (with partition and sort key)
- Terraform (for end-to-end infrastructure)

---

## Architecture
![serverless_api drawio](https://github.com/user-attachments/assets/e5850f47-ea32-4f87-94f3-2a5e70ab36b9)
 
---

## What this project does

This API allows you to:

-  **Create** employee records
-  **Read** employee details using employee_id and department_id
-  **Update** employee info
-  **Delete** employee record

All secured using **API Gateway API Key**.

---

##  Tools & Services Used

- **AWS Lambda** – backend logic written in Python using Boto3
- **API Gateway** – handles HTTP requests (POST, GET, PUT, DELETE)
- **DynamoDB** – stores employee data with employee_id + department_id as keys
- **Terraform** – used to automate the full infrastructure setup
- **Postman** – for testing all APIs with `x-api-key` authentication

---

## Folder Structure

lambda_function/<br>
├── add_employee/<br>
│ └── lambda_function.py<br>
├── get_employee/<br>
├── update_employee/<br>
├── remove_employee/<br>
├── main.tf<br>
├── iam.tf<br>
├── dynamodb.tf<br>
├── lambda.tf<br>
├── apigateway.tf<br>
├── variables.tf<br>
├── outputs.tf<br>

---

## How to Deploy from Terraform

```bash
terraform init
terraform apply
It creates everything: DynamoDB table, Lambda functions, API Gateway with secured stage, usage plan, and API key.
```
---
## Testing
You can use Postman or curl like this:

POST https://<your-api-id>.execute-api.<region>.amazonaws.com/dev/employee
Headers:
x-api-key: <your-api-key>
Content-Type: application/json

Body:
{
  "employee_name": "Jeya",
  "department_id": "DEV",
  "contact": "1234567",
  "email": "jeya@example.com"
}
Similarly you can call GET, PUT, DELETE based on employee_id and department_id.

---

## API Endpoints (Sample)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST   | `/employee` | Add a new employee |
| GET    | `/employee?employee_id=...&department_id=...` | Get employee details |
| PUT    | `/employee?employee_id=...&department_id=...` | Update employee |
| DELETE | `/employee?employee_id=...&department_id=...` | Remove employee |

---

## Snips from POSTMAN testing

**GET Method**
![image](https://github.com/user-attachments/assets/77b35403-b5b3-48e5-afaa-05a314e6f970)

**POST Method**
![image](https://github.com/user-attachments/assets/b8fb3ed0-2184-4150-b630-f028676a743a)

**PUT Method**
![image](https://github.com/user-attachments/assets/ff7a4746-402f-4810-baa2-ec776079299e)

**DELETE Method**
![image](https://github.com/user-attachments/assets/1acde684-6176-4692-8e00-05a7dffbf9f4)




