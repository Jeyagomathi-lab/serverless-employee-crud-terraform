import os
import json
import boto3
import uuid
db_client = boto3.client('dynamodb')
table_name = os.environ.get('TABLE_NAME')
def lambda_handler(event, context):
    print('<<<<event>>>>>>>')
    print(event)
    body_content = event.get('body', {})
    if body_content:
        try:
            body_json = json.loads(body_content)
            emp_id = uuid.uuid4()
            response = db_client.put_item(TableName=table_name, Item={
                'employee_id': {'S': str(emp_id)},
                'employee_name': {'S': str(body_json.get('employee_name', ''))},
                'department_id': {'S': str(body_json.get('department_id', ''))},
                'contact': {'S': str(body_json.get('contact', ''))},
                'email': {'S': str(body_json.get('email', ''))}
            })
            return {
                'statusCode': 201,
                'body': json.dumps({'message': f"employee_id {emp_id} created successfully"})
            }
        except Exception as e:
            return {
                'statusCode': 500,
                'body': json.dumps({'message': str(e)})
            }           
    else:
        return {
            'statusCode': 400,
            'body': json.dumps({'message': f"body content not found"})
        }