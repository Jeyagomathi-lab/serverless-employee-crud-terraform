import json
import os
import boto3
db_client = boto3.client('dynamodb')
table_name = os.environ.get('TABLE_NAME')
def lambda_handler(event, context):
    print('<<<<event>>>>>>>')
    print(event)
    emp_id = event.get('queryStringParameters', {}).get('employee_id')
    emp_department_id = event.get('queryStringParameters', {}).get('department_id')
    get_response = db_client.get_item(TableName=table_name, Key={'employee_id': {'S': str(emp_id)}, 'department_id': {'S': str(emp_department_id)}})
    if 'Item' in get_response:
        remove_response = db_client.delete_item(TableName=table_name,Key={'employee_id': {'S': str(emp_id)}, 'department_id': {'S': str(emp_department_id)}})
        return {
            'statusCode': 200,
            'body': json.dumps({'message': f"Employee {emp_id} removed from record successfully!!"})
        }  
    else:
        return {
            'statusCode': 404,
            'body': json.dumps({'message': f"Employee {emp_id} not found"})
        }          