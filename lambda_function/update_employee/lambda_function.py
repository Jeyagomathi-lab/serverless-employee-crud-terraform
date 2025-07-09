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
        body_content = event.get('body', {})
        if body_content:
            try:
                json_body = json.loads(body_content)
                emp_name = json_body.get('employee_name', '')
                emp_contact = json_body.get('contact','')
                email= json_body.get('email','')
                update_response = db_client.update_item(TableName=table_name,
                                                        Key={'employee_id':{'S':str(emp_id)},'department_id': {'S': str(emp_department_id)}},
                                                        AttributeUpdates={
                    'employee_name':{'Value': {'S': str(emp_name)}, 'Action': 'PUT'},
                    'contact':{'Value': {'S': str(emp_contact)}, 'Action': 'PUT'},
                    'email':{'Value': {'S': str(email)}, 'Action': 'PUT'}
                    })
                return {
                    'statusCode': 200,
                    'body': json.dumps({'message': f"Employee id {emp_id} updated successfully"})
                }              

            except Exception as e:
                return {
                    'statusCode': 500,
                    'body': json.dumps({'message': str(e)})
                }  
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': f"Body content not found"})
            }          
    else:
        return {
            'statusCode': 404,
            'body': json.dumps({'message': f"Employee {emp_id} not found"})
        }          