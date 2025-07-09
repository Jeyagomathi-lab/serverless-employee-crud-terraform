import json
import os
import boto3
db_client = boto3.client('dynamodb')
table_name = os.environ.get('TABLE_NAME')
def lambda_handler(event, context):
    print('<<<<event>>>>>>>')
    print(event)
    emp_id = event.get('queryStringParameters', {}).get('employee_id')
    depart_id = event.get('queryStringParameters', {}).get('department_id')
    response = db_client.get_item(TableName=table_name, Key={'employee_id':{'S': str(emp_id)}, 'department_id':{'S': str(depart_id)}})
    if 'Item' not in response:
        return {
            'statusCode': 404,
            'body': json.dumps({'message': f"Employee {emp_id} not found"})
        }
    else:
        try:
            employee_response = response.get('Item',{})
            result = {
                'employee_id': employee_response.get('employee_id',{}).get('S', ''),
                'employee_name': employee_response.get('employee_name',{}).get('S', ''),
                'department_id': employee_response.get('department_id',{}).get('S', ''),
                'contact': employee_response.get('contact',{}).get('S', ''),
                'email': employee_response.get('email',{}).get('S', '')
            }
            
            return {
                'statusCode': 200,
                'body': json.dumps(result)
            }
        except Exception as e:
            return {
                'statusCode': 500,
                'body': json.dumps({'message': f"Error: {e}"})
            }           