def entrypoint(event, context):
    message = 'Hello World.'
    return {
        "isBase64Encoded": False,
        "statusCode": 200,
        "headers": {},
        "body": message
    }